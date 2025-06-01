// RawTransistor.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//

struct DopingWrapper<T: RawRepresentable & Decodable & Equatable>: Equatable, Decodable where T.RawValue == String {
    
    let doping: T
    
    private enum CodingKeys: String, CodingKey {
        case bjt = "bjt_doping"
        case mosfet = "mosfet_doping"
        case jfet = "jfet_doping"
    }
    
    init(doping: T) {
        self.doping = doping
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if T.self == BJTDoping.self, let doping = try container.decodeIfPresent(T.self, forKey: .bjt) {
            self.doping = doping
        } else if T.self == MOSFETDoping.self, let doping = try container.decodeIfPresent(T.self, forKey: .mosfet) {
            self.doping = doping
        } else if T.self == JFETDoping.self, let doping = try container.decodeIfPresent(T.self, forKey: .jfet) {
            self.doping = doping
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "No valid doping field found for \(T.self)"
                )
            )
        }
    }
}

struct RawTransistor: Decodable, Equatable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    let bjtDoping: DopingWrapper<BJTDoping>?
    let mosfetDoping: DopingWrapper<MOSFETDoping>?
    let jfetDoping: DopingWrapper<JFETDoping>?
    
    private enum CodingKeys: String, CodingKey {
        case ratings, use, package
        case partNumber = "part_number"
        case bjtDoping = "BJT"
        case mosfetDoping = "MOSFET"
        case jfetDoping = "JFET"
    }
    
    func parse() throws -> Transistor {
        
        if let bjtDoping = bjtDoping {
            return BJT(ratings: ratings,
                       partNumber: partNumber,
                       package: package,
                       use: use,
                       doping: bjtDoping.doping)
        }
        
        if let mosfetDoping = mosfetDoping {
            return MOSFET(ratings: ratings,
                          partNumber: partNumber,
                          package: package,
                          use: use,
                          doping: mosfetDoping.doping)
        }
        
        if let jfetDoping = jfetDoping {
            return JFET(ratings: ratings,
                        partNumber: partNumber,
                        package: package,
                        use: use,
                        doping: jfetDoping.doping)
        }
        
        throw TransistorListorError.transistorParseError
    }
}
