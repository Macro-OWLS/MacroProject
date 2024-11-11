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
    func fetchPhrase(id: String) async throws -> [PhraseCardModel]?
    func fetchPhrase(topicID: String) async throws -> [PhraseCardModel]?
    func fetchPhrase(levelNumber: String) async throws -> [PhraseCardModel]?
    func fetchPhrases(topicID: String, levelNumber: String) async throws -> [PhraseCardModel]?
    func fetchPhrase(date: Date?, dateType: DateType) async throws -> [PhraseCardModel]?
    func fetchPhrase(levelNumber: String, date: Date?, dateType: DateType) async throws -> [PhraseCardModel]?
    func fetchPhrase(topicID: String, levelNumber: String, date: Date, dateType: DateType) async throws -> [PhraseCardModel]?
    func updatePhrase(id: String, result: PhraseResult) async throws
    func createPhrase(_ phrase: PhraseCardModel) async throws
}

final class LocalPhraseRepository: LocalPhraseRepositoryType {
    
    private let container = SwiftDataContextManager.shared.container
    
    @MainActor func fetchPhrase(id: String) throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [(.id, id)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchPhrase(topicID: String) throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [(.topic, topicID)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchPhrase(levelNumber: String) throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [(.level, levelNumber)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchPhrases(topicID: String, levelNumber: String) throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [(.level, levelNumber), (.topic, topicID)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchPhrase(date: Date?, dateType: DateType) async throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [], dateFilters: [(dateType, date)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchPhrase(levelNumber: String, date: Date?, dateType: DateType) async throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [(.level, levelNumber)], dateFilters: [(dateType, date)], from: domainPhrases ?? [])
    }
    
    @MainActor func fetchPhrase(topicID: String, levelNumber: String, date: Date, dateType: DateType) async throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        let domainPhrases = phrases?.compactMap { $0.toDomain() }
        return PhraseHelper.filterPhrases(using: [(.level, levelNumber), (.topic, topicID)], dateFilters: [(dateType, date)], from: domainPhrases ?? [])
    }
    
    
    @MainActor func updatePhrase(id: String, result: PhraseResult) throws {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>(predicate: #Predicate { $0.id == id })
        
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            entity.isReviewPhase = true
            let dateHelper = DateHelper()
            dateHelper.assignDate(for: entity, result: result)
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
    
    @MainActor func createPhrase(_ phrase: PhraseCardModel) throws {
        let entity = PhraseCardEntity(id: phrase.id, topicID: phrase.topicID, vocabulary: phrase.vocabulary, phrase: phrase.phrase, translation: phrase.translation, isReviewPhase: phrase.isReviewPhase, levelNumber: phrase.levelNumber, prevLevel: "0", nextLevel: "1", lastReviewedDate: phrase.lastReviewedDate, nextReviewDate: phrase.nextReviewDate)
        self.container?.mainContext.insert(entity)
        try self.container?.mainContext.save()
    }
    
}
