//
//  ReviewedPhraseUseCase.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import Combine

internal protocol ReviewedPhraseUseCaseType {
    func createReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) -> AnyPublisher<Bool, NetworkError>
    
    func fetchReviewedPhrasesByTopicID(_ topicID: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError>
    func fetchReviewedPhraseByLevel(prevLevel: String, nextLevel: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError>
}

internal final class ReviewedPhraseUseCase: ReviewedPhraseUseCaseType {
    private let repository: ReviewedPhraseRepositoryType
    
    init (repository: ReviewedPhraseRepositoryType = ReviewedPhraseRepository()) {
        self.repository = repository
    }
    
    func createReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) -> AnyPublisher<Bool, NetworkError> {
        repository.createReviewedPhrase(reviewedPhrase)
    }
    
    func fetchReviewedPhrasesByTopicID(_ topicID: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError> {
        repository.fetchReviewedPhrasesByTopicID(topicID)
    }
    
    func fetchReviewedPhraseByLevel(prevLevel: String, nextLevel: String) -> AnyPublisher<[ReviewedPhraseModel]?, NetworkError> {
        repository.fetchReviewedPhraseByLevel(prevLevel: prevLevel, nextLevel: nextLevel)
    }
}
