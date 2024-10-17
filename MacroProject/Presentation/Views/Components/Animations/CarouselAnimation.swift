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
    @ObservedObject var levelViewModel: LevelViewModel

    var body: some View {
        VStack {
            ZStack {
                // Iterate over the phraseCards array directly
                ForEach(levelViewModel.selectedPhraseCardsToReviewByTopic, id: \.self) { phraseBinding in
                    // Get the current index of the phrase in the phraseCards
                    if let index = levelViewModel.selectedPhraseCardsToReviewByTopic.firstIndex(where: { $0.id == phraseBinding.id }),
                       abs(viewModel.currIndex - index) <= 1 {
                        let phrase = phraseBinding
//                        if !phrase.isReviewPhase {
                            Flashcard(
                                englishText: PhraseHelper().vocabSearch(
                                    phrase: phrase.phrase,
                                    vocab: phrase.vocabulary,
                                    vocabEdit: .blank, userInput: viewModel.userInput, isRevealed: viewModel.isRevealed
                                ),
                                indonesianText: phrase.translation
                            )
                            .opacity(viewModel.currIndex == index ? 1.0 : 0.5)
                            .scaleEffect(viewModel.currIndex == index ? 1.0 : 0.9)
                            .offset(x: viewModel.getOffset(for: index), y: 0)
                            .zIndex(viewModel.currIndex == index ? 1 : 0)
//                        }
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
                                viewModel.moveToNextCard(phraseCards: levelViewModel.selectedPhraseCardsToReviewByTopic)
                            }
                        }
                    }
            )
        }
    }
}
