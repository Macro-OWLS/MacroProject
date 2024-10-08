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
                    ProgressView("Loading phrases...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.phrases.isEmpty {
                    ContentUnavailableView("No Phrases Available", systemImage: "")
                        .foregroundColor(.gray)
                        .opacity(0.3)
                } else {
                    List {
                        ForEach(viewModel.phrases, id: \.id) { phrase in
                            VStack(alignment: .leading) {
                                Text(phrase.phrase)
                                Text(phrase.translation)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationTitle("Phrases")
                }
            }
            .onAppear {
                viewModel.fetchPhrases()
            }
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
