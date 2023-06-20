//
//  InfoView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 09/06/23.
//

import SwiftUI

struct InfoView: View {
    //variável que recebe o título do botão
    var infoTitle: [String] = ["about", "privacy", "terms"]
    var infoText: [String] = ["hhhhhhh", "llllllll", "ttttttt"]
    
    var body: some View {
        
        VStack{
            //botões da tela de info
            ForEach(0..<infoText.count, id: \.self) { i in
                NavigationLink{
                    InfoText(infoText: infoText[i], infoTitle: infoTitle[i])
                } label: {
                    ButtonComponent(title: infoTitle[i])
                }.padding(5)
            }
            
            Spacer()
            
        }   .padding()
            .navigationTitle("info")
            .background(Color("backgroundColor"))
    }
}

struct InfoText: View {
    
    //variáveis que recebem o texto e título
    var infoText: String
    var infoTitle: String
    
    var body: some View {
        
        //formatação de texto da tela de informações
        ScrollView{
            VStack (alignment: .leading){
                Text(LocalizedStringKey(infoText))
                    .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                //TODO: colocar frame 
                    .foregroundColor(Color("labelColor"))
            }.padding()
            .navigationTitle(LocalizedStringKey(infoTitle))
        }
        .background(Color("backgroundColor"))
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        
        InfoView(infoTitle: [""])
    }
}
