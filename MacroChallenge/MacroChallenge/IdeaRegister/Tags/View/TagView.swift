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
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("labelColor"))
                .frame(width: screenSize.width * 0.5, height: screenSize.height * 0.005)
            Text("Tags")
                .font(.custom("Sen-Bold", size: 30))
                .frame (maxWidth: .infinity, alignment:
                        .leading)
                .padding(.vertical)
            HStack{
                //Text Field
                //TODO: localizar texto do placeholder
                TextField("Add a new tag", text: $text)
                    .font(.custom("Sen-Regular", size: 17))
                    .foregroundColor(Color("labelColor"))
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
                        isFocused = false
                        
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 30))
                    }
                    
                    //desabilitando botão quando o text field estiver vazio
                    .disabled(text == "")
                    .opacity (text == "" ? 0.6 : 1)
                }
            }
            
        //View de tag
        TagComponent(maxLimit: 150, tags: $tags)
                .padding(.top, 20)
            
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("backgroundColor"))
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
