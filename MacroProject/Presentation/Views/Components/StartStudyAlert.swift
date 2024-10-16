//
//  StartStudyAlert.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI

struct StartStudyAlert: View {
    @Binding var showStudyConfirmation: Bool
    var topic: TopicDTO
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.cream)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showStudyConfirmation = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color.black)
                    }
                }
                .padding(.trailing)
                .padding(.top, 24)
                .padding(.bottom, 14)

                Text(topic.name)
                    .bold()
                    .font(.helveticaHeadline)
                    .frame(width: 244, height: 40, alignment: .top)
                    .multilineTextAlignment(.center)

                Text(topic.description)
                    .font(.helveticaBody1)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 44, alignment: .top)
                    .padding(.top, -4)

                Text("\(topic.hasReviewedTodayCount)/\(topic.phraseCardCount)")
                    .bold()
                    .font(.helveticaHeadline)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 25, alignment: .top)
                    .padding(.top, 24)
                    .padding(.bottom,-2)

                Text("Cards Studied")
                    .font(.helveticaBody1)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 22, alignment: .top)

                Button(action: {
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)

                        Text("Start Study")
                            .font(.helveticaHeader3)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 183, height: 50, alignment: .center)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
        .frame(width: 292, height: 331)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
    StartStudyAlert(showStudyConfirmation: .constant(true), topic: TopicDTO(id: "", name: "", description: "", hasReviewedTodayCount: 0, phraseCardCount: 15))
}
