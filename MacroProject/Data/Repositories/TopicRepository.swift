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
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func save(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class TopicRepository: TopicRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    private let dataSynchronizer = DataSynchronizer()
    
    init() { }
    
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        return Future<[PhraseCardModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
                    let topic = try self.container?.mainContext.fetch(fetchDescriptor)
                    let models = topic?.compactMap { $0.toDomain() }
                    
                    promise(.success(models))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                // Use DataSynchronizer to save the data instead
                do {
                    try await self.dataSynchronizer.saveToLocal()
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
                    let fetchDescriptor = FetchDescriptor<PhraseCardEntity>(predicate: #Predicate { $0.phraseID == id })
                    let result = Result {
                        do {
                            if let entity = try self.container?.mainContext.fetch(fetchDescriptor).first {
                                self.container?.mainContext.delete(entity)
                                try self.container?.mainContext.save()
                                return true
                            } else {
                                throw NetworkError.noData
                            }
                        } catch {
                            throw error
                        }
                    }
                    
                    switch result {
                    case .success(let response):
                        promise(.success(response))
                    case .failure(let error):
                        promise(.failure(.genericError(error: error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
