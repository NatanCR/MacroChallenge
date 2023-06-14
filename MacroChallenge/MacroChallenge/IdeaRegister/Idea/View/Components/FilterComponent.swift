//
//  FilterComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct FilterComponent: View {
    @State var sortedByDescendent: Bool
    @State var byCreation: Bool
    @Binding var disposedData: [any Idea]
    @Binding var filteredData: [any Idea]
    @State var loadedData: [any Idea]
    @State var isFiltered: Bool
    @State var filterType: IdeaType
    @State var allFilterData: [any Idea] = []
    
    func orderBy() {
        DispatchQueue.main.async {
            if byCreation {
                //se true ordena do mais recente ao mais antigo - data de criação
                sortedByDescendent ? disposedData.sort(by: { $0.creationDate > $1.creationDate }) : disposedData.sort(by: { $0.creationDate < $1.creationDate })
                
                sortedByDescendent ? filteredData.sort(by: { $0.creationDate > $1.creationDate }) : disposedData.sort(by: { $0.creationDate < $1.creationDate })
            } else {
                //se true ordena do mais recente ao mais antigo - data de edição
                sortedByDescendent ? disposedData.sort(by: { $0.modifiedDate > $1.modifiedDate }) : disposedData.sort(by: { $0.modifiedDate < $1.modifiedDate })
                
                sortedByDescendent ? filteredData.sort(by: { $0.modifiedDate > $1.modifiedDate }) : disposedData.sort(by: { $0.modifiedDate < $1.modifiedDate })
            }
            
            
        }
    }
     
    func filterBy(_ type: IdeaType) {
        if (!isFiltered || (isFiltered && filterType != type)) {
            filterType = type
            isFiltered = true
            disposedData = loadedData.filter({ $0.ideiaType == type })
            allFilterData = filteredData
            filteredData = filteredData.filter({ $0.ideiaType == type })
            return
        }
        
        self.disposedData = self.loadedData
        self.filteredData = self.allFilterData
        self.isFiltered = false
    }
    
    var body: some View {
        //TODO: aplicar lógica de ordenação e filtro
        
                Menu{
                    Menu("Ordenar por:"){
                        Button{
                            print("ordenar por adição")
                            byCreation = true
                            orderBy()
                        } label: {
                            Text("Data de adição (Padrão)")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            print("ordenar por edição")
                            byCreation = false
                            orderBy()
                        } label: {
                            Text("Data de edição")
                            Image(systemName: "")
                        }
                        
                        Divider()
                        
                        Button{
                            print("ordenar por mais recente")
                            sortedByDescendent = true
                            orderBy()
                        } label: {
                            Text("Mais recente")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            print("ordenar por mais antigo")
                            sortedByDescendent = false
                            orderBy()
                        } label: {
                            Text("Mais antigo")
                            Image(systemName: "")
                        }
                    }
                    Menu("Filtrar por") {
                        Button{
                           print("imagem")
                            filterBy(.photo)
                        } label: {
                            Text("Imagem")
                            Image(systemName: "")
                        }
                        Button {
                            print("texto")
                            filterBy(.text)
                        } label: {
                            Text("Texto")
                            Image(systemName: "")
                        }
                        Button {
                            print("áudio")
                            filterBy(.audio)
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
