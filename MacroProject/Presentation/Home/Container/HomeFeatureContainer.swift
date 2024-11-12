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
            VStack(spacing: 0, content: {
                Spacer()
                Image("WaveHome")
                    .offset(x: 60)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 712)
                    .foregroundColor(.blue)
            })
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ForEach(homeViewModel.featureCards, id: \.self) { featureCard in
                    FeatureCard(featureCard: featureCard)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 80)
            .padding(.horizontal, 10)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    HomeFeatureContainer()
        .environmentObject(HomeViewModel())
        .environmentObject(OnboardingViewModel())
}
