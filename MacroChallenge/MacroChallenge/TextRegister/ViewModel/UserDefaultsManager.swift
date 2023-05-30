//
//  UserDefaults.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Natan de Camargo Rodrigues on 24/05/23.
//

import Foundation

class UserDefaultsManager {
    let defaults = Foundation.UserDefaults.standard
    
    /**Função para transformar a struct recebida em JSON para salvar no User Defaults**/
    func encoderModel(model: [ModelText]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            defaults.set(encoded, forKey: "SavedModel")
        }
    }
    
    /**Função para decodificar o JSON salvo e retornar em formato de array e conseguir ler em outra tela**/
    func decoderModel() -> [ModelText]? {
        if let savedModel = defaults.object(forKey: "SavedModel") as? Data {
            let decoder = JSONDecoder()
            if let loadedModel = try? decoder.decode([ModelText].self, from: savedModel) {
                return loadedModel
            }
        }
        return nil
    }
    
    /**Função responsável por excluir um elemento específico com base no seu ID do UserDefaults**/
    func deleteModel(withID id: UUID) {
        //para obter todos os modelos salvos no UserDefaults.
        if var savedModels = decoderModel() {
            //se o array savedModels não for nulo, usa o método removeAll(where:) para remover todos os elementos que correspondem ao ID do modelo original igual ao fornecido
            savedModels.removeAll(where: { $0.id == id })
            //salvar novamente o array atualizado no UserDefaults.
            encoderModel(model: savedModels)
        }
    }
}
