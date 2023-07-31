//
//  IdeasViewModel.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 15/06/23.
//

import Foundation
import SwiftUI

class IdeasViewModel: ObservableObject {
    @Published var loadedData = IdeaSaver.getAllSavedIdeas()
    @Published var disposedData: [any Idea] = IdeaSaver.getAllSavedIdeas()
    @Published var filteredIdeas: [any Idea] = IdeaSaver.getAllSavedIdeas()
    @Published var filterType: IdeaType = .text
    @Published var isFiltered: Bool = false
    @Published var isSortedByAscendent: Bool = false
    @Published var isSortedByCreation: Bool = false
    @Published var isShowingCamera = false
    @Published var searchText: String = ""
    @StateObject var cameraViewModel = CameraViewModel()
    
    
    func orderBy(byCreation: Bool, sortedByAscendent: Bool) {
        DispatchQueue.main.async { [self] in
            self.isSortedByAscendent = sortedByAscendent
            self.isSortedByCreation = byCreation
            
            if byCreation {
                //se true ordena do mais recente ao mais antigo - data de criação
                sortedByAscendent ? disposedData.sort(by: { $0.creationDate < $1.creationDate }) : disposedData.sort(by: { $0.creationDate > $1.creationDate })
                
                sortedByAscendent ? filteredIdeas.sort(by: { $0.creationDate < $1.creationDate }) : filteredIdeas.sort(by: { $0.creationDate > $1.creationDate })
            } else {
                //se true ordena do mais recente ao mais antigo - data de edição
                sortedByAscendent ? disposedData.sort(by: { $0.modifiedDate < $1.modifiedDate }) : disposedData.sort(by: { $0.modifiedDate > $1.modifiedDate })
                
                sortedByAscendent ? filteredIdeas.sort(by: { $0.modifiedDate < $1.modifiedDate }) : filteredIdeas.sort(by: { $0.modifiedDate > $1.modifiedDate })
            }
        }
    }
    
    func filterBy(_ type: IdeaType) {
        self.disposedData = self.loadedData
        self.filteredIdeas = self.filteringIdeas
        
        if (!isFiltered || (isFiltered && filterType != type)) {
            filterType = type
            isFiltered = true
            disposedData = loadedData.filter({ $0.ideiaType == type })
            filteredIdeas = filteredIdeas.filter({ $0.ideiaType == type })
            return
        }
        
        self.isFiltered = false
        
    }
    
    func reloadLoadedData() {
        self.loadedData = IdeaSaver.getAllSavedIdeas()
        self.loadedData = CloudManager.fetchData(loadedData)
        self.disposedData = loadedData
    }
    
//    func searchFilter(searchText: String) -> any Idea {
        var filteringIdeas: [any Idea] {
            if searchText.isEmpty {
                return disposedData
            } else {
                return disposedData.filter { idea in
                    //filtra com o que tem em cada propriedade e guarda na variavel
                    let isMatchingTitle = idea.title.localizedCaseInsensitiveContains(searchText)
                    let isMatchingDescription = idea.description.localizedCaseInsensitiveContains(searchText)
    //                let isMatchingTag = idea.tag.localizedCaseInsensitiveContains(searchText)
                    
                    return isMatchingTitle || isMatchingDescription //|| isMatchingTag
                    
                    //ordena na ordem de prioridade
                }
                .sorted { idea1, idea2 in
                    let titleMatch1 = idea1.title.localizedCaseInsensitiveContains(searchText)
                    let titleMatch2 = idea2.title.localizedCaseInsensitiveContains(searchText)
                    let descriptionMatch1 = idea1.description.localizedCaseInsensitiveContains(searchText)
                    let descriptionMatch2 = idea2.description.localizedCaseInsensitiveContains(searchText)
    //                let tagMatch1 = idea1.tag.localizedCaseInsensitiveContains(searchText)
    //                let tagMatch2 = idea2.tag.localizedCaseInsensitiveContains(searchText)

                    //compara pra saber qual ideia vem antes da outra
                    if titleMatch1 && !titleMatch2 {
                        return true
                    } else if !titleMatch1 && titleMatch2 {
                        return false
                    } else if descriptionMatch1 && !descriptionMatch2 {
                        return true
                    } else if !descriptionMatch1 && descriptionMatch2 {
                        return false
    //                } else if tagMatch1 && !tagMatch2 {
    //                    return true
    //                } else if !tagMatch1 && tagMatch2 {
    //                    return false
                    } else {
                        return idea1.creationDate > idea2.creationDate
                    }
                }
            }
        }
//        return filteredIdeas as! (any Idea)
//    }
}
