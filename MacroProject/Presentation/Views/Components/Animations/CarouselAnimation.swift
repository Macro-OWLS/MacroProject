import SwiftUI

struct CarouselAnimation: View {
    @EnvironmentObject var phraseStudyViewModel: PhraseStudyViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(phraseStudyViewModel.selectedPhraseCardsToReviewByTopic.indices, id: \.self) { index in
                    let phraseBinding = phraseStudyViewModel.selectedPhraseCardsToReviewByTopic[index]

                    if !phraseStudyViewModel.answeredCardIndices.contains(index) || (phraseStudyViewModel.isAnswerIndicatorVisible && phraseStudyViewModel.currIndex == index) {
                        Flashcard(
                            englishText: PhraseHelper().vocabSearch(
                                phrase: phraseBinding.phrase,
                                vocab: phraseBinding.vocabulary,
                                vocabEdit: .blank,
                                userInput: phraseStudyViewModel.userInput,
                                isRevealed: phraseStudyViewModel.isRevealed
                            ),
                            indonesianText: phraseBinding.translation
                        )
                        .opacity(phraseStudyViewModel.currIndex == index ? 1.0 : 0.5)
                        .scaleEffect(phraseStudyViewModel.currIndex == index ? 1.0 : 0.9)
                        .offset(x: phraseStudyViewModel.getOffset(for: index), y: 0)
                        .zIndex(phraseStudyViewModel.currIndex == index ? 1 : 0)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                phraseStudyViewModel.moveToPreviousCard()
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                phraseStudyViewModel.moveToNextCard(phraseCards: phraseStudyViewModel.selectedPhraseCardsToReviewByTopic)
                            }
                        }
                    }
            )
        }
    }
}
