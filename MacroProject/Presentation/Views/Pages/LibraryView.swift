import SwiftUI
import Combine
import Routing

struct LibraryView: View {
    @ObservedObject var viewModel: TopicViewModel
    @StateObject var router: Router<NavigationRoute>
    
    @State private var showCreateTopicSheet = false

    init(router: Router<NavigationRoute>, viewModel: TopicViewModel) {
        _router = StateObject(wrappedValue: router)
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading topics...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.topics.isEmpty {
                    ContentUnavailableView("No Topics Available", systemImage: "")
                        .foregroundColor(.gray)
                        .opacity(0.3)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            topicSections
                        }
                        .padding(16)
                    }
                    .navigationTitle("Phrases")
                }
            }
            .onAppear {
                viewModel.fetchTopics()
                
            }
        }
    }
    
    private var topicSections: some View {
        ForEach(viewModel.sectionedTopics.keys.sorted(), id: \.self) { section in
            Section(header: Text(section)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)) {
                sectionedTopicList(for: section)
            }
        }
    }
    
    private func sectionedTopicList(for section: String) -> some View {
        let topicsInSection = viewModel.sectionedTopics[section] ?? []
        return ForEach(topicsInSection, id: \.id) { topic in
            TopicCardStudy(topic: topic)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    router.routeTo(.libraryPhraseCardView(topic.id))
                }
        }
    }
}
