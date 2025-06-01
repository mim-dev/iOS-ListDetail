// TransistorListorErrorCodes.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

enum TransistorListorErrorCode: Int, CustomStringConvertible {
    
    // deneral / non-specific errors
    case generalError = 10
    
    // transistor services error
    case badDataFormatDopingWrapper = 100
    
    var description: String {
        switch self {
            
        case .generalError:
            return "General error"
        case .badDataFormatDopingWrapper:
            return "Bad data format - Transistor Doping Wrapper"
        }
    }
}
