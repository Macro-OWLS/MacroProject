//
//  CarouselAnimation.swift
//  MacroProject
//
//  Created by Ages on 14/10/24.
//

import SwiftUI

// View: Displays the carousel of flashcards
struct CarouselAnimation: View {
    @ObservedObject var viewModel: CarouselAnimationViewModel
    var phraseCards: [PhraseCardModel]
    private let phraseHelper: PhraseHelper // Ensure this is initialized properly

    init(viewModel: CarouselAnimationViewModel, phraseCards: [PhraseCardModel], phraseHelper: PhraseHelper) {
        self.viewModel = viewModel
        self.phraseCards = phraseCards
        self.phraseHelper = phraseHelper // Initialize the phraseHelper
    }

    var body: some View {
        VStack {
            ZStack {
                // Iterate over the phraseCards array directly
                ForEach($viewModel.phraseCards, id: \.self) { phraseBinding in
                    // Get the current index of the phrase in the phraseCards
                    if let index = viewModel.phraseCards.firstIndex(where: { $0.id == phraseBinding.wrappedValue.id }),
                       abs(viewModel.currIndex - index) <= 1 {
                        let phrase = phraseBinding.wrappedValue // Unwrap the binding to get the actual value
                        if !phrase.isReviewPhase {
                            Flashcard(
                                englishText: phraseHelper.vocabSearch(
                                    phrase: phrase.phrase,
                                    vocab: phrase.vocabulary,
                                    vocabEdit: .blank
                                ),
                                indonesianText: phrase.translation
                            )
                            .opacity(viewModel.currIndex == index ? 1.0 : 0.5)
                            .scaleEffect(viewModel.currIndex == index ? 1.0 : 0.9)
                            .offset(x: viewModel.getOffset(for: index), y: 0)
                            .zIndex(viewModel.currIndex == index ? 1 : 0)
                        }
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                viewModel.moveToPreviousCard()
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                viewModel.moveToNextCard()
                            }
                        }
                    }
            )
        }
    }
}
