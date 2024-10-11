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
    func create(param: TopicModel) -> AnyPublisher<Bool, NetworkError>
    func update(param: TopicModel) -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class TopicRepository: TopicRepositoryType {
    private let localRepository: LocalRepositoryType
    private let remoteRepository: RemoteRepositoryType
    private let syncHelper: SynchronizationHelper

    init(localRepository: LocalRepositoryType = LocalRepository(), remoteRepository: RemoteRepositoryType = RemoteRepository(), syncHelper: SynchronizationHelper = SynchronizationHelper()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.syncHelper = syncHelper
    }
    
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError> {
        return Future<[TopicModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()
                    let topics = try await self.localRepository.fetchTopics()
                    promise(.success(topics))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func create(param: TopicModel) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.localRepository.createTopic(param)
                    try await self.remoteRepository.createTopic(param)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(param: TopicModel) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.localRepository.updateTopic(param)
                    try await self.remoteRepository.updateTopic(param)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Bool, NetworkError> {
        // Implementation for delete is on progress
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.localRepository.deleteTopic(id: id)
                    // Remote delete can be added here later
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
