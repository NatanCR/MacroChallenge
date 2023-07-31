//
//  CloudManager.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 24/07/23.
//

import Foundation
import CloudKit

actor CloudManager {
    //MARK: - VARs
    // statics
    private static let database = CKContainer(identifier: "iCloud.com.macro.Ideeo").privateCloudDatabase
    
    // record types
    private static let audioRecordType = "AudioIdea"
    private static let textRecordType = "TextIdea"
    private static let photoRecordType = "PhotoIdea"
    
    //MARK: - PUBLIC STATIC FUNCs
    /**Save an idea as a record in iCloud.*/
    public static func saveRecord<T: Idea>(_ idea: T) {
        switch idea.ideiaType {
            case .audio: saveAudio(idea as! AudioIdeia)
            case .text:  saveText (idea as! ModelText)
            case .photo: savePhoto(idea as! PhotoModel)
        }
    }
    
    //MARK: - SAVE AUDIO
    private static func saveAudio(_ idea: AudioIdeia) {
        let audioRecord = CKRecord(recordType: audioRecordType)
        let audioURL = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.audioPath)
        let audioAsset = CKAsset(fileURL: audioURL)
        
        audioRecord.setValuesForKeys([
            "ideaID" : idea.id.uuidString,
            "ideaType" : idea.ideiaType.rawValue,
            "title" : idea.title,
            "description" : idea.description,
            "textComplete" : idea.textComplete,
            "isFavorite" : idea.isFavorite,
            "createDate" : idea.creationDate,
            "modifiedDate" : idea.modifiedDate,
            "audio" : audioAsset
        ])
        
        saveRecordInDatabase(record: audioRecord)
    }
    
    //MARK: - SAVE TEXT
    private static func saveText(_ idea: ModelText) {
        let textRecord = CKRecord(recordType: textRecordType)
        
        textRecord.setValuesForKeys([
            "ideaID" : idea.id.uuidString,
            "ideaType" : idea.ideiaType.rawValue,
            "title" : idea.title,
            "description" : idea.description,
            "textComplete" : idea.textComplete,
            "isFavorite" : idea.isFavorite,
            "createDate" : idea.creationDate,
            "modifiedDate" : idea.modifiedDate
        ])
        
        saveRecordInDatabase(record: textRecord)
    }
    
    //MARK: - SAVE PHOTO
    private static func savePhoto(_ idea: PhotoModel) {
        let photoRecord = CKRecord(recordType: photoRecordType)
        let photoURL = ContentDirectoryHelper.getDirectoryContent(contentPath: idea.capturedImages)
        let photoAsset = CKAsset(fileURL: photoURL)
        
        photoRecord.setValuesForKeys([
            "ideaID" : idea.id.uuidString,
            "ideaType" : idea.ideiaType.rawValue,
            "title" : idea.title,
            "description" : idea.description,
            "textComplete" : idea.textComplete,
            "isFavorite" : idea.isFavorite,
            "createDate" : idea.creationDate,
            "modifiedDate" : idea.modifiedDate,
            "photo" : photoAsset
        ])
        
        saveRecordInDatabase(record: photoRecord)
    }
    
    //MARK: - SAVE DATABASE
    private static func saveRecordInDatabase(record: CKRecord) {
        database.save(record) { record, error in
            if record != nil, error == nil {
                print("saved in iCloud")
            }
        }
    }
    
    //MARK: - FETCH
    /**Fetch the ideas data, unifying the local store data with the iCloud records.*/
    public static func fetchData(_ allData: [any Idea]) -> [any Idea] {
        var audioIdeas: [AudioIdeia] = []
        var textIdeas: [ModelText] = []
        var photoIdeas: [PhotoModel] = []
        
        // get the ideas saved in user defaults
        for data in allData {
            switch data.ideiaType{
            case .audio:
                audioIdeas.append(data as! AudioIdeia)
                
            case .text:
                textIdeas.append(data as! ModelText)
                
            case .photo:
                photoIdeas.append(data as! PhotoModel)
            }
        }
        
        let allTextIdeas = ideaFetch(textIdeas, type: ModelText.self)
        
        var allIdeas: [any Idea] = []
        allIdeas.append(contentsOf: allTextIdeas)
        
        return allIdeas
    }
    
    //MARK: AUDIO FETCH
    private static func ideaFetch<T: Idea>(_ ideas: [T], type: T.Type) -> [T] {
        var allRecords: [CKRecord] = []
        var allIdeas: [T] = []
        let recordType: String
        
        // query (consulta) the icloud database with the idea record type
        if type == AudioIdeia.self { recordType = getAudioRecordType() }
        else if type == ModelText.self { recordType = getTextRecordType() }
        else { recordType = getPhotoRecordType() }
        
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        // with the query, get a RESULT of the fetched data in database, this result may be an error or a tuple with the CKRecord.Id and a Result with a CKRecord and its possible error
        CloudManager.getDatabase().fetch(withQuery: query, inZoneWith: nil) { result in
            // see if the result gets a success or a failure
            switch result {
                case .success(let records):
                    // get the tuple of CKRecord.ID and the Result of CKRecord and its possible error
                    for match in records.matchResults {
                        // get the CKRecord from the Result
                        let matchRecord = getMatchResult(match.1)
                        
                        // if the result is not nil, append to the list of CKRecords
                        if let record = matchRecord {
                            allRecords.append(record)
                        }
                    }
                    allIdeas = getUnifiedIdeaAndRecords(ideas: ideas, records: allRecords, type: type)
                
                case .failure(let error): print(error.localizedDescription)
            }
        }
        
        print(allIdeas)
        return allIdeas
    }
    
    //MARK: MATCH RESULT
    /**With the given result of CKRecord and its error, query for possible error, if not, return the CKRecord itself*/
    private static func getMatchResult(_ result: Result<CKRecord, Error>) -> CKRecord? {
        switch result {
            case .success(let record): return record
            case .failure(let error): print(error.localizedDescription); return nil
        }
    }
    
    //MARK: COMPARE LISTS
    private static func getUnifiedIdeaAndRecords<T: Idea>(ideas: [T], records: [CKRecord], type: T.Type) -> [T] {
        var allIdeas = ideas
        var recordIdeas: [T] = []
        
        // get the records in the model format
        for record in records {
            if let recordedIdea = RecordToIdea(record, type: type) {
                recordIdeas.append(recordedIdea)
            }
        }
        
        // verifying all empty cases
        if ideas.isEmpty, recordIdeas.isEmpty { return [] }
        if !ideas.isEmpty, recordIdeas.isEmpty { return allIdeas }
        if ideas.isEmpty, !recordIdeas.isEmpty { return recordIdeas }
        
        for record in recordIdeas {
            // append the record if it doesnt exist in local storage
            if !allIdeas.contains(where: { $0.id == record.id }) {
                allIdeas.append(record)
                continue
            }
            
            // replace the local storage by the record if the modified date is more recent
            else {
                let index: Int = allIdeas.firstIndex(where: { $0.id == record.id }) ?? 0
                if allIdeas[index].modifiedDate < record.modifiedDate {
                    allIdeas.remove(at: index)
                    allIdeas.append(record)
                    continue
                }
            }
        }
        
        return allIdeas
    }
    
    //MARK: RECORD to IDEA
    private static func RecordToIdea<T: Idea>(_ record: CKRecord, type: T.Type) -> T? {
        // id
        let uuidString = record["ideaID"] as? String ?? String()
        if uuidString == String() { return nil }
        let ideaID = UUID(uuidString: uuidString)
        
        // idea type
        let ideaTypeRawValue = record["ideaType"] as? String ?? String()
        if ideaTypeRawValue == String() { return nil }
        let ideaType = IdeaType(rawValue: ideaTypeRawValue)
        
        // title
        let title = record["title"] as? String ?? String()
        // description
        let description = record["description"] as? String ?? String()
        // textComplete
        let textComplete = record["textComplete"] as? String ?? String()
        // isFavorite
        let isFavorite = record["isFavorite"] as? Bool ?? false
        // create date
        let createDate = record["createDate"] as? Date ?? Date()
        // modified Date
        let modifiedDate = record["modifiedDate"] as? Date ?? Date()
        
        // audio and photo
        if ideaType == .audio {
            
        }
        
        else if ideaType == .photo {
            
        }
        
        switch ideaType {
        case .text:
            return ModelText(id: ideaID ?? UUID(), ideiaType: ideaType ?? .text, title: title, isFavorite: isFavorite, creationDate: createDate, modifiedDate: modifiedDate, description: description, textComplete: textComplete) as? T
            
        case .audio:
            return AudioIdeia(id: ideaID ?? UUID(), title: title, description: description, textComplete: textComplete, creationDate: createDate, modifiedDate: modifiedDate, audioPath: "") as? T
            
        case .photo:
            return PhotoModel(id: ideaID ?? UUID(), title: title, description: description, textComplete: textComplete, creationDate: createDate, modifiedDate: modifiedDate, capturedImage: "") as? T
            
        default:
            return nil
        }
    }
    
    //MARK: - STATIC GETTERS
    /**Get the apps iCloud database.*/
    public static func getDatabase() -> CKDatabase {
        return database
    }
    
    /**Get the audio record type string.*/
    public static func getAudioRecordType() -> String {
        return audioRecordType
    }
    
    /**Get the text record type string.*/
    public static func getTextRecordType() -> String {
        return textRecordType
    }
    
    /**Get the photo record type string.*/
    public static func getPhotoRecordType() -> String {
        return photoRecordType
    }
}
