import SwiftUI

struct StudyView: View {
    @EnvironmentObject var libraryViewModel: StudyViewModel
    @EnvironmentObject var router: Router
    
    // Define the columns for LazyVGrid
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 24),  // Horizontal spacing between columns
            GridItem(.flexible(), spacing: 16)   // Horizontal spacing between columns
        ]
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
                                LazyVGrid(columns: columns, alignment: .leading, spacing: 28) {
                                    topicSections
                                }
                                .padding(.horizontal,16)
                            }
                            .clipped()
                            .padding(.top, 0)
                        }
                    }
                    .navigationTitle("Topic Study")
                    .navigationBarTitleDisplayMode(.large)
                    .searchable(text: $libraryViewModel.searchTopic, prompt: "Search")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text(DateHelper.formattedDateString(from: Date()))
                                .font(.helveticaHeader3)
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
                .font(.helveticaHeader3)
                .frame(maxWidth: .infinity, alignment: .leading)) {
                sectionedTopicList(for: section)
            }
        }
    }
    
    private func sectionedTopicList(for section: String) -> some View {
        let filteredTopics = libraryViewModel.filteredTopics(for: section)
        
        // Loop through filteredTopics and create topic cards inside the LazyVGrid
        return ForEach(filteredTopics, id: \.id) { topic in
            Button(action: {
                router.navigateTo(.studyPhraseCardView(topic.id))
            }) {
                TopicCardStudy(topic: topic)
                    .frame(width: 173, height: 217) // Ensure the size matches the grid
            }
            .buttonStyle(.plain)
        }
    }
}

//#Preview {
//    StudyView()
//        .environmentObject(StudyViewModel(topicViewModel: TopicViewModel()))
//}
