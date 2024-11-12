import SwiftUI

struct AssetContainer: View {
    var capybaraImage: String
    
    var body: some View {
        HStack (spacing: 6){
            Image("StudyPhraseBubble")
                .offset(y: -20)
            Image(capybaraImage)
                .resizable()
                .frame(width: 97, height: 120)
        }
    }
}

#Preview {
    AssetContainer(capybaraImage: "DoctorCapybara")
}
