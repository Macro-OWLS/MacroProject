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
    func fetch(id: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetch(topicID: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetch(levelNumber: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetch(levelNumber: String, date: Date?, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func fetch(topicID: String, levelNumber: String, date: Date, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func update(id: String, result: PhraseResult) -> AnyPublisher<Bool, NetworkError>
    
//    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
//    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
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
    
    func fetch(id: String) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchPhrase(id: id)
        }
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
    
    func fetch(levelNumber: String, date: Date?, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchPhrase(levelNumber: levelNumber, date: date, dateType: dateType)
        }
    }
    
    func fetch(topicID: String, levelNumber: String, date: Date, dateType: DateType) -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchPhrase(topicID: topicID, levelNumber: levelNumber, date: date, dateType: dateType)
        }
    }
    
    func update(id: String, result: PhraseResult) -> AnyPublisher<Bool, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.updatePhrase(id: id, result: result)
            return true
        }
    }
    
//    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
//        taskHelper.performTask {
//            try await self.localRepository.createPhrase(param)
//            try await self.remoteRepository.createPhrase(param)
//            return true
//        }
//    }
//    
//    func delete(id: String) -> AnyPublisher<Bool, NetworkError> {
//        taskHelper.performTask {
//            try await self.localRepository.deletePhrase(id: id)
//            return true
//        }
//    }
//    


}
