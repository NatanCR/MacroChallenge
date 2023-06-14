//
//  ListRowComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct ListRowComponent: View {
    
    var title: String
    var infoDate: Date
    var typeIdea: IdeaType
    var imageIdea: UIImage
    private let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    var body: some View {
        HStack{
            
            VStack(alignment: .leading){
                Text(title)
                    .font(Font.custom("Sen-Regular", size: 20))
                    .foregroundColor(Color("labelColor"))
                Text(infoDate.toString(dateFormatter: self.dateFormatter)!)
                    .font(Font.custom("Sen-Regular", size: 15))
                    .foregroundColor(Color("labelColor"))
                    .opacity(0.5)
            }
            
            Spacer()
            if typeIdea == .audio {
                Image(uiImage: UIImage(systemName: "waveform.and.mic") ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
            } else if typeIdea == .photo {
                //colocar foto
                Image(uiImage: UIImage(systemName: "rectangle.fill") ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
            } else {
                
            }

        }
            .padding()
        
    }
}

struct ListRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        
        ListRowComponent(title: "teste", infoDate: Date(), typeIdea: IdeaType.text, imageIdea: UIImage())
    }
}
