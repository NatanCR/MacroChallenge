//
//  TagSheetView.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 04/07/23.
//

import SwiftUI

struct TagSheetView: View {
    @ObservedObject var viewModel: IdeasViewModel //pego as tags ja salvas
    @State var nameTag: String = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            //titulo da pagina
            HStack(spacing: 20) {
                Text("Tags")
                    .font(Font.custom("Sen-Regular", size: 32, relativeTo: .headline))
                    .padding()
                Spacer()
            }.padding(.top, 50)
            
            //barra de pesquisa e registro de tag
            TextField("search", text: $nameTag)
                .foregroundColor(Color("labelColor"))
                .keyboardType(.default)
                .padding(UIDevice.current.userInterfaceIdiom == .phone ? 7 : 15)
                .background(Color("backgroundItem"))
                .opacity(0.8)
                .cornerRadius(8)
                .padding(10)
                .onSubmit {
                    let tag = Tag(name: nameTag, color: "#fff")
                    IdeaSaver.saveTag(tag: tag)
                }
            
            //exibe lista de tags - precisa atualizar em tempo real
            //lista com todas
            //lista será filtrada ao escrever no textfield
            
            ForEach(self.$viewModel.tagsLoadedData, id:\.id) { $tag in
                Text(tag.name)
                    .padding()
            }
            Spacer()
        }
        
    }
}

//struct TagSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagSheetView(tagModel: Tag(id: UUID(), name: "tag1", color: "#fff"))
//    }
//}
