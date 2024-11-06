//
//  WelcomeView.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        ZStack(content: {
            Color(Color.cream)
                .ignoresSafeArea()
            
            VStack(spacing: 0, content: {
                Spacer()
                
                ZStack(alignment: .center, content: {
                    Circle()
                        .frame(width: 328, height: 328)
                        .foregroundColor(.blue)
                        .offset(y: -240)
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: 657, height: 657)
                        .cornerRadius(657, corners: [.topLeft, .topRight])
                        .offset(y: 173)
                    
                    Image("WelcomeVocapy")
                        .offset(y: -380)
                    VStack(alignment: .leading, spacing: 0, content: {
                        HStack(spacing: 8, content: {
                            Image("OnboardingLeftCapybara")
                            Image("OnboardingCapybara")
                                .offset(y: -67)
                            Image("OnboardingRightCapybara")
                        })
                        .offset(y: -167)
                    })
                    
                    VStack(alignment: .center, spacing: 132, content: {
                        Text("Siap bikin kosakata baru nempel terus? Vocapy bantu kamu ingat lebih lama dengan cara simpel")
                            .frame(width: 314)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.title2)
                        
                        Button(action: {
                            router.navigateTo(.authenticationView)
                        }) {
                            Text("Aku Siap!")
                                .padding(8)
                                .frame(width: 152, alignment: .center)
                                .foregroundColor(.black)
                                .background(Color.cream)
                                .cornerRadius(15)
                        }
                    })
                    .padding(.top, 145)
                })
            })
        })
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeView()
}
