//
//  AudioHelper.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 02/06/23.
//

import Foundation

class AudioHelper {
    public static func getDocumentDirectoryContents() -> [URL] {
        do {
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let contents = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            return contents
        }
        
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    public static func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    public static func getAudioContent(audioPath: String) -> URL {
        let contents = getDocumentDirectoryContents()
        
        let index: Int = contents.firstIndex(where: { $0.lastPathComponent == audioPath }) ?? -1
        
        if index == -1 {
            print("AUDIOHELPER: audio not found")
            return getDocumentDirectory()
        }
        
        return contents[index]
    }
}
