//
//  PhraseCardRepository.swift
//  MacroProject
//
//  Created by Agfi on 07/10/24.
//

import Foundation
import Combine
import SwiftData

internal protocol PhraseCardRepositoryType {
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError>
    func create(param: PhraseCardModel) -> AnyPublisher<Bool, NetworkError>
    func delete(id: String) -> AnyPublisher<Bool, NetworkError>
}

internal final class PhraseCardRepository: PhraseCardRepositoryType {
    private let container = SwiftDataContextManager.shared.container
    
    init() { }
    
    func fetch() -> AnyPublisher<[PhraseCardModel]?, NetworkError> {
        return Future<[PhraseCardModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    let fetchDescriptor = FetchDescriptor<PhraseCardEntity>()
                    let phraseCards = try self.container?.mainContext.fetch(fetchDescriptor)
                    let models = phraseCards?.compactMap { $0.toDomain() }
                    promise(.success(models))
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
                    let phraseCard = PhraseCardEntity(id: param.id, topicID: param.topicID, vocabulary: param.vocabulary, phrase: param.phrase, translation: param.translation, isReviewPhase: param.isReviewPhase, boxNumber: param.boxNumber, lastReviewedDate: param.lastReviewedDate, nextReviewDate: param.nextReviewDate)
                    self.container?.mainContext.insert(phraseCard)
                    try self.container?.mainContext.save()
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
                    let fetchDescriptor = FetchDescriptor<PhraseCardEntity>(predicate: #Predicate { $0.id == id })
                    let result = Result {
                        do {
                            if let entity = try
                                self.container?.mainContext.fetch(fetchDescriptor).first {
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
