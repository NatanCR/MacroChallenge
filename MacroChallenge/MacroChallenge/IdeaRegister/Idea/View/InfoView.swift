//
//  InfoView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 09/06/23.
//

import SwiftUI

struct InfoView: View {
    //variável que recebe o título do botão
    var infoTitle: [String] = ["Sobre", "Política de privacidade", "Termos de uso"]
    
    var infoText: String
    
    var body: some View {
        
        VStack{
            //botões da tela de info
            ForEach(infoTitle, id: \.self) { title in
                NavigationLink{
                    InfoText(infoText: infoText, infoTitle: title)
                } label: {
                    ButtonComponent(title: title)
                }.padding(5)
                
            }
            
            Spacer()
            
        }   .padding()
            .navigationTitle("Info")
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
                Text(infoText)
                    .font(.custom("Sen-Regular", size: 17, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
            }.padding()
            .navigationTitle(infoTitle)
            
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        
        InfoView(infoText: "")
    }
}
