import SwiftUI


struct CorrectPhrasePreview: View {
    var phrase: UserAnswerDTO
    @State private var bold: String = ""
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .stroke(.green)
            
            VStack (alignment: .leading){
                Text(.init(bold)) // english
                    .font(.helveticaBody1)
                Divider()
                Text(phrase.translation) // indonesian
                    .font(.helveticaBody1)

            }
            .padding(16)
        }
        .frame(width: 361, height: 98)
        .onAppear {
            bold = PhraseHelper().vocabSearch(phrase: phrase.phrase, vocab: phrase.vocabulary, vocabEdit: .bold, userInput: phrase.userAnswer, isRevealed: false)
        }
    }
}

struct IncorrectPhrasePreview: View {
    var phrase: UserAnswerDTO
    @State private var bold: String = ""
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lightgrey)
                .stroke(.red)
            
            VStack (alignment: .leading){
                Text(.init(bold)) // english
                    .font(.helveticaBody1)
                Divider()
                Text(phrase.translation) // indonesian
                    .font(.helveticaBody1)
                
                Text("_Correct Answer: **\(phrase.vocabulary)**_") // indonesian
                    .font(.helveticaBody1)
                    .padding(.top, 18)

            }
            .padding(16)
        }
        .frame(width: 361, height: 98)
        .task {
            bold = PhraseHelper().vocabSearch(phrase: phrase.phrase, vocab: phrase.vocabulary, vocabEdit: .userAnswer, userInput: phrase.userAnswer, isRevealed: false)
        }
    }
}

#Preview {
    let phrase = UserAnswerDTO(id: "", topicID: "", vocabulary: "have", phrase: "I have an apple.", translation: "Aku punya apel.", isReviewPhase: true, levelNumber: "1", isCorrect: true, isReviewed: true)
    
    IncorrectPhrasePreview(phrase: phrase)
}
