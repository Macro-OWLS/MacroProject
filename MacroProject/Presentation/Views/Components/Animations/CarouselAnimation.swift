import SwiftUI

struct CarouselAnimation: View {
//    @EnvironmentObject var phraseStudyViewModel: PhraseStudyViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(levelViewModel.selectedPhraseCardsToReviewByTopic.indices, id: \.self) { index in
                    let phraseBinding = levelViewModel.selectedPhraseCardsToReviewByTopic[index]

                    if !levelViewModel.answeredCardIndices.contains(index) || (levelViewModel.isAnswerIndicatorVisible && levelViewModel.currIndex == index) {
                        Flashcard(
                            englishText: PhraseHelper().vocabSearch(
                                phrase: phraseBinding.phrase,
                                vocab: phraseBinding.vocabulary,
                                vocabEdit: .blank,
                                userInput: levelViewModel.userInput,
                                isRevealed: levelViewModel.isRevealed
                            ),
                            indonesianText: phraseBinding.translation
                        )
                        .opacity(levelViewModel.currIndex == index ? 1.0 : 0.5)
                        .scaleEffect(levelViewModel.currIndex == index ? 1.0 : 0.9)
                        .offset(x: levelViewModel.getOffset(for: index), y: 0)
                        .zIndex(levelViewModel.currIndex == index ? 1 : 0)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                levelViewModel.moveToPreviousCard()
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                levelViewModel.moveToNextCard(phraseCards: levelViewModel.selectedPhraseCardsToReviewByTopic)
                            }
                        }
                    }
            )
        }
    }
}
