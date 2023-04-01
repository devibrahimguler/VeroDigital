//
//  SearchView.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var dataController : DataController
    @FocusState var startTF: Bool
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                Button {
                    withAnimation{
                        viewModel.searchActivated = false
                        dataController.searchText = ""
                        dataController.searchMission = nil
                        dataController.filterByQRCode()
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.7))
                }
                
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $dataController.searchText)
                        .placeholder(when: dataController.searchText.isEmpty) {
                                Text("search").foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background {
                    Capsule()
                        .strokeBorder(Color.black,lineWidth: 1.5)
                }
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing, 20)
                
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            if let missions = dataController.searchMission {
                if missions.isEmpty {
                    VStack{
                        Text("Item not found !")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    GeometryReader {
                        let size = $0.size
                        ScrollView(.vertical, showsIndicators: false) {
                            ListView(missions: missions, animation: animation, size: size)
                                .environmentObject(dataController)
                                .environmentObject(viewModel)
                
                     
                        }
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .coordinateSpace(name: "SCROLLVIEW")
                        
                    }
                    .padding(.top, 15)
                }
            }
            else {
                if !dataController.searchText.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Used to make a view within a view.
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
