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
            Image("Water")
                .resizable()  // Allow the image to be resized
                .scaledToFill()  // Scale the image to fill the screen
                .frame(maxWidth: .infinity, maxHeight: .infinity)  // Ensure the image fills the screen
              /*  .clipped() */ // Clip any parts of the image that go beyond the bounds
            
            VStack(spacing: 0) {
                ForEach(homeViewModel.featureCards, id: \.self) { featureCard in
                    FeatureCard(featureCard: featureCard)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 80)
            .padding(.trailing, 18)
        }
        .edgesIgnoringSafeArea(.all)  // Make sure the ZStack occupies the whole screen
    }
}

#Preview {
    HomeFeatureContainer()
        .environmentObject(HomeViewModel())
        .environmentObject(OnboardingViewModel())
}
