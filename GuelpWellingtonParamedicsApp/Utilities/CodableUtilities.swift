//
//  StringUtilities.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-28.
//

import Foundation



class CodableUtilities {
    static func encodeObjectToJson(object: Answer) -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(object)
            let json = String(data: jsonData, encoding: .utf8)
            
            return json
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
    
    static func decodeJsonToObject(json: String) -> Answer? {
        let jsonData = Data(json.utf8)
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(Answer.self, from: jsonData)
            
            return result
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
