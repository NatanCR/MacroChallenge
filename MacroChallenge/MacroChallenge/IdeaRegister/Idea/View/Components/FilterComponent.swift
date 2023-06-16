//
//  FilterComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct FilterComponent: View {
    @ObservedObject var ideasViewModel: IdeasViewModel
    @State var sortedByDescendent: Bool = true
    @State var byCreation: Bool = true 
    
    var body: some View {        
                Menu{
                    Menu("order"){
                        Button{
                            byCreation = true
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("addDate)")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            byCreation = false
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("editDate")
                            Image(systemName: "")
                        }
                        
                        Divider()
                        
                        Button{
                            sortedByDescendent = true
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("recent")
                            Image(systemName: "checkmark")
                        }
                        Button {
                            sortedByDescendent = false
                            ideasViewModel.orderBy(byCreation: byCreation, sortedByDescendent: sortedByDescendent)
                        } label: {
                            Text("old")
                            Image(systemName: "")
                        }
                    }
                    Menu("filter") {
                        Button{
                            ideasViewModel.filterBy(.photo)
                        } label: {
                            Text("img")
                            Image(systemName: "")
                        }
                        Button {
                            ideasViewModel.filterBy(.text)
                        } label: {
                            Text("txt")
                            Image(systemName: "")
                        }
                        Button {
                            ideasViewModel.filterBy(.audio)
                        } label: {
                            Text("aud")
                            Image(systemName: "")
                        }
                    }
                } label: {
                    Text(Image(systemName: "line.3.horizontal.decrease.circle"))
                        .font(.system(size: 25))
        }
    }
}

//struct FilterComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterComponent(sortedByDescendent: <#Bool#>, byCreation: <#Bool#>, disposedData: <#[Idea]#>, loadedData: <#[Idea]#>, isFiltered: <#Bool#>, filterType: <#IdeaType#>)
//    }
//}
