//
//  NewLevelViewModel.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import Combine
import SwiftUI

final class LevelViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var phrasesforToday: [ReviewedPhraseModel] = []
    @Published var levels: [Level] = [
        .init(level: 1, title: "Phase 1", description: "Memorize everyday"),
        .init(level: 2, title: "Phase 2", description: "Memorize at Tuesday & Thursday"),
        .init(level: 3, title: "Phase 3", description: "Memorize every Friday"),
        .init(level: 4, title: "Phase 4", description: "Memorize every two weeks"),
        .init(level: 5, title: "Phase 5", description: "Memorize once in a month")
    ]
    
    private var cancellables = Set<AnyCancellable>()
    private var phraseCardUseCase: PhraseCardUseCaseType
    private var reviewedPhraseUseCase: ReviewedPhraseUseCase
    private var today: Date = Calendar.current.startOfDay(for: Date())
    
    init(phraseCardUseCase: PhraseCardUseCaseType = PhraseCardUseCase(), reviewedPhraseUseCase: ReviewedPhraseUseCase = ReviewedPhraseUseCase()) {
        self.phraseCardUseCase = phraseCardUseCase
        self.reviewedPhraseUseCase = reviewedPhraseUseCase
    }
    
    func getCurrentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: Date())
    }
    
    func isCurrentDay(for level: Level) -> Bool {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return true // Level 1 should be true for every day
        case 2:
            return currentDay == "Tuesday" || currentDay == "Thursday"
        case 3:
            return currentDay == "Friday"
        case 4:
            return checkIfLevelEmpty(level: 4) ? (currentDay == "Friday") : false
        case 5:
            return checkIfLevelEmpty(level: 5) ? (currentDay == "Friday") : false
        default:
            return false
        }
    }
    
    func setBackgroundColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .green
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .green : .gray
        case 3:
            return currentDay == "Friday" ? .green : .gray
        case 4, 5:
            return currentDay == "Friday" ? .green : .gray
        default:
            return .gray
        }
    }
    
    func setTextColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .white
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .white : .grey
        case 3:
            return currentDay == "Friday" ? .white : .grey
        case 4, 5:
            return currentDay == "Friday" ? .white : .grey
        default:
            return .gray
        }
    }
    
    func setStrokeColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .black // Level 1 has black text every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .black : .brown
        case 3:
            return currentDay == "Friday" ? .black : .brown
        case 4, 5:
            return currentDay == "Friday" ? .black : .brown
        default:
            return .gray
        }
    }
    
    func fetchAllReviewedPhraseForToday() {
        
        reviewedPhraseUseCase.fetchAllReviewedPhraseForToday()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] phrases in
                guard let self = self else { return }
                
                self.phrasesforToday = phrases ?? []
            }
            .store(in: &cancellables)
    }
    
    func checkIfLevelEmpty(level: Int) -> Bool {
        fetchAllReviewedPhraseForToday()
        
        let isEmpty = phrasesforToday.contains { $0.nextLevel == "\(level)" }
        return isEmpty
    }
}


