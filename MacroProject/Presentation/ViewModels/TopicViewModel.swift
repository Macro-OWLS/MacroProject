//
//  TopicViewModel.swift
//  MacroProject
//
//  Created by Agfi on 02/10/24.
//

import Combine
import SwiftUI

final class TopicViewModel: ObservableObject {
    @Published var topics: [TopicModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: TopicUseCaseType
    
    init(useCase: TopicUseCaseType) {
        self.useCase = useCase
        fetchTopics()
    }
    
    func fetchTopics() {
        isLoading = true
        errorMessage = nil
        
        useCase.fetch()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] topics in
                self?.topics = topics ?? []
            }
            .store(in: &cancellables)
    }
}
