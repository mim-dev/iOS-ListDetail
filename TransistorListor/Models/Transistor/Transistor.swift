// Transistor.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

import Foundation

struct Ratings: Decodable, Hashable {
    
    let maxVoltage: Double
    let maxCurrent: Double
    
    private enum CodingKeys: String, CodingKey {
        case maxVoltage = "max_voltage"
        case maxCurrent = "max_current"
    }
}

enum Package: String, Decodable, Hashable {
    
    case to92 = "TO-92"
    case to220 = "TO-220"
    case sot23 = "SOT-23"
}

enum BJTDoping: String, Decodable, Hashable {
    case npn = "NPN"
    case pnp = "PNP"
}

enum MOSFETDoping: String, Decodable, Hashable {
    case nmos = "NMOS"
    case pmos = "PMOS"
}

enum JFETDoping: String, Decodable, Hashable {
    case nChannel = "N-channel"
    case pChannel = "P-channel"
}

protocol Transistor {
    
    var ratings: Ratings { get }
    var partNumber: String { get }
    var package: Package { get }
    var use: String { get }
}

struct BJT: Transistor, Hashable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    
    let doping: BJTDoping
}

struct MOSFET: Transistor, Hashable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    
    let doping: MOSFETDoping
}

struct JFET: Transistor, Hashable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    
    let doping: JFETDoping
}
