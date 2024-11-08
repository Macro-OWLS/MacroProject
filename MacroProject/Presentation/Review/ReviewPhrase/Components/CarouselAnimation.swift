import SwiftUI

struct CarouselAnimation: View {
    @EnvironmentObject var reviewViewModel: ReviewPhraseViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(reviewViewModel.phrasesToReview.enumerated()), id: \.element.id) { index, phrase in
                    if !reviewViewModel.answeredCardIndices.contains(index) || (reviewViewModel.isAnswerIndicatorVisible && reviewViewModel.currIndex == index) {
                        Flashcard(
                            englishText: PhraseHelper().vocabSearch(
                                phrase: phrase.phrase,
                                vocab: phrase.vocabulary,
                                vocabEdit: .blank,
                                userInput: reviewViewModel.userInput,
                                isRevealed: reviewViewModel.isRevealed
                            ),
                            indonesianText: phrase.translation
                        )
                        .opacity(reviewViewModel.currIndex == index ? 1.0 : 0.5)
                        .scaleEffect(reviewViewModel.currIndex == index ? 1.0 : 0.9)
                        .offset(x: reviewViewModel.getOffset(for: index), y: 0)
                        .zIndex(reviewViewModel.currIndex == index ? 1 : 0)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                reviewViewModel.moveToPreviousCard()
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                reviewViewModel.moveToNextCard(phraseCards: reviewViewModel.phrasesToReview)
                            }
                        }
                    }
            )
        }
    }
}
