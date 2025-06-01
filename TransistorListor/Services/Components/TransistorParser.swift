// TransistorParser.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

import Foundation

class TransistorParser: DataParser {
    
    typealias DataModel = [any Transistor]
    
    func parse(_ data: Data) throws -> [any Transistor] {
        
        let jsonDecoder = JSONDecoder()
        let decodedTransistors : [RawTransistor]
        
        do {
            decodedTransistors = try jsonDecoder.decode([RawTransistor].self, from: data)
        } catch {
            print("Error decoding transitor JSON: \(error)")
            throw error
        }
        
        let parsedTransistors: [any Transistor]
        
        do {
            parsedTransistors = try decodedTransistors.map { (rawTransistor) in
                return try rawTransistor.parse()
            }
        } catch {
            print("Error decoding transitor JSON: \(error)")
            throw error
        }
        
        
        return parsedTransistors
    }
    
}
