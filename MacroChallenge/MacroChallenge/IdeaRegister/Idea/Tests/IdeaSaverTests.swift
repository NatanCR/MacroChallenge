////
////  IdeaSaverTests.swift
////  MacroChallengeTests
////
////  Created by Henrique Assis on 30/05/23.
////

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
        let audioIdea = AudioIdea(id: UUID(), title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: [])
        
        IdeaSaver.saveAudioIdea(idea: audioIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedAudio(audio: audioIdea), audioIdea)
    }

    func testPhotoIdeaSavingInUserDeafults() {
        let photoIdea = PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: "testPath", tag: [])
        
        IdeaSaver.savePhotoIdea(idea: photoIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedPhoto(photo: photoIdea), photoIdea)
    }
    
    func testTextIdeaSavingInUserDeafults() {
        let textIdea = ModelText(title: "", creationDate: Date(), modifiedDate: Date(), description: "", textComplete: "", tag: [])
        
        IdeaSaver.saveTextIdea(idea: textIdea)
        
        XCTAssertEqual(IdeaSaver.getSavedText(text: textIdea), textIdea)
    }
    
    func testIdeaChangeInUserDeafults() {
        let testId = UUID()
        
        IdeaSaver.clearUniqueTypeIdea(type: .audio)
        
        var array = [
            AudioIdea(id: UUID(), title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: []),
            AudioIdea(id: testId, title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: []),
            AudioIdea(id: UUID(), title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: [])
        ]
        
        let audioFinder = AudioIdea(id: testId, title: "TESTE", description: "TESTE", textComplete: "TESTE", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: [])
        
        IdeaSaver.saveAudioIdeas(ideas: array)
        IdeaSaver.changeSavedValue(type: AudioIdea.self, idea: audioFinder)
        
        array = IdeaSaver.getSavedUniqueIdeasType(type: AudioIdea.self, key: IdeaSaver.getAudioModelKey())
        
        XCTAssertEqual(audioFinder.title, array[1].title)
    }
    
    func testIdeaDeleteInUserDefaults() {
        IdeaSaver.clearAll()
        
        var audioArray = [
            AudioIdea(id: UUID(), title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: []),
            AudioIdea(id: UUID(), title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: []),
            AudioIdea(id: UUID(), title: "test", description: "", textComplete: "test", creationDate: Date(), modifiedDate: Date(), audioPath: "testPath", tag: [])
        ]
        
        var textArray = [
            ModelText(title: "", creationDate: Date(), modifiedDate: Date(), description: "", textComplete: "", tag: []),
            ModelText(title: "", creationDate: Date(), modifiedDate: Date(), description: "", textComplete: "", tag: []),
            ModelText(title: "", creationDate: Date(), modifiedDate: Date(), description: "", textComplete: "", tag: [])
        ]
        
        var photoArray = [
            PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: "", tag: []),
            PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: "", tag: []),
            PhotoModel(title: "", description: "", textComplete: "", creationDate: Date(), modifiedDate: Date(), capturedImage: "", tag: [])
        ]
        
        IdeaSaver.saveAudioIdeas(ideas: audioArray)
        IdeaSaver.saveTextIdeas(ideas: textArray)
        IdeaSaver.savePhotoIdeas(ideas: photoArray)
        
        let audioDelete = audioArray[1]
        let textDelete  =  textArray[1]
        let photoDelete = photoArray[1]
        
        IdeaSaver.clearOneIdea(type: AudioIdea.self, idea: audioDelete)
        IdeaSaver.clearOneIdea(type: ModelText.self, idea: textDelete)
        IdeaSaver.clearOneIdea(type: PhotoModel.self, idea: photoDelete)
        
        audioArray.remove(at: 1)
        textArray.remove(at: 1)
        photoArray.remove(at: 1)
        
        let savedAudioArray = IdeaSaver.getSavedUniqueIdeasType(type: AudioIdea.self, key: IdeaSaver.getAudioModelKey())
        let savedTextArray = IdeaSaver.getSavedUniqueIdeasType(type: ModelText.self, key: IdeaSaver.getTextModelKey())
        let savedPhotoArray = IdeaSaver.getSavedUniqueIdeasType(type: PhotoModel.self, key: IdeaSaver.getPhotoModelKey())
        
        XCTAssertEqual(savedAudioArray, audioArray)
        XCTAssertEqual(savedTextArray, textArray)
        XCTAssertEqual(savedPhotoArray, photoArray)
    }
}
