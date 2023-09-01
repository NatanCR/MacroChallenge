//
//  EditView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 30/08/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.screenSize) var screenSize
    @Binding var font: UIFont?
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .center){
                //título
                Text("Formatar")
                    .font(.custom("Sen-Bold", size: 20))
                    .foregroundColor(Color("labelColor"))
                    .frame(alignment: .topLeading)
                    .padding()
                
                Spacer()
                
                //fecha tela de edição
                Button{
                    
                } label: {
                    Image(systemName: "x.circle.fill")
                }
                
                .padding()
            }
            .frame(width: screenSize.width, alignment: .topLeading)
//            .background(Color.red)
            ScrollView(.horizontal){
                HStack{
                    Button{
                        font = UIFont(name: "Sen-Bold", size: 25)
                    } label: {
                        Text("Título")
                            .font(.custom("Sen-Bold", size: 25))
                    }
                    .padding()
                    
                    Button{
                        font = UIFont(name: "Sen-Regular", size: 20)
                    } label: {
                        Text("Cabeçalho")
                            .font(.custom("Sen-Regular", size: 20))
                    }
                    .padding()
                    
                    Button{
                        font = UIFont(name: "Sen-Bold", size: 20)
                    } label: {
                        Text("Subtítulo")
                            .font(.custom("Sen-Bold", size: 20))
                    }
                    .padding()
                    
                    Button{
                        font = UIFont(name: "Sen-Regular", size: 17)
                    } label: {
                        Text("Corpo")
                            .font(.custom("Sen-Regular", size: 17))
                    }
                    .padding()
                }
            }
            .frame(alignment: .center)

        }
        .frame(width: screenSize.width, height: screenSize.height * 0.3, alignment: .topLeading)
        .background(
            Rectangle()
                .fill(Color("backgroundItem"))
                .cornerRadius(20)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
