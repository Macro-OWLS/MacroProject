//
//  OnboardingViewModel.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

import Foundation
import Combine

internal final class OnboardingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var name: String = ""
    @Published var inputEmail: String = ""
    @Published var inputPassword: String = ""
    @Published var streak: Int = 0
}
