//
//  TextViewModelTests.swift
//  MacroChallengeTests
//
//  Created by Henrique Assis on 07/06/23.
//

import XCTest
@testable import MacroChallenge

final class TextViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTextTitleAndDescriptionSeparator() {
        var title = ""
        var description = ""
        
        var complete = """
                        Titulo
                        Descricao
                        """
        
        let completeComparison = complete
        
        TextViewModel.setTitleDescriptionAndCompleteText(title: &title, description: &description, complete: &complete)
        
        XCTAssertEqual(title, "Titulo")
        XCTAssertEqual(description, "Descricao")
        XCTAssertEqual(complete, completeComparison)
    }

    func testSetTextsFromIdea() {
        var complete = """
                        Titulo
                        Descricao
                        """
        
        var audioIdea = AudioIdea(title: "", description: "", textComplete: complete, creationDate: Date(), modifiedDate: Date(), audioPath: "")
        var textIdea = ModelText(title: "", creationDate: Date(), modifiedDate: Date(), description: "", textComplete: complete)
        var photoIdea = PhotoModel(title: "", description: "", textComplete: complete, creationDate: Date(), modifiedDate: Date(), capturedImages: [])
        
        TextViewModel.setTextsFromIdea(idea: &audioIdea)
        TextViewModel.setTextsFromIdea(idea: &textIdea)
        TextViewModel.setTextsFromIdea(idea: &photoIdea)
        
        // audio
        XCTAssertEqual(audioIdea.title, "Titulo")
        XCTAssertEqual(audioIdea.description, "Descricao")
        XCTAssertEqual(audioIdea.textComplete, complete)
        
        // text
        XCTAssertEqual(textIdea.title, "Titulo")
        XCTAssertEqual(textIdea.description, "Descricao")
        XCTAssertEqual(textIdea.textComplete, complete)
        
        // photo
        XCTAssertEqual(photoIdea.title, "Titulo")
        XCTAssertEqual(photoIdea.description, "Descricao")
        XCTAssertEqual(photoIdea.textComplete, complete)
    }
}
