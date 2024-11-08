//
//  RemotePhraseRepository.swift
//  MacroProject
//
//  Created by Ages on 12/10/24.
//
import Foundation
import SwiftData
import Supabase

internal protocol RemotePhraseRepositoryType {
    func fetchPhrase() async throws -> [PhraseCardModel]?
    func createPhrase(_ phrase: PhraseCardModel) async throws
}

final class RemotePhraseRepository: RemotePhraseRepositoryType {
    private let supabase = SupabaseService.shared.getClient()
    
    func fetchPhrase() async throws -> [PhraseCardModel]? {
        do {
            let fetchedPhrase: [PhraseCardModel] = try await supabase
                .database
                .from("Phrases")
                .select()
                .execute()
                .value
            print("\nremotefetchPhrase: \(fetchedPhrase)\n")
            
            if !fetchedPhrase.isEmpty {
                return fetchedPhrase
            }
        } catch {
            return []
        }
        
        return []
    }
    
    func createPhrase(_ phrase: PhraseCardModel) async throws {
        do {
            try await supabase
                .database
                .from("Phrases")
                .insert([
                    "Phrase": phrase.id,
                    "topicID": phrase.topicID,
                    "vocabulary": phrase.vocabulary,
                    "translation": phrase.translation,
                    "isReviewPhase": phrase.isReviewPhase ? "true" : "false",
                    "levelNumber": phrase.levelNumber
                ]).execute()
        } catch {
            throw NetworkError.noData
        }
    }
}
