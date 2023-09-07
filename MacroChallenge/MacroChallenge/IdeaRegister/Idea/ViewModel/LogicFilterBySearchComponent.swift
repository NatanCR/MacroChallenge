//
//  LogicFilterBySearchComponent.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 07/09/23.
//

import Foundation

class LogicFilterBySearchComponent {
    static func filterBySearch(newOrderArray: [any Idea], searchText: String) -> [any Idea] {
        return newOrderArray.filter { idea in
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
