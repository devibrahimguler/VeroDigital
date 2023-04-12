//
//  Persistence.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import CoreData
import Combine
import CoreImage.CIFilterBuiltins

// DataController is a class used to control data.
class DataController : ObservableObject {
    
    @Published var progress : Bool = false
    
    @Published var fetchMission : [Missions]?
    @Published var selectMission : [Missions]?
    @Published var searchMission : [Missions]?
    @Published var searchText: String = ""
    
    @Published var activeTag: String = "From The Data"
    
    private let services : DataPullingService = DataPullingService()
    
    var tags: [String] = [
        "From The Data", "From The QR Code"
    ]
    
    private let container: NSPersistentContainer
    private var searchCancellable: AnyCancellable?
    
    init() {
        container = NSPersistentContainer(name: "VeroDigital")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str != "" {
                    self.filterByMission()
                } else {
                    self.searchMission = nil
                }
            })
        
        addAllMission()
    }
    
    // Login API and Pulls data from the API.
    func loginData() {
        let url = "https://api.baubuddy.de/index.php/login"
        let token = "QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz"
        let tokenType = "Basic"
        services.postServices(ofType: User.self, url: url, token: token, tokenType: tokenType) { result in
            switch result{
            case .success(let data):
                UserDefaults.standard.set(data[0].oauth.access_token, forKey: "token")
                UserDefaults.standard.set(data[0].oauth.token_type, forKey: "tokenType")
                self.getData()
                
            case .failure(let err):
                print(err)
                self.fetchData()
                self.filterByQRCode()
                DispatchQueue.main.async {
                    self.progress = false
                }
            }
        }
    }
    
    // Pulls data from the API with token.
    func getData() {
        DispatchQueue.main.async {
            self.progress = true
        }
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            return self.loginData()
        }
        guard let tokenType = UserDefaults.standard.object(forKey: "tokenType") as? String else {
            return self.loginData()
        }
        
        let url =  "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
        services.postServices(ofType: Mission.self, url: url, token: token, tokenType: tokenType) { result in
            switch result{
            case .success(let data):
                if data.count != 0 {
                    
                    if data.count > self.fetchMission?.count ?? 0 {
                        self.deleteAllMission()
                        
                        for mission in data {
                            self.addingModel(mission: mission, isQRCode: false)
                        }
                        self.save()
                    }
                    
                    self.fetchData()
                    self.filterByQRCode()
                    self.progress = false
                }
            case .failure(let err):
                if(err == .statusError) {
                    self.loginData()
                }
                DispatchQueue.main.async {
                    self.progress = false
                }
            }
        }
        
    }
    
    
    // Adds Data to Core Data.
    func addMission(mission: Mission) {
        addingModel(mission: mission, isQRCode: true)
        
        save()
    }
    
    // Used to get data from CoreData.
    func filterByQRCode() {
        DispatchQueue.global(qos: .userInteractive).async {
            if let missions = self.fetchMission {
                let results = missions
                    .lazy
                    .filter { mission in
                        return self.activeTag == "From The Data" ? !mission.isQRCode : mission.isQRCode
                    }
                
                DispatchQueue.main.async {
                    self.selectMission = results.compactMap { mission in
                        return mission
                    }
                    
                }
            }
            
        }
    }
    
    // Pulls data from Core Data.
    func fetchData() {
        DispatchQueue.main.async {
            self.progress = true
        }
        let request = NSFetchRequest<Missions>(entityName: "Missions")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Missions.id, ascending: false)]
        
        do {
            let fetchMissions = try container.viewContext.fetch(request)
            DispatchQueue.main.async {
                self.fetchMission = fetchMissions
                if self.fetchMission?.count ?? 0 > 0 {
                        self.progress = false
                }
            }
            
        } catch {
            print("Veriler alınamadı: \(error.localizedDescription)")
        }
        
    }
    
    // Used to reach the searched object by searching the list.
    private func filterByMission() {
        DispatchQueue.global(qos: .userInteractive).async {
            if let missions = self.fetchMission {
                let results = missions
                    .lazy
                    .filter { mission in
                        return mission.title!.lowercased().contains(self.searchText.lowercased())
                    }
                
                
                DispatchQueue.main.async {
                    self.searchMission = results.compactMap { mission in
                        return mission
                    }
                    
                }
            }
        }
    }
    
    // Saves data to Core Data.
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // The data in Core Data is compared with the data in the API and if there is a difference, it pulls data from the API.
    private func addAllMission() {
        self.fetchData()
        
        if fetchMission?.count ?? 0 <= 0 {
            self.loginData()
        }
    }
    
    // Deletes all data from Core Data.
    private func deleteAllMission() {
        if let missions = fetchMission {
            for mission in missions {
                container.viewContext.delete(mission)
            }
        }
        
        save()
        
    }
    
    // Model.
    private func addingModel(mission: Mission, isQRCode: Bool) {
        let newMissions = Missions(context: container.viewContext)
        newMissions.id = mission.id
        newMissions.task = mission.task
        newMissions.title = mission.title
        newMissions.descriptions = mission.description
        newMissions.sort = mission.sort
        newMissions.wageType = mission.wageType
        newMissions.businessUnitKey = mission.BusinessUnitKey
        newMissions.businessUnit = mission.businessUnit
        newMissions.parentTaskID = mission.parentTaskID
        newMissions.preplanningBoardQuickSelect = mission.preplanningBoardQuickSelect
        newMissions.colorCode = mission.colorCode
        newMissions.workingTime = mission.workingTime
        newMissions.isAvailableInTimeTrackingKioskMode = mission.isAvailableInTimeTrackingKioskMode
        newMissions.isQRCode = isQRCode
    }
    
}


