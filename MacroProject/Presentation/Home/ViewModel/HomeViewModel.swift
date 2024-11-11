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
    @Published var streak: Int? = 0
    @Published var lastUserUpdate: Date? = Date()
    @Published var userStreakTarget: Int = 0
    @Published var targetCounter: Int = 0
    
    @Published var featureCards: [FeatureCardType] = [
        .init(id: "review", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"),
        .init(id: "study", backgroundColor: Color.blue, icon: "TopicStudyMascot", title: "Topic Study", description: "Text Description"),
        .init(id: "tutorial", backgroundColor: Color.yellow, icon: "MethodTutorialMascot", title: "Method Explanation", description: "Text Description")
    ]
    
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private let userUserCase: UserUseCaseType = UserUseCase()
    private let reviewedPhraseCase: ReviewedPhraseUseCaseType = ReviewedPhraseUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func getStreakData() async {
        self.isLoading = true
        
        do {
            if let user = try await userUserCase.getUserSession() {
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
    
    func updateUserStreak() async {
        self.isLoading = true
        
        do {
            try await userUserCase.updateUser(uid: user.id, streak: streak)
        } catch {
            self.errorMessage = "Failed to update user streak: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    func updateOnGoingStreak() async {
        let req_1 = StreakRequirement_1()
        let req_2 = StreakRequirement_2()
        
        if req_1 && req_2 {
            streak! += 1
            isStreakOnGoing = true
        } else {
            isStreakOnGoing = false
        }
        
    }
    
    func StreakRequirement_1() -> Bool {
        if let daysPassed = Calendar.current.dateComponents([.day], from: lastUserUpdate ?? Date(), to: today).day, daysPassed >= 1 {
            streak = 0
            return false
        } else {
            return true
        }
    }
    
    func StreakRequirement_2() -> Bool {
        if Calendar.current.isDate(lastUserUpdate ?? Date(), inSameDayAs: today) {
            return true
//            self.isLoading = true
//            reviewedPhraseCase.fetchReviewedPhraseByUserID(userID: user.id)
//                .sink(receiveCompletion: { completion in
//                    self.isLoading = false
//                    if case let .failure(error) = completion {
//                        self.errorMessage = "Failed to get reviewed phrase user: \(error.localizedDescription)"
//                    }
//                }, receiveValue: { [weak self] reviewedPhrases in
//                    if let reviewedPhrases = reviewedPhrases {
//                        self?.streak = self?.user.streak ?? 0
//                        self?.lastUserUpdate = self?.user.updatedAt
//                    } else {
//                        self?.errorMessage = "User session not found."
//                    }
//                })
//                .store(in: &cancellables)
        } else {
            
        }
        

        return false
    }


}

