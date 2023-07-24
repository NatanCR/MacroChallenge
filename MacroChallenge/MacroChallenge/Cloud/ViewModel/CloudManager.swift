//
//  CloudManager.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 24/07/23.
//

import Foundation
import CloudKit

class CloudManager {
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
    public static func fetchData(_ allData: [any Idea]) {
        audioFetch(allData)
        
//        var textIdeas: [ModelText] = []
//        var photoIdeas: [PhotoModel] = []
//
//        for data in allData {
//            switch data.ideiaType {
//                case .text : textIdeas.append(data as! ModelText)
//                case .photo: photoIdeas.append(data as! PhotoModel)
//                default: break
//            }
//        }
//
//
//        let textQuery = CKQuery(recordType: CloudManager.getTextRecordType(), predicate: NSPredicate(value: true))
//        let photoQuery = CKQuery(recordType: CloudManager.getPhotoRecordType(), predicate: NSPredicate(value: true))
        
        
    }
    
    private static func audioFetch(_ allData: [any Idea]) {
        var ideas: [AudioIdeia] = []
        var audioRecords: [CKRecord] = []
        
        // get the ideas saved in user defaults
        for data in allData {
            if data.ideiaType == .audio {
                ideas.append(data as! AudioIdeia)
            }
        }
        
        // query (consulta) the icloud database with the audio record type
        let query = CKQuery(recordType: CloudManager.getAudioRecordType(), predicate: NSPredicate(value: true))
        
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
                        audioRecords.append(record)
                    }
                }
                
                case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    //MARK: MATCH RESULT
    /**With the given result of CKRecord and its error, query for possible error, if not, return the CKRecord itself*/
    private static func getMatchResult(_ result: Result<CKRecord, Error>) -> CKRecord? {
        switch result {
            case .success(let record): return record
            case .failure(let error): print(error.localizedDescription); return nil
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
