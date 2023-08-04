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
    @ObservedObject var viewModel: IdeasViewModel
    
    var body: some View {
        
        VStack(alignment: .leading){
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    //apresentando as tags
                    ForEach(getRows(), id: \.self) { rows in
                        
                        HStack(spacing: 8) {
                            // lendo e exibindo o array de todas as tags
                            ForEach(rows, id: \.id) { tag in
                                RowView(tag: $allTags[getIndex(tag: tag, allTags: true)])
                            }
                        }
                        .frame(width: screenSize.width * 0.9, alignment: .leading)
                        .padding(.horizontal, 5)
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear{
            //função para comparar as tags que ja existem e coloca-las com borda no array usado com all tags
            self.allTags = viewModel.updateSelectedTags(allTags: self.allTags, tagSelected: self.tagArraySelected)
        }
        .onChange(of: self.allTags.count, perform: { newValue in
            self.allTags = viewModel.updateSelectedTags(allTags: self.allTags, tagSelected: self.tagArraySelected)
        })
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
                TagLabelComponent(tagName: tag.wrappedValue.name, isSelected: tag.wrappedValue.isTagSelected)

                //Deletar
                    .contentShape(Capsule())
                    .contextMenu {
                        Button(role: .destructive){
                            IdeaSaver.removeTagFromIdeas(tagToRemove: tag.wrappedValue)
                            
                            if allTags.count <= 1 {
                                IdeaSaver.clearUniqueTag()
                            } else {
                                IdeaSaver.clearOneTag(tag: tag.wrappedValue)
                            }
                            
                            allTags.remove(at: getIndex(tag: tag.wrappedValue, allTags: true))
                        } label: {
                            HStack{
                                Text("Delete")
                                Image(systemName: "trash.fill")
                            }
                        }
                    }
            } else {
                TagLabelComponent(tagName: tag.wrappedValue.name, isSelected: tag.wrappedValue.isTagSelected)
                //Deletar
                    .contentShape(Capsule())
                    .contextMenu {
                        Button(role: .destructive){
                            IdeaSaver.removeTagFromIdeas(tagToRemove: tag.wrappedValue)
                            
                            if allTags.count <= 1 {
                                IdeaSaver.clearUniqueTag()
                            } else {
                                IdeaSaver.clearOneTag(tag: tag.wrappedValue)
                            }
                            
                            allTags.remove(at: getIndex(tag: tag.wrappedValue, allTags: true))
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
    
}
