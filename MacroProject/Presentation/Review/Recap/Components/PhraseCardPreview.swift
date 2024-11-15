import SwiftUI


struct CorrectPhrasePreview: View {
    var phrase: UserAnswerDTO
    @State private var bold: String = ""
    @State private var translationBold: String = ""

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.disableBrown)
                .stroke(Color.green, lineWidth: .init(2))

            VStack (alignment: .leading){
                Text(.init(bold))
                    .font(.poppinsB1)
                Divider()
                Text(translationBold)
                    .font(.poppinsB1)

            }
            .padding(16)
        }
        .frame(width: 361, height: 98)
        .onAppear {
            bold = PhraseHelper().vocabSearch(phrase: phrase.phrase, vocab: phrase.vocabulary, vocabEdit: .bold, userInput: phrase.userAnswer, isRevealed: false)
            translationBold = PhraseHelper().vocabSearch(phrase: phrase.translation, vocab: phrase.vocabularyTranslation ?? "", vocabEdit: .bold, userInput: phrase.userAnswer, isRevealed: false)
        }
    }
}

struct IncorrectPhrasePreview: View {
    var phrase: UserAnswerDTO
    @State private var bold: String = ""
    @State private var translationBold: String = ""

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.disableBrown)
                .stroke(Color.red, lineWidth: .init(2))

            VStack (alignment: .leading){
                Text(.init(bold))
                    .font(.poppinsB1)
                Divider()
                Text(translationBold)
                    .font(.poppinsB1)

                Text("_Correct Answer: **\(phrase.vocabulary)**_")
                    .font(.poppinsB1)
                    .padding(.top, 18)

            }
            .padding(16)
        }
        .frame(width: 361, height: 98)
        .task {
            bold = PhraseHelper().vocabSearch(phrase: phrase.phrase, vocab: phrase.vocabulary, vocabEdit: .userAnswer, userInput: phrase.userAnswer, isRevealed: false)
            translationBold = PhraseHelper().vocabSearch(phrase: phrase.translation, vocab: phrase.vocabularyTranslation ?? "", vocabEdit: .bold, userInput: phrase.userAnswer, isRevealed: false)
        }
    }
}

#Preview {
    let phrase = UserAnswerDTO(id: "", topicID: "", vocabulary: "have", phrase: "I have an apple.", translation: "Aku punya apel.", vocabularyTranslation: "apel", isReviewPhase: true, levelNumber: "1", isCorrect: true, isReviewed: true)

    IncorrectPhrasePreview(phrase: phrase)
}
