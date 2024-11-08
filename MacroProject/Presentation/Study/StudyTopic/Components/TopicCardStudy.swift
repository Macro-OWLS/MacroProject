import SwiftUI

struct TopicCardStudy: View {
    var topic: TopicModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: topic.icon)
                .resizable()
                .frame(width: 48, height: 47)

                    Text(topic.name)
                .font(.helveticaHeader3)
                .frame(width: 141, alignment: .topLeading)
            Spacer()
            Text(topic.desc)
                .font(.helveticaBody1)
                .frame(width: 141, alignment: .topLeading)
        }
        .frame(width: 173-16, height: 217-28)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.darkcream)
        .cornerRadius(30)
    }
}
