//
//  InfoView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 09/06/23.
//

import SwiftUI

struct InfoView: View {
    //variável que recebe o título do botão
    var infoTitle: String
    var infoText: String
    
    var body: some View {
        
        VStack{
            //botões da tela de info
            ForEach((1...3), id: \.self) { i in
                
                NavigationLink{
                    InfoText(infoText: infoText, infoTitle: infoTitle)
                } label: {
                    ButtonComponent(title: infoTitle)
                }.padding(5)
                
            }
            
            Spacer()
            
        }   .padding()
            .navigationTitle("Info")
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
                    .font(.custom("Sen-Regular", size: 17))
                    .foregroundColor(Color("labelColor"))
            }.padding()
            .navigationTitle(infoTitle)
            
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        
        InfoView(infoTitle: "", infoText: "")
    }
}
