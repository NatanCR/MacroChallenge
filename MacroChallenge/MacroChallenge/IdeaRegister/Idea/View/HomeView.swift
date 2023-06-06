//
//  HomeView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 06/06/23.
//

import SwiftUI

struct HomeView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Spacer()
                        Menu{
                            Menu("Ordenar por:"){
                                Button("Data de adição (Padrão)") {
                                    print("ordenar por adição")
                                }
                                Button("Data de edição") {
                                    print("ordenar por edição")
                                    
                                }
                                
                                Divider()
                                
                                Button("Mais recente") {
                                    print("ordenar por mais recente")
                                }
                                Button("Mais antigo") {
                                    print("ordenar por mais antigo")
                                    
                                }
                            }
                            Menu("Filtrar por") {
                                Button("Imagem") {
                                   
                                }
                                Button("Texto") {
                                    
                                }
                                Button("Áudio") {
                                    
                                }
                            }
                        } label: {
                            Text(Image(systemName: "line.3.horizontal.decrease.circle"))
                                .font(.system(size: 20))
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach((1...9), id: \.self) { i in
                            // teste para texto
                            if i < 4 {
                                TextPreviewComponent(text: "oioioioioioioioioioioioioioioioioioioio")
                            }
                            
                            // teste para audio
                            else if i >= 4 && i < 7 {
                                AudioPreviewComponent()
                            }
                            
                            // teste para foto
                            else {
                                ImagePreviewComponent(image: UIImage(systemName: "trash.fill") ?? UIImage())
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
