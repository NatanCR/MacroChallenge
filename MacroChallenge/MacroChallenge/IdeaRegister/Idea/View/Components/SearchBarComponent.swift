//
//  SearchBarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct SearchBarComponent: View {
    
    //TODO: fazer a lógica da search bar
    
    @State var textoPesquisa: String = ""
    @State var textFieldEstaEditando: Bool = false
    
    static var filteredIdeas: [any Idea] {
        if HomeView.searchText.isEmpty {
            return HomeView.disposedData
        } else {
            return HomeView.disposedData.filter { idea in
                //filtra com o que tem em cada propriedade e guarda na variavel
                let isMatchingTitle = idea.title.localizedCaseInsensitiveContains(HomeView.searchText)
                let isMatchingDescription = idea.description.localizedCaseInsensitiveContains(HomeView.searchText)
//                let isMatchingTag = idea.tag.localizedCaseInsensitiveContains(searchText)

                return isMatchingTitle || isMatchingDescription //|| isMatchingTag
                
                //ordena na ordem de prioridade
            }.sorted { idea1, idea2 in
                let titleMatch1 = idea1.title.localizedCaseInsensitiveContains(HomeView.searchText)
                let titleMatch2 = idea2.title.localizedCaseInsensitiveContains(HomeView.searchText)
                let descriptionMatch1 = idea1.description.localizedCaseInsensitiveContains(HomeView.searchText)
                let descriptionMatch2 = idea2.description.localizedCaseInsensitiveContains(HomeView.searchText)
//                let tagMatch1 = idea1.tag.localizedCaseInsensitiveContains(searchText)
//                let tagMatch2 = idea2.tag.localizedCaseInsensitiveContains(searchText)

                //compara pra saber qual ideia vem antes da outra
                if titleMatch1 && !titleMatch2 {
                    return true
                } else if !titleMatch1 && titleMatch2 {
                    return false
                } else if descriptionMatch1 && !descriptionMatch2 {
                    return true
                } else if !descriptionMatch1 && descriptionMatch2 {
                    return false
//                } else if tagMatch1 && !tagMatch2 {
//                    return true
//                } else if !tagMatch1 && tagMatch2 {
//                    return false
                } else {
                    return idea1.creationDate > idea2.creationDate
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
                TextField("Pesquise aqui", text: $textoPesquisa)
                    .foregroundColor(Color("labelColor"))
                    .keyboardType(.default)
                    .disabled(self.textFieldEstaEditando)
            }
            .padding(UIDevice.current.userInterfaceIdiom == .phone ? 7 : 15)
            .background(Color("backgroundItem"))
            .opacity(0.8)
            .cornerRadius(8)
            .padding(.leading, 10)
            
            FilterComponent()
        }
//        .searchable(text: $textoPesquisa)
    }
}



struct SearchBarComponent_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBarComponent()
    }
}
