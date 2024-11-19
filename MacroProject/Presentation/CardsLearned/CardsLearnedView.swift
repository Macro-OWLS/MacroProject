//
//  CardsLearnedView.swift
//  MacroProject
//
//  Created by Agfi on 19/11/24.
//

import SwiftUI

struct CardsLearnedView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Color.cream
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false, content: {
                VStack(alignment: .leading, spacing: 33, content: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Vocab Recap")
                            .font(.poppinsH1)
                        
                        Text("Revisit Your Memorized Vocab")
                            .font(.poppinsB1)
                    }
                    .frame(maxWidth: 313, alignment: .topLeading)
                    .padding(.top, 33)
                    
                    VStack(alignment: .leading, spacing: 16, content: {
                        Text("Total Words: \(homeViewModel.retainedPhraseCount)")
                            .font(.poppinsHeader3)
                        
//                        Text("Awful")
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 8)
//                            .background(Color.yellow)
//                            .cornerRadius(15)
                        if homeViewModel.retainedPhraseCount == 0 {
                            VStack(alignment: .center, spacing: 16, content: {
                                Image("UnavailableCapybara")
                                Text("You don't have any cards passed from Phase 5 yet")
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            })
                            .padding(.top, 120)
                        }
                    })
                })
                .padding(.horizontal, 40)
            })
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.navigateBack()
                }) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                            .font(.poppinsB1)
                    }
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CardsLearnedView()
        .environmentObject(HomeViewModel())
}
