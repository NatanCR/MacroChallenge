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
        let audioIdea = AudioIdeia(id: UUID(), title: "test", creationDate: Date(), modifiedDate: Date(), audioPath: URL(string: "testPath")!)
        
        IdeaSaver.saveAudioIdea(idea: audioIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedAudio(audio: audioIdea), audioIdea)
    }

    func testPhotoIdeaSavingInUserDeafults() {
        let photoIdea = PhotoModel(title: "", creationDate: Date(), modifiedDate: Date(), capturedImages: [])
        
        IdeaSaver.savePhotoIdea(idea: photoIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedPhoto(photo: photoIdea), photoIdea)
    }
    
    func testTextIdeaSavingInUserDeafults() {
        let textIdea = ModelText(title: "", creationDate: Date(), modifiedDate: Date(), text: "")
        
        IdeaSaver.saveTextIdea(idea: textIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedText(text: textIdea), textIdea)
    }
    
    func testIdeaChangeInUserDeafults() {
        let testId = UUID()
        
        IdeaSaver.clearUniqueTypeIdea(type: .audio)
        
        var array = [
            AudioIdeia(title: "", creationDate: Date(), modifiedDate: Date(), audioPath: URL(string: "testPath")!),
            AudioIdeia(id: testId, title: "", creationDate: Date(), modifiedDate: Date(), audioPath: URL(string: "testPath")!),
            AudioIdeia(title: "", creationDate: Date(), modifiedDate: Date(), audioPath: URL(string: "testPath")!)
        ]
        
        let audioFinder = AudioIdeia(id: testId, title: "TESTE", creationDate: Date(), modifiedDate: Date(), audioPath: URL(string: "testPath")!)
        
        IdeaSaver.saveAudioIdeas(ideas: array)
        IdeaSaver.changeSavedValue(type: AudioIdeia.self, idea: audioFinder)
        
        array = IdeaSaver.getSavedUniqueIdeasType(type: AudioIdeia.self, key: IdeaSaver.getAudioModelKey())
        
        XCTAssertEqual(audioFinder.title, array[1].title)
    }
}
