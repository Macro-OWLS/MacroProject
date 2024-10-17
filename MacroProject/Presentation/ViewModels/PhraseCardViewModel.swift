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
    
    init(useCase: PhraseCardUseCaseType) {
        self.useCase = useCase
    }
    
    func fetchPhraseCards(topicID: String) {
        guard !isLoading else { return }
        
        isLoading = true

        useCase.fetch(topicID: topicID)
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
                print(self?.phraseCards)
            }
            .store(in: &cancellables)
    }
    
    func updatePhraseCards(phraseID: String){
        useCase.update(id: phraseID)
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
                print(self?.phraseCards)
            }
            .store(in: &cancellables)
    }
    
    //library animations
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
