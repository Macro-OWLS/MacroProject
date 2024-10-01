import SwiftUI

struct TopicCardReview: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(.quaternary)
            HStack {
                VStack (alignment: .leading){
                    Text("Ordering a Meal")
                        .bold()
                    Text("Order food at a restaurant")
                    Spacer()
                    HStack {
                        Text("Cards to review:")
                            .foregroundStyle(.secondary)
                        Text("14" + " of " + "14") // Text(cardsReviewed + " of " + totalCards)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
            }.padding(16)
        }
        .frame(width: 361, height: 116)
    }
}

#Preview {
    TopicCardReview()
}
