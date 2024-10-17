//
//  ReviewRecapView.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 11/10/24.
//

import SwiftUI

struct ReviewRecapView: View {
    @ObservedObject var carouselAnimationViewModel: CarouselAnimationViewModel
    
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
                VStack(spacing: 16) {
                    ForEach(carouselAnimationViewModel.recapAnsweredPhraseCards, id: \.self) { phrase in
                        VStack {
                            if phrase.isCorrect {
                                CorrectPhrasePreview(phrase: phrase)
                            } else {
                                IncorrectPhrasePreview(phrase: phrase)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal)
                .navigationTitle("Review Recap")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ReviewRecapView(carouselAnimationViewModel: CarouselAnimationViewModel())
}
