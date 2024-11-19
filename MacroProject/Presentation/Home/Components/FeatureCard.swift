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
        ZStack(alignment: .top) {
            switch featureCard.id {
            case "review":
                Image("ReviewIsland")
                    .offset(x: 55, y: 25)
            case "study":
                Image("TopicsIsland")
                    .offset(x: -60, y: 20)
            case "cards-learned":
                Image("CardsLearnedIsland")
                    .offset(x: 55, y: 25)
            default:
                EmptyView()
            }
            
            Button(action: {
                switch featureCard.id {
                case "review":
                    router.navigateTo(.levelView)
                case "study":
                    router.navigateTo(.studyView)
                case "cards-learned":
                    router.navigateTo(.cardsLearnedView)
                default:
                    break
                }
            }) {
                switch featureCard.id {
                case "review":
                    Image("ReviewTime")
                        .offset(x: 40)
                case "study":
                    Image("TopicLibrary")
                        .offset(x: -35)
                case "cards-learned":
                    Image("MethodExplanation")
                        .offset(x: 40)
                default:
                    EmptyView()
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    FeatureCard(featureCard: FeatureCardType(id: "study", backgroundColor: Color.red, icon: "ReviewCardMascot", title: "Review Time", description: "Boost memory with every review"))
}
