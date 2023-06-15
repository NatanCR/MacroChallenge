//
//  FilterComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct FilterComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State var sortedByDescendent: Bool = true
    @State var byCreation: Bool = true 
    
    var body: some View {        
                Menu{
                    Menu("Ordenar por:"){
                        Button{
                            print("ordenar por adição")
                            byCreation = true
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("Data de adição (Padrão)")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            byCreation = false
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("Data de edição")
                            Image(systemName: "")
                        }
                        
                        Divider()
                        
                        Button{
                            print("ordenar por mais recente")
                            sortedByDescendent = true
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("Mais recente")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            print("ordenar por mais antigo")
                            sortedByDescendent = false
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("Mais antigo")
                            Image(systemName: "")
                        }
                    }
                    Menu("Filtrar por") {
                        Button{
                           print("imagem")
                            ideasViewModel.filterBy(.photo)
                        } label: {
                            Text("Imagem")
                            Image(systemName: "")
                        }
                        Button {
                            print("texto")
                            ideasViewModel.filterBy(.text)
                        } label: {
                            Text("Texto")
                            Image(systemName: "")
                        }
                        Button {
                            print("áudio")
                            ideasViewModel.filterBy(.audio)
                        } label: {
                            Text("Áudio")
                            Image(systemName: "")
                        }
                    }
                } label: {
                    Text(Image(systemName: "line.3.horizontal.decrease.circle"))
                        .font(.system(size: 25))
        }
    }
}

//struct FilterComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterComponent(sortedByDescendent: <#Bool#>, byCreation: <#Bool#>, disposedData: <#[Idea]#>, loadedData: <#[Idea]#>, isFiltered: <#Bool#>, filterType: <#IdeaType#>)
//    }
//}
