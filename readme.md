# Transitor Listor 

## Abstract 

Transistor Listor is portfolio project presenting an iOS-based application implementing a List - Detail view paradigm.  As the name implies, with a twist on the verb Lister, the application presents a list of various transistors with the option to delve into the details of a specific part with a simple tap.

**NOTE: This project is a work in progress - please ccheck back periodically fpr updates!**

## Architecture

### UI

The application uses the common *MVVM* UI architecture for the presentation layer.  

### Models

A model collection is used for representing domain constructs such as the various transistors within the application

### Services

A services layer is implemented to handle the (simulated) retrieval and parsing of JSON formatted transistor data. 

### Error Handling and Reporting

<< TBD >>

### Testing

*SwiftTest* is favored for unit testing of application logic.

### Dependency Injection

For testability dependency injection is favored thereby allowing mocks to be supplied for various unit testing scenarios.  Additional dependency injection (IoC) provides enhanced configuration and improved modularity of the application as well.  The style of dependency injection selected is simple supplying of dependencies via class / struct initializers.  

## Models

### Transistor

The primary model within the application is the Transistor.  The application is currently implemented to process three transistor families: Bipolar Junction Transistors (BJTs), Metal Oxide Semiconductor Field Effect Transistors (MOSFETs), and Junction Field Effect Transistors (JFETs).  As all transistors within the application have common characteristics, this is a good scenario to use either inheritance to represent the common transistor characteristics (i.e., a base Transistor class) and two subclasses, BJT and FET representing the individual families - or - protocols to define the common or base elements (data and behavior) and specific data instances to provide the concrete types.

Whichever approach is taken (inheritance or protocols) the leaf / concrete types need to implement the Equality and Hashable protocols to enable simpler unit testing and not preclude the types from being used in sets or dictionaries.  

#### Inheritance / Classes

Using inheritence requires class types with the need to implement the Equality and Hashable protocols manually which can get a little tricky with inheritance.  However, using classes allows further sub-classing (perhaps NPN and PNP subclasses of BJTs) and the common properties only need to be implemented once, in the base class.  

As an inheritance implementation requires classes, immutability needa to be carefully enforced as classes are reference types.

#### Protocols / Structs 

With structs the requirement to implement the Equality and Hashable protocols is more easily achieved  through allowing the Swift compiler to synthesize the implementations.  Also, as structs are value types, immutability is also enforced through the type.  One drawback of using structs is that protocol extensions cannot be used to store instance specific data such as that needed to implement instance properties and therefore each concrete structure requires the common properties to be defined (repeated).  Another drawback is that as structs cannot be extended through inheritance, subclassing to represent additional types (as the aforementioned potential NPN and PNP subclasses of BJTs) would not be possible perhaps leading to duplicating shared properties and logic across multiple structures.

#### Implementation

With the above considerations, as there is no current need to define further subclasses for the known types such as BJT, MOSFET and JFET, the benefits gained by the synthesis of the Equality and Hashable protocols as well as the intrinsic immutable gained by the struct type, the implementation uses a protocol to allow factory type implementation for building specific transistor types while minimizing the amount of code that needs to be written and maintained.  The implementation appears as:


```
protocol Transistor {
    
    var ratings: Ratings { get }
    var partNumber: String { get }
    var package: Package { get }
    var use: String { get }
} 
```

As there is a relatively natural close relationship between the protocol defining a transistor and the concrete structures, the choice was made to keep all transistor related protocols, structures and enumerations in a single file thereby making updates easier via a single file while preventing file spread. 

##### BJT

The BJT structure implements the transistor protocol providing a specific Bipolar Junction Transistor (BJT) implementation.  

BJT transistors can be one of two types, NPN or PNP based on the arrangement of silicon doping used.  This doping definition is represented by a property of type *BJTDoping*:

```
enum BJTDoping: String, Decodable, Hashable {
    case npn = "NPN"
    case pnp = "PNP"
}


struct BJT: Transistor, Hashable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    
    let doping: BJTDoping
}
```

Note that declaring conformance to the Hashable protocol is all that is needed for the synthesis of the implementation.  Additionally, conforming to the Hashable protocol also requires conforming to the Equatable protocol so explicit conformance is not necessary. 

##### MOSFET

Like the BJT struct, the MOSFET struct implements the Transistor protocol providing a specific Metal Oxide Semiconductor Field Effect Transistor (MOSFET) implementation.  

MOSFETs can be one of two types, PMOS or NMOS, again based on the arrangement of silicon doping used.  This doping definition is represented by a property of type *MOSFETDoping*:

```
enum MOSFETDoping: String, Decodable, Hashable {
    case nmos = "NMOS"
    case pmos = "PMOS"
}

struct MOSFET: Transistor, Equatable, Hashable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    
    let doping: MOSFETDoping
}
```
##### JFET

The final transistor type represented in this portfolio application is the Junction Field Effect Transistor or JFET. Like the preceding BJT MOSFET transistor elements, the JFET is realized as a Swift struct implementing the Transistor.  

JFET transistors can be one of two type, P-channel or N-channel dependent on their internal solid state physics construction.  This type is defined through a property of type *JFETDoping*:

```
enum JFETDoping: String, Decodable, Hashable {
    case nChannel = "N-channel"
    case pChannel = "P-channel"
}

struct JFET: Transistor, Equatable, Hashable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    
    let doping: JFETDoping
}
```

### Deserialization

The JSON representation for transistor data is structured as one of the following:

MOSFET:

```
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
```

BJT:

```
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
```

JFET:

```
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
```
As there is a JSON element defining the transistor family (MOSFET, BJT, pr JFET), any family can be deserialized into a flat raw transistor struct(ure) with optional enumerations for the actual family - which has a property of doping type (for BJTs either NPN or PNP and for MOSFETs either PMOS or NMOS).  As the transistor families are mutually exclusive, one of three properties on the raw deserialized structure will be nil.  While this is not the most efficient (i.e., knowing that the three properties are mutual exclusive - that is only one of the three will not be nil per deserialized transistor instance) it does allow for a simplified deserialization structure as well as allowing deserialization to happen in a single pass.  If different structures needed to be used for deserialization based on a type defined in the JSON, the JSON would first need to be deserialized to determine the type then deserialized a second time into the mapped type.

The initial structure and enumerations needed for JSON deserialization were  implemented as:

```
struct BJTTransistorType: Decodable, Equatable {
    
    let doping: BJTDoping
    
    private enum CodingKeys: String, CodingKey {
        case doping = "bjt_doping"
    }
}

struct MOSFETTransistorType: Decodable, Equatable {
    
    let doping: MOSFETDoping
    
    private enum CodingKeys: String, CodingKey {
        case doping = "mosfet_doping"
    }
    
}

struct JFETTransistorType: Decodable, Equatable {
    
    let doping: JFETDoping
    
    private enum CodingKeys: String, CodingKey {
        case doping = "jfet_doping"
    }
    
}

struct RawTransistor: Decodable, Equatable {
    
    let ratings: Ratings
    let partNumber: String
    let package: Package
    let use: String
    let bjtType: BJTTransistorType?
    let mosfetType: MOSFETTransistorType?
		let jfetType: JFETTransistorType?
    
    private enum CodingKeys: String, CodingKey {
        case ratings, use, package
        case partNumber = "part_number"
        case bjtType = "BJT"
        case mosfetType = "MOSFET"
			  case jfetType = "JFET"
    }
}     
```

With this implementation, there are three discrete structs that have no model value other they serving as a deserialization container for the JSON representing the transistor family: JFET, BJT, or MOSFET.  This could be simplified by moving these to internal structures within the *RawTransistor* struct to limit definitions strictly to the scope in which they have purpose, that is the concept of *JFETTransistorType* is only needed within the context of the *RawTransistor* 

Whether the struct to decode the transistor family and doping resides internal or external to the RawTransistor struct, adding a new type of transistor requires adding a new struct to decode that family / doping type.  Of course I could have changed the JSON to be more decodable friendly, however, we do not always have control over the JSON format (perhaps we are pulling data from a 3rd party service) and the format here is a pretty standard approach to represent data [TO DO Need more here] is seen in so I took the approach of improving the scalability (in adding additional types) via code refactoring.  

#### Generic Doping

As the three families represent similar concepts simply for different types, generics may offer a solution.  Considering the data is the type of silicon doping for a specific family, a generic doping wrapper, with the generic element being the type of doping looks like:

```
struct DopingWrapper<T>: Decodable {
    let doping: T
}

```

where T would be of type: BJTDoping, JFETDoping, or MOSFETDoping. 

In order to use the XXDoping enumerations for T some bounds for the generic type T as well as conformance to protocols for decoding and   on the generic to support decoding and equating (there is currently no need to conform to Hashable) the structure definition evolves to:

```
struct DopingWrapper<T: RawRepresentable & Decodable & Equatable>: Equatable, Decodable where T.RawValue == String {
    
    let doping: T
}
```

Adding the CodingKeys and initializer enabling Decodable conformance results is:

```
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

```

An initializer accepting a value for and assign said value to the *doping* property provides unit testing support.

This implementation will not require any new structures for decoding the doping type data in the JSON and limits logic parsing changes to the single decodable initializer in the generic DopingWrapper.

#### Factory Method

A factory method added to the RawTransistor struct facilitates creating the correct concrete transistor type struct (JFET, BJT, or MOSFET) from a RawTransistor instance.  The final implementation for the RawTransistor JSON decoding implementation appears as:

```
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
    
    func toTransistor() -> Transistor? {
        
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
        
        return nil
    }
}
```

The factory method could just as easily throw, however simply returning nil will not require the caller to wrap the execution of the method in try logic nor will it require the implementation of a new error type, it will require the caller to perform a nil check on the result before using said result.
 

## Services Layer
