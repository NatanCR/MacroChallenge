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
        let audioIdea = AudioIdeia(title: "testT", description: "testD", textComplete: "testC", creationDate: Date(), modifiedDate: Date(), audioPath: "testP")
        
        IdeaSaver.saveAudioIdea(idea: audioIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedAudio(audio: audioIdea), audioIdea)
    }

    func testPhotoIdeaSavingInUserDeafults() {
      let photoIdea = PhotoModel(title: "testT", description: "testD", textComplete: "testC", creationDate: Date(), modifiedDate: Date(), capturedImages: [])
        
        IdeaSaver.savePhotoIdea(idea: photoIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedPhoto(photo: photoIdea), photoIdea)
    }
    
    func testTextIdeaSavingInUserDeafults() {
        let textIdea = ModelText(title: "testT", creationDate: Date(), modifiedDate: Date(), description: "testD", textComplete: "testC")
        
        IdeaSaver.saveTextIdea(idea: textIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedText(text: textIdea), textIdea)
    }
    
    func testIdeaChangeInUserDeafults() {
        let testId = UUID()
        
        IdeaSaver.clearUniqueTypeIdea(type: .audio)
        
        var array = [
            AudioIdeia(title: "testT", description: "testD", textComplete: "testC", creationDate: Date(), modifiedDate: Date(), audioPath: "testP"),
            AudioIdeia(id: testId, title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), audioPath: ""),
            AudioIdeia(title: "testT", description: "testD", textComplete: "testC", creationDate: Date(), modifiedDate: Date(), audioPath: "testP")
        ]
        
        let audioFinder = AudioIdeia(id: testId, title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), audioPath: "")
        
        IdeaSaver.saveAudioIdeas(ideas: array)
        IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: audioFinder)
        
        array = IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey())
        
        XCTAssertEqual(audioFinder.title, array[1].title)
    }
}
