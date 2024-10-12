import SwiftUI

struct TopicCardStudy: View {
    var topic: TopicModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .fill(.quaternary)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .inset(by: 0.5)
                    .stroke(.black, lineWidth: 1)
                )

            HStack {
                VStack (alignment: .leading){
                    Text(topic.name)
                        .bold()
                    Text(topic.desc)
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
    TopicCardStudy(topic: TopicModel(id: "", name: "", desc: "", isAddedToLibraryDeck: false, section: ""))
}
