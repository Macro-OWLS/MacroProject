//
//  HomeViewModel.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import Foundation
import Combine
import SwiftUI

internal final class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var user: UserModel = UserModel(id: "")
    @Published var errorMessage: String?
    @Published var isStreakOnGoing: Bool = false
    @Published var isStreakAdded: Bool = false
    @Published var isStreakComplete: Bool = false
    @Published var lastUserUpdate: Date? = Date()
    @Published var userStreakTarget: Int? = 0
    @Published var targetCounter: Int = 0
    @Published var todayReviewedPhraseCounter: Int = 0
    @Published var todayReviewedPhrase: [UserPhraseCardModel] = []
    @Published var streak: Int? = 0
    @Published var retainedPhraseCount: Int = 0
    @Published var reviewedPhraseCount: Int = 0
    
    @Published var featureCards: [FeatureCardType] = [
        .init(id: "review", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"),
        .init(id: "study", backgroundColor: Color.blue, icon: "TopicStudyMascot", title: "Topic Study", description: "Text Description"),
        .init(id: "cards-learned", backgroundColor: Color.yellow, icon: "MethodTutorialMascot", title: "Method Explanation", description: "Text Description")
    ]
    
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 3, to: today) ?? Date()
    }
    private let userCase: UserUseCaseType = UserUseCase()
    private let userPhraseCase: UserPhraseUseCaseType = UserPhraseUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    var formattedJoinDate: String {
        if let createdAt = user.createdAt {
            return dateFormatter.string(from: createdAt)
        }
        return "N/A"
    }
    
    @MainActor
    func getStreakData() async {
        self.isLoading = true
        
        do {
            if let user = try await userCase.getUserSession() {
                self.user = user
                self.lastUserUpdate = user.updatedAt
                self.streak = user.streak
                self.isStreakComplete = user.isStreakComplete ?? false
                self.userStreakTarget = user.targetStreak
                print("streak [\(streak)")
                
            } else {
                self.errorMessage = "User session not found."
            }
        } catch {
            self.errorMessage = "Failed to get user streak: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    func updateUserStreak() async {
        do {
            try await userCase.updateUserStreak(uid: user.id, streak: streak ?? 0, isStreakOnGoing: isStreakOnGoing, updateAT: today, isStreakComplete: true)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to update user streak: \(error.localizedDescription)"
            }
        }
    }
    
    @MainActor
    func updateOnGoingStreak() async {
        guard let lastUserUpdate else {
            return
        }
        
        if streak == 0 || !Calendar.current.isDate(lastUserUpdate, inSameDayAs: Date()) {
            let req_2 = await StreakRequirement_2()
            if req_2 {
                if let currentStreak = streak {
                    self.streak = currentStreak + 1
                    self.isStreakOnGoing = true
                    self.isStreakAdded = true
                } else {
                    print("Error: Streak is nil.")
                }
            } else {
                self.streak = 0
                self.isStreakOnGoing = false
                self.isStreakAdded = false
            }
        } else {
            print("Streak already updated today. No further action.")
        }

        await updateUserStreak()

        print("Updated Streak Data: \(streak ?? 0), isStreakOnGoing: \(isStreakOnGoing), isStreakAdded: \(isStreakAdded)")
    }

    
    func StreakRequirement_1() -> Bool {
        guard let lastUserUpdate else {
            return false
        }

        let timeDifference = today.timeIntervalSince(lastUserUpdate)

        // 24 jam = 86400 detik
        return timeDifference >= 86400
    }

    
    func StreakRequirement_2() async -> Bool {
        guard let userStreakTarget else {
            return false
        }
        do {
            let userReviewedPhraseResult = try await userPhraseCase.getFilteredPhraseByUserID(userID: user.id)

            switch userReviewedPhraseResult {
            case .success(let reviewedPhrases):
                let phrase = reviewedPhrases.filter { phrase in
                    if let lastReviewedDate = phrase.lastReviewedDate {
                        return Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
                    }
                    return false
                }.count
                
                if phrase >= userStreakTarget && userStreakTarget != 0 {
                    print("Requirement 2 met. Incrementing streak.")
                    return true
                } else {
                    print("Requirement 2 not met. Resetting streak.")
                    return false
                }

            case .failure(let error):
                self.errorMessage = "Failed to get reviewed phrases: \(error.localizedDescription)"
                return false
            }
        } catch {
            self.errorMessage = "Failed to get reviewed phrases: \(error.localizedDescription)"
            return false
        }
    }

    
    func reviewedPhraseCounter() async { // utk total reviewed phrase
        do {
            let userReviewedPhraseResult = try await userPhraseCase.getFilteredPhraseByUserID(userID: user.id)
            
            switch userReviewedPhraseResult {
            case .success(let reviewedPhrases):
                let todayReviewedPhrase = reviewedPhrases.filter { phrase in
                    if let lastReviewedDate = phrase.lastReviewedDate {
                        return Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
                    }
                    return false
                }.count
                
                let counter = reviewedPhrases.count
                
                print("counter reviewed = \(counter)")
                DispatchQueue.main.async {
                    self.todayReviewedPhraseCounter = todayReviewedPhrase
                    self.reviewedPhraseCount = counter
                }
                
            case .failure(let error):
                self.errorMessage = "Failed to count reviewed phrases: \(error.localizedDescription)"
            }
            
        } catch {
            self.errorMessage = "Failed to count reviewed phrases: \(error.localizedDescription)"
        }
    }
    
    func retainedPhraseCounter() async { // utk total retained phrase
        do {
            let userReviewedPhraseResult = try await userPhraseCase.getFilteredPhraseByUserID(userID: user.id)
            
            switch userReviewedPhraseResult {
            case .success(let reviewedPhrases):
                let counter = reviewedPhrases.filter { phrase in
                    phrase.prevLevel == "6" && phrase.nextLevel == "6"
                }.count
                
                print("counter retained = \(counter)")
                DispatchQueue.main.async {
                    self.retainedPhraseCount = counter
                }
            case .failure(let error):
                self.errorMessage = "Failed to count reviewed phrases: \(error.localizedDescription)"
            }
            
        } catch {
            self.errorMessage = "Failed to count reviewed phrases: \(error.localizedDescription)"
        }
    }
}
    
//    func addStreak() async { // check button
//
//        do {
//            let userReviewedPhraseResult = try await userPhraseCase.getFilteredPhraseByUserID(userID: user.id)
//
//            switch userReviewedPhraseResult {
//            case .success(let reviewedPhrases):
//                let isTherePhraseReviewedToday = reviewedPhrases.contains { phrase in
//                    Calendar.current.isDate(phrase.lastReviewedDate ?? Date(), inSameDayAs: today)
//                }
//                print("userUpdateStreak = \(isTherePhraseReviewedToday)")
//                if !isTherePhraseReviewedToday {
//                    streak! += 1
//                    print("userUpdateStreak = \(streak!)")
//                }
//
//            case .failure(let error):
//                self.errorMessage = "Failed to get reviewed phrases: \(error.localizedDescription)"
//            }
//
//        } catch {
//            self.errorMessage = "Failed to get reviewed phrases: \(error.localizedDescription)"
//        }
//
//    }
    
    
//    func addStreak() {
//        streak! += 1
//        isStreakAdded = true
//        Task {
//            await updateUserStreak()
//        }
//    }
