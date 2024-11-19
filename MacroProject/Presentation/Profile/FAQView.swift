//
//  FAQView.swift
//  MacroProject
//
//  Created by Agfi on 19/11/24.
//

import SwiftUI

struct FAQ: Identifiable {
    var id: Int
    var question: String
    var answer: String
    var isExpanded: Bool
}

struct FAQView: View {
    @EnvironmentObject var router: Router
    
    @State private var faqs: [FAQ] = [
        .init(id: 1, question: "What is Vocapy?", answer: "Vocapy is an app designed to help you learn and memorize vocabulary at your own pace using a proven, effective method. It focuses on practical, daily-use words and phrases to improve your language skills.", isExpanded: false),
        .init(id: 2, question: "How does Vocapy work?", answer: "Vocapy uses the Leitner System, a spaced repetition method, to help you focus on words you struggle with, ensuring better long-term retention.", isExpanded: false),
        .init(id: 3, question: "Is Vocapy suitable for beginners?", answer: "Yes! Vocapy is perfect for beginners who want to expand their vocabulary with essential words and phrases for everyday use.", isExpanded: false),
        .init(id: 4, question: "What type of vocabulary does Vocapy focus on?", answer: "Vocapy focuses on daily-use and practical vocabulary that helps you in real-life situations, making learning relevant and useful.", isExpanded: false),
        .init(id: 5, question: "What kind of words do I need to learn and memorize?", answer: "You can learn and memorize any words! However, if you want better progress, it's best to focus on learning and memorizing new or unfamiliar vocabulary!", isExpanded: false),
        .init(id: 6, question: "When can I add new cards to study?", answer: "Anytime you want! However, it's better to add new cards when you feel ready to take on more and continue learning and memorizing!", isExpanded: false),
        .init(id: 7, question: "Do I have to start memorizing in the order of topics?", answer: "No, you can start learning and memorizing from any topic that interests you or that you need the most!", isExpanded: false),
        .init(id: 8, question: "Do I need an internet connection to use Vocapy?", answer: "Yes, an internet connection is required to save your learning and memorization progress in the database, so it can be accessed across all the devices you own.", isExpanded: false),
        .init(id: 9, question: "How is Vocapy different from other language learning apps?", answer: "Vocapy focuses specifically on vocabulary, using a personalized and structured method to ensure better retention and practical usage, unlike apps that focus on all aspects of language learning.", isExpanded: false)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.cream
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false, content: {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Frequently Asked Questions")
                            .font(.poppinsH3)
                        
                        Text("Answering your curiosity")
                            .font(.poppinsB1)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .center, spacing: 10) {
                        ForEach(faqs.indices, id: \.self) { index in
                            FAQItem(faq: $faqs[index])
                        }
                    }
                    .padding(.top, 28)
                }
                .padding(.horizontal, 40)
            })
        }
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

struct FAQItem: View {
    @Binding var faq: FAQ
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(faq.question)
                    .font(.poppinsB1)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(faq.isExpanded ? 90 : 0))
                    .animation(.easeInOut(duration: 0.3), value: faq.isExpanded)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    faq.isExpanded.toggle()
                }
            }
            
            if faq.isExpanded {
                Text(faq.answer)
                    .font(.poppinsB2)
                    .foregroundColor(.stoneGrey)
                    .padding(.top, 4)
                    .transition(.move(edge: .top).combined(with: .scale))
                    .animation(.easeInOut(duration: 0.3), value: faq.isExpanded)
            }
        }
        .background (
            Color.clear
                .animation(.easeInOut(duration: 0.3), value: faq.isExpanded)
        )
        .padding(.vertical, 8)
    }
}


#Preview {
    FAQView()
        .environmentObject(Router())
}
