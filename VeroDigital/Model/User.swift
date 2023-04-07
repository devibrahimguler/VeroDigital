//
//  User.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import Foundation

// Created for easy use by converting json data to User model.

struct User: DataModel, Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case oauth
        case userInfo
        case permissions
        case apiVersion
        case showPasswordPrompt
    }
    
    var id = UUID()
    var oauth: Oauth
    var userInfo: UserInfo
    var permissions: [String]
    var apiVersion: String
    var showPasswordPrompt: Bool
    
}

// It was created to retrieve Oauth data, which is a subclass of the User model.
struct Oauth : Codable {
    enum CodingKeys: CodingKey {
        case access_token
        case expires_in
        case token_type
        case scope
        case refresh_token
    }
    
    var access_token: String
    var expires_in: Int
    var token_type: String
    var scope: String?
    var refresh_token: String
    
}

// It was created to retrieve UserInfo data, which is a subclass of the User model.
struct UserInfo : Codable {
    enum CodingKeys: CodingKey {
        case personalNo
        case firstName
        case lastName
        case displayName
        case active
        case businessUnit
    }
    
    var personalNo: Int
    var firstName: String
    var lastName: String
    var displayName: String
    var active: Bool
    var businessUnit: String
    
}
