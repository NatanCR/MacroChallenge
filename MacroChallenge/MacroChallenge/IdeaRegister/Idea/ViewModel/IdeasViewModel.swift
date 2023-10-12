//
//  IdeasViewModel.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 15/06/23.
//

import Foundation
import SwiftUI

class IdeasViewModel: ObservableObject {
    //MARK: Ideas data
    @Published var loadedData = IdeaSaver.getAllSavedIdeas()
    @Published var disposedData: [any Idea] = IdeaSaver.getAllSavedIdeas()
    @Published var filteredIdeas: [any Idea] = IdeaSaver.getAllSavedIdeas()
    @Published var favoriteIdeas: [any Idea] = []
    @Published var weekIdeas: [any Idea] = []
    //MARK: Filters or Search
    @Published var filterType: IdeaType = .text
    @Published var isFiltered: Bool = false
    @Published var isSortedByAscendent: Bool = false
    @Published var isSortedByCreation: Bool = false
    @Published var isShowingCamera: Bool = false
    @Published var searchText: String = ""
    @Published var searchTag: String = ""
    //MARK: Camera
    var cameraViewModel = CameraViewModel()
    //MARK: Tags data
    @Published var tagsLoadedData: [Tag] = IdeaSaver.getAllSavedTags()
    @Published var tagsFiltered: [Tag] = IdeaSaver.getAllSavedTags()
    //MARK: Group data
    @Published var groupsLoadedData: [GroupModel] = IdeaSaver.getAllSavedGroups().reversed()
    @Published var weekGroups: [GroupModel] = []
    @Published var favoriteGroups: [GroupModel] = []
    @Published var selectedGroup: GroupModel? = nil
    //MARK: Dates
    static let dateFormatter = DateFormatter(format: "dd/MM/yyyy")
    //MARK: Section
    @Published var revealSectionDetails: Bool = false
    
    
    func DismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    static func hourDateLanguageFormat() -> DateFormatter {
        if dateFormatter.locale.identifier == "pt_BR" || dateFormatter.locale.identifier == "en_BR" {
            return DateFormatter(format: "HH:mm")
        } else {
            return DateFormatter(format: "hh:mm a")
        }
    }
    
    func orderBy(byCreation: Bool, sortedByAscendent: Bool) -> [any Idea] {
        DispatchQueue.main.async { [self] in
            self.isSortedByAscendent = sortedByAscendent
            self.isSortedByCreation = byCreation
            
            if byCreation {
                //se true ordena do mais recente ao mais antigo - data de criação
                sortedByAscendent ? disposedData.sort(by: { $0.creationDate < $1.creationDate }) : disposedData.sort(by: { $0.creationDate > $1.creationDate })
                
                self.filteredIdeas = self.notWeekIdeas(newOrderArray: disposedData)
                self.weekIdeas = self.weekCorrentlyIdeas(newOrderArray: disposedData)
                                
                sortedByAscendent ? favoriteIdeas.sort(by: { $0.creationDate < $1.creationDate }) : favoriteIdeas.sort(by: { $0.creationDate > $1.creationDate })
                
            } else {
                //se true ordena do mais recente ao mais antigo - data de edição
                sortedByAscendent ? disposedData.sort(by: { $0.modifiedDate < $1.modifiedDate }) : disposedData.sort(by: { $0.modifiedDate > $1.modifiedDate })
                
                self.filteredIdeas = self.notWeekIdeas(newOrderArray: disposedData, byCreation: false)
                self.weekIdeas = self.weekCorrentlyIdeas(newOrderArray: disposedData, byCreation: false)
                                
                sortedByAscendent ? favoriteIdeas.sort(by: { $0.modifiedDate < $1.modifiedDate }) : favoriteIdeas.sort(by: { $0.modifiedDate > $1.modifiedDate })
                
            }
        }
        
        return disposedData
    }
    
    /**Função para filtrar TODAS as ideias de acordo com o tipo de ideia escolhido pelo usuário em todas as seções**/
    func filterBy(_ type: IdeaType) {
        self.disposedData = self.loadedData
        self.filteredIdeas = self.notWeekIdeas()
        self.favoriteIdeas = self.filteringFavoriteIdeas()
        self.weekIdeas = self.weekCorrentlyIdeas()
        
        if (!isFiltered || (isFiltered && filterType != type)) {
            filterType = type
            isFiltered = true
            disposedData = loadedData.filter({ $0.ideiaType == type })
            filteredIdeas = filteredIdeas.filter({ $0.ideiaType == type })
            favoriteIdeas = favoriteIdeas.filter({ $0.ideiaType == type })
            weekIdeas = weekIdeas.filter({ $0.ideiaType == type })
            return
        }
        
        self.isFiltered = false
    }
    
    /**Função para filtrar e devolver apenas ideias favoritadas pra exibir na seção de favoritos*/
    func filteringFavoriteIdeas(newOrderArray: [any Idea] = [], useCurrentArray: Bool = false) -> [any Idea] {
        if useCurrentArray {
            return self.filteringIdeas(newOrderArray: newOrderArray).filter { idea in
                return idea.isFavorite == true
            }
        } else {
            return self.filteringIdeas().filter { idea in
                return idea.isFavorite == true
            }
        }
    }
    
    /**Função que filtra e devolve as ideias não favoritadas pra serem exibidas na seção geral**/
    func filteringNotFavoriteIdeas(newOrderArray: [any Idea] = [], useCurrentArray: Bool = false) -> [any Idea] {
        if useCurrentArray {
            return self.filteringIdeas(newOrderArray: newOrderArray).filter { idea in
                return idea.isFavorite == false
            }
        } else {
            //utiliza o array que foi ordenado pelo filtro que o usuário escolheu
            return newOrderArray.filter { idea in
                return idea.isFavorite == false
            }
        }
    }
    
    /**Função que filtra e devolve as ideias da semana que não estão favoritadas.**/
    func weekCorrentlyIdeas(newOrderArray: [any Idea] = [], byCreation: Bool = true) -> [any Idea] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        if newOrderArray.isEmpty {
            return filteringNotFavoriteIdeas().filter { idea in
                calendar.isDate(idea.creationDate, equalTo: currentDate, toGranularity: .weekOfYear) ||
                calendar.isDate(idea.modifiedDate, equalTo: currentDate, toGranularity: .weekOfYear)
            }
        } else {
            //utiliza o array que foi ordenado pelo filtro que o usuário escolheu
            if byCreation {
                return filteringNotFavoriteIdeas(newOrderArray: newOrderArray, useCurrentArray: true).filter { idea in
                    calendar.isDate(idea.creationDate, equalTo: currentDate, toGranularity: .weekOfYear)
                }
            } else {
                return filteringNotFavoriteIdeas(newOrderArray: newOrderArray, useCurrentArray: true).filter { idea in
                    calendar.isDate(idea.modifiedDate, equalTo: currentDate, toGranularity: .weekOfYear)
                }
            }
        }
    }
    
    /**Função que filtra e devolve as DEMAIS ideias que não estão favoritadas**/
    func notWeekIdeas(newOrderArray: [any Idea] = [], byCreation: Bool = true) -> [any Idea] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        if newOrderArray.isEmpty {
            return filteringNotFavoriteIdeas().filter { idea in
                !(calendar.isDate(idea.creationDate, equalTo: currentDate, toGranularity: .weekOfYear) ||
                  calendar.isDate(idea.modifiedDate, equalTo: currentDate, toGranularity: .weekOfYear))
            }
        } else {
            //utiliza o array que foi ordenado pelo filtro que o usuário escolheu
            if byCreation {
                return filteringNotFavoriteIdeas(newOrderArray: newOrderArray, useCurrentArray: true).filter { idea in
                    !(calendar.isDate(idea.creationDate, equalTo: currentDate, toGranularity: .weekOfYear))
                }
            } else {
                return filteringNotFavoriteIdeas(newOrderArray: newOrderArray, useCurrentArray: true).filter { idea in
                    !(calendar.isDate(idea.modifiedDate, equalTo: currentDate, toGranularity: .weekOfYear))
                }
            }
        }
    }
        
    func reloadLoadedData() {
        self.loadedData = IdeaSaver.getAllSavedIdeas()
        self.groupsLoadedData = IdeaSaver.getAllSavedGroups().reversed()
        self.disposedData = loadedData
    }
    
    /**Função para atualizar a seção de favoritos ao favoritar novas ideias e obter mudanças**/
    func updateSectionIdeas() {
        resetDisposedData()
        
        self.favoriteIdeas = self.filteringFavoriteIdeas()
        self.filteredIdeas = self.notWeekIdeas()
        self.weekIdeas = self.weekCorrentlyIdeas()
    }
    
    /**Variável que filtra TODAS as tags para serem exibidas em suas ideias ao realizar uma pesquisa*/
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
    
    /**Variável que filtra TODAS as ideias com certas prioridades para serem exibidas ao realizar uma pesquisa na Home**/
    func filteringIdeas(newOrderArray: [any Idea] = [], useCurrentArray: Bool = false) -> [any Idea] {
        if searchText.isEmpty {
            return disposedData
        } else {
            if useCurrentArray {
                return LogicFilterBySearchComponent.filterBySearch(newOrderArray: newOrderArray, searchText: searchText)
            } else {
                return LogicFilterBySearchComponent.filterBySearch(newOrderArray: disposedData, searchText: searchText)
            }
            
        }
    }
    
    func resetDisposedData() {
        self.reloadLoadedData()
        self.filteredIdeas = self.loadedData
        self.orderBy(byCreation: self.isSortedByCreation, sortedByAscendent: self.isSortedByAscendent)
    }
    
    /**Função para formatar e devolver uma tag estruturada para adicionar no banco de dados**/
    func addTag(tagToAdd: Tag) -> Tag {
        var tagAdding = tagToAdd
        
        //pegando tamanho do texto
        let font = UIFont.systemFont(ofSize: 16)
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (tagAdding.name as NSString).size(withAttributes: attributes)
        
        tagAdding.size = size.width
        
        return tagAdding
    }
    
    /**Função que verifica se existem tags já usadas na ideia que está sendo visualizada, para exibi-las com borda pro usuário.**/
    func updateSelectedTags(allTags: [Tag], tagSelected: [Tag]) -> [Tag] {
        // Cria uma cópia do array allTags
        var updatedTags = allTags
        
        // Itera sobre as tags presentes em tagSelected
        for selectedTag in tagSelected {
            // Verifica se a tag selecionada está presente em allTags
            if let index = updatedTags.firstIndex(where: { $0.id == selectedTag.id }) {
                // Atualiza a propriedade isTagSelected para true
                updatedTags[index].isTagSelected = true
                
            }
        }
        return updatedTags
    }
    
    /**Função que verifica se a tag que esta sendo registrada ja existe**/
    func verifyExistTags(newTagName: String) -> Bool {
        for tag in self.tagsLoadedData {
            if tag.name == newTagName {
                return true
            } else {
                
            }
        }
        return false
    }
    
    /**Função que salva uma nova tag e recarrega a lista com as tags recentes**/
    func saveTagAndUpdateListView(tagToSave: Tag) {
        IdeaSaver.saveTag(tag: addTag(tagToAdd: tagToSave))
        tagsLoadedData = IdeaSaver.getAllSavedTags()
    }
    
    func fixingTagColor() {
        var newTags = IdeaSaver.getAllSavedTags()
        
        for i in 0..<newTags.count {
            if newTags[i].color == "fff" {
                newTags[i].color = ""
                IdeaSaver.changeOneTagValue(tag: newTags[i])
            }
        }
    }
}

