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
            ZStack {
                Color.cream // Set the background color for the entire view
                    .ignoresSafeArea() // Ensure it covers the entire screen
                
                VStack(spacing: 0) {
                    // Stroke under the navigation bar
                    Rectangle()
                        .fill(Color.brown) // Stroke color
                        .frame(height: 1) // Line width
                    
                    // Main content
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
                            StickyNavHelper()
                                .frame(height: 0)
                            ScrollView {
                                VStack(alignment: .leading, spacing: 20) {
                                    topicSections
                                }
                                .padding(16)
                            }
                            .clipped()
                            .padding(.top, -7.5)
                        }
                    }
                    .navigationTitle("Topic Library")
                    .navigationBarTitleDisplayMode(.large)
                    .animation(nil)
                    .searchable(text: $viewModel.searchTopic, prompt: "Search")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text(DateHelper.formattedDateString())
                                .font(.helveticaHeader3)
                        }
                    }
                    .onAppear {
                        viewModel.fetchTopics()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var topicSections: some View {
        ForEach(viewModel.sectionedTopics.keys.sorted(), id: \.self) { section in
            Section(header: Text(section)
                .font(.helveticaHeader3)
                .frame(maxWidth: .infinity, alignment: .leading)) {
                sectionedTopicList(for: section)
            }
        }
    }
    
    private func sectionedTopicList(for section: String) -> some View {
        let topicsInSection = viewModel.sectionedTopics[section] ?? []
        return ForEach(topicsInSection, id: \.id) { topic in
            let phraseViewModel = PhraseCardViewModel(useCase: PhraseCardUseCase(repository: PhraseCardRepository()))
            Button(action:{
                router.routeTo(.libraryPhraseCardView(topic.id))
            }) {
                TopicCardStudy(viewModel: phraseViewModel, topic: topic)
                    .onAppear {
                        phraseViewModel.fetchPhraseCards(topicID: topic.id)
                    }
            }.buttonStyle(.plain)

        }
    }

}

#Preview {
    ContentView()
}
