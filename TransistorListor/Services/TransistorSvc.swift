// TransistorSvc.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

import Foundation

class TransistorSvc {
    
    let dataParser: any DataParser
    
    var transistors: [any Transistor] = []
    
    init(dataParser: any DataParser) {
        self.dataParser = dataParser
    }
    
    func fetchTransistors() async throws {
        
        guard let transistorSrcPath = Bundle.main.url(forResource: "transistors", withExtension: "json") else {
            throw TransistorListorError.resourceNotFound
        }
        
        do {
            let transistorJSONData = try Data(contentsOf: transistorSrcPath)
            let transistors = try dataParser.parse(transistorJSONData) as? [any Transistor]
            
            // simulated network latency
            try await Task.sleep(for: .seconds(3))
            print(#function, "Loaded \(transistors?.count ?? 0) transistors")
        } catch {
            print("Error loading JSON file: \(error)")
            throw TransistorListorError.resourceCoundNotBeRead
        }
        
    }
    
}
