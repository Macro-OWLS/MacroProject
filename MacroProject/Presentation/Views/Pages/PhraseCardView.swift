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
        ZStack {
            // Set the background color to cream
            Color.cream
                .ignoresSafeArea() // Ensure it covers the entire screen
            
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    Text("Cards Added: \(viewModel.cardsAdded)")
                        .font(.helveticaHeader3)
                        .padding(27)
                    SwipeableFlashcardsView(viewModel: viewModel)
                        .padding(.bottom, 129)
                }
            }
            .navigationTitle(topicViewModel.topics.first { $0.id == topicID }?.name ?? "Unknown Topic")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        router.popToRoot()
                    }
                    .foregroundColor(Color.blue)
                }
            }
            .onAppear {
                viewModel.fetchPhraseCards(topicID: topicID)
            }
        }
    }
}

