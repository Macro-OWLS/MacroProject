import SwiftUI

struct Flashcard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.gray)
            
            VStack(spacing: 40) {
                Text("I don't have that pain anymore") // English
                Divider()
                    .frame(maxWidth: 178)
                Text("Saya sudah tidak merasakan sakit itu lagi") // Indonesian
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 29)
            .padding(.vertical, 100)
        }
        .frame(width: 265, height: 368)
    }
}

#Preview {
    Flashcard()
}
