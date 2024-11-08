import SwiftUI

struct TopicCardReview: View {
    var topicDTO: TopicDTO
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: topicDTO.icon)
                .resizable()
                .frame(width: 48, height: 47)
            Text(topicDTO.name)
                .font(.poppinsH3)
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .topLeading)
                .multilineTextAlignment(.leading)
            VStack(alignment: .leading, content: {
                Text("\(topicDTO.hasReviewedTodayCount)/\(topicDTO.phraseCardCount)")
                    .font(.poppinsB2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Text("Cards Studied")
                    .font(.poppinsB2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            })
        }
        .foregroundColor(color)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(width: 173, height: 191, alignment: .leading)
        .background(Color.darkcream)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .inset(by: 0.5)
                .stroke(color, lineWidth: 1)
        )
    }
}
