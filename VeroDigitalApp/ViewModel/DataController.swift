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
    
    @Published var fetchMission : [Missions]?

    let services : Services = Services()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "VeroDigital")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true

        addAllMission()
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
    
    // Pulls data from Core Data.
    func fetchData() {
        let request = NSFetchRequest<Missions>(entityName: "Missions")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Missions.id, ascending: false)]
        
        do {
            let fetchMissions = try container.viewContext.fetch(request)
            self.fetchMission = fetchMissions
            if self.fetchMission?.count ?? 0 > 0 {
            }
        } catch {
            print("Veriler alınamadı: \(error.localizedDescription)")
        }
        
    }
    
    // Adds Data to Core Data.
    func addMission(mission: Mission) {
        addingModel(mission: mission, isQRCode: true)
        
        save()
    }
    
    // Pulls data from the API.
    func getDataWithApi() {
        
        services.getDataWithApi { data in
            if data.count != 0 {
                
                if data.count > self.fetchMission?.count ?? 0 {
                    self.deleteAllMission()
                    
                    for mission in data {
                        self.addingModel(mission: mission, isQRCode: false)
                    }
                    self.save()
                }
                
                self.fetchData()
            }
        }
    }
    
    // The data in Core Data is compared with the data in the API and if there is a difference, it pulls data from the API.
    private func addAllMission() {
        self.fetchData()
        
        if fetchMission?.count ?? 0 <= 0 {
            getDataWithApi()
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


