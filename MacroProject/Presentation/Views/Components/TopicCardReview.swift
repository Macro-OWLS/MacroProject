import SwiftUI

struct TopicCardReview: View {
    var body: some View {
//        ZStack{
//            RoundedRectangle(cornerRadius: 30)
//                .fill(.quaternary)
//            HStack {
//                VStack (alignment: .leading){
//                    Text("Ordering a Meal")
//                        .bold()
//                    Text("Order food at a restaurant")
//                    Spacer()
//                    HStack {
//                        Text("Cards to review:")
//                            .foregroundStyle(.secondary)
//                        Text("14" + " of " + "14") // Text(cardsReviewed + " of " + totalCards)
//                    }
//                }
//                Spacer()
//                Image(systemName: "chevron.right")
//            }.padding(16)
//        }
//        .frame(width: 173, height: 164)
//    }
//}
        
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .fill(.quaternary)
            HStack {
                VStack (alignment: .leading){
                    Text("Ordering a Meal")
                        .bold()
                        .font(.system(size: 20))
                        .frame(width: 140, height: 75, alignment: .topLeading)
                    Spacer()
                    Text("100/100")
                        .frame(width: 140, height: 20, alignment: .topLeading)
                    Text("Cards Studied")
                        .frame(width: 140, height: 20, alignment: .topLeading)
                }
                Spacer()
            }.padding(16)
        }
        .frame(width: 173, height: 164)
    }
}

#Preview {
    TopicCardReview()
}
