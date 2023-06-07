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

}
