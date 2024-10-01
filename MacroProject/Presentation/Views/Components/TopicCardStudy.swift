import SwiftUI

struct TopicCardStudy: View {
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
                        Text("Total Cards:")
                           
                        Text("120") // Text(totalCards)
                    }
                    .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }.padding(16)
        }
        .frame(width: 361, height: 116)
    }
}

#Preview {
    TopicCardStudy()
}
