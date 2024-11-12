import SwiftUI

struct TopicCardStudy: View {
    var topic: TopicModel

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Image(systemName: topic.icon)
                .resizable()
                .frame(width: 48, height: 47)

                    Text(topic.name)
                .font(.poppinsHeader3)
                .frame(width: 141, alignment: .topLeading)
            Spacer()
            Text(topic.desc)
                .font(.poppinsB2)
                .frame(width: 141, alignment: .topLeading)
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

