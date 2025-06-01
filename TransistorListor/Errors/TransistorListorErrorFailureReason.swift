// TransistorListorErrorFailureReason.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

enum TransistorListorErrorFailureReason: String {
    
    // deneral / non-specific errors
    case generalError = "The undexpected error does not have a known cause."
    
    // transistor services error
    case badDataFormatDopingWrapper = "The JSON data representing the type and doping of a specific transistor could not be decoded."
}
