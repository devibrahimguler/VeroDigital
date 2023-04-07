//
//  ListView.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var dataController : DataController
    var missions : [Missions]
    var animation: Namespace.ID
    var size: CGSize
    
    var body: some View {
        VStack(spacing: 35) {
            ForEach(missions) { mission in
                MissionCardView(mission: mission, animation: animation)
                    .environmentObject(viewModel)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.animateCurrentMission = true
                            viewModel.selectedMission = mission
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                viewModel.showDetailView = true
                                
                            }
                        }
                    }
                
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.bottom, bottomPadding(size))
    }
    
    // Used to keep a single CardView view on the Screen when scrolled to the bottom with a ScrollView.
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        return  scrollViewHeight - cardHeight - 40
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
