//
//  FilterComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct FilterComponent: View {
    var body: some View {
        
        //TODO: aplicar lógica de ordenação e filtro
        
                Menu{
                    Menu("Ordenar por:"){
                        Button{
                            print("ordenar por adição")
                        } label: {
                            Text("Data de adição (Padrão)")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            print("ordenar por edição")
                            
                        } label: {
                            Text("Data de edição")
                            Image(systemName: "")
                        }
                        
                        Divider()
                        
                        Button{
                            print("ordenar por mais recente")
                        } label: {
                            Text("Mais recente")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            print("ordenar por mais antigo")
                        } label: {
                            Text("Mais antigo")
                            Image(systemName: "")
                        }
                    }
                    Menu("Filtrar por") {
                        Button{
                           print("imagem")
                        } label: {
                            Text("Imagem")
                            Image(systemName: "")
                        }
                        Button {
                            print("texto")
                        } label: {
                            Text("Texto")
                            Image(systemName: "")
                        }
                        Button {
                            print("áudio")
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

struct FilterComponent_Previews: PreviewProvider {
    static var previews: some View {
        FilterComponent()
    }
}
