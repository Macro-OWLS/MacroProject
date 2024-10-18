//
//  ReviewRecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct ReviewRecapView: View {
    @ObservedObject var carouselAnimationViewModel: CarouselAnimationViewModel
    @Environment(\.presentationMode) var presentationMode // Environment variable for dismissing the view

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
                        ForEach(carouselAnimationViewModel.recapAnsweredPhraseCards, id: \.self) { phrase in
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
            presentationMode.wrappedValue.dismiss() // Dismiss the current view
        }) {
            HStack {
                Image(systemName: "chevron.left") // Back arrow icon
                    .foregroundColor(Color.blue) // Change to your desired color
                Text("Back") // Optional: Add text next to the arrow
                    .foregroundColor(Color.blue) // Change to your desired color
            }
        }
        .navigationTitle("Review Recap")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ReviewRecapView(carouselAnimationViewModel: CarouselAnimationViewModel())
}
