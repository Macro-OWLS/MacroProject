import SwiftUI

struct CorrectAnswerIndicator: View {
    var onNext: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.lightGreen)
                .frame(width: 403, height: 240, alignment: .leading)
                .cornerRadius(30)

            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .top, spacing: 4) {
                    HStack(alignment: .center, spacing: 4, content: {
                        Image(systemName: "checkmark.square.fill")
                            .font(.poppinsH2)
                            .foregroundColor(Color.green)
                        Text("Correct!")
                            .font(.poppinsH2)
                            .kerning(0.38)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.black)
                            .fontWeight(.semibold)
                    })
                    .padding(.leading, 22)
                    
                    Spacer()
                    Image("HappyCapybara")
                        .offset(y: -15)
                }
                .offset(y: 40)

                ZStack {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 201, height: 50, alignment: .leading)
                        .cornerRadius(12)
                    Text("Next")
                        .font(.poppinsB1)
                        .foregroundColor(Color.white)
                        .fontWeight(.medium)
                }
                .padding(.bottom, 28)
                .onTapGesture {
                    onNext()
                }
                .offset(y: -40)
            }
            .offset(y: -10)
        }
    }
}

#Preview {
    CorrectAnswerIndicator(onNext: {
        
    })
}
