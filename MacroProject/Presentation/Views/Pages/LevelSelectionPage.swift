//
//  LevelSelectionPage.swift
//  MacroProject
//
//  Created by Agfi on 12/10/24.
//

import SwiftUI

struct LevelSelectionPage: View {
    @ObservedObject var levelViewModel: LevelViewModel
    @ObservedObject var phraseCardViewModel: PhraseCardViewModel
    var level: Level
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedView: TabViewType

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            // Set the background color here to fill the entire screen
            Color.cream
                .ignoresSafeArea() // Ensure it covers the entire screen
            
            VStack(alignment: .leading) {
                // Stroke under the navigation bar
                Rectangle()
                    .fill(Color.brown) // Stroke color
                    .frame(height: 1) // Line width
                    .padding(.top, 8) // Adjust for spacing below the navbar
                
                // Center the content
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    if level.level == 1 {
                        Button(action: {
                            selectedView = .library
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            AddTopic() // Keep button's original style
                        }
                    }
                    ForEach(levelViewModel.topicsToReviewTodayFilteredByLevel) { topic in
                        Button(action: {
                            levelViewModel.showStudyConfirmation = true
                            levelViewModel.selectedTopicToReview = topic
                            levelViewModel.fetchPhraseCardsToReviewByTopic(levelNumber: String(level.level), topicID: topic.id)
                        }) {
                            TopicCardReview(topicDTO: topic) // Keep button's original style
                        }
                    }
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top) // Allow the grid to expand
            }
            .navigationTitle(level.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide the native back button
            .toolbar {
                // Custom back button in the navigation bar
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
            .onAppear {
                levelViewModel.fetchTopicsByFilteredPhraseCards(levelNumber: String(level.level), level: level)
                levelViewModel.setSelectedLevel(level: level)
            }
            .overlay(
                Group {
                    if levelViewModel.showAlert {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        AlertView(alert: AlertType(isPresented: $levelViewModel.showAlert, title: levelViewModel.alertTitle, message: levelViewModel.alertMessage, dismissAction: {
                            levelViewModel.resetAlert()
                            presentationMode.wrappedValue.dismiss()
                        }))
                    }
                    if levelViewModel.showStudyConfirmation {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        StartStudyAlert(levelViewModel: levelViewModel)
                    }
                }
            )
        }
    }

    // Custom back button
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss() // Dismiss the current view
        }) {
            HStack {
                Image(systemName: "chevron.left") // Back arrow icon
                    .foregroundColor(Color.blue) // Change to your desired color
                Text("Back") // Optional: Add text next to the arrow
                    .foregroundColor(Color.blue) // Change to your desired color
            }
        }
    }
}

#Preview {
    ContentView()
}
