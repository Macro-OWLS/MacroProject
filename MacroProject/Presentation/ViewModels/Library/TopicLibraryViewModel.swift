//
//  TopicViewModel.swift
//  MacroProject
//
//  Created by Agfi on 03/10/24.
//

import Foundation
import Combine

final class TopicViewModel: ObservableObject {
    @Published var topics: [TopicModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isTopicCreated: Bool = false
    @Published var isTopicDeleted: Bool = false
    @Published var searchTopic: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let useCase: TopicUseCaseType
    
    // Computed property to filter topics based on the search term
    private var filteredTopics: [TopicModel] {
        if searchTopic.isEmpty {
            return topics
        } else {
            return TopicHelper.filterTopics(using: [(.name, searchTopic)], from: topics)
        }
    }
    
    // Computed property to group filtered topics by section
    public var sectionedTopics: [String: [TopicModel]] {
        Dictionary(grouping: filteredTopics, by: { $0.section })
    }
    
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

    func createTopic(name: String, icon: String, desc: String, section: String) {
        let newTopic = TopicModel(id: UUID().uuidString, name: name, icon: icon, desc: desc, isAddedToLibraryDeck: false, section: section)
        isLoading = true
        errorMessage = nil
        
        useCase.create(param: newTopic)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    self.isTopicCreated = true
                    self.fetchTopics()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func deleteTopic(id: String) {
        isLoading = true
        errorMessage = nil
        
        useCase.delete(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    self.fetchTopics()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func deleteTopic(at offsets: IndexSet) {
        offsets.forEach { index in
            let topic = topics[index]
            deleteTopic(id: topic.id)
        }
    }
}
