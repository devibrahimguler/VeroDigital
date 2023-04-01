//
//  Mission.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import Foundation

// Created for easy use by converting json data to Mission model

struct Mission : DataModel, Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case task
        case title
        case description
        case sort
        case wageType
        case BusinessUnitKey
        case businessUnit
        case parentTaskID
        case preplanningBoardQuickSelect
        case colorCode
        case workingTime
        case isAvailableInTimeTrackingKioskMode
    }
    
    var id = UUID()
    var task: String
    var title: String
    var description: String
    var sort: String
    var wageType: String
    var BusinessUnitKey: String?
    var businessUnit: String
    var parentTaskID: String
    var preplanningBoardQuickSelect: String?
    var colorCode: String
    var workingTime: String?
    var isAvailableInTimeTrackingKioskMode: Bool
}


