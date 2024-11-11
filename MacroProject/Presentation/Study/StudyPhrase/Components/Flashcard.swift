import SwiftUI

struct Flashcard: View {
    let englishText: String
    let indonesianText: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lightBrown)

            VStack(spacing: 40) {
                Text(.init(englishText))
                    .font(.poppinsB1)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                Text(.init(indonesianText))
                    .font(.poppinsB1)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 29)
            .padding(.vertical, 100)
        }
        .frame(width: 265, height: 368)
    }
}

#Preview {
    Flashcard(englishText: "I don't have that pain anymore", indonesianText: "Saya sudah tidak merasakan sakit itu lagi")
}
