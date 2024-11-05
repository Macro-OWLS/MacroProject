//
//  HomeFeatureContainer.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct HomeFeatureContainer: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack(content: {
            Color(Color.darkcream)
                .ignoresSafeArea()
            VStack(spacing: 32, content: {
                ForEach(homeViewModel.featureCards, id: \.self) { featureCard in
                    FeatureCard(featureCard: featureCard)
                }
            })
            .padding(.top, 32)
            .padding(.bottom, 80)
            .cornerRadius(32)
        })
    }
}

#Preview {
    HomeFeatureContainer()
        .environmentObject(HomeViewModel())
}
