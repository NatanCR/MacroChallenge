//
//  IdeaSaverTests.swift
//  MacroChallengeTests
//
//  Created by Henrique Assis on 30/05/23.
//

import XCTest
@testable import MacroChallenge

final class IdeaSaverTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAudioIdeaSavingInUserDeafults() {
        let audioIdea = AudioIdeia(id: UUID(), name: "test", ideiaType: .audio, creationDate: Date(), modifiedDate: Date(), audioPath: URL(filePath: "testPath"))
        
        IdeaSaver.saveAudioIdea(idea: audioIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedAudio(audio: audioIdea), audioIdea)
    }

}
