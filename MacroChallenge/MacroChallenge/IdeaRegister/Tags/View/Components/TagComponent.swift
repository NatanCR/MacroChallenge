//
//  TagComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 05/07/23.
//

import SwiftUI

struct TagComponent: View {
    @Environment(\.screenSize) var screenSize
    var fontSize: CGFloat = 16
    var maxLimit: Int
    @Binding var allTags: [Tag]
    @Binding var tagArraySelected: [Tag]
    
    var body: some View {
        
        VStack(alignment: .leading){
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10) {
                    //apresentando as tags
                    ForEach(getRows(), id: \.self) { rows in
                        
                        HStack(spacing: 6){
                            ForEach(rows) { row in
                                RowView(tag: row)
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
    func RowView(tag: Tag) -> some View {
        
        Button{
            //append em um array de tags
            //esse array deve vir da tela de registro por referência
            tagArraySelected.append(tag)
        } label: {
            Text(tag.name)
                .font(.custom("Sen-Regular", size: fontSize))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                    //TODO: deixar o usuário escolher a cor
                        .fill(Color("labelColor"))
                )
                .foregroundColor(Color("backgroundColor"))
                .lineLimit(1)
            
            //Deletar
                .contentShape(Capsule())
                .contextMenu {
                    Button(role: .destructive){
                        allTags.remove(at: getIndex(tag: tag))
                        IdeaSaver.clearOneTag(tag: tag)
                    } label: {
                        HStack{
                            Text("Delete")
                            Image(systemName: "trash.fill")
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

