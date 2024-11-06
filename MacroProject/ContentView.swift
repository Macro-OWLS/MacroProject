//
//  ContentView.swift
//  MacroProject
//
//  Created by Agfi on 17/09/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        if onboardingViewModel.isAuthenticated {
            HomeView()
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(OnboardingViewModel())
        .environmentObject(Router())
}
