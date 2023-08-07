//
//  HomeNavigationBar.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 07/08/23.
//

import SwiftUI

struct HomeNavigationBar: View {
    @ObservedObject var ideasVM : IdeasViewModel
    @FocusState private var searchInFocus: Bool
    
    var body: some View {
        VStack {
            HStack {
                SearchBarComponent(ideasViewModel: ideasVM)
                    .font(Font.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    .focused($searchInFocus)
                FilterComponent(ideasViewModel: ideasVM)
                    .padding(.trailing)
            }
        }
        
    }
}

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBar(ideasVM: IdeasViewModel())
    }
}
