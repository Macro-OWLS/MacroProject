//
//  ReviewRecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct RecapPhrasesView: View {
    @EnvironmentObject var reviewPhraseViewModel: ReviewPhraseViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            // Set the background color to cream
            Color.cream
                .ignoresSafeArea() // Ensure it covers the entire screen
            
            VStack(spacing: 0) {
                // Stroke directly under the navigation bar
                Rectangle()
                    .fill(Color.brown) // Stroke color
                    .frame(height: 1) // Line width
                
                // Main content
                VStack {
                    ScrollView(content: {
                        ForEach(reviewPhraseViewModel.recapAnsweredPhraseCards, id: \.self) { phrase in
                            VStack {
                                if phrase.isCorrect {
                                    CorrectPhrasePreview(phrase: phrase)
                                } else {
                                    IncorrectPhrasePreview(phrase: phrase)
                                        .padding(.vertical, 20)
                                }
                            }
                        }
                    })
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal)
                .navigationTitle("Review Recap")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true) // Hide the default back button
                .navigationBarItems(leading: backButton) // Add custom back button
            }
        }
    }
    
    // Custom back button
    private var backButton: some View {
        Button(action: {
            router.navigateBack()
        }) {
           HStack {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                    Text("Back")
            }
            .foregroundColor(.blue)
        }
        .navigationTitle("Review Recap")
        .navigationBarTitleDisplayMode(.inline)
    }
}


