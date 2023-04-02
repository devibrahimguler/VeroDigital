//
//  Home.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI
import CodeScanner

struct Home: View {
    @StateObject var viewModel : HomeViewModel = HomeViewModel()
    @StateObject var dataController : DataController = DataController()
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer(minLength: 10)
                
                VStack(spacing: 15) {
                    ZStack {
                        if viewModel.searchActivated {
                            SearchBar()
                        } else {
                            SearchBar()
                                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                        }
                        
                    }
                    .frame(width: getRect().width / 1.6)
                    .padding(.horizontal, 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewModel.searchActivated = true
                            dataController.selectMission = nil
                        }
                    }
                    
                }
                .padding(.vertical)
                
                Spacer(minLength: 10)
                
                Button {
                    viewModel.isShowingScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding (.horizontal, 15)
            
            TagsView()
            
            Divider()
            
            if dataController.progress {
                ProgressView()
            } else {
                if let missions = dataController.selectMission {
                    GeometryReader {
                        let size = $0.size
                        ScrollView(.vertical, showsIndicators: false) {
                            PullToRefreshView {
                                if dataController.activeTag == "From The Data" {
                                    dataController.getDataWithApi()
                                } else
                                {
                                    dataController.filterByQRCode()
                                }
                                
                            }

                            ListView(missions: missions, animation: animation, size: size)
                                .environmentObject(dataController)
                                .environmentObject(viewModel)
                        }
                        .coordinateSpace(name: "SCROLLVIEW")
                        
                    }
                    .padding(.top, 15)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear{
            dataController.filterByQRCode()
        }
        .foregroundColor(.black)
        .background{
            Color.white
                .ignoresSafeArea()
        }
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
        }
        .overlay {
            ZStack {
                if (viewModel.searchActivated) {
                    SearchView(animation: animation)
                        .environmentObject(dataController)
                        .environmentObject(viewModel)
                    
                }
                if viewModel.selectedMission != nil, viewModel.showDetailView {
                    DetailView(animation: animation)
                        .environmentObject(viewModel)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
                }
            }
        }
        .onChange(of: viewModel.showDetailView) { newValue in
            if !newValue {
                withAnimation(.easeInOut(duration: 0.15).delay(0.4)){
                    viewModel.animateCurrentMission = false
                }
            }
        }
        .onChange(of: dataController.activeTag)
        { _ in
            dataController.filterByQRCode()
        }
        
        
        
        
    }
    
    
    // The code that will run as soon as the QR Code is read is used to add elements.
    func handleScan(result: Result<ScanResult, ScanError>) {
        viewModel.isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 12 else { return }
            
            let mission = Mission(task: details[0], title: details[1], description: details[2], sort: details[3], wageType: details[4],BusinessUnitKey:details[5], businessUnit: details[6], parentTaskID: details[7],preplanningBoardQuickSelect: details[8], colorCode: details[9],workingTime:details[10], isAvailableInTimeTrackingKioskMode: details[11].bool!)
            
            
            dataController.addMission(mission: mission)
            
            dataController.fetchData()
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    // SearchBar View.
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
            
            TextField("",text: .constant("search"))
                .disabled(true)
                .foregroundColor(.gray)
        }
        .padding(.vertical,12)
        .padding(.horizontal)
        .background {
            Capsule()
                .strokeBorder(Color.gray,lineWidth: 0.8)
        }
        
    }
    
    // Tags View.
    @ViewBuilder
    func TagsView() -> some View {
        HStack (spacing: 10) {
            ForEach(dataController.tags, id: \.self) { tag in
                Text (tag)
                    .font (.caption)
                    .padding (.horizontal, 12)
                    .padding (.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background {
                        if dataController.activeTag == tag {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.blue)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        } else {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill (.gray.opacity (0.2))
                        }
                        
                    }
                    .foregroundColor (dataController.activeTag == tag ? .white : .gray)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction:0.7, blendDuration: 0.7)) {
                            dataController.activeTag = tag
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Used for quick access to screen sizes.
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

// Used to convert String to Bool.
extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y":
            return true
        case "false", "f", "no", "n", "":
            return false
        default:
            if let int = Int(self) {
                return int != 0
            }
            return nil
        }
    }
}
