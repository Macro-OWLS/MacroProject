import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var libraryViewModel: LibraryViewModel
    @EnvironmentObject var router: Router
    
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
                        if libraryViewModel.isLoading {
                            ProgressView("Loading topics...")
                        } else if let error = libraryViewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        } else if libraryViewModel.sectionedTopics.isEmpty {
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
                    .searchable(text: $libraryViewModel.searchTopic, prompt: "Search")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text(DateHelper.formattedDateString(from: Date()))
                                .font(.poppinsH3)
                        }
                    }
                    .onAppear {
                        libraryViewModel.fetchTopics()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var topicSections: some View {
        ForEach(libraryViewModel.sectionedTopics.keys.sorted(), id: \.self) { section in
            Section(header: Text(section)
                .font(.poppinsH3)
                .frame(maxWidth: .infinity, alignment: .leading)) {
                sectionedTopicList(for: section)
            }
        }
    }
    
    private func sectionedTopicList(for section: String) -> some View {
        let filteredTopics = libraryViewModel.filteredTopics(for: section)
        
        return ForEach(filteredTopics, id: \.id) { topic in
            let phraseViewModel = libraryViewModel.getPhraseCardViewModel(for: topic.id)
            Button(action: {
                router.navigateTo(.libraryPhraseCardView(topic.id))
            }) {
                TopicCardStudy(viewModel: phraseViewModel, topic: topic)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
