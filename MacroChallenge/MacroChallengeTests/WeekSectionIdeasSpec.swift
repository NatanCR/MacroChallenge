//
//  WeekSectionIdeasSpec.swift
//  MacroChallengeTests
//
//  Created by Natan de Camargo Rodrigues on 29/08/23.
//

import XCTest
import SwiftUI
@testable import MacroChallenge

final class WeekSectionIdeasSpec: XCTestCase {
    @ObservedObject var viewModel = IdeasViewModel()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        IdeaSaver.clearAll()
    }

    func testExample() throws {
       
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testIfWeekIdeasSectionWorks() {
        var ideas: [any Idea] = []
        
        let mostRecentTitle = "Ideia de hoje"
        let thisWeekTitle = "Ideia dessa semana"
        let lastMonthTitle = "Ideia do mês passado"
        
        //cria a ideia de hoje
        let mostRecentIdea = ModelText(title: mostRecentTitle, creationDate: Date(), modifiedDate: Date(), description: "nada demais", textComplete: "Ideia de hoje\nnada demais", tag: nil)
        IdeaSaver.saveTextIdea(idea: mostRecentIdea)
        
        //cria a ideia desse semana
        let thisWeekIdea = ModelText(title: thisWeekTitle, creationDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), modifiedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), description: "", textComplete: "Ideia dessa semana", tag: [])
        IdeaSaver.saveTextIdea(idea: thisWeekIdea)
        
        //cria a ideia do mes passado
        let lastMonthIdea = ModelText(title: lastMonthTitle, creationDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(), modifiedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(), description: "nada", textComplete: "Ideia do mês passado\nnada", tag: [])
        IdeaSaver.saveTextIdea(idea: lastMonthIdea)
        
        //pega todas as ideias para o array
        ideas = IdeaSaver.getAllSavedIdeas()
        //carrega os arrays separados por favoritos, dessa semana e demais ideias
        viewModel.updateFavoriteSectionIdeas()
        
        //verifica se as ideias conseguiram ser salvas e atribuidas ao array
        XCTAssertNotNil(ideas)
        
        //verfica se a primeira ideia do array ideias da semana tem o mesmo titulo da primeira ideia que foi criada com a data de hoje
        if let recentIdea = viewModel.weekIdeas.first {
            XCTAssertEqual(mostRecentTitle, recentIdea.title)
        }
        
        //verifica se a segunda ideia do array ideias da semana tem o mesmo titulo que a segunda ideia que foi adicionada com a data de 2 dias atras
        XCTAssertEqual(thisWeekTitle, viewModel.weekIdeas[1].title)
        
        //verificxa se a primeira ideia do array geral tem o mesmo titulo que a terceira ideia que foi adicionada com a data de 30 dias atras
        XCTAssertEqual(lastMonthTitle, viewModel.filteredIdeas[0].title)
    }
}
