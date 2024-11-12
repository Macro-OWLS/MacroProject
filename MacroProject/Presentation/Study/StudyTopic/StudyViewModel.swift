//
//  StudyViewModel.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 29/10/24.
//
import SwiftUI
import Combine

class StudyViewModel: ObservableObject {
    @Published var topics: [TopicModel] = [
        .init(id: "Tes", name: "Tes", icon: "Tes", desc: "Tes", isAddedToStudyDeck: true, section: "Tes"),
        .init(id: "Tes", name: "Tes", icon: "Tes", desc: "Tes", isAddedToStudyDeck: true, section: "Tes")
    ]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchTopic: String = "" // For search functionality

    private var cancellables = Set<AnyCancellable>()
    private let useCase: TopicUseCaseType

    init(useCase: TopicUseCaseType = TopicUseCase()) {
        self.useCase = useCase
    }

    func fetchTopics() {
        guard !isLoading else { return }

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
