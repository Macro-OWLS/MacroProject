import SwiftUI

struct CarouselAnimation: View {
    @EnvironmentObject var studyViewModel: StudyPhraseViewModel

    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(studyViewModel.phrasesToStudy.enumerated()), id: \.element.id) { index, phrase in
                    if !studyViewModel.answeredCardIndices.contains(index) || (studyViewModel.isAnswerIndicatorVisible && studyViewModel.currIndex == index) {
                        Flashcard(
                            englishText: PhraseHelper().vocabSearch(
                                phrase: phrase.phrase,
                                vocab: phrase.vocabulary,
                                vocabEdit: .blank,
                                userInput: studyViewModel.userInput,
                                isRevealed: studyViewModel.isRevealed
                            ),
                            indonesianText: phrase.translation
                        )
                        .opacity(studyViewModel.currIndex == index ? 1.0 : 0.5)
                        .scaleEffect(studyViewModel.currIndex == index ? 1.0 : 0.9)
                        .offset(x: studyViewModel.getOffset(for: index), y: 0)
                        .zIndex(studyViewModel.currIndex == index ? 1 : 0)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                studyViewModel.moveToPreviousCard()
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                studyViewModel.moveToNextCard(phraseCards: studyViewModel.phrasesToStudy)
                            }
                        }
                    }
            )
        }
    }
}
