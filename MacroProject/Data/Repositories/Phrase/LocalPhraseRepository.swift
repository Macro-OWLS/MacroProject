//
//  LocalPhraseRepository.swift
//  MacroProject
//
//  Created by Ages on 12/10/24.
//

import Foundation
import SwiftData
import Supabase

internal protocol LocalPhraseRepositoryType {
    func fetchPhrase() async throws -> [PhraseCardModel]?
    func createPhrase(_ phrase: PhraseCardModel) async throws
    func updatePhrase(id: String, nextLevelNumber: String) async throws
    func deletePhrase(id: String) async throws
}

final class LocalPhraseRepository: LocalPhraseRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func fetchPhrase() throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        return phrases?.compactMap { $0.toDomain() }
    }
    
    @MainActor func createPhrase(_ phrase: PhraseCardModel) throws {
        let entity = PhraseCardEntity(id: phrase.id, topicID: phrase.topicID, vocabulary: phrase.vocabulary, phrase: phrase.phrase, translation: phrase.translation, isReviewPhase: phrase.isReviewPhase, levelNumber: phrase.levelNumber, lastReviewedDate: phrase.lastReviewedDate, nextReviewDate: phrase.nextReviewDate)
        self.container?.mainContext.insert(entity)
        try self.container?.mainContext.save()
    }
    
    @MainActor func updatePhrase(id: String, nextLevelNumber: String) throws {
        let id = id
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            entity.isReviewPhase = true
            entity.levelNumber = nextLevelNumber
//            entity.lastReviewedDate = Date.now()
//            entity.nextReviewDate = Date()
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
    
    @MainActor func deletePhrase(id: String) throws {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            container?.mainContext.delete(entity)
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
}
