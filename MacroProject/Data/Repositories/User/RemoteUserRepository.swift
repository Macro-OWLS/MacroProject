//
//  RemoteUserRepository.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct UserDTO {
    var fullName: String?
    var email: String?
    var streak: Int?
    var createdAt: Date?
}

internal protocol RemoteUserRepositoryType {
    func registerUser(_ user: RegisterDTO) async throws
    func getUser(uid: String) async throws -> UserDTO
}

final class RemoteUserRepository: RemoteUserRepositoryType {
    private let firebase = FirebaseAuthService.shared
    private let db = Firestore.firestore()
    
    func registerUser(_ userRegisterInput: RegisterDTO) async throws {
        do {
            guard let authResult = await firebase.register(registerInput: userRegisterInput) else {
                return print("Failed to register user")
            }
            
            authResult.user.displayName = userRegisterInput.fullName
            authResult.user.phoneNumber = "0"
            
            let userData: [String: Any] = [
                "fullName": userRegisterInput.fullName,
                "email": userRegisterInput.email,
                "streak": 0,
                "createdAt": FieldValue.serverTimestamp()
            ]
            try await db.collection("users").document(authResult.user.uid).setData(userData)
        } catch {
            throw error
        }
    }
    
    func getUser(uid: String) async throws -> UserDTO {
        do {
            let userDoc = try await db.collection("users").document(uid).getDocument()
            
            guard let data = userDoc.data() else {
                throw NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Firestore"])
            }
            
            // Parse the user data into a UserDTO
            let fullName = data["fullName"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let streak = data["streak"] as? Int ?? 0
            let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
            
            let userDTO = UserDTO(
                fullName: fullName,
                email: email,
                streak: streak,
                createdAt: createdAt.dateValue()
            )
            
            return userDTO
        } catch {
            throw error
        }
    }
}
