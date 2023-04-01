//
//  Home.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

struct Home: View {
    @StateObject var viewModel : HomeViewModel = HomeViewModel()
    @StateObject var dataController : DataController = DataController()
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer(minLength: 10)
                
                VStack(spacing: 15) {
                    SearchBar()
                    
                }
                .padding(.vertical)
                
                Spacer(minLength: 10)
                
                
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
                                }
                                
                            }

                            VStack(spacing: 35) {
                                ForEach(missions) { mission in
                                    MissionCardView(mission: mission, animation: animation)
                                        .environmentObject(viewModel)

                                    
                                }
                                
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 20)
                            .padding(.bottom, bottomPadding(size))
                            .background {
                                ScrollViewDetector()
                                    .environmentObject(dataController)
                            }
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
        .onChange(of: dataController.activeTag)
        { _ in
            dataController.filterByQRCode()
        }
        
        
        
        
    }
    
    // Used to keep a single CardView view on the Screen when scrolled to the bottom with a ScrollView.
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        return  scrollViewHeight - cardHeight - 40
    }
    
    
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
