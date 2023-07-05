//
//  TagView.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 05/07/23.
//

import SwiftUI

struct TagView: View {
    @Environment(\.screenSize) var screenSize
    @State var text: String = ""
    @FocusState private var isFocused: Bool

    //Tags
    @State var tags: [Tag] = []
    
    var body: some View {
        VStack{
            Text("title")
                .font(.custom("Sen-Bold", size: 25))
                .frame (maxWidth: .infinity, alignment:
                        .leading)
            
        //View de tag
        TagComponent(maxLimit: 150, tags: $tags)
                .padding(.top, 20)
            
            HStack{
                    //Text Field
                    TextField("add a new tag", text: $text)
                        .font(.custom("Sen-Regular", size: 17))
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color("labelColor").opacity(0.5), lineWidth: 1)
                        )
                        .focused($isFocused)
                
                //mostra o botão de adicionar quando clica no text field
                if isFocused{
                    Button{
                        //adicionando tags
                        tags.append(addTag(text: text, fontSize: 16))
                        text = ""
    
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 30))
                    }
                    
                    //desabilitando botão quando o text field estiver vazio
                    .disabled(text == "")
                    .opacity (text == "" ? 0.6 : 1)
                }
            }
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onTapGesture {
            isFocused = false
        }
    }

}


struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
