//
//  ReviewPhraseViewModel.swift
//  MacroProject
//
//  Created by Ages on 29/10/24.
//
import Foundation
import Combine

final class ReviewPhraseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var phrasesToReview: [PhraseCardModel] = [] {
        didSet {
            updateCurrentCard()
        }
    }
    @Published var currIndex: Int = 0
    @Published var currentCard: PhraseCardModel?
    @Published var isRevealed: Bool = false
    @Published var userInput: String = ""
    
    @Published var recapAnsweredPhraseCards: [UserAnswerDTO] = []
    @Published var unansweredPhrasesCount: Int = 0
    
    @Published var answeredCardIndices: Set<Int> = []
    @Published var isAnswerIndicatorVisible: Bool = false
    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", icon: "", hasReviewedTodayCount: 0, phraseCardCount: 0, isDisabled: false, phraseCards: [])
    
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private let phraseCardUseCase: PhraseCardUseCase = PhraseCardUseCase()
    private let reviewedPhraseUseCase: ReviewedPhraseUseCaseType = ReviewedPhraseUseCase()
    private let userPhraseUseCase: UserPhraseUseCaseType = UserPhraseUseCase()
    private let userUseCase: UserUseCaseType = UserUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    func updateCurrentCard() {
        if currIndex <= phrasesToReview.count  {
            currentCard = phrasesToReview[currIndex]
        } else {
            currentCard = nil
        }
    }
    
    func fetchPhrasesToReviewToday(topicID: String, selectedLevel level: Level) {
        guard !isLoading else { return }
        isLoading = true
        
        phraseCardUseCase.fetchByTopicAndLevel(topicID: topicID, levelNumber: String(level.level))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] phrases in
                guard let self = self else { return }
                self.phrasesToReview = phrases?.filter {
                    let isNextReviewToday = $0.nextReviewDate.map { Calendar.current.isDate($0, inSameDayAs: self.today) } ?? false
                    return isNextReviewToday &&
                            $0.nextLevel == String(level.level)
                } ?? []
                
                self.unansweredPhrasesCount = phrasesToReview.count
                
            }
            .store(in: &cancellables)
    }
    
    func addUserAnswer(userAnswer: UserAnswerDTO, phraseID: String) {
        recapAnsweredPhraseCards.append(userAnswer)
        answeredCardIndices.insert(currIndex)
        isAnswerIndicatorVisible = true
        unansweredPhrasesCount -= 1
        
        let nextReviewDate = DateHelper().assignReviewedPhrase(result: userAnswer.isCorrect ? .correct : .incorrect, prevLevel: userAnswer.levelNumber)
        addToReviewedPhrase(ReviewedPhraseModel(
            id: UUID().uuidString,
            phraseID: phraseID,
            topicID: userAnswer.topicID,
            vocabulary: userAnswer.vocabulary,
            phrase: userAnswer.phrase,
            translation: userAnswer.translation,
            prevLevel: userAnswer.levelNumber,
            nextLevel: userAnswer.isCorrect ? String((Int(userAnswer.levelNumber) ?? 0) + 1) : "1",
            lastReviewedDate: today,
            nextReviewDate: nextReviewDate)
        )
        
        Task {
            try await userPhraseUseCase.updatePhraseToReview(
                userID: userUseCase.getUserSession()?.id ?? "",
                phraseID: phraseID,
                result: UpdateUserPhraseReviewDTO(
                    prevLevel: userAnswer.levelNumber,
                    nextLevel: userAnswer.isCorrect ? String((Int(userAnswer.levelNumber) ?? 0) + 1) : "1",
                    lastReviewedDate: today, nextReviewDate: nextReviewDate)
            )
        }
    }
    
    func addToReviewedPhrase(_ reviewedPhrase: ReviewedPhraseModel) {
        reviewedPhraseUseCase.createReviewedPhrase(reviewedPhrase)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func moveToNextCard(phraseCards: [PhraseCardModel]) {
        guard !phraseCards.isEmpty else { return }

        isAnswerIndicatorVisible = false
        var newIndex = currIndex + 1

        newIndex = newIndex % phraseCards.count
        while answeredCardIndices.contains(newIndex) {
            newIndex = (newIndex + 1) % phraseCards.count
        }

        currIndex = newIndex
    }

    func moveToPreviousCard() {
        guard currIndex > 0 else { return }

        var newIndex = currIndex - 1
        while newIndex >= 0 {
            if !answeredCardIndices.contains(newIndex) {
                break
            }
            newIndex -= 1
        }
        if newIndex >= 0 {
            currIndex = newIndex
            updateCurrentCard()
        }
    }


    func getOffset(for index: Int) -> CGFloat {
        if index == currIndex {
            return 0
        } else if index < currIndex {
            return -50
        } else {
            return 50
        }
    }
    
}
