//
//  LocalReviewedPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import SwiftData

internal protocol LocalReviewedPhraseRepositoryType {
    func createReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) async throws
    
    func fetchReviewedPhraseByTopicID(_ topicID: String) async throws -> [ReviewedPhraseModel]?
    func fetchReviewedPhraseByLevel(prevLevel: String, nextLevel: String) async throws -> [ReviewedPhraseModel]?
}

final class LocalReviewedPhraseRepository: LocalReviewedPhraseRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func createReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) throws {
        let entity = ReviewedPhraseEntity(id: reviewedPhrase.id, phraseID: reviewedPhrase.phraseID, topicID: reviewedPhrase.topicID, vocabulary: reviewedPhrase.vocabulary, phrase: reviewedPhrase.phrase, translation: reviewedPhrase.translation, prevLevel: reviewedPhrase.prevLevel, nextLevel: reviewedPhrase.nextLevel, lastReviewedDate: reviewedPhrase.lastReviewedDate, nextReviewDate: reviewedPhrase.nextReviewDate)
        self.container?.mainContext.insert(entity)
        try self.container?.mainContext.save()
    }
    
    @MainActor func fetchReviewedPhraseByTopicID(_ topicID: String) async throws -> [ReviewedPhraseModel]? {
        let fetchDescriptor = FetchDescriptor<ReviewedPhraseEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterReviewedPhrases(using: [(.topic, topicID)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchReviewedPhraseByLevel(prevLevel: String, nextLevel: String) async throws -> [ReviewedPhraseModel]? {
        let fetchDescriptor = FetchDescriptor<ReviewedPhraseEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterReviewedPhrases(using: [(.prevLevel, prevLevel), (.nextLevel, nextLevel)], from: domainPhrases ?? [])
    }
}
