import SwiftUI

struct PhraseCardPreview: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(.quaternary)
            
            VStack (alignment: .leading){
                Text("I don't have that pain anymore") // english
                Divider()
                Text("Saya sudah tidak merasakan sakit itu lagi") // indonesian
            }.padding(16)
        }
        .frame(width: 361, height: 98)
    }
}

#Preview {
    PhraseCardPreview()
}
