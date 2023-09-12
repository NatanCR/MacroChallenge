//
//  ListGroupComponent.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 22/08/23.
//

import SwiftUI

struct ListGroupComponent: View {
    @Environment(\.screenSize) var screenSize
    var group: GroupModel
    @State private var isAlertActive: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(group.title)
                    .font(Font.custom("Sen-Regular", size: 20, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
                    .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.01, alignment: .leading)
                    .padding(.bottom, 5)
                
                if group.modifiedDate == group.creationDate {
                    Text(group.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                        .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                        .opacity(0.5)
                        .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.01, alignment: .leading)

                    Text(group.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                        .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                        .foregroundColor(Color("labelColor"))
                        .opacity(0.5)
                        .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.01, alignment: .leading)

                } else {
                    Text(group.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                        .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                        .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
                    
                    Text(group.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                        .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                        .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
                }
            }
            
            Spacer()
                Image(uiImage: UIImage(systemName: "folder") ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25)
        }
        .padding([.top, .bottom])
        //arrastar para deletar e para favoritar na lista
        .swipeActions(edge: .trailing) {
            //TODO: atualizar a view assim que deleta a ideia
            Button(role: .destructive) {
                IdeaSaver.clearOneGroup(group: group)
                self.ideasViewModel.resetDisposedData()
            } label: {
                Image(systemName: "trash.fill")
            }
            .tint(Color("deleteColor"))
            
        }
    }
}

//struct ListGroupComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ListGroupComponent()
//    }
//}
