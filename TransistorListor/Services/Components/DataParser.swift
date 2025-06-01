// DataParser.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

import Foundation

protocol DataParser {
    associatedtype DataModel
    
    func parse(_ data: Data) throws -> DataModel
}
