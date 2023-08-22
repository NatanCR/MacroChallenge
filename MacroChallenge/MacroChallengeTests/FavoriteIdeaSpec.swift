//
//  FavoriteIdeaSpec.swift
//  MacroChallengeTests
//
//  Created by Natan de Camargo Rodrigues on 07/06/23.
//

import XCTest
@testable import MacroChallenge

final class FavoriteIdeaSpec: XCTestCase {
    

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        IdeaSaver.clearAll()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testIsFavoriteIdea() {
        var idea: [any Idea] = []
        let textModel = ModelText(title: "Title test", creationDate: Date(), modifiedDate: Date(), description: "Description test", textComplete: "Title test\nDescription test", tag: [])
        
        IdeaSaver.saveTextIdea(idea: textModel)
        idea = IdeaSaver.getAllSavedIdeas()
        
        XCTAssertNotNil(idea)
        XCTAssertFalse(idea[0].isFavorite)
        
        if var modelText = idea[0] as? ModelText {
            modelText.isFavorite = true
            IdeaSaver.changeSavedValue(type: ModelText.self, idea: modelText)
            XCTAssertTrue(modelText.isFavorite)
        }
        
        XCTAssertFalse(idea[0].isFavorite)
    }

}
