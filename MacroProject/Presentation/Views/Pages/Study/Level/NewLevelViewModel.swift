//
//  NewLevelViewModel.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import Combine
import SwiftUI

final class NewLevelViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var phrasesToReviewToday: [PhraseCardModel] = []
    
    @Published var levels: [Level] = [
        .init(level: 1, title: "Level 1", description: "Learn this everyday"),
        .init(level: 2, title: "Level 2", description: "Learn this every Tuesday & Thursday"),
        .init(level: 3, title: "Level 3", description: "Learn this every Friday"),
        .init(level: 4, title: "Level 4", description: "Learn this biweekly on Friday"),
        .init(level: 5, title: "Level 5", description: "Learn this once a month")
    ]
    
    private var phraseCardUseCase: PhraseCardUseCaseType
    private var today: Date = Calendar.current.startOfDay(for: Date())
    
    init(phraseCardUseCase: PhraseCardUseCaseType = PhraseCardUseCase()) {
        self.phraseCardUseCase = phraseCardUseCase
        fetchPhrasesReviewedToday()
    }
    
    func fetchPhrasesReviewedToday() {
        guard !isLoading else { return }
        isLoading = true
        
        phraseCardUseCase.fetchByDate(date: today, dateType: .nextDate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] phrases in
                guard let self = self else { return }
                
                self.phrasesToReviewToday = phrases ?? []
                print(phrasesToReviewToday)
            }
            .store(in: &cancellables)
    }
    
    private func filteredPhrasesByLevel(levelNumber: String) -> Int {
        return phrasesToReviewToday.count(where: { $0.levelNumber == levelNumber })
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
    
    func setBackgroundColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .darkcream // Level 1 has background cream every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .darkcream : .cream
        case 3:
            return currentDay == "Tuesday" ? .darkcream : .cream
        case 4, 5:
            return currentDay == "Friday" && filteredPhrasesByLevel(levelNumber: String(level.level)) > 0 ? .darkcream : .cream
        default:
            return .gray
        }
    }
    
    func setTextColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .black // Level 1 has black text every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .black : .brown
        case 3:
            return currentDay == "Tuesday" ? .black : .brown
        case 4, 5:
            return currentDay == "Friday" && filteredPhrasesByLevel(levelNumber: String(level.level)) > 0 ? .black : .brown
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
            return currentDay == "Tuesday" ? .black : .brown
        case 4, 5:
            return currentDay == "Friday" && filteredPhrasesByLevel(levelNumber: String(level.level)) > 0 ? .black : .brown
        default:
            return .gray
        }
    }
}
