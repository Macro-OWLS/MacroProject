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
        NavigationView {
            VStack(spacing: 16) {
                ForEach(carouselAnimationViewModel.recapAnsweredPhraseCards, id: \.self) { phrase in
                    VStack(content: {
                        if phrase.isCorrect {
                            CorrectPhrasePreview(phrase: phrase)
                        } else if !phrase.isCorrect {
                            IncorrectPhrasePreview(phrase: phrase)
                        }
                    })
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

#Preview {
    ReviewRecapView(carouselAnimationViewModel: CarouselAnimationViewModel())
}
