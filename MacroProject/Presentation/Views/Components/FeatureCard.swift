//
//  FeatureCard.swift
//  MacroProject
//
//  Created by Agfi on 04/11/24.
//

import SwiftUI

struct FeatureCard: View {
    @EnvironmentObject var router: Router
    
    var featureCard: FeatureCardType
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(content: {
                VStack(alignment: .leading, spacing: 4, content: {
                    Text(featureCard.title)
                        .font(.helveticaHeadline)
                        .foregroundColor(.white)
                    Text(featureCard.description)
                        .font(.helveticaBody2)
                        .foregroundColor(.white)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 50)
                
                Button(action: {
                    switch featureCard.id {
                    case "review":
                        router.navigateTo(.levelView)
                    case "library":
                        router.navigateTo(.libraryView)
                    default:
                        break
                    }
                }) {
                    Text("Review Now!")
                        .font(.helveticaBody1)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.cream)
                        .cornerRadius(12)
                }
            })
            .frame(width: 300)
            .padding(27)
            .background(featureCard.backgroundColor)
            .cornerRadius(30)
            
            Image(featureCard.icon)
                .offset(x: 0, y: 0)
        }
    }
}

#Preview {
    FeatureCard(featureCard: FeatureCardType(id: "review", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"))
}
