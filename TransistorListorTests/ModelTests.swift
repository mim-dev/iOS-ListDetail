// ModelTests.swift
// TransistorListor
//
// Copyright © 2025 Luther Stanton. All rights reserved.
//

import Foundation

import Testing
@testable import TransistorListor

struct ModelTests {

    @Test func deserializeAndBuildMOSFET_NMOS() throws {
        
        let sourceJSONData =
        """
            {
                "part_number": "IRF540N",
                "MOSFET": {
                    "mosfet_doping": "NMOS"
                },
                "ratings": {
                    "max_voltage": 100.0,

                    "max_current": 33.0
                },
                "use": "Power MOSFET for switching in motor control and power supplies",
                "package": "TO-220"
            }
        """.data(using: .utf8)!
        
        let expectedRawTransistor = RawTransistor(
            ratings: Ratings(maxVoltage: 100.0, maxCurrent: 33.0),
            partNumber: "IRF540N",
            package: .to220,
            use: "Power MOSFET for switching in motor control and power supplies",
            bjtDoping: nil,
            mosfetDoping: DopingWrapper<MOSFETDoping>(doping: .nmos),
            jfetDoping: nil)
        
        let expectedMOSFET = MOSFET(ratings: Ratings(maxVoltage: 100.0, maxCurrent: 33.0),
                                    partNumber: "IRF540N",
                                    package: .to220,
                                    use: "Power MOSFET for switching in motor control and power supplies",
                                    doping: .nmos)
        
        let decoder = JSONDecoder()
        
        do {
            let actualRawTransistor = try decoder.decode(RawTransistor.self, from: sourceJSONData)
            #expect(actualRawTransistor == expectedRawTransistor)
            
            let actualMOSFET = actualRawTransistor.toTransistor() as? MOSFET
            #expect(actualMOSFET == expectedMOSFET)
            
        } catch {
            print("error deserializing NMOS FET JSON: [\(error)]")
            throw error
        }
    }
    
    @Test func deserializeAndBuildMOSFET_PMOS() throws {
        
        let sourceJSONData =
        """
            {
                "part_number": "IRF9540N",
                "MOSFET": {
                    "mosfet_doping": "PMOS"
                },
                "ratings": {
                    "max_voltage": 100.0,
                    "max_current": 23.0
                },
                "use": "P-channel MOSFET for power management and load switching",
                "package": "TO-220"
            }
        """.data(using: .utf8)!
        
        let expectedRawTransistor = RawTransistor(
            ratings: Ratings(maxVoltage: 100.0, maxCurrent: 23),
            partNumber: "IRF9540N",
            package: .to220,
            use: "P-channel MOSFET for power management and load switching",
            bjtDoping: nil,
            mosfetDoping: DopingWrapper<MOSFETDoping>(doping: .pmos),
            jfetDoping: nil)
        
        let expectedMOSFET = MOSFET(ratings: Ratings(maxVoltage: 100.0, maxCurrent: 23.0),
                                    partNumber: "IRF9540N",
                                    package: .to220,
                                    use: "P-channel MOSFET for power management and load switching",
                                    doping: .pmos)
        
        let decoder = JSONDecoder()
        
        do {
            let actualRawTransistor = try decoder.decode(RawTransistor.self, from: sourceJSONData)
            #expect(actualRawTransistor == expectedRawTransistor)
            let actualMOSFET = actualRawTransistor.toTransistor() as? MOSFET
            #expect(actualMOSFET == expectedMOSFET)
        } catch {
            print("error deserializing PMOS FET JSON: [\(error)]")
            throw error
        }
    }
    
    @Test func deserializeAndBuildBJT_NPN() throws {
        
        let sourceJSONData =
        """
            {
                "part_number": "BC547",
                "BJT": {
                    "bjt_doping": "NPN"
                },
                "ratings": {
                    "max_voltage": 45.0,
                    "max_current": 0.1
                },
                "use": "Small-signal transistor for audio and general-purpose circuits",
                "package": "TO-92"   
            }
        """.data(using: .utf8)!
        
        let expectedRawTransistor = RawTransistor(
            ratings: Ratings(maxVoltage: 45.0, maxCurrent: 0.1),
            partNumber: "BC547",
            package: .to92,
            use: "Small-signal transistor for audio and general-purpose circuits",
            bjtDoping: DopingWrapper<BJTDoping>(doping: .npn),
            mosfetDoping: nil,
            jfetDoping: nil)
        
        let expectedBJT = BJT(ratings: Ratings(maxVoltage: 45.0, maxCurrent: 0.1),
                                    partNumber: "BC547",
                                    package: .to92,
                                    use: "Small-signal transistor for audio and general-purpose circuits",
                                    doping: .npn)
        
        let decoder = JSONDecoder()
        
        do {
            let actualRawTransistor = try decoder.decode(RawTransistor.self, from: sourceJSONData)
            #expect(actualRawTransistor == expectedRawTransistor)
            let actualBJT = actualRawTransistor.toTransistor() as? BJT
            #expect(actualBJT == expectedBJT)
        } catch {
            print("error deserializing NPN BJT JSON: [\(error)]")
            throw error
        }
    }
    
    @Test func deserializeBJT_PNP() throws {
        
        let sourceJSONData =
        """
            {
                "part_number": "2N3906",
                "BJT": {
                    "bjt_doping": "PNP"
                },
                "ratings": {
                    "max_voltage": 40.0,
                    "max_current": 0.2
                },
                "use": "Small-signal PNP for low-power amplification and switching",
                "package": "TO-92"
            }
        """.data(using: .utf8)!
        
        let expectedRawTransistor = RawTransistor(
            ratings: Ratings(maxVoltage: 40.0, maxCurrent: 0.2),
            partNumber: "2N3906",
            package: .to92,
            use: "Small-signal PNP for low-power amplification and switching",
            bjtDoping: DopingWrapper<BJTDoping>(doping: .pnp),
            mosfetDoping: nil,
            jfetDoping: nil)
        
        let expectedBJT = BJT(ratings: Ratings(maxVoltage: 40.0, maxCurrent: 0.2),
                                    partNumber: "2N3906",
                                    package: .to92,
                                    use: "Small-signal PNP for low-power amplification and switching",
                                    doping: .pnp)
        
        let decoder = JSONDecoder()
        
        do {
            let actualRawTransistor = try decoder.decode(RawTransistor.self, from: sourceJSONData)
            #expect(actualRawTransistor == expectedRawTransistor)
            let actualBJT = actualRawTransistor.toTransistor() as? BJT
            #expect(actualBJT == expectedBJT)
        } catch {
            print("error deserializing PNP BJT JSON: [\(error)]")
            throw error
        }
    }
    
    @Test func deserializeAndBuildJFET_PCHANNEL() throws {
        
        let sourceJSONData =
        """
            {
                "part_number": "2SJ103",
                "JFET": {
                    "jfet_doping": "P-channel"
                },
                "ratings": {
                    "max_voltage": 50.0,
                    "max_current": 0.015
                },
                "use": "Voltage-controlled resistor in audio circuits",
                "package": "TO-92"
            }
        """.data(using: .utf8)!
        
        let expectedRawTransistor = RawTransistor(
            ratings: Ratings(maxVoltage: 50.0, maxCurrent: 0.015),
            partNumber: "2SJ103",
            package: .to92,
            use: "Voltage-controlled resistor in audio circuits",
            bjtDoping: nil,
            mosfetDoping: nil,
            jfetDoping: DopingWrapper<JFETDoping>(doping: .pChannel))
        
        let expectedJFET = JFET(ratings: Ratings(maxVoltage: 50.0, maxCurrent: 0.015),
                                    partNumber: "2SJ103",
                                    package: .to92,
                                    use: "Voltage-controlled resistor in audio circuits",
                                    doping: .pChannel)
        
        let decoder = JSONDecoder()
        
        do {
            let actualRawTransistor = try decoder.decode(RawTransistor.self, from: sourceJSONData)
            #expect(actualRawTransistor == expectedRawTransistor)
            let actualJFET = actualRawTransistor.toTransistor() as? JFET
            #expect(actualJFET == expectedJFET)
        } catch {
            print("error deserializing PCHANNEL JFET JSON: [\(error)]")
            throw error
        }
    }
    
    @Test func deserializeAndBuildJFET_NCHANNEL() throws {
        
        let sourceJSONData =
        """
            {
                "part_number": "SST201",
                "JFET": {
                    "jfet_doping": "N-channel"
                },
                "ratings": {
                    "max_voltage": 40.0,
                    "max_current": 0.01
                },
                "use": "Precision amplifier for instrumentation",
                "package": "SOT-23"
            }
        """.data(using: .utf8)!
        
        let expectedRawTransistor = RawTransistor(
            ratings: Ratings(maxVoltage: 40.0, maxCurrent: 0.01),
            partNumber: "SST201",
            package: .sot23,
            use: "Precision amplifier for instrumentation",
            bjtDoping: nil,
            mosfetDoping: nil,
            jfetDoping: DopingWrapper<JFETDoping>(doping: .nChannel))
        
        let expectedJFET = JFET(ratings: Ratings(maxVoltage: 40.0, maxCurrent: 0.01),
                                    partNumber: "SST201",
                                    package: .sot23,
                                    use: "Precision amplifier for instrumentation",
                                    doping: .nChannel)
        
        let decoder = JSONDecoder()
        
        do {
            let actualRawTransistor = try decoder.decode(RawTransistor.self, from: sourceJSONData)
            #expect(actualRawTransistor == expectedRawTransistor)
            let actualJFET = actualRawTransistor.toTransistor() as? JFET
            #expect(actualJFET == expectedJFET)
        } catch {
            print("error deserializing PCHANNEL JFET JSON: [\(error)]")
            throw error
        }
    }

}
