//
//  TopicViewModel.swift
//  MacroProject
//
//  Created by Agfi on 03/10/24.
//

import Foundation
import Combine

final class TopicViewModel: ObservableObject {
    @Published var phrases: [PhraseCardModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isTopicCreated: Bool = false
    @Published var isTopicDeleted: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: TopicUseCaseType

    init(useCase: TopicUseCaseType) {
        self.useCase = useCase
        fetchPhrases()
    }

    func fetchPhrases() {
        isLoading = true
        errorMessage = nil

        useCase.save()
        useCase.fetch()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    print("fetched phrases successfully")
                    break
                case .failure(let error):
                    print("failed to fetch phrases: \(error.localizedDescription)  ")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] phrases in
                self?.phrases = phrases ?? []
            }
            .store(in: &cancellables)
    }


    
    func deletePhrases(id: String) {
        isLoading = true
        errorMessage = nil
        
        useCase.delete(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    self.fetchPhrases()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
