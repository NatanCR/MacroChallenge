//
//  ChangeTagValueSpec.swift
//  MacroChallengeTests
//
//  Created by Natan de Camargo Rodrigues on 11/09/23.
//

import XCTest
import SwiftUI
@testable import MacroChallenge

final class ChangeTagValueSpec: XCTestCase {
    @ObservedObject var viewModel = IdeasViewModel()

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        IdeaSaver.clearAllTags()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testChangingTagValue() {
        //cria tags que serão testadas
        var tags: [Tag] = [
            Tag(name: "Tag 1 de teste fff", color: "fff"),
            Tag(name: "Tag 2 de teste fff", color: "fff"),
            Tag(name: "Tag 3 de teste vazio", color: ""),
            Tag(name: "Tag 4 de teste labelColor", color: "labelColor"),
            Tag(name: "Tag 5 de teste aleatorio", color: "sjbhdhjs")]
        
        //salva as tags no banco
        IdeaSaver.saveTags(tags: tags)
        
        //pega as tags salvas no banco para uma nova variavel
        var savedTags = IdeaSaver.getAllSavedTags()
        //teste se p array nao esta vazio
        XCTAssertNotNil(savedTags, "Esse array de tags nao deve ser vazio")
        
        print("antes de alterar")
        dump(savedTags)
        
        //chama a função que vai alterar o valor colorName das tags para o correto
        viewModel.fixingTagColor()
        
        //pega novamente as ideias do banco
        var newSavedTags = IdeaSaver.getAllSavedTags()
        
        //teste se os arrays tem elementos com valores diferentes
        XCTAssertFalse(savedTags.allSatisfy({ newSavedTags.contains($0)}))
        XCTAssertNotEqual(savedTags, newSavedTags, "Os arrays devem ter valores diferentes")
        
        print("depois de alterar")
        dump(newSavedTags)
    }
}
