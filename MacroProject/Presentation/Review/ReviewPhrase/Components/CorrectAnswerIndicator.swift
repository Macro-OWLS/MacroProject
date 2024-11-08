import SwiftUI

struct CorrectAnswerIndicator: View {
    var onNext: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: 403, height: 222, alignment: .leading)
                .cornerRadius(30)
                .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 91) {
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "checkmark.square.fill")
                        .font(.poppinsH2)
                        .foregroundColor(Color(red: 0, green: 0.49, blue: 0.08))

                    Text("Correct!")
                        .font(.poppinsH2)
                        .kerning(0.38)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                }
                .padding(.top, 24)

                Button(action: {
                    onNext()
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.cream)
                            .frame(width: 345, height: 50, alignment: .leading)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color.black, lineWidth: 1)
                            )

                        Text("Next")
                            .font(.poppinsB1)
                            .foregroundColor(Color.black)
                    }
                    .padding(.bottom, 28)
                }
            }
        }
    }
}
