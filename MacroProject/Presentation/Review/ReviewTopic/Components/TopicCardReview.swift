import SwiftUI

struct TopicCardReview: View {
    var topicDTO: TopicDTO
    var color: Color
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Image(systemName: topicDTO.icon)
                .resizable()
                .frame(width: 48, height: 47)
            Text(topicDTO.name)
                .font(.poppinsHeader3)
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
        .background(Color.lightBrown)
        .cornerRadius(30)
        
    }
}
