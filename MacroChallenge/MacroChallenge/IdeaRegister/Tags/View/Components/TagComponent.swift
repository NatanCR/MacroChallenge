//
//  TagComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 05/07/23.
//

import SwiftUI

struct TagComponent: View {
    @Environment(\.screenSize) var screenSize
    @Binding var allTags: [Tag]
    @Binding var tagArraySelected: [Tag]
    
    var body: some View {
        
        VStack(alignment: .leading){
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10) {
                    //apresentando as tags
                    ForEach(getRows(), id: \.self) { rows in
                        
                        HStack(spacing: 6){
                            ForEach(rows, id: \.id) { tag in
                                RowView(tag: $allTags[getIndex(tag: tag)])
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .frame(width: screenSize.width * 0.9, alignment: .leading)
        .animation(.easeInOut, value: allTags)
        
    }
    
    @ViewBuilder
    func RowView(tag: Binding<Tag>) -> some View {
        
        Button {
            tag.wrappedValue.isTagSelected.toggle()
            
            //verifica se a tag ja existe para não salvar repetido
            if tag.wrappedValue.isTagSelected && !tagArraySelected.contains(tag.wrappedValue) {
                //append em um array de tags
                //esse array deve vir da tela de registro por referência
                tagArraySelected.append(tag.wrappedValue)
                
                print("AQUI COMECA O ARRAY")
                dump(tagArraySelected)
                print("AQUI TERMINA O ARRAY")
            } else {
                //TODO: REMOVER TAG DO ARRAY
                //TODO: TA TROCANDO A POSIÇAO DOS ELEMENTOS NO ARRAY AO EXCLUIR OU TA EXCLUINDO A POSICAO ERRADA
                self.tagArraySelected.remove(at: getIndex(tag: tag.wrappedValue))
            }
        } label: {
            if tag.wrappedValue.isTagSelected {
                TagLabelComponent(tagName: tag.wrappedValue.name)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("AccentColor"), lineWidth: 4)
                    )
                //Deletar
                    .contentShape(Capsule())
                    .contextMenu {
                        Button(role: .destructive){
                            allTags.remove(at: getIndex(tag: tag.wrappedValue))
                            if allTags.count <= 1 {
                                IdeaSaver.clearUniqueTag()
                            } else {
                                IdeaSaver.clearOneTag(tag: tag.wrappedValue)
                            }
                        } label: {
                            HStack{
                                Text("Delete")
                                Image(systemName: "trash.fill")
                            }
                        }
                    }
            } else {
                TagLabelComponent(tagName: tag.wrappedValue.name)
                //Deletar
                    .contentShape(Capsule())
                    .contextMenu {
                        Button(role: .destructive){
                            allTags.remove(at: getIndex(tag: tag.wrappedValue))
                            if allTags.count <= 1 {
                                IdeaSaver.clearUniqueTag()
                            } else {
                                IdeaSaver.clearOneTag(tag: tag.wrappedValue)
                            }
                            
                        } label: {
                            HStack{
                                Text("Delete")
                                Image(systemName: "trash.fill")
                            }
                        }
                    }
            }
        }
    }
    
    func getIndex(tag: Tag) -> Int{
        
        let index = allTags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }
    
    //dividindo o array quando passa do tamanho da tela
    func getRows() -> [[Tag]]{
        
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        //calculando largura do texto
        var totalWidht: CGFloat = 0
        
        allTags.forEach { tag in
            
            //atualizando largura total do texto + background e paddings
            totalWidht += (tag.size + 40)
            
            //checando se a largura do texto é maior que a tela
            if totalWidht > (screenSize.width * 0.9) {
                
                //adicionando row em rows
                //limpando os dados
                totalWidht = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else {
                currentRow.append(tag)
            }
        }
        
        //tratativa para se estiver vazio
        if !currentRow.isEmpty{
            rows.append(currentRow)
            currentRow.removeAll()
            
        }
        
        return rows
    }
}

//função global
func addTag(text: String, color: String) -> Tag {
    
    //pegando tamanho do texto
    let font = UIFont.systemFont(ofSize: 16)
    
    let attributes = [NSAttributedString.Key.font: font]
    
    let size = (text as NSString).size(withAttributes: attributes)
    
    return Tag(name: text, color: color, size: size.width)
}

