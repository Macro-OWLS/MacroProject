//
//  CarouselAnimation.swift
//  MacroProject
//
//  Created by Ages on 14/10/24.
//

import SwiftUI

struct CarouselAnimation: View {
    @ObservedObject var viewModel: CarouselAnimationViewModel
    @ObservedObject var levelViewModel: LevelViewModel

    var body: some View {
        VStack {
            ZStack {
                // Iterate over the phraseCards array directly
                ForEach(levelViewModel.selectedPhraseCardsToReviewByTopic.indices, id: \.self) { index in
                    let phraseBinding = levelViewModel.selectedPhraseCardsToReviewByTopic[index]

                    // Check if the current index is in the answeredCardIndices set
                    // Show the answered card if the indicator is visible
                    if !viewModel.answeredCardIndices.contains(index) || (viewModel.isAnswerIndicatorVisible && viewModel.currIndex == index) {
                        Flashcard(
                            englishText: PhraseHelper().vocabSearch(
                                phrase: phraseBinding.phrase,
                                vocab: phraseBinding.vocabulary,
                                vocabEdit: .blank,
                                userInput: viewModel.userInput,
                                isRevealed: viewModel.isRevealed
                            ),
                            indonesianText: phraseBinding.translation
                        )
                        .opacity(viewModel.currIndex == index ? 1.0 : 0.5)
                        .scaleEffect(viewModel.currIndex == index ? 1.0 : 0.9)
                        .offset(x: viewModel.getOffset(for: index), y: 0)
                        .zIndex(viewModel.currIndex == index ? 1 : 0)
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
