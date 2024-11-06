//
//  NewLevelViewModel.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import Combine
import SwiftUI

enum LevelType: Int, Equatable, Hashable, CaseIterable {
    case phase1
    case phase2
    case phase3
    case phase4
    case phase5

    var level: Level {
        switch self {
        case .phase1:
            return Level(level: 1, title: "Phase 1", description: "Learn this everyday")
        case .phase2:
            return Level(level: 2, title: "Phase 2", description: "Learn this every Tuesday & Thursday")
        case .phase3:
            return Level(level: 3, title: "Phase 3", description: "Learn this every Friday")
        case .phase4:
            return Level(level: 4, title: "Phase 4", description: "Learn this biweekly on Friday")
        case .phase5:
            return Level(level: 5, title: "Phase 5", description: "Learn this once a month")
        }
    }
}


final class NewLevelViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var phrasesToReviewToday: [PhraseCardModel] = []
    @Published var levels: [Level] = []
    
    private var phraseCardUseCase: PhraseCardUseCaseType
    private var today: Date = Calendar.current.startOfDay(for: Date())
    
    init(phraseCardUseCase: PhraseCardUseCaseType = PhraseCardUseCase()) {
        self.phraseCardUseCase = phraseCardUseCase
        self.levels = getLevels()
        fetchPhrasesReviewedToday()
    }
    private func getLevels() -> [Level] {
        return LevelType.allCases.map { $0.level }
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
            return currentDay == "Friday" ? .darkcream : .cream
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
            return currentDay == "Friday" ? .black : .brown
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
            return currentDay == "Friday" ? .black : .brown
        case 4, 5:
            return currentDay == "Friday" && filteredPhrasesByLevel(levelNumber: String(level.level)) > 0 ? .black : .brown
        default:
            return .gray
        }
    }
}
