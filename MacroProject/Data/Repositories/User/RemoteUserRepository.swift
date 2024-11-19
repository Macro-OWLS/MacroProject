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
    var isStreakOnGoing: Bool
    var targetStreak: Int?
    var isStreakComplete: Bool
    var lastTargetUpdated: Date?
    var createdAt: Date?
    var updatedAt: Date
}

internal protocol RemoteUserRepositoryType {
    func registerUser(_ user: RegisterDTO) async throws
    func getUser(uid: String) async throws -> UserDTO
    func updateUserStreak(uid: String, streak: Int, isStreakOnGoing: Bool, updateAT: Date, isStreakComplete: Bool) async throws
    func updateUserTarget(uid: String, targetStreak: Int, lastTargetUpdated: Date) async throws
    func deleteAccount(uid: String) async throws
}

final class RemoteUserRepository: RemoteUserRepositoryType {
    private let firebase = FirebaseAuthService.shared
    private let db = Firestore.firestore()
    
    func registerUser(_ userRegisterInput: RegisterDTO) async throws {
        do {
            guard let authResult = await firebase.register(registerInput: userRegisterInput) else {
                throw NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "User Already Exists"])
            }
            
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = userRegisterInput.fullName
            try await changeRequest.commitChanges()
            
            let userData: [String: Any] = [
                "fullName": userRegisterInput.fullName,
                "email": userRegisterInput.email,
                "streak": 0,
                "isStreakOnGoing": false,
                "targetStreak": 0,
                "isStreakComplete": false,
                "lastTargetUpdated": FieldValue.serverTimestamp(),
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp()
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
            let isStreakOnGoing = data["isStreakOnGoing"] as? Bool ?? false
            let targetStreak = data["targetStreak"] as? Int ?? 0
            let isStreakComplete = data["isStreakComplete"] as? Bool ?? false
            let lastTargetUpdated = data["lastTargetUpdated"] as? Timestamp ?? Timestamp()
            let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
            let updatedAt = data["updatedAt"] as? Timestamp ?? Timestamp()
            
            let userDTO = UserDTO(
                fullName: fullName,
                email: email,
                streak: streak,
                isStreakOnGoing: isStreakOnGoing,
                targetStreak: targetStreak,
                isStreakComplete: isStreakComplete,
                lastTargetUpdated: lastTargetUpdated.dateValue(),
                createdAt: createdAt.dateValue(),
                updatedAt: updatedAt.dateValue()
            )
            
            return userDTO
        } catch {
            throw error
        }
    }

    func updateUserStreak(uid: String, streak: Int, isStreakOnGoing: Bool, updateAT: Date, isStreakComplete: Bool) async throws {
        let userDoc = db.collection("users").document(uid)

        do {
            try await userDoc.updateData([
                "streak": streak,
                "isStreakOnGoing": isStreakOnGoing,
                "updatedAt": updateAT,
                "isStreakComplete": isStreakComplete
            ])
            print("User streak successfully updated.")
        } catch {
            throw NSError(domain: "UpdateError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update user streak: \(error.localizedDescription)"])
        }
    }

    func updateUserTarget(uid: String, targetStreak: Int, lastTargetUpdated: Date) async throws {
        let userDoc = db.collection("users").document(uid)

        do {
            try await userDoc.updateData([
                "targetStreak": targetStreak,
                "lastTargetUpdated": lastTargetUpdated
            ])
            print("User target successfully updated.")
        } catch {
            throw NSError(domain: "UpdateError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update user target: \(error.localizedDescription)"])
        }
    }

    func deleteAccount(uid: String) async throws {
        do {
            try await db.collection("users").document(uid).delete()
            
            try await withCheckedThrowingContinuation { continuation in
                firebase.deleteAccount { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            throw NSError(domain: "DeleteAccountError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to delete user account: \(error.localizedDescription)"])
        }
    }
}
