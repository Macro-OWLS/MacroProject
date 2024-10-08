//
//  StartStudyAlert.swift
//  MacroProject
//
//  Created by Riyadh Abu Bakar on 07/10/24.
//

import SwiftUI

struct StartStudyAlert: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.gray)

            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
                .padding(.trailing)
                .padding(.top, 24)
                .padding(.bottom, 14)

                Text("At The Doctor Office")
                    .bold()
                    .font(.system(size: 22))
                    .frame(width: 244, height: 28, alignment: .top)

                Text("Describe symptoms and get advice")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 44, alignment: .top)
                    .padding(.top, -4)

                Text("0/14")
                    .bold()
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 25, alignment: .top)
                    .padding(.top, 24)
                    .padding(.bottom,-2)

                Text("Cards Studied")
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .frame(width: 194, height: 22, alignment: .top)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.secondary)

                    Text("Start Study")
                        .font(Font.custom("SF Pro", size: 17))
                        .foregroundColor(.white)
                }
                .frame(width: 183, height: 50, alignment: .center)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
        .frame(width: 292, height: 331)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
    StartStudyAlert()
}
