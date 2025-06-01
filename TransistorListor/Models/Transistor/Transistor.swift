// Transistor.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//  

import Foundation

struct Ratings: Decodable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    
    let maxVoltage: Double
    let maxCurrent: Double
    
    private enum CodingKeys: String, CodingKey {
        case maxVoltage = "max_voltage"
        case maxCurrent = "max_current"
    }
    
    var debugDescription: String {
        return "Ratings: [Max Voltage: [\(maxVoltage)] (V)\nMax Current: [\(maxCurrent)] (A)]"
    }
    
    var description: String {
        return "Max Voltage: \(maxVoltage)(V)\nMax Current: \(maxCurrent)(A)"
    }
}

enum Package: String, Decodable, Hashable, CustomStringConvertible, CustomDebugStringConvertible  {
    
    case to92 = "TO-92"
    case to220 = "TO-220"
    case sot23 = "SOT-23"
    
    var description: String {
        switch self {
        case .to92:
            return "TO-92"
        case .to220:
            return "TO-220"
        case .sot23:
            return "SOT-23"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

protocol TransistorDoping: CustomStringConvertible, CustomDebugStringConvertible {
    
}

enum BJTDoping: String, Decodable, Hashable, TransistorDoping {
    case npn = "NPN"
    case pnp = "PNP"
    
    var description: String {
        switch self {
        case .npn:
            return "NPN"
        case .pnp:
            return "PNP"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

enum MOSFETDoping: String, Decodable, Hashable, TransistorDoping {
    case nmos = "NMOS"
    case pmos = "PMOS"
    
    var description: String {
        switch self {
        case .nmos:
            return "N-channel"
        case .pmos:
            return "P-channel"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

enum JFETDoping: String, Decodable, Hashable, TransistorDoping {
    case nChannel = "N-channel"
    case pChannel = "P-channel"
    
    var description: String {
        switch self {
        case .nChannel:
            return "N-channel"
        case .pChannel:
            return "P-channel"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

protocol Transistor: CustomStringConvertible, CustomDebugStringConvertible  {
    
    associatedtype Doping: TransistorDoping
    
    var ratings: Ratings { get }
    var partNumber: String { get }
    var package: Package { get }
    var use: String { get }
    
    var doping: Doping { get }
}

extension Transistor {
    
    var debugDescription: String {
        return "Transistor: type:[\(type(of: self))] ratings:[\(self.ratings)] partNumber:[\(self.partNumber)] package:[\(self.package)] use:[\(self.use)] doping:[\(self.doping.debugDescription)]"
    }
    
    var description: String {
        return "Transistor - \(type(of: self)) (\(self.doping.description))\n  \(self.ratings)\n  partNumber - \(self.partNumber)\n  package - \(self.package)\n  use - \(self.use) doping:[\(self.doping.debugDescription)]"
    }
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
