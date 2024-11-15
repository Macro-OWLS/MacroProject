//
//  ReviewedPhraseRepository.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import Combine

internal protocol ReviewedPhraseRepositoryType {
    func createReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) -> AnyPublisher<Bool, NetworkError>
    func fetchAllReviewedPhraseForToday()-> AnyPublisher<[ReviewedPhraseModel]?, NetworkError>
    func fetchReviewedPhrasesByTopicID(_ topicID: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError>
    func fetchReviewedPhraseByLevel(prevLevel: String, nextLevel: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError>
}

internal final class ReviewedPhraseRepository: ReviewedPhraseRepositoryType {
    private let localRepository: LocalReviewedPhraseRepositoryType
    private let syncHelper: SynchronizationHelper
    
    init(localRepository: LocalReviewedPhraseRepositoryType = LocalReviewedPhraseRepository(), syncHelper: SynchronizationHelper = SynchronizationHelper()) {
        self.localRepository = localRepository
        self.syncHelper = syncHelper
    }
    
    func createReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.localRepository.createReviewedPhrase(reviewedPhrase)
                    promise(.success(true))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchReviewedPhrasesByTopicID(_ topicID: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError> {
        return Future<[ReviewedPhraseModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()
                    let phrases = try await self.localRepository.fetchReviewedPhraseByTopicID(topicID)
                    promise(.success(phrases))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchReviewedPhraseByLevel(prevLevel: String, nextLevel: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError> {
        return Future<[ReviewedPhraseModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()
                    let phrases = try await self.localRepository.fetchReviewedPhraseByLevel(prevLevel: prevLevel, nextLevel: nextLevel)
                    promise(.success(phrases))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchAllReviewedPhraseForToday()-> AnyPublisher<[ReviewedPhraseModel]?, NetworkError> {
        return Future<[ReviewedPhraseModel]?, NetworkError> { promise in
            Task { @MainActor in
                do {
                    try await self.syncHelper.ensureSynchronized()
                    let phrases = try await self.localRepository.fetchAllReviewedPhraseForToday()
                    promise(.success(phrases))
                } catch {
                    promise(.failure(.noData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
