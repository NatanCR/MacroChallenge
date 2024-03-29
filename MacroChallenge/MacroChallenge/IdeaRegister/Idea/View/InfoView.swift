//
//  InfoView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 09/06/23.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.screenSize) var screenSize
    //variável que recebe o título do botão
    var infoTitle: [String] = ["about", "privacy", "terms", "tutorial"]
    var infoText: [String] = ["aboutText", "privacyText", "termsText", ""]
    
    var body: some View {
        
        VStack {
            //botões da tela de info
            ForEach(0..<infoText.count, id: \.self) { i in
                NavigationLink{
                    // if is the tutorial screen
                    if i == 3 {
                        TutorialView(tutorialPresented: nil)
                    } else {
                        InfoText(infoText: infoText[i], infoTitle: infoTitle[i])
                    }
                } label: {
                    ButtonComponent(title: infoTitle[i])
                }.padding(5)
            }
            Spacer()
            
        }
        .frame(width: screenSize.width)
        .navigationTitle("info")
        .background(Color("backgroundColor"))
    }
}

struct InfoText: View {
    @Environment(\.screenSize) var screenSize
    @Environment(\.dismiss) var dismiss
    //variáveis que recebem o texto e título
    var infoText: String
    var infoTitle: String
    
    var body: some View {
        
            //formatação de texto da tela de informações
            ScrollView{
                VStack (alignment: .leading){
                    Text(LocalizedStringKey(infoText))
                        .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                        .frame(maxWidth: screenSize.width * 0.9, maxHeight: .infinity, alignment: .leading)
                        .foregroundColor(Color("labelColor"))
                }
                .navigationTitle(LocalizedStringKey(infoTitle))
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("back")
                                    .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                            }
                        }

                    }
                }
            }
            .frame(width: screenSize.width)
            .background(Color("backgroundColor"))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        
        InfoView(infoTitle: [""])
    }
}
