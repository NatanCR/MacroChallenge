//
//  TutorialView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 10/09/23.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.screenSize) var screenSize
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @Binding var tutorialPresented: Bool? //reconhece se o tutorial ja foi apresentado
    @State var index = 1 //index das imagens
    
    init(tutorialPresented: Binding<Bool?>?) {
        self._tutorialPresented = tutorialPresented ?? Binding.constant(nil)
    }
    
    var body: some View {
        
        //TODO: versão em inglês e versão para iPad
        NavigationView {
            
            VStack{
            }
                    .frame(width: screenSize.width, height: screenSize.height)
                    .background{
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            //reconhece idioma para setar a imagem
                            if let preferredLanguage = Locale.preferredLanguages.first {
                                if preferredLanguage.starts(with: "pt") {
                                    // carrega imagem em português
                                    // identifica se está em dark ou light mode
                                    // chama a imagem de acordo com o index
                                    Image(colorScheme == .dark ? "tutorialdark-pt\(index)" : "tutorial-pt\(index)")
                                } else {
                                    // carrega imagem em inglês
                                    // identifica se está em dark ou light mode
                                    // chama a imagem de acordo com o index
                                    Image(colorScheme == .dark ? "tutorialdark-en\(index)" : "tutorial-en\(index)")
                                    
                                }
                            }
                        } else if UIDevice.current.userInterfaceIdiom == .pad {
                            //reconhece idioma para setar a imagem
                            if let preferredLanguage = Locale.preferredLanguages.first {
                                if preferredLanguage.starts(with: "pt") {
                                    // carrega imagem em português
                                    // identifica se está em dark ou light mode
                                    // chama a imagem de acordo com o index
                                    Image(colorScheme == .dark ? "tutorialdarkipad-pt\(index)" : "tutorialipad-pt\(index)")
                                } else {
                                    // carrega imagem em inglês
                                    // identifica se está em dark ou light mode
                                    // chama a imagem de acordo com o index
                                    Image(colorScheme == .dark ? "tutorialdarkipad-en\(index)" : "tutorialipad-en\(index)")
                                    
                                }
                            }
                        }
                    }
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    // opção de pular tutorial, aparece se não for a última imagem
                    if index<=4{
                        Button{
                            let fromInfo = tutorialPresented == nil
                            if !fromInfo {
                                tutorialPresented = true
                                UserDefaults.standard.set(true, forKey: "hasShownTutorial")
                            } else {
                                dismiss()
                            }
                        } label: {
                            Text("skip")
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack{
                        
                        // botão de voltar para imagem anterior
                        HStack{
                            if index>1{
                                Button{
                                    index = index - 1
                                } label: {
                                    Text("previous")
                                        .padding(.leading)
                                }
                            }
                        }
                        .frame(width: screenSize.width * 0.5, alignment: .leading)

                        // botão de avançar para próxima imagem ou concluir tutorial
                        HStack{
                            if index<=4{
                                Button{
                                    index = index + 1
                                } label: {
                                    Text("next")
                                        .padding(.trailing)
                                }
                                
                            } else {
                                Button{
                                    //na primeira vez que o tutorial for acessado, salva acesso
                                    if let presented = tutorialPresented {
                                        if !presented{
                                            tutorialPresented = true
                                            UserDefaults.standard.set(true, forKey: "hasShownTutorial") //salva no user defaults para aparecer apenas no primeiro acesso
                                        }
                                    } else {
                                        dismiss() //se estiver visualizando da tela de info, dá dismiss
                                    }
                                } label: {
                                    Text("OK")
                                        .foregroundColor(Color("backgroundColor"))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 10)
                                        .background{
                                            Capsule(style: .circular)
                                                .fill(Color("AccentColor"))
                                        }
                                        .padding(.trailing)
                                }
                            }
                            
                        }
                        .frame(width: screenSize.width * 0.5, alignment: .trailing)
                        
                    }
                    .frame(width: screenSize.width, alignment: .trailing)

                }
                
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)

    }
}

//struct TutorialView_Previews: PreviewProvider {
//    @Environment(\.screenSize) var screenSize
//    static var previews: some View {
//        TutorialView()
//    }
//}
