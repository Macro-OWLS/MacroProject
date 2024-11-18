//
//  TopicRepository.swift
//  MacroProject
//
//  Created by Agfi on 01/10/24.
//

import Foundation
import Combine
import SwiftData

internal protocol TopicRepositoryType {
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError>
    func removeAllTopics() async throws
}

internal final class TopicRepository: TopicRepositoryType {
    private let localRepository: LocalRepositoryType
    private let remoteRepository: RemoteRepositoryType
    private let taskHelper: RepositoryTaskHelper

    init(localRepository: LocalRepositoryType = LocalRepository(), remoteRepository: RemoteRepositoryType = RemoteRepository(), syncHelper: SynchronizationHelper = SynchronizationHelper()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.taskHelper = RepositoryTaskHelper(syncHelper: syncHelper)
    }
    
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError> {
        taskHelper.performTask(withSync: true) {
            try await self.localRepository.fetchTopics()
        }
    }
    
    func fetch(ids: [String]) -> AnyPublisher<[TopicModel]?, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.fetchTopics(ids: ids)
        }
    }
    
    func fetch(section: String) -> AnyPublisher<[TopicModel]?, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.fetchTopics(section: section)
        }
    }
    
    func fetch(name: String) -> AnyPublisher<[TopicModel]?, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.fetchTopics(name: name)
        }
    }
    
    func update(param: TopicModel) -> AnyPublisher<Bool, NetworkError> {
        taskHelper.performTask {
            try await self.localRepository.createTopic(param)
            return true
        }
    }
    
    func removeAllTopics() async throws {
        try await localRepository.removeAllTopics()
    }
}
