//
//  StartStudyAlert.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI
 

struct StartStudyAlert: View {
    @EnvironmentObject var levelSelectionViewModel: LevelSelectionViewModel
    @EnvironmentObject var studyPhraseViewModel: StudyPhraseViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.cream)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        levelSelectionViewModel.showStudyConfirmation = false
                        
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color.black)
                    }
                }
                .padding(.trailing)
                .padding(.top, 24)
                .padding(.bottom, 14)

                Text(studyPhraseViewModel.selectedTopicToReview.name)
                    .bold()
                    .font(.helveticaHeadline)
                    .frame(width: 244, height: 40, alignment: .top)
                    .multilineTextAlignment(.center)

                Text(studyPhraseViewModel.selectedTopicToReview.description)
                    .font(.helveticaBody1)
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 44, alignment: .top)
                    .padding(.top, -4)

                Text("\(studyPhraseViewModel.selectedTopicToReview.hasReviewedTodayCount)/\(studyPhraseViewModel.selectedTopicToReview.phraseCardCount)")
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
                
                Button (action: {
                    studyPhraseViewModel.fetchPhrasesToStudy(topicID: studyPhraseViewModel.selectedTopicToReview.id, levelNumber: String(levelSelectionViewModel.selectedLevel.level))
                    router.navigateTo(.studyPhraseView)
                    levelSelectionViewModel.showStudyConfirmation = false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)

                        Text("Start Study")
                            .font(.helveticaHeader3)
                            .foregroundColor(.white)
                    }
                    .frame(width: 183, height: 50, alignment: .center)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            print("\n\n SelectedTopics: \(levelSelectionViewModel.selectedLevel)")
        }
        .frame(width: 292, height: 331)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}
