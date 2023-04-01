//
//  HomeViewModel.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

class HomeViewModel : ObservableObject {

    @Published var showDetailView: Bool = false
    @Published var searchActivated: Bool = false
    @Published var animateCurrentMission: Bool = false
    @Published var animateContent: Bool = false
    @Published var offsetAnimation: Bool = false
    
    @Published var selectedMission: Missions?

}
