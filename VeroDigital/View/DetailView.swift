//
//  DetailView.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 15) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.offsetAnimation = false
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                    viewModel.animateContent = false
                    viewModel.showDetailView = false
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.black)
                    .contentShape(Rectangle())
            }
            .padding([.leading,.vertical], 15)
            .frame(maxWidth: .infinity,alignment: .leading)
            .opacity(viewModel.animateContent ? 1 : 0)
            
            if let mission = viewModel.selectedMission {
                GeometryReader {
                    let size = $0.size
                    
                    HStack(spacing: 20) {
                        
                        Rectangle()
                            .fill(Color(hex: "\(mission.colorCode ?? "")"))
                            .frame(width: (size.width - 30) / 2, height: size.height)
                            .clipShape(CustomCorners(corners: [.topRight,.bottomRight], radius: 20))
                            .overlay{
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: (size.width - 30) / 2, height: size.height)
                                    .clipShape(CustomCorners(corners: [.topRight,.bottomRight], radius: 20).stroke(lineWidth: 2))
                            }
                            .matchedGeometryEffect(id: mission.id, in: animation)
                        
                        
                        Text("\(mission.title ?? "")")
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.trailing, 15)
                            .padding(.top, 30)
                            .offset(y: viewModel.offsetAnimation ? 0 : 100)
                            .opacity(viewModel.offsetAnimation ? 1 : 0)
                        
                    }
                }
                .frame(height: 220)
                .zIndex(1)
            }
            
            Rectangle()
                .fill(.gray.opacity(0.04))
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    MissionDetails()
                        .padding(.leading, 30)
                })
                .padding(.leading, 0)
                .padding(.top, -180)
                .zIndex(0)
                .padding(viewModel.animateContent ? 1 : 0)
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .background{
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .opacity(viewModel.animateContent ? 1 : 0)
            
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.35)) {
                viewModel.animateContent = true
            }
            withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                viewModel.offsetAnimation = true
            }
        }
    }
    
    @ViewBuilder
    func MissionDetails() -> some View {
        VStack(spacing: 0) {
            
            Divider()
            
            if let mission = viewModel.selectedMission {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            InfoView(title: "Task", subTitle: "\(mission.task ?? "")")
                            InfoView(title: "Description", subTitle: "\(mission.descriptions ?? "")")
                            InfoView(title: "Sort", subTitle: "\(mission.sort ?? "")")
                            InfoView(title: "WageType", subTitle: "\(mission.wageType ?? "")")
                            InfoView(title: "Business Unit Key", subTitle: "\(mission.businessUnitKey ?? "Business Unit Key")")
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            InfoView(title: "BusinessUnit", subTitle: "\(mission.businessUnit ?? "")")
                            InfoView(title: "ParentTaskID", subTitle: "\(mission.parentTaskID ?? "")")
                            InfoView(title: "Pre-Planning", subTitle: "\(mission.preplanningBoardQuickSelect ?? "Pre-Planning")")
                            InfoView(title: "Color Code", subTitle: "\(mission.colorCode ?? "")")
                            InfoView(title: "Working Time", subTitle: "\(mission.workingTime ?? "Working Time")")
                            InfoView(title: "Timely Tracking", subTitle: "\(mission.isAvailableInTimeTrackingKioskMode)")
                        }
                        
                        VStack(alignment: .center){
                            Image(uiImage: viewModel.qrCode)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 15)
                    .padding(.top, 20)
                }
                .onAppear(perform: viewModel.getQRCode)
            }
            
        }
        .padding(.top, 180)
        .padding([.horizontal,.top], 15)
        .offset(y: viewModel.offsetAnimation ? 0 : 100)
        .opacity(viewModel.offsetAnimation ? 1 : 0)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
