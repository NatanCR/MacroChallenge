//
//  TextViewModel.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 31/05/23.
//

import Foundation

class TextViewModel {
    /**Função para separar o titulo do resto do texto vindo de um text Editor**/
    static func separateTitleFromText(textComplete: String, title: String) -> String? {
        var titleAux = title
        //encontrar a primeira ocorrência de um caractere de nova linha no texto
        if let range = textComplete.rangeOfCharacter(from: .newlines) {
            //obtem a posição desse caractere
            let index = textComplete.distance(from: textComplete.startIndex, to: range.lowerBound)
            //para obter o String.Index correto correspondente à posição de onde o título termina.
            let titleIndex = textComplete.index(textComplete.startIndex, offsetBy: index)
            //para extrair a parte do texto anterior
            titleAux = String(textComplete[..<titleIndex])
            return titleAux
        } else {
            titleAux = textComplete
            return nil
        }
    }
    
    public static func setTitleDescriptionAndCompleteText(title: inout String, description: inout String, complete: inout String) {
        title = separateTitleFromText(textComplete: complete, title: title) ?? String()
        
        description = complete.replacingOccurrences(of: title, with: String()).trimmingCharacters(in: .whitespacesAndNewlines)
        
        description = description.removeEmptyLines()
        title = title.removeEmptyLines()
        complete = complete.removeEmptyLines()
    }
    
    /**Formata a data em string com o horario local do device**/
    static func formatarData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.locale = Locale.current
        return formatter.string(from: data)
    }
}

extension String {
    func removeEmptyLines() -> String {
        let lines = self.components(separatedBy: CharacterSet.newlines)
        let nonEmptyLines = lines.filter { !$0.isEmpty }
        return nonEmptyLines.joined(separator: "\n")
    }
}
