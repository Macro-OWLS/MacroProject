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
        ZStack(alignment: .top) {
            HStack(alignment: .top) {
                Image("Sun")
                    .offset(x: 60, y: -20)
            }
            
            HStack(alignment: .firstTextBaseline, content:  {
                VStack(alignment: .leading, spacing: 13) {
                    ZStack {
                        Image("CloudStreak")
                        
                        VStack(alignment: .leading, spacing: -2) {
                            Text("\(homeViewModel.user.streak ?? 10)")
                                .font(.poppinsH1)
                                .frame(width: 40, height: 45)
                            
                            Text("Day Streak!")
                                .font(.poppinsH2)
                            
                            Text("Review Target: \(homeViewModel.todayReviewedPhraseCounter ?? 99) / \(homeViewModel.user.targetStreak ?? 99)")
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
                    .padding(.leading, 80)
                    .frame(width: 172, height: 77)
                }
                .offset(x: -50, y: 10)
                Button(action: {
                    router.navigateTo(.profileView)
                }) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                .offset(x: 10)
            })
            .padding(.top, 60)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeHeaderContainer()
        .environmentObject(OnboardingViewModel())
        .environmentObject(HomeViewModel())
}
