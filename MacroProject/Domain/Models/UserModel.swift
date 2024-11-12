//
//  UserModel.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation

internal struct UserModel: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var updatedAt: Date?
    var email: String?
    var fullName: String?
    var streak: Int?
    var avatarURL: String?
    var website: String?
    var lastSignInAt: Date?
    var accessToken: String?
    var refreshToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case updatedAt = "updated_at"
        case fullName = "full_name"
        case streak = "streak"
        case email = "email"
        case avatarURL = "avatar_url"
        case website = "website"
    }
}
