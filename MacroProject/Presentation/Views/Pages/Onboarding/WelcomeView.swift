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
                        .foregroundColor(.yellow)
                        .frame(width: 657, height: 657)
                        .cornerRadius(657, corners: [.topLeft, .topRight])
                        .offset(y: 173)
                    HStack(spacing: 225, content: {
                        Image("OnboardingLeftCapybara")
                        
                        Image("OnboardingRightCapybara")
                    })
                    .offset(y: -160)
                    Image("CircleTopWelcomePage")
                        .resizable()
                        .frame(width: 435.38, height: 126.1)
                        .offset(y: -100)
                    
                    Image("WelcomeVocapy")
                        .offset(y: -360)
                    VStack(alignment: .leading, spacing: 0, content: {
                        HStack(spacing: 8, content: {
                            Image("OnboardingCapybara")
                                .offset(y: -67)
                        })
                        .offset(y: -167)
                    })
                    
                    VStack(alignment: .center, spacing: 120, content: {
                        Text("Siap bikin kosakata nempel terus? Vocapy bantu ingat lebih lama dengan cara simpel!")
                            .frame(width: 314)
                            .multilineTextAlignment(.center)
                            .font(.poppinsH3)
                        
                        Button(action: {
                            router.navigateTo(.authenticationView)
                        }) {
                            Text("Aku Siap!")
                                .padding(14)
                                .frame(width: 225-14, alignment: .center)
                                .font(.poppinsH3)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(15)
                        }
                    })
                    .padding(.top, 250)
                })
            })
        })
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeView()
}
