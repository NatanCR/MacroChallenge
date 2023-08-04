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
    @Published var searchTag: String = ""
    @StateObject var cameraViewModel = CameraViewModel()
    @Published var tagsLoadedData: [Tag] = IdeaSaver.getAllSavedTags()
    @Published var tagsFiltered: [Tag] = IdeaSaver.getAllSavedTags()
    static let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    
    func DismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
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
        self.disposedData = loadedData
    }
    
    var filteringTags: [Tag] {
        if searchTag.isEmpty {
            return tagsLoadedData
        } else {
            
            return tagsLoadedData.filter { tag in
                let isMachingTag = tag.name.localizedCaseInsensitiveContains(searchTag)
                
                return isMachingTag
            }
            .sorted { tag1, tag2 in
                let tagMach1 = tag1.name.localizedCaseInsensitiveContains(searchTag)
                let tagMach2 = tag2.name.localizedCaseInsensitiveContains(searchTag)
                
                if tagMach1 && !tagMach2 {
                    return true
                } else if !tagMach1 && tagMach2 {
                    return false
                } else {
                    return tag1.name > tag2.name
                }
            }
        }
    }
    
    var filteringIdeas: [any Idea] {
        if searchText.isEmpty {
            return disposedData
        } else {
            return disposedData.filter { idea in
                //filtra com o que tem em cada propriedade e guarda na variavel
                let isMatchingTitle = idea.title.localizedCaseInsensitiveContains(searchText)
                let isMatchingDescription = idea.description.localizedCaseInsensitiveContains(searchText)
                let isMatchingTag = idea.tag?.first(where: { $0.name.localizedCaseInsensitiveContains(searchText) })
                
                return isMatchingTitle || isMatchingDescription || (isMatchingTag != nil)
                
                //ordena na ordem de prioridade
            }
            .sorted { idea1, idea2 in
                let titleMatch1 = idea1.title.localizedCaseInsensitiveContains(searchText)
                let titleMatch2 = idea2.title.localizedCaseInsensitiveContains(searchText)
                let descriptionMatch1 = idea1.description.localizedCaseInsensitiveContains(searchText)
                let descriptionMatch2 = idea2.description.localizedCaseInsensitiveContains(searchText)
                let tagMatch1 = idea1.tag?.first(where: { $0.name.localizedCaseInsensitiveContains(searchText) })
                let tagMatch2 = idea2.tag?.first(where: { $0.name.localizedCaseInsensitiveContains(searchText) })
                
                //compara pra saber qual ideia vem antes da outra
                if titleMatch1 && !titleMatch2 {
                    return true
                } else if !titleMatch1 && titleMatch2 {
                    return false
                } else if descriptionMatch1 && !descriptionMatch2 {
                    return true
                } else if !descriptionMatch1 && descriptionMatch2 {
                    return false
                } else if (tagMatch1 != nil) && (tagMatch2 == nil) {
                    return true
                } else if (tagMatch1 == nil) && (tagMatch2 != nil) {
                    return false
                } else {
                    return idea1.creationDate > idea2.creationDate
                }
            }
        }
    }
    
    /**Função para formatar e devolver uma tag estruturada para adicionar no banco de dados**/
    func addTag(text: String, color: String) -> Tag {
        
        //pegando tamanho do texto
        let font = UIFont.systemFont(ofSize: 16)
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        return Tag(name: text, color: color, size: size.width)
    }
    
    /**Função que verifica se existem tags já usadas na ideia que está sendo visualizada, para exibi-las com borda pro usuário.**/
    func updateSelectedTags(allTags: [Tag], tagSelected: [Tag]) -> [Tag] {
        // Cria uma cópia do array allTags
        var updatedTags = allTags
        
        // Itera sobre as tags presentes em tagArraySelected
        for selectedTag in tagSelected {
            // Verifica se a tag selecionada está presente em allTags
            if let index = updatedTags.firstIndex(where: { $0.id == selectedTag.id }) {
                // Atualiza a propriedade isTagSelected para true
                updatedTags[index].isTagSelected = true
                
            }
        }
        return updatedTags
    }
    
    func verifyExistTags(newTagName: String) -> Bool {
        for tag in self.tagsLoadedData {
            if tag.name == newTagName {
                print("nome igual")
                return true
            } else {
                print("ainda nao existe")
            }
        }
        print("ta retornando falso")
        return false
    }
    
    /**Função que salva uma nova tag e recarrega a lista com as tags recentes**/
    func saveTagAndUpdateListView(tagName: String, tagColor: String) {
        IdeaSaver.saveTag(tag: addTag(text: tagName, color: tagColor))
        tagsLoadedData = IdeaSaver.getAllSavedTags()
    }
}

