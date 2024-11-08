//import SwiftUI
//
//class CarouselAnimationViewModel: ObservableObject {
//    @Published var currIndex: Int
//    @Published var isRevealed: Bool
//    @Published var userInput: String
//    @Published var recapAnsweredPhraseCards: [UserAnswerDTO]
//    @Published var answeredCardIndices: Set<Int> = []
//    @Published var isAnswerIndicatorVisible: Bool = false
//
//    init(currIndex: Int = 0) {
//        self.currIndex = currIndex
//        self.isRevealed = false
//        self.userInput = ""
//        self.recapAnsweredPhraseCards = []
//    }
//
//    func addUserAnswer(userAnswer: UserAnswerDTO) {
//        recapAnsweredPhraseCards.append(userAnswer)
//        answeredCardIndices.insert(currIndex)
//        isAnswerIndicatorVisible = true
//    }
//
//    func moveToNextCard(phraseCards: [PhraseCardModel]) {
//        guard !phraseCards.isEmpty else { return }
//
//        isAnswerIndicatorVisible = false
//        var newIndex = currIndex + 1
//
//        newIndex = newIndex % phraseCards.count
//        while answeredCardIndices.contains(newIndex) {
//            newIndex = (newIndex + 1) % phraseCards.count
//        }
//
//        currIndex = newIndex
//    }
//
//    func moveToPreviousCard() {
//        guard currIndex > 0 else { return }
//
//        var newIndex = currIndex - 1
//        while newIndex >= 0 && answeredCardIndices.contains(newIndex) {
//            newIndex -= 1
//        }
//        if newIndex >= 0 {
//            currIndex = newIndex
//        }
//    }
//
//    func getOffset(for index: Int) -> CGFloat {
//        if index == currIndex {
//            return 0
//        } else if index < currIndex {
//            return -50
//        } else {
//            return 50
//        }
//    }
//}
