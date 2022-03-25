//
//  Bundle-Decodable.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 22/03/22.
//

import Foundation

extension Bundle {
    
    /// Tag: Generic Method for decoding data stored in the App's Bundle as JSON or XML into any custom Type.
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {

        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("ERROR: Failed to locate \(file) in Bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("ERROR: Failed to load \(file) from Bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("ERROR: Failed to load \(file). - \(key.stringValue) - CONTEXT: \(context.debugDescription).")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("ERROR: Failed to load \(file). - CONTEXT: \(context.debugDescription).")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("ERROR: Failed to load \(file). MISSING \(type) - CONTEXT: \(context.debugDescription).")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("ERROR: Failed to load \(file) - Data Corruption. - CONTEXT: \(context.debugDescription).")
        } catch {
            fatalError("ERROR: Failed to decode \(file) from Bundle: \(error.localizedDescription).")
        }
    }
    
}
