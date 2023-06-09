//
//  SearchBarComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct SearchBarComponent: View {
    
    //TODO: fazer a lógica da search bar
    
    @State var textoPesquisa = ""
    @State var textFieldEstaEditando = false
    
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
