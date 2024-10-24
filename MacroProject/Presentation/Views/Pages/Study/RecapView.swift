import SwiftUI
import Routing

struct RecapView: View {
    @EnvironmentObject var phraseStudyViewModel: PhraseStudyViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
    @StateObject var router: Router<NavigationRoute>
    @Binding private var selectedView: TabViewType
    
    init(router: Router<NavigationRoute>, selectedView: Binding<TabViewType>) {
        _router = StateObject(wrappedValue: router)
        _selectedView = selectedView
    }
    
    var body: some View {
        ZStack {
            // Background color
            Color.cream
                .ignoresSafeArea(.all)
            
            VStack(spacing: 72) {
                VStack(alignment: .center, spacing: 54) {
                    // Header section
                    VStack(alignment: .center, spacing: 32) {
                        Text("Well Done!")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 102, height: 30)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .cornerRadius(10)
                        
                        // Correct and Incorrect answers section
                        VStack(alignment: .leading, spacing: 40) {
                            answerRow(
                                answerNumber: String(phraseStudyViewModel.recapAnsweredPhraseCards.filter { $0.isCorrect }.count),
                                title: "Correct answers",
                                subtitle: "Move to Level \(levelViewModel.selectedLevel.level + 1)"
                            )
                            answerRow(
                                answerNumber: String(phraseStudyViewModel.recapAnsweredPhraseCards.count - phraseStudyViewModel.recapAnsweredPhraseCards.filter { $0.isCorrect }.count),
                                title: "Incorrect answers",
                                subtitle: "Return to Level 1"
                            )
                        }
                    }
                }
                
                // Cards remaining section
                VStack {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Cards remaining to review:")
                            .font(Font.custom("HelveticaNeue-Light", size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        
                        Text(String(phraseStudyViewModel.selectedPhraseCardsToReviewByTopic.count - phraseStudyViewModel.recapAnsweredPhraseCards.count))
                            .font(Font.custom("HelveticaNeue-Bold", size: 22).weight(.bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                }
                
                // Buttons section
                HStack(alignment: .center, spacing: 8) {
                    NavigationLink(destination: ReviewRecapView()) {
                        CustomButton(title: "Review Recap", backgroundColor: Color.white, foregroundColor: Color.blue)
                    }
                    
                    Button(action: {
                        selectedView = .study
                        router.popToRoot()
                    }){
                        CustomButton(title: "Back to Home", backgroundColor: Color.white, foregroundColor: Color.blue)
                    }
                }
            }
            .frame(width: 291, alignment: .top)
            .padding(0)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden()
        .padding(0)
    }

    // Answer row view
    @ViewBuilder
    private func answerRow(answerNumber: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(answerNumber)
                .font(.system(size: 64))
                .bold()
                .foregroundColor(.black)
                .offset(y: -10)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28))
                    .bold()
                    .kerning(0.38)
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray.opacity(0.55))
            }
        }
        .frame(width: 291, alignment: .leading)
    }

    // Custom button layout
    @ViewBuilder
    private func CustomButton(title: String, backgroundColor: Color, foregroundColor: Color) -> some View {
        Text(title)
            .font(.helveticaBody1)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(width: 148, alignment: .center)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.GraysBlack, lineWidth: 1)
            )
    }
}
