//
//  IdeaSaver.swift
//  MacroChallenge01_BigIdeas
//
//  Created by Henrique Assis on 29/05/23.
//

import Foundation

class IdeaSaver {
    private static let defaults = UserDefaults.standard
    
    private static let audioModelKey: String = "audioIdeas"
    private static let textModelKey: String = "textIdeas"
    private static let photoModelKey: String = "photoIdeas"
    
    //MARK: - Audio Saves
    /**Save an audio idea in UserDefaults that stores all AudioIdeas**/
    public static func saveAudioIdea(idea: AudioIdeia) {
        saveUniqueIdea(idea: idea, type: AudioIdeia.self, key: audioModelKey)
    }
    
    /**Save a collection of audio ideas in UserDefaults that stores all AudioIdeas**/
    public static func saveAudioIdeas(ideas: [AudioIdeia]) {
        saveMultipleIdeas(ideas: ideas, type: AudioIdeia.self, key: audioModelKey)
    }
    
    //MARK: Text Saves
    /**Save an text idea in UserDefaults that stores all TextIdeas**/
    public static func saveTextIdea(idea: ModelText) {
        saveUniqueIdea(idea: idea, type: ModelText.self, key: textModelKey)
    }
    
    /**Save a collection of text ideas in UserDefaults that stores all TextIdeas**/
    public static func saveTextIdeas(ideas: [ModelText]) {
        saveMultipleIdeas(ideas: ideas, type: ModelText.self, key: textModelKey)
    }
    
    //MARK: Photo Saves
    /**Save an photo idea in UserDefaults that stores all PhotoIdeas**/
    public static func savePhotoIdea(idea: PhotoModel) {
        saveUniqueIdea(idea: idea, type: PhotoModel.self, key: photoModelKey)
    }
    
    /**Save a collection of photo ideas in UserDefaults that stores all PhotoIdeas**/
    public static func savePhotoIdeas(ideas: [PhotoModel]) {
        saveMultipleIdeas(ideas: ideas, type: PhotoModel.self, key: photoModelKey)
    }
    
    //MARK: - LOADS
    /**Return  a list of all types of ideas saved in user default (text, audio and photo).*/
    public static func getAllSavedIdeas() -> [any Idea] {
        var ideas: [any Idea] = []
        
        // verify if have content for each model and append to the array
        if defaults.object(forKey: audioModelKey) != nil {
            ideas.append(contentsOf: getSavedUniqueIdeasType(type: AudioIdeia.self, key: audioModelKey))
        }
        
        if defaults.object(forKey: textModelKey) != nil {
            ideas.append(contentsOf: getSavedUniqueIdeasType(type: ModelText.self, key: textModelKey))
        }
        
        if defaults.object(forKey: photoModelKey) != nil {
            ideas.append(contentsOf: getSavedUniqueIdeasType(type: PhotoModel.self, key: photoModelKey))
        }
        
        return ideas
    }
    
    /**Returns all unique idea type saved in UserDefaults (audio, text or photo).**/
    public static func getSavedUniqueIdeasType<T: Idea>(type: T.Type, key: String) -> [T] {
        if let savedIdeas = defaults.object(forKey: key) as? Data {
            if let loadedIdeas = try? JSONDecoder().decode([T].self, from: savedIdeas) {
                return loadedIdeas
            }
        }
        
        print("error to GetSavedIdeas")
        return []
    }
    
    //MARK: - GETTERS
    /**Gets the key used for audio ideas saved in UserDefaults.**/
    public static func getAudioModelKey() -> String {
        return audioModelKey
    }
    
    /**Gets the key used for text ideas saved in UserDefaults.**/
    public static func getTextModelKey() -> String {
        return textModelKey
    }
    
    /**Gets the key used for photo ideas saved in UserDefaults.**/
    public static func getPhotoModelKey() -> String {
        return photoModelKey
    }
    
    // MARK: - PRIVATE STATICS
    /**Save an idea of an unique idea type in UserDefaults.**/
    private static func saveUniqueIdea<T: Idea>(idea: T, type: T.Type, key: String){
        let encoder = JSONEncoder()
        var savedIdeas: [T] = []
        
        // creating the user defaults if the user never saved an idea before
        if defaults.object(forKey: key) == nil {
            defaults.set(savedIdeas, forKey: key)
        }
        
        // getting the array before encoding
        else {
            savedIdeas = getSavedUniqueIdeasType(type: T.self, key: key)
        }
        
        // append the idea in the array
        savedIdeas.append(idea)
        
        // encoding and saving the idea array
        if let encoded = try? encoder.encode(savedIdeas) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    /**Save multiple ideas of an unique idea type in UserDefaults.**/
    private static func saveMultipleIdeas<T: Idea>(ideas: [T], type: T.Type, key: String){
        let encoder = JSONEncoder()
        var savedIdeas: [T] = []
        
        // creating the user defaults if the user never saved an idea before
        if defaults.object(forKey: key) == nil {
            defaults.set(savedIdeas, forKey: key)
        }
        
        // getting the array before encoding
        else {
            savedIdeas = getSavedUniqueIdeasType(type: T.self, key: key)
        }
        
        // append the ideas in the array
        savedIdeas.append(contentsOf: ideas)
        
        // encoding and saving the idea array
        if let encoded = try? encoder.encode(savedIdeas) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    //MARK: - TESTS
    /**TEST POURPOSES. Receive an audio idea and get its value saved in user default.*/
    public static func getSavedAudio(audio: AudioIdeia) -> AudioIdeia {
        let audio: [AudioIdeia] = getSavedUniqueIdeasType(type: AudioIdeia.self, key: audioModelKey)
        return audio.last! as AudioIdeia
    }
    
    /**TEST POURPOSES. Receive a photo idea and get its value saved in user default.*/
    public static func getSavedPhoto(photo: PhotoModel) -> PhotoModel {
        let photo: [PhotoModel] = getSavedUniqueIdeasType(type: PhotoModel.self, key: photoModelKey)
        return photo.last! as PhotoModel
    }
    
    /**TEST POURPOSES. Receive a text idea and get its value saved in user default.*/
    public static func getSavedText(text: ModelText) -> ModelText {
        let text: [ModelText] = getSavedUniqueIdeasType(type: ModelText.self, key: textModelKey)
        return text.last! as ModelText
    }
    
}
