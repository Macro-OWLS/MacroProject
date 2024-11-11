import SwiftUI

struct RecapView: View {
    @EnvironmentObject var reviewPhraseViewModel: ReviewPhraseViewModel
    @EnvironmentObject var levelViewModel: LevelSelectionViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack(content: {
            Color.cream
                .ignoresSafeArea(.all)

            VStack(content: {
                Spacer()
                Ellipse()
                    .frame(width: 564, height: 236)
                    .offset(y: 200)
                    .foregroundColor(.green)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 570)
                    .foregroundColor(.green)
            })
            .ignoresSafeArea()

            Section(content: {
                HStack(spacing: 250, content: {
                    Image("CapybaraRecapRight")
                    Image("CapybaraRecapLeft")
                })

                HStack(spacing: 50, content: {
                    Image("CapybaraRecapRight")
                        .offset(x: 0, y: -25)
                    VStack(spacing: -10, content: {
                        Image("SmallCapybaraRecapLeft")
                            .zIndex(2)
                        Image("MediumCapybaraRecapLeft")
                            .zIndex(1)
                        Image("BigCapybaraRecapLeft")
                    })
                    .offset(y: -70)
                })

                Image("WellDoneRecap")
                    .offset(x: -50,y: -140)
            })
            .offset(y: -170)

            VStack(alignment: .center, spacing: 30, content: {
                AnswerRow(answerNumber: String(reviewPhraseViewModel.recapAnsweredPhraseCards.filter { $0.isCorrect }.count), title: "Correct Answer", subtitle: "Move to Phase \(levelViewModel.selectedLevel.level + 1)", foregroundColor: .green)
                AnswerRow(answerNumber: String(reviewPhraseViewModel.recapAnsweredPhraseCards.count - reviewPhraseViewModel.recapAnsweredPhraseCards.filter { $0.isCorrect }.count), title: "Incorrect Answer", subtitle: "Move to Phase 1", foregroundColor: .red)

                VStack(alignment: .center, spacing: 8, content: {
                    Text("Cards remaining to review:")
                        .font(.poppinsB1)
                        .foregroundColor(.cream)
                    Text("\(String(reviewPhraseViewModel.unansweredPhrasesCount)) Cards")
                        .font(.poppinsHd)
                        .foregroundColor(.cream)
                })
                .padding(.top, 10)

                HStack(alignment: .center, spacing: 8, content: {
                    Button(action: {
                        router.navigateTo(.reviewRecapView)
                    }) {
                        CustomButton(title: "Review Recap", backgroundColor: Color.white, foregroundColor: .brown)
                    }
                    Button(action: {
                        reviewPhraseViewModel.recapAnsweredPhraseCards = []
                        router.popToRoot()
                    }) {
                        CustomButton(title: "Back to Home", backgroundColor: Color.brown, foregroundColor: .white)
                    }
                })
                .padding(.top, 10)
            })
            .padding(.top, 200)
        })
        .navigationBarBackButtonHidden()
    }

    @ViewBuilder
    private func AnswerRow(answerNumber: String, title: String, subtitle: String, foregroundColor: Color) -> some View {
        ZStack(alignment: .center, content: {
            Image("EllipseAnswerRecap")
            HStack(alignment: .center, spacing: 24, content: {
                Text(answerNumber)
                    .font(.poppinsH1)
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(title)
                        .font(.poppinsHd)
                    Text(subtitle)
                        .font(.poppinsB1)
                })
            })
            .foregroundColor(foregroundColor)
        })
    }

    @ViewBuilder
    private func CustomButton(title: String, backgroundColor: Color, foregroundColor: Color) -> some View {
        Text(title)
            .font(.poppinsB1)
            .frame(width: 148, height: 54)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(12)
    }
}

#Preview {
    RecapView()
        .environmentObject(ReviewPhraseViewModel())
        .environmentObject(LevelSelectionViewModel())
}
