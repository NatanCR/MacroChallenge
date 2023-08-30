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
    private static let tagModelKey: String = "tags"
    private static let groupModelKey: String = "groups"
    
    //MARK: - Groups saves
    public static func saveGroup(group: GroupModel) {
        saveUniqueGroup(group: group, key: groupModelKey)
    }
    
    public static func saveGroups(groups: [GroupModel]) {
        if groups.isEmpty { print("Groups to save is empty."); return }
        
        saveMultiplesGroups(groups: groups, key: groupModelKey)
    }
    
    //MARK: - Tag's Saves
    public static func saveTag(tag: Tag) {
        saveUniqueTag(tag: tag, key: tagModelKey)
    }
    
    public static func saveTags(tags: [Tag]) {
        if tags.isEmpty { print("Tags to save is empty."); return }
        
        saveMultiplesTags(tags: tags, key: tagModelKey)
    }
    
    //MARK: - Audio Saves
    /**Save an audio idea in UserDefaults that stores all AudioIdeas**/
    public static func saveAudioIdea(idea: AudioIdea) {
        saveUniqueIdea(idea: idea, type: AudioIdea.self, key: audioModelKey)
    }
    
    /**Save a collection of audio ideas in UserDefaults that stores all AudioIdeas**/
    public static func saveAudioIdeas(ideas: [AudioIdea]) {
        saveMultipleIdeas(ideas: ideas, type: AudioIdea.self, key: audioModelKey)
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
    
    //MARK: - CHANGERS
    /**Função para alterar o valores de uma tag**/
    public static func changeOneTagValue(tag: Tag) {
        if defaults.object(forKey: tagModelKey) == nil { print("No saved Tags"); return }
        
        var currentTags: [Tag] = getAllSavedTags()
        
        let tagIndex: Int = currentTags.firstIndex(where: { $0.id == tag.id }) ?? -1
        if tagIndex == -1 {print("Tag not found"); return}
        
        currentTags[tagIndex] = tag
        
        clearOneTag(tag: tag, willSaveTag: false)
        saveTags(tags: currentTags)
    }
    
    
    /**Changes an already saved idea in user default to a new idea value.**/
    public static func changeSavedValue<T: Idea>(type: T.Type, idea: T) {
        var key = ""
        let ideaType: IdeaType
        
        if type == AudioIdea.self { key = audioModelKey; ideaType = .audio }
        else if type == ModelText.self { key = textModelKey; ideaType = .text }
        else { key = photoModelKey; ideaType = .photo }
        
        if defaults.object(forKey: key) == nil {print("No saved Ideas"); return}
        
        var ideas: [T] = getSavedUniqueIdeasType(type: type, key: key)
        
        let ideaIndex: Int = ideas.firstIndex(where: { $0.id == idea.id }) ?? -1
        if ideaIndex == -1 { print("Idea not found"); return }
        
        ideas[ideaIndex] = idea
        
        switch ideaType {
        case .audio: clearUniqueTypeIdea(type: .audio); saveAudioIdeas(ideas: (ideas as? [AudioIdea] ?? []))
        case .text: clearUniqueTypeIdea(type: .text); saveTextIdeas(ideas: ideas as? [ModelText] ?? [])
        case .photo: clearUniqueTypeIdea(type: .photo); savePhotoIdeas(ideas: ideas as? [PhotoModel] ?? [])
        }
    }
    
    public static func changeSavedGroup (newGroup: GroupModel) {
        var groups = getAllSavedGroups()
        
        for i in 0..<groups.count {
            if groups[i].id == newGroup.id {
                groups[i] = newGroup
            }
        }
        
        clearGroups()
        saveGroups(groups: groups)
    }
    
    //MARK: - LOADS
    /**Return  a list of all types of ideas saved in user default (text, audio and photo).*/
    public static func getAllSavedIdeas() -> [any Idea] {
        var ideas: [any Idea] = []
        
        // verify if have content for each model and append to the array
        if defaults.object(forKey: audioModelKey) != nil {
            ideas.append(contentsOf: getSavedUniqueIdeasType(type: AudioIdea.self, key: audioModelKey))
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
        
        print("error to GetSavedIdeas, or no saved ideas of specified type exists in UserDefault - \(type)")
        return []
    }
    
    /**Returns all tags saved in UserDefaults**/
    public static func getAllSavedTags() -> [Tag] {
        if let savedTags = defaults.object(forKey: tagModelKey) as? Data {
            if let loadedTags = try? JSONDecoder().decode([Tag].self, from: savedTags) {
                return loadedTags
            }
        }
        print("error to GetSavedTags, or no saved tags of specified type exists in UserDefault")
        return []
    }
    
    public static func getAllSavedGroups() -> [GroupModel] {
        if let savedGroups = defaults.object(forKey: groupModelKey) as? Data {
            if let loadedGroups = try? JSONDecoder().decode([GroupModel].self, from: savedGroups) {
                return loadedGroups
            }
        }
        print("error to GetSavedGroups, or no saved groups of specified type exists in UserDefault")
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
    
    //MARK: - CLEARS
    /**Função para limpar todas as tags do user defaults*/
    public static func clearAllTags() {
        let emptyTags: [Tag] = []
        
        if defaults.object(forKey: tagModelKey) != nil {
            defaults.set(emptyTags, forKey: tagModelKey)
        }
    }
    
    /**Clears all user defaults ideas.*/
    public static func clearAll() {
        let emptyIdea: [any Idea] = []
        
        if defaults.object(forKey: audioModelKey) != nil {
            defaults.set(emptyIdea, forKey: audioModelKey)
        }
        
        if defaults.object(forKey: textModelKey) != nil {
            defaults.set(emptyIdea, forKey: textModelKey)
        }
        
        if defaults.object(forKey: photoModelKey) != nil {
            defaults.set(emptyIdea, forKey: photoModelKey)
        }
    }
    
    /**Clears all user defaults ideas of an unique type.*/
    public static func clearUniqueTypeIdea(type: IdeaType) {
        let emptyIdea: [any Idea] = []
        
        switch type {
        case .audio: if defaults.object(forKey: audioModelKey) != nil { defaults.set(emptyIdea, forKey: audioModelKey) }; break
        case .text:  if defaults.object(forKey: textModelKey)  != nil { defaults.set(emptyIdea, forKey: textModelKey)  }; break
        case .photo: if defaults.object(forKey: photoModelKey) != nil { defaults.set(emptyIdea, forKey: photoModelKey) }; break
        }
    }
    
    /**Clears one saved idea.*/
    public static func clearOneIdea<T: Idea>(type: T.Type, idea: T) {
        var key = ""
        let ideaType: IdeaType
        
        if type == AudioIdea.self { key = audioModelKey; ideaType = .audio }
        else if type == ModelText.self { key = textModelKey; ideaType = .text }
        else { key = photoModelKey; ideaType = .photo }
        
        if defaults.object(forKey: key) == nil {print("No saved Ideas"); return}
        
        var ideas: [T] = getSavedUniqueIdeasType(type: type, key: key)
        
        let ideaIndex: Int = ideas.firstIndex(where: { $0.id == idea.id }) ?? -1
        
        if ideaIndex == -1 { print("Idea not found"); return }
        
        ideas.remove(at: ideaIndex)
        
        switch ideaType {
        case .audio: clearUniqueTypeIdea(type: .audio); saveAudioIdeas(ideas: (ideas as? [AudioIdea] ?? []))
        case .text: clearUniqueTypeIdea(type: .text); saveTextIdeas(ideas: ideas as? [ModelText] ?? [])
        case .photo: clearUniqueTypeIdea(type: .photo); savePhotoIdeas(ideas: ideas as? [PhotoModel] ?? [])
        }
    }
    
    /**Função para remover das ideias as tags que foram apagadas da lista de tags**/
    public static func removeTagFromIdeas(tagToRemove: Tag) {
        var ideas: [any Idea] = getAllSavedIdeas()
        
        for i in 0..<ideas.count {
            if let tags = ideas[i].tag {
                if let tagIndex = tags.firstIndex(where: { $0.id == tagToRemove.id }) {
                    ideas[i].tag?.remove(at: tagIndex)
                    
                    if let idea = ideas[i] as? ModelText {
                        changeSavedValue(type: ModelText.self, idea: idea)
                    } else if let idea = ideas[i] as? AudioIdea {
                        changeSavedValue(type: AudioIdea.self, idea: idea)
                    } else if let idea = ideas[i] as? PhotoModel {
                        changeSavedValue(type: PhotoModel.self, idea: idea)
                    }
                } else {
                    print("Tag id not found")
                }
            } else {
                print("Tags not recorded")
            }
        }
    }
    
    public static func clearUniqueTag() {
        let emptyTag: [Tag] = []
        
        if defaults.object(forKey: tagModelKey) != nil { defaults.set(emptyTag, forKey: tagModelKey)};
    }
    
    public static func clearOneTag(tag: Tag, willSaveTag: Bool = true) {
        
        if defaults.object(forKey: tagModelKey) == nil { print("No saved Tag"); return }
        
        var tags: [Tag] = getAllSavedTags()
        
        let tagIndex: Int = tags.firstIndex(where: { $0.id == tag.id }) ?? -1
        
        if tagIndex == -1 { print("Tag not found"); return }
        
        tags.remove(at: tagIndex)
        
        clearUniqueTag()
        if willSaveTag {
            saveTags(tags: tags)
        }
    }
    
    public static func clearGroups() {
        let emptyGroup: [GroupModel] = []
        
        if defaults.object(forKey: groupModelKey) != nil { defaults.set(emptyGroup, forKey: groupModelKey)};
    }
    
    public static func clearOneGroup(group: GroupModel) {
        
        if defaults.object(forKey: groupModelKey) == nil { print("No saved Group"); return }
        
        var groups: [GroupModel] = getAllSavedGroups()
        
        let groupIndex: Int = groups.firstIndex(where: { $0.id == group.id }) ?? -1
        
        if groupIndex == -1 { print("Group not found"); return }
        
        groups.remove(at: groupIndex)
        
        clearIdeasInGroup(group: group)
        clearGroups()
        saveGroups(groups: groups)
    }
    
    public static func clearIdeasInGroup(group: GroupModel) {
        let ideas = getAllSavedIdeas()
        
        for ideaId in group.ideasIds {
            for idea in ideas {
                if ideaId == idea.id {
                    switch idea {
                    case is ModelText:
                        clearOneIdea(type: ModelText.self, idea: idea as! ModelText)
                    case is AudioIdea:
                        clearOneIdea(type: AudioIdea.self, idea: idea as! AudioIdea)
                    case is PhotoModel:
                        clearOneIdea(type: PhotoModel.self, idea: idea as! PhotoModel)
                    default:
                        break
                    }
                    
                    if let audioIdea = idea as? AudioIdea {
                        ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: audioIdea.audioPath)
                    }
                    else if let photoIdea = idea as? PhotoModel {
                        ContentDirectoryHelper.deleteAudioFromDirectory(audioPath: photoIdea.capturedImages)
                    }
                }
            }
        }
    }
    
    public static func removeIdeaIdFromGroup (group: GroupModel, ideaId: UUID) {
        var changedGroup = group
        
        for id in 0..<changedGroup.ideasIds.count {
            if changedGroup.ideasIds[id] == ideaId {
                changedGroup.ideasIds.remove(at: id)
                break
            }
        }
        
        if changedGroup.ideasIds.count > 0 {
            changeSavedGroup(newGroup: changedGroup)
        } else {
            clearOneGroup(group: changedGroup)
        }
    }
    
    // MARK: - PRIVATE STATICS
    
    private static func saveUniqueGroup(group: GroupModel, key: String) {
        let encoder = JSONEncoder()
        var savedGroups: [GroupModel] = []
        
        if defaults.object(forKey: key) == nil {
            defaults.set(savedGroups, forKey: key)
        } else {
            savedGroups = getAllSavedGroups()
        }
        
        savedGroups.append(group)
        
        if let encoded = try? encoder.encode(savedGroups) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    /**Save an unique tag.*/
    private static func saveUniqueTag(tag: Tag, key: String) {
        let encoder = JSONEncoder()
        var savedTags: [Tag] = []
        
        if defaults.object(forKey: key) == nil {
            defaults.set(savedTags, forKey: key)
        }
        
        else {
            savedTags = getAllSavedTags()
        }
        
        savedTags.append(tag)
        
        if let encoded = try? encoder.encode(savedTags) {
            defaults.set(encoded, forKey: key)
        }
    }
    
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
    
    /**Save multiple groups*/
    private static func saveMultiplesGroups(groups: [GroupModel], key: String) {
        let encoder = JSONEncoder()
        var savedGroups: [GroupModel] = []
        
        if defaults.object(forKey: key) == nil {
            defaults.set(savedGroups, forKey: key)
        }
        
        else {
            savedGroups = getAllSavedGroups()
        }
        
        savedGroups.append(contentsOf: groups)
        
        if let encoded = try? encoder.encode(savedGroups) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    /**Save multiple tags*/
    private static func saveMultiplesTags(tags: [Tag], key: String) {
        let encoder = JSONEncoder()
        var savedTags: [Tag] = []
        
        if defaults.object(forKey: key) == nil {
            defaults.set(savedTags, forKey: key)
        }
        
        else {
            savedTags = getAllSavedTags()
        }
        
        savedTags.append(contentsOf: tags)
        
        if let encoded = try? encoder.encode(savedTags) {
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
        if !ideas.isEmpty { savedIdeas.append(contentsOf: ideas) }
        
        // encoding and saving the idea array
        if let encoded = try? encoder.encode(savedIdeas) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    //MARK: - TESTS
    /**TEST POURPOSES. Receive an audio idea and get its value saved in user default.*/
    public static func getSavedAudio(audio: AudioIdea) -> AudioIdea {
        let audio: [AudioIdea] = getSavedUniqueIdeasType(type: AudioIdea.self, key: audioModelKey)
        return audio.last! as AudioIdea
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
