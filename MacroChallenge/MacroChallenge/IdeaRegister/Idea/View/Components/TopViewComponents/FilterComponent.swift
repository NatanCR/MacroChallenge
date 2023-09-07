//
//  FilterComponent.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 07/06/23.
//

import SwiftUI

struct FilterComponent: View {
    private enum FilterType {
        case audio, text, photo, none
    }
    
    @ObservedObject var ideasViewModel: IdeasViewModel
    @Binding var sortedByAscendent: Bool
    @Binding var byCreation: Bool 
    @State private var filterType: FilterType = .none
    
    var body: some View {        
        Menu{
            Menu("order"){
                // ordenacao por data de modificacao
                Button {
                    byCreation = false
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                } label: {
                    Text("editDate")
                    Image(systemName: byCreation ? "" : "checkmark")
                }
                
                // ordenacao por data de criacao
                Button{
                    byCreation = true
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                } label: {
                    Text("addDate")
                    Image( systemName: byCreation ? "checkmark" : "")
                }
                
                Divider()
                
                // ordenacao por ordem decrescente
                Button{
                    sortedByAscendent = false
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                } label: {
                    Text("recent")
                    Image(systemName: sortedByAscendent ? "" : "checkmark")
                }
                // ordenacao por ordem crescente
                Button {
                    sortedByAscendent = true
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                } label: {
                    Text("old")
                    Image(systemName: sortedByAscendent ? "checkmark" : "")
                }
            }
            Menu("filter") {
                Button{
                    ideasViewModel.filterBy(.photo)
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                    self.setFilterType(.photo)
                } label: {
                    Text("img")
                    Image(systemName: self.filterType == .photo ? "checkmark" : "")
                }
                Button {
                    ideasViewModel.filterBy(.text)
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                    self.setFilterType(.text)
                } label: {
                    Text("txt")
                    Image(systemName: self.filterType == .text ? "checkmark" : "")
                }
                Button {
                    ideasViewModel.filterBy(.audio)
                    ideasViewModel.orderBy(byCreation: byCreation, sortedByAscendent: sortedByAscendent)
                    self.setFilterType(.audio)
                } label: {
                    Text("aud")
                    Image(systemName: self.filterType == .audio ? "checkmark" : "")
                }
            }
        } label: {
            Text(Image(systemName: "line.3.horizontal.decrease.circle"))
                .font(.system(size: 25))
        }
        .onAppear {
            self.filterType = .none
            self.ideasViewModel.isFiltered = false
        }
    }
    
    private func setFilterType(_ filter: FilterType) {
        if !self.ideasViewModel.isFiltered {
            self.filterType = .none
            return
        }
        
        self.filterType = filter
    }
}
