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
    
    // State variable to control the alert visibility
    @State private var showUnavailableAlert = false
    
    var body: some View {
        ZStack {
            // Set the background color to cream
            Color.cream
                .ignoresSafeArea() // Ensure it covers the entire screen
            
            VStack(spacing: 0) {
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
                // Conditionally show the "Done" button based on the alert's visibility
                ToolbarItem(placement: .topBarTrailing) {
                    if !showUnavailableAlert { // Hide button when alert is shown
                        Button("Done") {
                            router.popToRoot()
                        }
                        .foregroundColor(Color.blue)
                    }
                }
            }
            .onAppear {
                // Start by fetching the phrase cards for the topic
                viewModel.fetchPhraseCards(topicID: topicID)
            }

            .onChange(of: viewModel.phraseCards) { newValue in
                // After the phrase cards are fetched, check if there are any unreviewed cards for this topic
                let unreviewedCount = viewModel.countUnreviewedPhrases(for: topicID)
                
                // If no unreviewed cards are found, show the alert
                if unreviewedCount == 0 {
                    showUnavailableAlert = true
                } else {
                    showUnavailableAlert = false
                }
            }


            
            // Display the overlay with alert if showUnavailableAlert is true
            if showUnavailableAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea(edges: .all)
                
                AlertView(alert: AlertType(
                    isPresented: .constant(showUnavailableAlert),
                    title: "Deck is Empty",
                    message: "Choose another topic to study.",
                    dismissAction: {
                        router.popToRoot()
                    }
                ))
            }
        }
        .overlay(
            VStack {
                Rectangle() // Stroke is now only in the overlay
                    .fill(Color.brown) // Stroke color
                    .frame(height: 1) // Line width
            },
            alignment: .top // Ensures the stroke is positioned at the top
        )
    }
}
