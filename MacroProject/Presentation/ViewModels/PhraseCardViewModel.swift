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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: PhraseCardUseCaseType
    
    init(useCase: PhraseCardUseCaseType) {
        self.useCase = useCase
        fetchPhraseCards()
    }
    
    func fetchPhraseCards() {
        isLoading = true

        useCase.fetch()
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
    
    func createPhraseCard(param: PhraseCardModel) {
        useCase.create(param: param)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    self?.fetchPhraseCards()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func deletePhraseCard(topicId: String) {
        useCase.delete(topicId: topicId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    self?.fetchPhraseCards()
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
