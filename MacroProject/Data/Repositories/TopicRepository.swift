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
    
}

internal final class TopicRepository: TopicRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    init() { }
    
    func fetch() -> AnyPublisher<[TopicModel]?, NetworkError> {
        return Future<[TopicModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let fetchDescriptor = FetchDescriptor<TopicEntity>()
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
}
