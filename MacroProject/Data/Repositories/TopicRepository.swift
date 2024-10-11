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
    private let container = SwiftDataContextManager.shared.container
    private let dataSynchronizer = DataSynchronizer()
    private let supabase = SupabaseService.shared.getClient()
    
    private var hasSynchronized: Bool = false
    
    init() { }
    
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError> {
        return Future<[TopicModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.ensureSynchronized()
                    let topics = try self.fetchFromLocal()
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
                    try self.createLocal(param: param)
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
                    try self.updateLocal(param: param)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Bool, NetworkError> { //on progress
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
}


// MARK: Local Repository
extension TopicRepository {
    @MainActor private func fetchFromLocal() throws -> [TopicModel]? {
        let fetchDescriptor = FetchDescriptor<TopicEntity>()
        let topics = try container?.mainContext.fetch(fetchDescriptor)
        return topics?.compactMap { $0.toDomain() }
    }
    
    @MainActor private func createLocal(param: TopicModel) throws {
        let entity = TopicEntity(id: param.id, name: param.name, desc: param.desc, isAddedToLibraryDeck: param.isAddedToLibraryDeck)
        self.container?.mainContext.insert(entity)
        try self.container?.mainContext.save()
    }
    
    @MainActor private func updateLocal(param: TopicModel) throws {
        let id = param.id
        let fetchDescriptor = FetchDescriptor<TopicEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            entity.name = param.name
            entity.desc = param.desc
            entity.isAddedToLibraryDeck = param.isAddedToLibraryDeck
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
    
    @MainActor private func deleteLocal(id: String) throws {
        let fetchDescriptor = FetchDescriptor<TopicEntity>(predicate: #Predicate { $0.id == id })
        if let entity = try container?.mainContext.fetch(fetchDescriptor).first {
            container?.mainContext.delete(entity)
            try container?.mainContext.save()
        } else {
            throw NetworkError.noData
        }
    }
}

// MARK: Remote Repository
extension TopicRepository {
    private func fetchRemote() async throws -> [TopicModel] {
        do {
            let fetchedTopic: [TopicModel] = try await supabase
                .database
                .from("Topics")
                .select()
                .execute()
                .value
            
            if !fetchedTopic.isEmpty {
                return fetchedTopic
            }
        } catch {
            return []
        }
        
        return []
    }
    
    private func createRemote(param: TopicModel) async throws {
        do {
            try await supabase
                .database
                .from("Topics")
                .insert([
                    "id": param.id,
                    "name": param.name,
                    "desc": param.desc,
                    "isAddedToLibraryDeck": param.isAddedToLibraryDeck ? "true" : "false"
                ]).execute()
        } catch {
            throw NetworkError.noData
        }
    }
    
    private func updateRemote(param: TopicModel) async throws {
        do {
            try await supabase
                .database
                .from("Topics")
                .update([
                    "name": param.name,
                    "desc": param.desc,
                    "isAddedToLibraryDeck": param.isAddedToLibraryDeck ? "true" : "false"
                ])
                .eq("id", value: param.id)
                .execute()
        } catch {
            throw NetworkError.noData
        }
    }
}

// MARK: UTILITIES FUNCTION
extension TopicRepository {
    private func ensureSynchronized() async throws {
        guard !self.hasSynchronized && SyncManager.isFirstAppOpen() else { return
        }
        
        try await self.synchronizeRemoteToLocal()
        SyncManager.markAsSynchronized()
        self.hasSynchronized = true
    }
    
    private func synchronizeRemoteToLocal() async throws {
        let remoteTopics = try await self.fetchRemote()
        for topic in remoteTopics {
            try await self.createLocal(param: topic)
        }
    }
}
