//
//  PhraseCardRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/10/24.
//

import Foundation
import Combine
import SwiftData
import Supabase

internal protocol PhraseCardRepositoryType {
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
    func update(id: String, nextLevelNumber: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class PhraseCardRepository: PhraseCardRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    private let supabase = SupabaseService.shared.getClient()
    
    private var hasSynchronized: Bool = false
    
    init() { }
    
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        return Future<[PhraseCardModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.ensureSynchronized()
                    let phrases = try self.fetchFromLocal()
                   
                    print("repo fetch \(String(describing: phrases))")
                    promise(.success(phrases))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try self.createLocal(param: param)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try self.deleteLocal(id: id)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(id: String, nextLevelNumber: String) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try self.updateLocal(id: id, nextLevelNumber: nextLevelNumber)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}


// MARK: Local Repository
extension PhraseCardRepository {
    @MainActor private func fetchFromLocal() throws -> [PhraseCardModel]? {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
        let phrases = try container?.mainContext.fetch(fetchDescriptor)
        return phrases?.compactMap { $0.toDomain() }
    }
    
    @MainActor private func createLocal(param: PhraseCardModel) throws {
        let entity = PhraseCardEntity(id: param.id, topicID: param.topicID, vocabulary: param.vocabulary, phrase: param.phrase, translation: param.translation, isReviewPhase: param.isReviewPhase, levelNumber: param.levelNumber, lastReviewedDate: param.lastReviewedDate, nextReviewDate: param.nextReviewDate)
        self.container?.mainContext.insert(entity)
        try self.container?.mainContext.save()
    }
    
    @MainActor private func updateLocal(id: String, nextLevelNumber: String) throws {
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
    
    @MainActor private func deleteLocal(id: String) throws {
        let fetchDescriptor = FetchDescriptor<PhraseCardEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            container?.mainContext.delete(entity)
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
}

// MARK: Remote Repository
extension PhraseCardRepository {
    private func fetchRemote() async throws -> [PhraseCardModel] {
        do {
            let fetchedPhrase: [PhraseCardModel] = try await supabase
                .database
                .from("Phrases")
                .select()
                .execute()
                .value
            print("test")
            
            if !fetchedPhrase.isEmpty {
                return fetchedPhrase
            }
        } catch {
            return []
        }
        
        return []
    }
    
    private func createRemote(param: PhraseCardModel) async throws {
        do {
            try await supabase
                .database
                .from("Phrases")
                .insert([
                    "Phrase": param.id,
                    "topicID": param.topicID,
                    "vocabulary": param.vocabulary,
                    "translation": param.translation,
                    "isReviewPhase": param.isReviewPhase ? "true" : "false",
                    "levelNumber": param.levelNumber
                ]).execute()
        } catch {
            throw NetworkError.noData
        }
    }
    
    private func updateRemote(param: PhraseCardModel) async throws {
        do {
            try await supabase
                .database
                .from("Phrases")
                .update([
                    "id": param.id,
                    "topicID": param.topicID,
                    "vocabulary": param.vocabulary,
                    "translation": param.translation,
                    "isReviewPhase": param.isReviewPhase ? "true" : "false",
                    "levelNumber": param.levelNumber
                ])
                .eq("id", value: param.id)
                .execute()
        } catch {
            throw NetworkError.noData
        }
    }
}

// MARK: UTILITIES FUNCTION
extension PhraseCardRepository {
    private func ensureSynchronized() async throws {
        guard !self.hasSynchronized && SyncManager.isFirstAppOpen() else { return
        }
        
        try await self.synchronizeRemoteToLocal()
        SyncManager.markAsSynchronized()
        self.hasSynchronized = true
    }
    
    private func synchronizeRemoteToLocal() async throws {
        let remotePhrase = try await self.fetchRemote()
        for phrase in remotePhrase{
            try await self.createLocal(param: phrase)
        }
    }
}

