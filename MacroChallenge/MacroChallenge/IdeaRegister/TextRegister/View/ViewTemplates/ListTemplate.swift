//
//  ListTemplate.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 07/06/23.
//

import SwiftUI

struct ListTemplate: View {
    @State var idea: any Idea
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy hh:mm:ss")
    
    var body: some View {
        HStack {
            VStack {
                Text("\(idea.title)")
                Text("\(idea.modifiedDate.toString(dateFormatter: self.dateFormatter)!)")
            }.padding()
            Spacer()
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
                idea.isFavorite ? Circle().fill().foregroundColor(.red).frame(width: 25, height: 25) : Circle().fill().foregroundColor(.white).frame(width: 25, height: 25)
            }
        }
    }
}

//struct ListTemplate_Previews: PreviewProvider {
//    static var previews: some View {
//        ListTemplate()
//    }
//}
