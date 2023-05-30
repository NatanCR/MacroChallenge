//
//  UserDefaultsSpec.swift
//  MacroChallenge01_BigIdeasTests
//
//  Created by Natan de Camargo Rodrigues on 25/05/23.
//

import XCTest
@testable import MacroChallenge

final class UserDefaultsSpec: XCTestCase {
    var userDefaultsManager: UserDefaultsManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userDefaultsManager = UserDefaultsManager()
    }

    override func tearDownWithError() throws {
        userDefaultsManager = nil
        try super.tearDownWithError()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEncoderModel() {
        let modelTest = ModelText(name: "Title test", text: "Idea test", creationDate: Date(), modifiedDate: Date())
        //executa o método de codificação
        userDefaultsManager.encoderModel(model: [modelTest])
        
        //verifica se os dados foram salvos corretamente
        let savedData = UserDefaults.standard.data(forKey: "SavedModel")
        XCTAssertNotNil(savedData, "Os dados salvos não devem ser nulos")
        
        //fazer a decodificação para saber se os dados foram salvos corretamente
        let decoder = JSONDecoder()
        if let decodedModel = try? decoder.decode([ModelText].self, from: savedData!) {
            XCTAssertEqual(decodedModel.count, 1, "Deve haver um único elemento decodificado!")
            XCTAssertEqual(decodedModel[0].name,"Title test", "O título decodificado deve ser igual ao original." )
            XCTAssertEqual(decodedModel[0].text, "Idea test", "O texto decodificado deve ser igual ao original.")
        } else {
            XCTFail("Falha na decodificação dos dados salvos.")
        }
    }

    
    func testDecoderModel() {
        let modelTest = ModelText(name: "Title test", text: "Idea test", creationDate: Date(), modifiedDate: Date())
        let enconder = JSONEncoder()
        let encondedData = try? enconder.encode([modelTest])
        UserDefaults.standard.set(encondedData, forKey: "SavedModel")
        
        //executa o método de decodificação
        let decodedModel = userDefaultsManager.decoderModel()
        XCTAssertNotNil(decodedModel, "Os dados salvos não devem ser nulos")
        XCTAssertEqual(decodedModel?.count, 1, "Deve haver um único elemento decodificado!")
        XCTAssertEqual(decodedModel?[0].name,"Title test", "O título decodificado deve ser igual ao original." )
        XCTAssertEqual(decodedModel?[0].text, "Idea test", "O texto decodificado deve ser igual ao original.")
    }
}
