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
                Image(uiImage: UIImage(named: "folder") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                    .padding(.trailing)
            
            Spacer()

            VStack(alignment: .leading){
                Text(group.title)
                    .font(Font.custom("Sen-Bold", size: 20, relativeTo: .headline))
                    .foregroundColor(Color("labelColor"))
                    .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                    .padding(.bottom, 10)
                
                if group.modifiedDate == group.creationDate {
                    HStack{
                        Text(group.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                            .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                            .opacity(0.5)
                            .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                        
                        Text(group.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                            .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                            .opacity(0.5)
                            .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                    }

                } else {
                    HStack{
                        Text(group.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                            .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                            .opacity(0.5)
                            .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                        
                        Text(group.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                            .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                            .foregroundColor(Color("labelColor"))
                            .opacity(0.5)
                            .frame(maxWidth: screenSize.width * 0.4, maxHeight: screenSize.height * 0.008, alignment: .leading)
                    }
                }
            }
        }
        .padding([.top, .bottom], 25)
        .padding(.leading, 5)
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
