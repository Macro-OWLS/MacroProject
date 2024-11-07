//
//  PhraseCardViewModel.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import Combine
import SwiftUI

final class PhraseCardViewModel: ObservableObject {
    @Published var phraseCards: [PhraseCardModel] = []
    @Published var phraseCardsByLevel: [PhraseCardModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cardOffset: CGSize = .zero
    @Published var currIndex: Int = 0
    @Published var cardsAdded: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: PhraseCardUseCaseType
    private let userPhraseUseCase: UserPhraseUseCaseType
    private let authService: AuthService
    
    init(useCase: PhraseCardUseCaseType = PhraseCardUseCase(), userPhraseUseCase: UserPhraseUseCaseType = UserPhraseUseCase(), authService: AuthService = AuthService.shared) {
        self.useCase = useCase
        self.userPhraseUseCase = userPhraseUseCase
        self.authService = authService
    }
    
    func countUnreviewedPhrases(for topicID: String) -> Int {
        return phraseCards.filter { $0.topicID == topicID && !$0.isReviewPhase }.count
    }
    
    func resetCardsAdded() {
        cardsAdded = 0
    }
    
    func fetchPhraseCards(topicID: String) {
        guard !isLoading else { return }
        
        isLoading = true

        useCase.fetchByTopicID(topicID: topicID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] phraseCards in
                self?.phraseCards = phraseCards ?? []
            }
            .store(in: &cancellables)
    }

    
    func updatePhraseCards(phraseID: String, result: PhraseResult){
        useCase.update(id: phraseID, result: result)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] updatedPhraseCard in
                if let index = self?.phraseCards.firstIndex(where: { $0.id == phraseID }) {
                    var currentCard = self?.phraseCards[index]
                    currentCard?.isReviewPhase = true
                    if let updatedCard = currentCard {
                        self?.phraseCards[index] = updatedCard
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func savePhraseToRemoteProfile(phrase: PhraseCardModel) async {
        do {
            try await userPhraseUseCase.createPhraseToReview(phrase: UserPhraseCardModel(
                id: UUID().uuidString,
                profileID: self.authService.getSession().user.id.uuidString,
                phraseID: phrase.id,
                topicID: phrase.topicID,
                vocabulary: phrase.vocabulary,
                phrase: phrase.phrase,
                translation: phrase.translation,
                prevLevel: "1",
                nextLevel: "1",
                nextReviewDate: Date())
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func librarySwipeRight() {
        withAnimation {
            cardOffset = CGSize(width: 500, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.libraryMoveToNextCard()
        }
    }

    func librarySwipeLeft() {
        withAnimation {
            cardOffset = CGSize(width: -500, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.libraryMoveToNextCard()
        }
    }

    func libraryMoveToNextCard() {
        cardOffset = .zero
        currIndex = (currIndex + 1) % phraseCards.count
    }
}
