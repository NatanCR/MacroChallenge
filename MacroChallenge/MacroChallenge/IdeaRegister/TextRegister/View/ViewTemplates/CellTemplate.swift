//
//  CellTemplate.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 30/05/23.
//

import SwiftUI

struct CellTemplate: View {
    @State var idea: any Idea
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy hh:mm:ss")
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 100)
                .foregroundColor(.gray)
                .overlay(alignment: .topTrailing) {
                    Button {
                        //troca o valor booleano
                        idea.isFavorite.toggle()
                        //verfica qual é o tipo de ideia pra poder salvar o registro novamente
                        switch idea.ideiaType {
                        case .audio:
                            IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: idea as! AudioIdeia)
                        case .text:
                            IdeaSaver.changeSavedValue(type: ModelText.self, idea: idea as! ModelText)
                        case .photo:
                            IdeaSaver.changeSavedValue(type: PhotoModel.self, idea: idea as! PhotoModel)
                        }
                    } label: {
                        //if ternario que verifica o valor booleano pra trocar a cor do favorito
                        idea.isFavorite ? Circle().fill().foregroundColor(.red).frame(width: 20, height: 20) : Circle().fill().foregroundColor(.white).frame(width: 20, height: 20)
                    }
                }
            VStack {
                Text("\(idea.title)")
                Text("\(idea.modifiedDate.toString(dateFormatter: self.dateFormatter)!)")
            }.padding()
        }.onAppear{
            print(idea.isFavorite)
        }
    }
}
//
//struct CellTemplate_Previews: PreviewProvider {
//    static var previews: some View {
//        CellTemplate()
//    }
//}
