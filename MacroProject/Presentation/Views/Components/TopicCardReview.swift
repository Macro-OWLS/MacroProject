import SwiftUI

struct TopicCardReview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "star.bubble.fill")
                .resizable()
                .frame(width: 48, height: 47)
            Text("Formal & Informal Greetings")
                .font(.helveticaHeader3)
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .topLeading)
            VStack(alignment: .leading,content: {
                Text("100/100")
                    .font(.helveticaBody2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Text("Cards Studied")
                    .font(.helveticaBody2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(width: 173, height: 191, alignment: .leading)
        .background(Color.cream)
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
    TopicCardReview()
}
