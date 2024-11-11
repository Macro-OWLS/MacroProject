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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            HStack(alignment: .center, content: {
                Spacer()
                
                HStack(spacing: 8, content: {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("**\(onboardingViewModel.user.streak ?? 0)** Days Streak")
                    }
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                })
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color.darkcream)
                .cornerRadius(8)
            })
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(onboardingViewModel.user.fullName ?? "")")
                    .font(.poppinsHd)
                Text("Ready to make progress today?")
                    .font(.poppinsB1)
            }
        })
        .padding(.horizontal, 16)
    }
}
