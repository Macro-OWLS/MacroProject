//
//  HomeFeatureContainer.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct HomeFeatureContainer: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Color(Color.darkcream)
                .ignoresSafeArea()
            VStack(spacing: 32) {
                ForEach(homeViewModel.featureCards, id: \.self) { featureCard in
                    FeatureCard(featureCard: featureCard)
                }
                
                Button(action: {
                    Task {
                        await onboardingViewModel.signOut()
                    }
                }) {
                    Text("Sign Out")
                        .padding(.horizontal, 46)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 80)
            .cornerRadius(32)
        }
    }
}


#Preview {
    HomeFeatureContainer()
        .environmentObject(HomeViewModel())
        .environmentObject(OnboardingViewModel())
}
