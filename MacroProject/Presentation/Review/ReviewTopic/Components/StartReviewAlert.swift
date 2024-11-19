//
//  StartReviewAlert.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI


struct StartReviewAlert: View {
    @EnvironmentObject var levelSelectionViewModel: LevelSelectionViewModel
    @EnvironmentObject var reviewPhraseViewModel: ReviewPhraseViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.cream)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        levelSelectionViewModel.showReviewConfirmation = false

                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color.darkGrey)
                            .opacity(0.6)
                    }
                }
                .padding(.trailing)
                .padding(.top, 24)
                .padding(.bottom, 14)

                Text(reviewPhraseViewModel.selectedTopicToReview.name)
                    .bold()
                    .font(.poppinsHd)
                    .frame(width: 244, height: 40, alignment: .top)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Text(reviewPhraseViewModel.selectedTopicToReview.description)
                    .font(.poppinsB1)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 52, alignment: .top)
                    .padding(.top, -4)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(reviewPhraseViewModel.selectedTopicToReview.hasReviewedTodayCount)/\(reviewPhraseViewModel.selectedTopicToReview.phraseCardCount)")
                    .bold()
                    .font(.poppinsHd)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 25, alignment: .top)
                    .padding(.top, 24)
                    .padding(.bottom,-2)


                Text("Cards Studied")
                    .font(.poppinsB1)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 22, alignment: .top)

                Button (action: {
                    reviewPhraseViewModel.fetchPhrasesToReviewToday(topicID: reviewPhraseViewModel.selectedTopicToReview.id, selectedLevel: levelSelectionViewModel.selectedLevel)
                    router.navigateTo(.reviewPhraseView)
                    levelSelectionViewModel.showReviewConfirmation = false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)

                        Text("Start Study")
                            .font(.poppinsHeader3)
                            .foregroundColor(.white)
                    }
                    .frame(width: 183, height: 50, alignment: .center)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(width: 292, height: 331)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
    StartReviewAlert()
        .environmentObject(LevelSelectionViewModel())
        .environmentObject(ReviewPhraseViewModel())
        .environmentObject(Router())
}
