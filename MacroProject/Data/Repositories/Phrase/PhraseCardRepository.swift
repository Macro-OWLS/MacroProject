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
    func update(id: String, result: PhraseResult) -> AnyPublisher<Bool, NetworkError>
}

internal final class PhraseCardRepository: PhraseCardRepositoryType {
    
    private let localRepository: LocalPhraseRepositoryType
    private let remoteRepository: RemotePhraseRepositoryType
    private let taskHelper: RepositoryTaskHelper
    
    init(localRepository: LocalPhraseRepositoryType = LocalPhraseRepository(), remoteRepository: RemotePhraseRepositoryType = RemotePhraseRepository(), syncHelper: SynchronizationHelper = SynchronizationHelper()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.taskHelper = RepositoryTaskHelper(syncHelper: syncHelper)
    }
    
    func fetch(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchPhrase(topicID: topicID)
        }
    }
    
    func fetch(levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchPhrase(levelNumber: levelNumber)
        }
    }
    
    func fetchPhrase(topicID: String, levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchPhrase(topicID: topicID, levelNumber: levelNumber)
        }
    }
    
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.createPhrase(param)
            try await self.remoteRepository.createPhrase(param)
            return true
        }
    }
    
    func delete(id: String) -> AnyPublisher<Bool, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.deletePhrase(id: id)
            return true
        }
    }
    
    func update(id: String, result: PhraseResult) -> AnyPublisher<Bool, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.updatePhrase(id: id, result: result)
            return true
        }
    }

}
