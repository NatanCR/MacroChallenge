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
                            // lendo e exibindo o array de todas as tags
                            ForEach(rows, id: \.id) { tag in
                                RowView(tag: $allTags[getIndex(tag: tag, allTags: true)])
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear{
            dump(self.tagArraySelected)
            //função para comparar as tags que ja existem e coloca-las com borda no array usado com all tags
            updateSelectedTags()
        }
        .frame(width: screenSize.width * 0.9, alignment: .leading)
        .animation(.easeInOut, value: allTags)
        
    }
    
    @ViewBuilder
    func RowView(tag: Binding<Tag>) -> some View {
        
        // selecionando a tag
        Button {

            tag.wrappedValue.isTagSelected.toggle()
            
            //verifica se a tag ja existe para não salvar repetido
            if tag.wrappedValue.isTagSelected && !tagArraySelected.contains(tag.wrappedValue) {
                //append em um array de tags
                //esse array deve vir da tela de registro por referência
                tagArraySelected.append(tag.wrappedValue)

            } else {

                if getIndex(tag: tag.wrappedValue) != -1 {
                    self.tagArraySelected.remove(at: getIndex(tag: tag.wrappedValue))
                }
            }
            
        } label: {
            // definindo se a tag terá borda de acordo com sua variavel isActive
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
                            allTags.remove(at: getIndex(tag: tag.wrappedValue, allTags: true))
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
                            allTags.remove(at: getIndex(tag: tag.wrappedValue, allTags: true))
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
    
    func getIndex(tag: Tag, allTags: Bool = false) -> Int {
        var index = -1
        if allTags {
            index = self.allTags.firstIndex { currentTag in
                return tag.id == currentTag.id
            } ?? -1
        } else {
            index = tagArraySelected.firstIndex { currentTag in
                return tag.id == currentTag.id
            } ?? -1
        }
        
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
    
    func updateSelectedTags() {
        // Cria uma cópia do array allTags
        var updatedTags = self.allTags
        
        // Itera sobre as tags presentes em tagArraySelected
        for selectedTag in self.tagArraySelected {
            // Verifica se a tag selecionada está presente em allTags
            if let index = updatedTags.firstIndex(where: { $0.id == selectedTag.id }) {
                // Atualiza a propriedade isTagSelected para true
                updatedTags[index].isTagSelected = true
                dump(updatedTags[index])
            }
        }
        
        // Substitui o array allTags pela versão atualizada
        self.allTags = updatedTags
        dump(self.allTags)
    }
}
