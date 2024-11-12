import SwiftUI

struct CorrectAnswerIndicator: View {
    var onNext: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 207 / 255, green: 229 / 255, blue: 219 / 255))
                .frame(width: 403, height: 222, alignment: .leading)
                .cornerRadius(30)

            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .top, spacing: 4) {
                    HStack(alignment: .center, spacing: 4, content: {
                        Image(systemName: "checkmark.square.fill")
                            .font(.poppinsH2)
                            .foregroundColor(.green)
                        Text("Correct!")
                            .font(.poppinsH2)
                            .kerning(0.38)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.black)
                    })
                    .padding(.leading, 22)
                    Spacer()
                    Image("SadCapybara")
                        .offset(y: -15)
                }
                .padding(.top, 24)

                Button(action: {
                    onNext()
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 201, height: 50, alignment: .leading)
                            .cornerRadius(12)

                        Text("Next")
                            .font(.poppinsB1)
                            .foregroundColor(Color.white)
                    }
                    .padding(.bottom, 28)
                }
                .offset(y: -40)
            }
        }
    }
}

#Preview {
    CorrectAnswerIndicator(onNext: {
        
    })
}
