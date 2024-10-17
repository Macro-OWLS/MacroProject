import SwiftUI

struct TopicCardReview: View {
    var topicDTO: TopicDTO
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "star.bubble.fill")
                .resizable()
                .frame(width: 48, height: 47)
            Text(topicDTO.name)
                .font(.helveticaHeader3)
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .topLeading)
                .multilineTextAlignment(.leading)
            VStack(alignment: .leading, content: {
                Text("\(topicDTO.hasReviewedTodayCount)/\(topicDTO.phraseCardCount)")
                    .font(.helveticaBody2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Text("Cards Studied")
                    .font(.helveticaBody2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            })
        }
        .foregroundColor(.black)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(width: 173, height: 191, alignment: .leading)
        .background(Color.darkcream)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .inset(by: 0.5)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}
