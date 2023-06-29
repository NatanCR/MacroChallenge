//
//  TextViewModel.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 31/05/23.
//

import Foundation

class TextViewModel {
    /**Função para separar o titulo do resto do texto vindo de um text Editor**/
    public static func separateTitleFromText(textComplete: String, title: String) -> String {
        // pega o texto completo sem quebras de linha e pega o intervalo da primeira linha como titulo
        let textWithoutBreakLines = textComplete.trimmingCharacters(in: .whitespacesAndNewlines)
        let titleRange = textWithoutBreakLines.rangeOfCharacter(from: .newlines)
        
        if let range = titleRange {
            // pega a distancia do texto de titulo, partindo do texto completo sem quebras de linha até o range do titulo
            let completeTitleDistance = textWithoutBreakLines.distance(from: textWithoutBreakLines.startIndex, to: range.lowerBound)
            
            // pega o index representando a distancia total entre o primeiro caracter do texto ate a distancia total do titulo
            let titleIndex = textWithoutBreakLines.index(textWithoutBreakLines.startIndex, offsetBy: completeTitleDistance)
            
            // pega o texto do titulo, retornando o texto total do inicio até o indice de termino do titulo
            let titleAux = String(textWithoutBreakLines[..<titleIndex])
            
            return titleAux
        } else {
            return textWithoutBreakLines
        }
    }
    
    /**Sets and convert the title, description and complete text of an idea, passing each individual text as reference.**/
    public static func setTitleDescriptionAndCompleteText(title: inout String, description: inout String, complete: inout String) {
        title = separateTitleFromText(textComplete: complete, title: title)
        let titleRange = complete.range(of: title)
        
        // description parte do index final do titulo
        let descriptionStartIndex = titleRange?.upperBound ?? complete.startIndex
        description = String(complete[descriptionStartIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
        
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        complete = complete.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /**Sets and convert the title, description and complete text of an idea, passing an entire idea as reference.**/
    public static func setTextsFromIdea<T: Idea>(idea: inout T) {
        var title = idea.title
        var description = idea.description
        var complete = idea.textComplete
        
        setTitleDescriptionAndCompleteText(title: &title, description: &description, complete: &complete)
        
        idea.title = title
        idea.description = description
        idea.textComplete = complete
    }
    
}

extension String {
    func removeEmptyLines() -> String {
        let lines = self.components(separatedBy: CharacterSet.newlines)
        let nonEmptyLines = lines.filter { !$0.isEmpty }
        return nonEmptyLines.joined(separator: "\n")
    }
}
