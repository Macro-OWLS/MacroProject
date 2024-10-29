//
//  LibraryViewModel.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 29/10/24.
//
import SwiftUI
import Combine

class LibraryViewModel: ObservableObject {
    @Published var topics: [TopicModel] = [] // Replace TopicModel with your actual model type
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchTopic: String = "" // For search functionality
    
    private var cancellables = Set<AnyCancellable>()
    private var topicViewModel: TopicViewModel // Declare the TopicViewModel property

    // New property to hold PhraseCardViewModels
    private var phraseCardViewModels: [String: PhraseCardViewModel] = [:]

    // Computed property to organize topics into sections
    var sectionedTopics: [String: [TopicModel]] {
        Dictionary(grouping: topics, by: { $0.section }) // Adjust as necessary based on your TopicModel structure
    }

    // Initialize with a TopicViewModel
    init(topicViewModel: TopicViewModel) {
        self.topicViewModel = topicViewModel
        fetchTopics()
    }

    func fetchTopics() {
        isLoading = true
        errorMessage = nil

        // Fetch topics from the topicViewModel and subscribe to updates
        topicViewModel.$topics
            .sink { [weak self] topics in
                self?.topics = topics
                self?.isLoading = false
            }
            .store(in: &cancellables)

        topicViewModel.$errorMessage
            .sink { [weak self] error in
                self?.errorMessage = error
                self?.isLoading = false
            }
            .store(in: &cancellables)

        topicViewModel.fetchTopics()
    }

    // Method to get or create PhraseCardViewModel for a topic
    func getPhraseCardViewModel(for topicID: String) -> PhraseCardViewModel {
        if let viewModel = phraseCardViewModels[topicID] {
            return viewModel
        } else {
            let newViewModel = PhraseCardViewModel()
            phraseCardViewModels[topicID] = newViewModel
            newViewModel.fetchPhraseCards(topicID: topicID) // Initial fetch
            return newViewModel
        }
    }

    // Method to filter topics based on the search text and section
    func filteredTopics(for section: String) -> [TopicModel] {
        let topicsInSection = sectionedTopics[section] ?? []
        return topicsInSection.filter { topic in
            topic.name.localizedCaseInsensitiveContains(searchTopic) || searchTopic.isEmpty
        }
    }
}
