//
//  UserEntity.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import SwiftData

@Model
final class UserEntity {
    var id: String
    var updatedAt: Date?
    var email: String?
    var fullName: String?
    var avatarURL: String?
    var website: String?
    var lastSignInAt: Date?
    var accessToken: String?
    var refreshToken: String?
    
    init(id: String, updatedAt: Date? = nil, email: String? = nil, fullName: String? = nil, avatarURL: String? = nil, website: String? = nil, lastSignInAt: Date? = nil, accessToken: String? = nil, refreshToken: String? = nil) {
        self.id = id
        self.updatedAt = updatedAt
        self.email = email
        self.fullName = fullName
        self.avatarURL = avatarURL
        self.website = website
        self.lastSignInAt = lastSignInAt
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
