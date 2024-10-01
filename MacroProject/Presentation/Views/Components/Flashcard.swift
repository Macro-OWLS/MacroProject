import SwiftUI

struct Flashcard: View {

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(.gray)
            
            VStack (spacing: 40){
                Text("I don't have that pain anymore") // eng
                Divider()
                    .frame(maxWidth: 178)
                Text("Saya sudah tidak merasakan sakit itu lagi") // indo
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 29)
            .padding(.vertical, 100)
        }
        .frame(width: 265, height: 368)
        
        
    }
}

struct CarouselAnimation: View {
    @State private var currIndex: Int = 0
    private let flashcards = Array(repeating: "Flashcard", count: 5)
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<flashcards.count, id: \.self) { index in
                    if abs(currIndex - index) <= 1 {
                        Flashcard()
                            .opacity(currIndex == index ? 1.0 : 0.5)
                            .scaleEffect(currIndex == index ? 1.0 : 0.9)
                            .offset(x: getOffset(for: index), y: 0)
                            .zIndex(currIndex == index ? 1 : 0)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation{
                                currIndex = max(0, currIndex - 1)
                            }
                            
                        } else if value.translation.width < -threshold {
                            withAnimation{
                                currIndex = min(flashcards.count - 1, currIndex + 1)
                            }
                            
                        }
                    }
            )
        }
    }
    
    private func getOffset(for index: Int) -> CGFloat {
        if index == currIndex {
            return 0 // Center card
        } else if index < currIndex {
            return -50 // Previous card
        } else {
            return 50 // Next card
        }
    }
}
#Preview {
    CarouselAnimation()
}
