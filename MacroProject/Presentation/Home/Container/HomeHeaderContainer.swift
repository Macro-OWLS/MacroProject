//
//  HomeHeaderContainer.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct HomeHeaderContainer: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                // Sun image in the background
                Image("Sun")
                    .offset(x: 133, y: -30) // Adjust position of the sun as needed
                
                VStack(alignment: .leading, spacing: 13) {
                    ZStack {
                        Image("CloudStreak")
                        
                        VStack(alignment: .leading, spacing: -2) {
                            Text("\(onboardingViewModel.user.streak ?? 10)")
                                .font(.poppinsH1)
                                .frame(width: 40, height: 52)
                            
                            Text("Days Streak!")
                                .font(.poppinsH2)
                            
                            Text("Longest Streak: \(onboardingViewModel.user.streak ?? 100)")
                        }
                        .padding(.leading, 40)
                        .padding(.trailing, 15)
                        .padding(.vertical, 10)
                        .frame(width: 250, height: 136, alignment: .topLeading)
                        .cornerRadius(30)
                    }
                    
                    ZStack {
                        Image("CloudStats")
                        
                        HStack(alignment: .center, spacing: 10) {
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(Color.green)
                                
                                Text("\(homeViewModel.reviewedPhraseCount)")
                                    .font(.poppinsB1)
                            }
                            .frame(width: 60, height: 28, alignment: .leading)
                            
                            HStack(alignment: .center, spacing: 5) {
                                Image(systemName: "brain.fill")
                                    .foregroundColor(Color.lightRedSemantics)
                                
                                Text("\(homeViewModel.retainedPhraseCount)")
                                    .font(.poppinsB1)
                            }
                            .frame(width: 60, height: 28, alignment: .leading)
                        }
                        .padding(.leading, 15)
                        .padding(10)
                    }
                    .padding(.top, -30)
                    .padding(.leading, 75)
                    .frame(width: 172, height: 77)
                }
                
                Button(action: {
                    router.navigateTo(.profileView)
                }) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)

                }
                .padding(.top, -120)
                .padding(.leading, 340)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeHeaderContainer()
        .environmentObject(OnboardingViewModel())
        .environmentObject(HomeViewModel())
}
