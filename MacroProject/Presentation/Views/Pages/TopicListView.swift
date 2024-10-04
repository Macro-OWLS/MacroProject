//
//  TopicListView.swift
//  MacroProject
//
//  Created by Agfi on 03/10/24.
//

import SwiftUI
import Combine

struct TopicListView: View {
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
                    List {
                        ForEach(viewModel.topics) { topic in
                            Text(topic.name)
                        }
                        .onDelete(perform: deleteTopic)  // Enable swipe-to-delete
                    }
                    .navigationTitle("Topics")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateTopicSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showCreateTopicSheet) {
                        CreateTopicView(viewModel: viewModel)
                    }
                }
            }
            .onAppear {
                viewModel.fetchTopics()
            }
        }
    }
    
    private func deleteTopic(at offsets: IndexSet) {
        offsets.forEach { index in
            let topic = viewModel.topics[index]
            viewModel.deleteTopic(id: topic.id)
        }
    }
}


struct TopicListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = TopicUseCase(repository: TopicRepository())
        let viewModel = TopicViewModel(useCase: mockUseCase)

        return TopicListView(viewModel: viewModel)
    }
}
