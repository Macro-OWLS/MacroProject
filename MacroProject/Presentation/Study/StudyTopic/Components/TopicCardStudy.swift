import SwiftUI

struct TopicCardStudy: View {
    var topic: TopicModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Image(topic.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 50)

            Text(topic.name)
                .font(.poppinsHeader3)
                .frame(width: 141, alignment: .topLeading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Text(topic.desc)
                .font(.poppinsB2)
                .frame(width: 141, alignment: .topLeading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 173-16, height: 217-28)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.lightBrown)
        .cornerRadius(30)
    }
}

#Preview {
    TopicCardStudy(topic: TopicModel(id: "", name: "Topic", icon: "brain.fill", desc: "desc", isAddedToStudyDeck: true, section: "Topic"))
//        .environmentObject(StudyViewModel())
}

