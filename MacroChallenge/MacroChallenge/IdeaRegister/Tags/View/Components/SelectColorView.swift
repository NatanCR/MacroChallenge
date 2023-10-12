//
//  SelectColorView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 24/08/23.
//

import SwiftUI

struct SelectColorView: View {
    @Environment(\.screenSize) var screenSize
    
    @Binding var colorName: String //passa a cor selecionada para as outras views
    
    var body: some View {
        //view de selecionar cor para tag
        ScrollView(.horizontal){
            HStack{
                //apresenta as 11 opções de cores
                ForEach(1..<12){ i in
                    Button{
                        
                        if colorName != "tagColor\(i)"{
                            colorName = "tagColor\(i)" //atribui a cor de acordo com o índice
                        } else {
                            colorName = "" //se clicar novamente, volta para a cor padrão
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("tagColor\(i)"))
                        //indica qual cor está selecionada
                            .overlay{
                                Circle()
                                .stroke(colorName == "tagColor\(i)" ? Color.green : Color.clear, lineWidth: 1)
                            }
                            
                    }
                }
                
            }
            .frame(height: screenSize.height * 0.1)
            .padding(5)
        }

    }
}

//struct SelectColorView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectColorView(color: "")
//    }
//}
