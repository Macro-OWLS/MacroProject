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
    @Published var lastUserUpdate: Date? = Date()
    @Published var userStreakTarget: Int = 0
    @Published var targetCounter: Int = 0
    
    @Published var streak: Int? = 0
    @Published var retainedPhraseCount: Int = 0
    @Published var reviewedPhraseCount: Int = 0
    
    @Published var featureCards: [FeatureCardType] = [
        .init(id: "review", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"),
        .init(id: "study", backgroundColor: Color.blue, icon: "TopicStudyMascot", title: "Topic Study", description: "Text Description"),
        .init(id: "cards-learned", backgroundColor: Color.yellow, icon: "MethodTutorialMascot", title: "Method Explanation", description: "Text Description")
    ]
    
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private let userCase: UserUseCaseType = UserUseCase()
    private let userPhraseCase: UserPhraseUseCaseType = UserPhraseUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func getStreakData() async {
        self.isLoading = true
        
        do {
            if let user = try await userCase.getUserSession() {
                self.user = user
                self.lastUserUpdate = user.updatedAt
                self.streak = user.streak
                //                self.userStreakTarget = user.streakTarget
            } else {
                self.errorMessage = "User session not found."
            }
        } catch {
            self.errorMessage = "Failed to get user streak: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    func addStreak() {
        streak! += 1
        isStreakAdded = true
        Task {
            await updateUserStreak()
        }
        print("\n\n user Streak = \(streak!)")
    }
    
    func updateUserStreak() async {
        do {
            try await userCase.updateUser(uid: user.id, streak: streak, isStreakOnGoing: isStreakOnGoing)
            
            try await userCase.updateUser(uid: user.id, streak: streak, isStreakOnGoing: isStreakOnGoing)
            
        } catch {
            self.errorMessage = "Failed to update user streak: \(error.localizedDescription)"
        }
    }
    
    func updateOnGoingStreak() async {
        let req_1 = StreakRequirement_1()
//        let req_2 = await StreakRequirement_2()

        if req_1 /*&& req_2*/ {
            DispatchQueue.main.async {
                self.isStreakOnGoing = true
            }
        } else {
            streak = 0
            DispatchQueue.main.async {
                self.isStreakAdded = false
                self.isStreakOnGoing = false
            }
            await updateUserStreak()
        }
        print("OnGoingStreak = \(isStreakOnGoing)")
    }

    
    func StreakRequirement_1() -> Bool {
        if let daysPassed = Calendar.current.dateComponents([.day], from: lastUserUpdate ?? Date(), to: today).day, daysPassed >= 1 {
            return false
        } else {
            return true
        }
    }
    
    func reviewedPhraseCounter() async { // utk total reviewed phrase
        do {
            let userReviewedPhraseResult = try await userPhraseCase.getFilteredPhraseByUserID(userID: user.id)
            
            switch userReviewedPhraseResult {
            case .success(let reviewedPhrases):
                let counter = reviewedPhrases.count
                
                print("counter reviewed = \(counter)")
                DispatchQueue.main.async {
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

    

//    func addStreak() {
//        Task {
//            await addStreak()
//        }
//    }
    
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
    
    
//    func StreakRequirement_2() async -> Bool {
//        self.isLoading = true
//
//        if Calendar.current.isDate(lastUserUpdate ?? Date(), inSameDayAs: today) {
//            return false
//        }
//
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
//        
//        do {
//            let userReviewedPhraseResult = try await userPhraseCase.getFilteredPhraseByUserID(userID: user.id)
//            
//            switch userReviewedPhraseResult {
//            case .success(let reviewedPhrases):
//                let reviewedYesterdayCounter = reviewedPhrases.filter { phrase in
//                    Calendar.current.isDate(phrase.lastReviewedDate ?? today, inSameDayAs: yesterday ?? Date())
//                }.count
//                
//                if reviewedYesterdayCounter >= userStreakTarget {
//                    return true
//                } else {
//                    return false
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
//
//    }



}

