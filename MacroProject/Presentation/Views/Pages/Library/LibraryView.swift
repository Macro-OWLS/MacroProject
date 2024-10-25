import SwiftUI
import Combine
import Routing

struct LibraryView: View {
    @EnvironmentObject var topicViewModel: TopicViewModel
    @StateObject var router: Router<NavigationRoute>
    
    init(router: Router<NavigationRoute>) {
        _router = StateObject(wrappedValue: router)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cream
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.brown)
                        .frame(height: 1)
                    
                    VStack {
                        if topicViewModel.isLoading {
                            ProgressView("Loading topics...")
                        } else if let error = topicViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        } else if topicViewModel.topics.isEmpty {
                            ContentUnavailableView("No Topics Available", systemImage: "")
                                .foregroundColor(.gray)
                                .opacity(0.3)
                        } else {
                            StickyNavHelper()
                                .frame(height: 0)
                            ScrollView {
                                VStack(alignment: .leading, spacing: 20) {
                                    ForEach(topicViewModel.sectionedTopics.keys.sorted(), id: \.self) { section in
                                        Section(header: Text(section)
                                            .font(.helveticaHeader3)
                                            .frame(maxWidth: .infinity, alignment: .leading)) {
                                                sectionedTopicList(for: section)
                                            }
                                    }
                                }
                                .padding(16)
                            }
                            .clipped()
                            .padding(.top, -7.5)
                        }
                    }
                    .navigationTitle("Topic Library")
                    .navigationBarTitleDisplayMode(.large)
                    .searchable(text: $topicViewModel.searchTopic, prompt: "Search")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text(DateHelper.formattedDateString())
                                .font(.helveticaHeader3)
                        }
                    }
                    .onAppear {
                        topicViewModel.fetchTopics()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func sectionedTopicList(for section: String) -> some View {
        let topicsInSection = topicViewModel.sectionedTopics[section] ?? []
        return ForEach(topicsInSection, id: \.id) { topic in
            let phraseViewModel = PhraseCardViewModel()
            Button(action: {
                router.routeTo(.libraryPhraseCardView(topic.id))
            }) {
                TopicCardStudy(viewModel: phraseViewModel, topic: topic)
                    .onAppear {
                        phraseViewModel.fetchPhraseCards(topicID: topic.id)
                    }
                
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
