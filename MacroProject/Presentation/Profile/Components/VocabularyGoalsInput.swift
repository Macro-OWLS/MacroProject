import SwiftUI

enum GoalType {
    case currentGoals
    case newGoals
}

struct VocabularyGoalsInput: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    var goalType: GoalType
    var isDisabled: Bool // Flag to disable only the new goal field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your \(goalType == .currentGoals ? "Current" : "New") Goals")
                .font(.poppinsB2)
            
            HStack(alignment: .center, spacing: 0, content: {
                if goalType == .currentGoals {
                    Text("\(homeViewModel.userStreakTarget ?? 99)")
                        .font(.poppinsHeader3)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(minWidth: 163, alignment: .leading)
                        .background(goalType == .currentGoals ? Color.darkGrey : .white)
                        .cornerRadius(12)
                } else {
                    TextField(isDisabled ? "" : "Input number", text: $viewModel.userInputTarget)
                        .font(.poppinsHeader3)
                        .foregroundColor(isDisabled ? .white : .black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: 163, alignment: .leading)
                        .background(isDisabled ? Color.darkGrey : Color.white)
                        .cornerRadius(12)
                        .disabled(isDisabled)
                }
                Spacer()
                Text("Vocab / Day")
            })
        }
    }
}
