//
//  GroupPreviewComponent.swift
//  MacroChallenge
//
//  Created by Rodrigo Ferreira Pereira on 16/08/23.
//

import SwiftUI

struct GroupPreviewComponent: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.screenSize) var screenSize
    var group: GroupModel
    @State private var isAlertActive: Bool = false
    @ObservedObject var ideasViewModel: IdeasViewModel
    
    init(group: GroupModel, ideasViewModel: IdeasViewModel) {
        self.group = group
        self.ideasViewModel = ideasViewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("backgroundItem"))
                    .frame(width: screenSize.width * 0.26, height: screenSize.width * 0.26)
                Image(systemName: "folder")
                    .font(.title)
            }
            .padding(.bottom, 5)
            
            //deletar
            .contextMenu{
                Button(role: .destructive){
                    isAlertActive = true
                } label: {
                    HStack{
                        Text("del")
                        Image(systemName: "trash")
                    }
                }
            }
            
            Text(group.title)
                .font(.custom("Sen-Bold", size: 17, relativeTo: .headline))
                .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            
            if group.modifiedDate == group.creationDate {
                Text(group.creationDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                    .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                    .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
                Text(group.creationDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                    .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                    .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            } else {
                Text(group.modifiedDate.toString(dateFormatter: IdeasViewModel.dateFormatter)!)
                    .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                    .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
                Text(group.modifiedDate.toString(dateFormatter: IdeasViewModel.hourDateLanguageFormat())!)
                    .font(Font.custom("Sen-Regular", size: 15, relativeTo: .headline))
                    .frame(maxWidth: screenSize.width * 0.25, maxHeight: screenSize.height * 0.015)
            }
        }
        .confirmationDialog("delMsg", isPresented: $isAlertActive) {
            Button("delFolder", role: .destructive) {
                //deletar
                IdeaSaver.clearOneGroup(group: group)
                self.ideasViewModel.resetDisposedData()
            }
        }
    }
}

//struct GroupPreviewComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupPreviewComponent()
//    }
//}
