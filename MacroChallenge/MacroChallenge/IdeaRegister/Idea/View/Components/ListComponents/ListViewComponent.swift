//
//  ListViewComponente.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 17/08/23.
//

import SwiftUI

struct ListViewComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var isAdding: Bool
    @Binding var selectedIdeas: Set<UUID>
    
    var body: some View {
        List(selection: $selectedIdeas) {
            //MARK: - SECTION FAVORITE IDEAS
            //mostra apenas se houver ideias favoritadas
            if ideasViewModel.favoriteIdeas.count != 0 {
                Section {
                    ForEachListComponent(ideasViewModel: ideasViewModel, ideaType: $ideasViewModel.favoriteIdeas, isAdding: $isAdding, selectedIdeas: $selectedIdeas, groupType: $ideasViewModel.favoriteGroups)
                } header: {
                    Text("fav")
                        .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                }
                .listRowBackground(Color("backgroundItem"))
            }
            
            //MARK: - SECTION WEEK DATE
            if ideasViewModel.weekIdeas.count != 0 {
                Section {
                    ForEachListComponent(ideasViewModel: ideasViewModel, ideaType: $ideasViewModel.weekIdeas, isAdding: $isAdding, selectedIdeas: $selectedIdeas, groupType: $ideasViewModel.weekGroups)
                } header: {
                    Text("week")
                        .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                }
                .listRowBackground(Color("backgroundItem"))
            }
            
            //MARK: - SECTION ALL IDEAS
            if ideasViewModel.filteredIdeas.count != 0 {
                Section {
                    ForEachListComponent(ideasViewModel: ideasViewModel, ideaType: $ideasViewModel.filteredIdeas, isAdding: $isAdding, selectedIdeas: $selectedIdeas, groupType: $ideasViewModel.filteredGroups)
                } header: {
                    Text("prev")
                        .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                }
                .listRowBackground(Color("backgroundItem"))
            }
        }
        //modo de expansão da lista
        .listStyle(SidebarListStyle())
    }
}

//struct ListViewComponente_Previews: PreviewProvider {
//    static var previews: some View {
//        ListViewComponente()
//    }
//}
