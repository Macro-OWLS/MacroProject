//
//  PhraseCardView.swift
//  MacroProject
//
//  Created by Agfi on 08/10/24.
//

import SwiftUI
import Routing

struct LibraryPhraseCardView: View {
    @ObservedObject var viewModel: PhraseCardViewModel
    @ObservedObject var topicViewModel: TopicViewModel
    @StateObject var router: Router<NavigationRoute>
    var topicID: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("Cards Added: \(viewModel.cardsAdded)")
                    .font(.headline)
                    .padding()
                SwipeableFlashcardsView(viewModel: viewModel)
            }
        }
        .navigationTitle(topicViewModel.topics.first { $0.id == topicID }?.name ?? "Unknown Topic")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done"){
                    router.popToRoot()
                }
                
            }
        }
        .onAppear {
            viewModel.fetchPhraseCards(topicID: topicID)
        }
    }
}
