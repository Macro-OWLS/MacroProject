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
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack (spacing: 32){
                if libraryViewModel.isLoading {
                    LoadingView()
                } else if let error = libraryViewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if libraryViewModel.topics.isEmpty {
                    ContentUnavailableView("No Topics Available", systemImage: "")
                        .foregroundColor(.gray)
                        .opacity(0.3)
                } else {
                    VStack (alignment: .leading, spacing: 8){
                        Text("Topics Library")
                            .font(.poppinsH1)
                        Text("Essential for daily conversation")
                            .font(.poppinsB2)
                    }
                    .padding(.leading, 38)
                    .padding(.trailing, 42)
                    .padding(0)
                    .frame(width: 393, height: 40, alignment: .topLeading)
                    
                    StickyNavHelper()
                        .frame(height: 0)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 28) {
                            return ForEach(libraryViewModel.topics, id: \.id) { topic in
                                Button(action: {
                                    router.navigateTo(.studyPhraseCardView(topic.id))
                                }) {
                                    TopicCardStudy(topic: topic)
                                        .frame(width: 173, height: 217) // Ensure the size matches the grid
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal,16)
                    }
                    .clipped()
                    .padding(.vertical, 0)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                libraryViewModel.fetchTopics()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.poppinsB1)
                        })
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    StudyView()
        .environmentObject(StudyViewModel())
}
