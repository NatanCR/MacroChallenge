//
//  SearchBarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct SearchBarComponent: View {    
    @State var searchText: String = String()
    @State var textFieldEstaEditando: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var sortedByAscendent: Bool
    @Binding var byCreation: Bool
    
    //MARK: - BODY
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
                TextField("search", text: $searchText)
                    .foregroundColor(Color("labelColor"))
                    .keyboardType(.default)
                    .disabled(self.textFieldEstaEditando)
                
                    .onChange(of: searchText) { _ in
                        self.resetSearchText(false)
                        let currentOrdenedIdeas = ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                        
                        self.ideasViewModel.filteredIdeas = ideasViewModel.notWeekIdeas(newOrderArray: currentOrdenedIdeas, byCreation: byCreation)
                        self.ideasViewModel.favoriteIdeas = ideasViewModel.filteringFavoriteIdeas(newOrderArray: currentOrdenedIdeas, useCurrentArray: true)
                        self.ideasViewModel.weekIdeas = ideasViewModel.weekCorrentlyIdeas(newOrderArray: currentOrdenedIdeas, byCreation: byCreation)
                    }
            }
            .onAppear(perform: { self.resetSearchText() })
            .padding(UIDevice.current.userInterfaceIdiom == .phone ? 7 : 15)
            .background(Color("backgroundItem"))
            .opacity(0.8)
            .cornerRadius(8)
            .padding(.leading, 10)
        }
    }
    
    //MARK: - FUNCs
    private func resetSearchText(_ clearText: Bool = true) {
        if clearText {
            self.searchText = String()
        }
        
        self.ideasViewModel.searchText = self.searchText
    }
}
