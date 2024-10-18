import SwiftUI

struct TopicCardStudy: View {
    var topic: TopicModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.darkcream)
                .cornerRadius(25)
                .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .inset(by: 0.5)
                    .stroke(.black, lineWidth: 1)
                )

            VStack (alignment: .leading){
                HStack{
                    VStack (alignment: .leading){
                        Text(topic.name)
                            .font(.helveticaHeader3)
                        Text(topic.desc)
                            .font(.helveticaBody1)
                    }
                    Spacer()
                    Image(systemName: "star.bubble.fill")
                        .resizable()
                        .frame(width: 48, height:  47)
                }
                Spacer()
                HStack {
                    Text("Total Cards:")
                    Text("120") // Text(totalCards)
                    HStack{
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.helveticaBody1)
                .foregroundStyle(.secondary)
            }.padding(16)
        }
        .frame(width: 361, height: 143.57)
    }
}

#Preview {
    TopicCardStudy(topic: TopicModel(id: "", name: "a telephone call", desc: "frasa untuk percakapan", isAddedToLibraryDeck: false, section: ""))
}
