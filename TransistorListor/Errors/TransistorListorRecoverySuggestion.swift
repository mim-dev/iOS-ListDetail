// TransistorListorRecoverySuggestion.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

enum TransistorListorRecoverySuggestion: String {
    
    // deneral / non-specific errors
    case generalError = "Please contact the developer."
    
    // transistor services error
    case badDataFormatDopingWrapper = "Verify the source/format of the JSON transistor data alignes wit the currennt version of the application. If the issue persists, please contact the developer."
}
