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
    func fetch(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetchPhrase(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
    func update(id: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class PhraseCardRepository: PhraseCardRepositoryType {
    
    private let localRepository: LocalPhraseRepositoryType
    private let remoteRepository: RemotePhraseRepositoryType
    private let syncHelper: SynchronizationHelper
    
    init(localRepository: LocalPhraseRepositoryType = LocalPhraseRepository(), remoteRepository: RemotePhraseRepositoryType = RemotePhraseRepository(), syncHelper: SynchronizationHelper = SynchronizationHelper()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.syncHelper = syncHelper
    }
    
    func fetch(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        return Future<[PhraseCardModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()

                    let phrases = try await self.localRepository.fetchPhrase(topicID: topicID)
                   
//                    print("repo fetch \(String(describing: phrases))")
                    promise(.success(phrases))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        return Future<[PhraseCardModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()
                    
                    let phrases = try await self.localRepository.fetchPhrase(levelNumber: levelNumber)
                    promise(.success(phrases))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchPhrase(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        return Future<[PhraseCardModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()

                    let phrases = try await self.localRepository.fetchPhrase(topicID: topicID, levelNumber: levelNumber)
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
                    try await self.localRepository.createPhrase(param)
                    try await self.remoteRepository.createPhrase(param)
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
                    try await self.localRepository.deletePhrase(id: id)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(id: String) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.localRepository.updatePhrase(id: id)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}
