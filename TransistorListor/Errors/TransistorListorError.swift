// TransistorListorError.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//

import Foundation

protocol TransistorListorError: LocalizedError, CustomDebugStringConvertible {
    var domain: String { get }
    var errorCode: TransistorListorErrorCode { get }
    var source: TransistorListorError? { get }
}

extension LocalizedError {
    
    var debugDescription: String {
        return ""
    }
    
}

struct TransistorListorErrorDetail: TransistorListorError {
    
    let domain: String
    let errorCode: TransistorListorErrorCode
    let source: TransistorListorError?
    let errorDescription: String?
    let failureReason: String?
    let recoverySuggestion: String?
    let helpAnchor: String?
    
    init(domain: String = "com.transistorlistor.error",
         errorCode: TransistorListorErrorCode,
         errorDescription: String? = nil,
         failureReason: String? = nil,
         recoverySuggestion: String? = nil,
         helpAnchor: String? = nil,
         source: TransistorListorError? = nil)           {
        
        self.domain = domain
        self.errorCode = errorCode
        self.errorDescription = errorDescription
        self.failureReason = failureReason
        self.recoverySuggestion = recoverySuggestion
        self.helpAnchor = helpAnchor
        self.source = source
    }
}
