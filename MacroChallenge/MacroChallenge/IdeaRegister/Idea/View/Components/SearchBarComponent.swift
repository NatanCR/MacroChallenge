//
//  SearchBarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct SearchBarComponent: View {    
    @State var searchText: String = ""
    @State var textFieldEstaEditando: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
        
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
                TextField("Pesquise aqui", text: $searchText)
                    .foregroundColor(Color("labelColor"))
                    .keyboardType(.default)
                    .disabled(self.textFieldEstaEditando)
                
                    .onChange(of: searchText) { _ in
                        self.ideasViewModel.searchText = self.searchText
                        self.ideasViewModel.filteredIdeas = ideasViewModel.filteringIdeas
                    }
            }
            .padding(UIDevice.current.userInterfaceIdiom == .phone ? 7 : 15)
            .background(Color("backgroundItem"))
            .opacity(0.8)
            .cornerRadius(8)
            .padding(.leading, 10)
            
        }
    }
}



//struct SearchBarComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarComponent()
//    }
//}
