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
            Image("Island")
                .padding(.leading, 40) // Move right
            
            Button(action: {
                switch featureCard.id {
                case "review":
                    router.navigateTo(.levelView)
                case "study":
                    router.navigateTo(.studyView)
                default:
                    break
                }
            }) {
                switch featureCard.id {
                case "review":
                    Image("ReviewTime")
                case "study":
                    Image("TopicLibrary")
                case "explanation":
                    Image("MethodExplanation")
                default:
                    EmptyView()
                }
            }
            .padding(.top, 10) // Adjusts the vertical position
            .padding(.trailing, 10) // Adjusts the horizontal position
        }
    }
}

#Preview {
    FeatureCard(featureCard: FeatureCardType(id: "review", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"))
}
