import SwiftUI
import Combine

struct LibraryView: View {
    @ObservedObject var viewModel: TopicViewModel
    @State private var showCreateTopicSheet = false

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
                            ForEach(viewModel.sectionedTopics.keys.sorted(), id: \.self) { section in
                                Section(header:
                                    Text(section)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                ) {
                                    let topicsInSection = viewModel.sectionedTopics[section] ?? []
                                    ForEach(topicsInSection, id: \.id) { topic in
                                        TopicCardStudy(topic: topic)
                                            .frame(maxWidth: .infinity)
                                            .onTapGesture {
//                                                StudyPhraseCardView()
                                            }
                                    }

                                }
                            }
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
}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = TopicUseCase(repository: TopicRepository())
        let viewModel = TopicViewModel(useCase: mockUseCase)

        return LibraryView(viewModel: viewModel)
    }
}
