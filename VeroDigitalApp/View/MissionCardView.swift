//
//  MissionCardView.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

struct MissionCardView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    var mission : Missions
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            HStack(spacing: -25) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(mission.title ?? "")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("Color in \(mission.colorCode ?? "") colorcode")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4) {
                        Text("Read more")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8,x: 5,y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8,x: -5,y: -5)
                }
                .zIndex(1)
                .offset(x:viewModel.animateCurrentMission && viewModel.selectedMission?.id == mission.id ? -20 : 0)
                
                ZStack {
                    
                    if !(viewModel.selectedMission?.id == mission.id) {
                        Rectangle()
                            .fill(Color(hex: "\(mission.colorCode ?? "")"))
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .matchedGeometryEffect(id: mission.id, in: animation)
                            //.matchedGeometryEffect(id: mission.id, in: animation, isSource: false)
                            .shadow(color: .black.opacity(0.1), radius: 5,x: 5,y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5,x: -5,y: -5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )
                        
                        
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom,anchorZ: 1, perspective: 0.5)
        }
        .frame(height: 220)
    }
    
    
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
    
}

struct MissionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}
