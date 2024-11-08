//
//  RemoteUserPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/11/24.
//

import Foundation

internal protocol RemoteUserPhraseRepositoryType {
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel]
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws
}

final class RemoteUserPhraseRepository: RemoteUserPhraseRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    
    func getFilteredPhraseByUserID(userID: UUID) async throws -> [UserPhraseCardModel] {
        let query = """
            SELECT p.*
            FROM Phrases p
            LEFT JOIN Profile_Phrase pp ON p.id = pp.phrase_id AND pp.user_id = '\(userID.uuidString)'
            WHERE pp.phrase_id IS NULL
            """
        
        do {
            let result: [UserPhraseCardModel] = try await supabase.database.rpc(query).execute().value
            return result
        } catch {
            throw error
        }
    }
    
    func createPhraseToReview(phrase: UserPhraseCardModel) async throws {
        do {
            let dateFormatter = ISO8601DateFormatter()
            print("Create PhraseToReview: \(phrase)")
            try await supabase
                .database
                .from("ProfilePhrase")
                .insert([
                    "id": UUID().uuidString,
                    "profile_id": phrase.profileID,
                    "phrase_id": phrase.phraseID,
                    "vocabulary": phrase.vocabulary,
                    "phrase": phrase.phrase,
                    "translation": phrase.translation,
                    "prevLevel": phrase.prevLevel,
                    "nextLevel": phrase.nextLevel,
                    "lastReviewedDate": phrase.lastReviewedDate != nil ? dateFormatter.string(from: phrase.lastReviewedDate!) : nil,
                    "nextReviewDate": phrase.nextReviewDate != nil ? dateFormatter.string(from: phrase.nextReviewDate!) : nil
                ])
                .execute()
        } catch {
            throw error
        }
    }
    
    func updatePhraseToReview(id: String, result: UpdateProfilePhraseReview) async throws {
        do {
            let dateFormatter = ISO8601DateFormatter()
            try await supabase
                .database
                .from("ProfilePhrase")
                .update([
                    "prevLevel": result.prevLevel,
                    "nextLevel": result.nextLevel,
                    "lastReviewedDate": dateFormatter.string(from: result.lastReviewedDate),
                    "nextReviewDate": dateFormatter.string(from: result.nextReviewDate)
                ])
                .execute()
        } catch {
            throw error
        }
    }
}

struct UpdateProfilePhraseReview {
    var prevLevel: String
    var nextLevel: String
    var lastReviewedDate: Date
    var nextReviewDate: Date
}
