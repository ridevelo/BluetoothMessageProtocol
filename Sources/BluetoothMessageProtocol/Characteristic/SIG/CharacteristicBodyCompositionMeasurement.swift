//
//  CharacteristicBodyCompositionMeasurement.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 9/2/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import DataDecoder
import FitnessUnits

/// BLE Body Composition Measurement Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
final public class CharacteristicBodyCompositionMeasurement: Characteristic {
    
    /// Characteristic Name
    public static var name: String { "Body Composition Measurement" }
    
    /// Characteristic UUID
    public static var uuidString: String { "2A9C" }
    
    /// Name of the Characteristic
    public var name: String { Self.name }
    
    /// Characteristic UUID String
    public var uuidString: String { Self.uuidString }
    
    /// Body Fat Percentage
    private(set) public var bodyFat: Measurement<UnitPercent>
    
    /// Timestamp
    private(set) public var currentTime: DateTime?
    
    /// User ID
    private(set) public var userID: User?
    
    /// Basal Metabolism
    private(set) public var basalMetabolism: Measurement<UnitEnergy>?
    
    /// Muscle Percentage
    private(set) public var musclePercentage: Measurement<UnitPercent>?
    
    /// Muscle Mass
    private(set) public var muscleMass: Measurement<UnitMass>?
    
    /// Fat Free Mass
    private(set) public var fatFreeMass: Measurement<UnitMass>?
    
    /// Soft Lean Mass
    private(set) public var softLeanMass: Measurement<UnitMass>?
    
    /// Body Water Mass
    private(set) public var bodyWaterMass: Measurement<UnitMass>?
    
    /// Impedance
    private(set) public var impedance: Measurement<UnitElectricResistance>?
    
    /// Weight
    private(set) public var weight: Measurement<UnitMass>?
    
    /// Height
    private(set) public var height: Measurement<UnitLength>?
    
    /// Multiple Packet Measurement
    private(set) public var multiplePacketMeasurement: Bool
    
    /// Creates Body Composition Measurement Characteristic
    ///
    /// - Parameters:
    ///   - bodyFat: Body Fat Percentage
    ///   - currentTime: Timestamp
    ///   - userID: User ID
    ///   - basalMetabolism: Basal Metabolism
    ///   - musclePercentage: Muscle Percentage
    ///   - muscleMass: Muscle Mass
    ///   - fatFreeMass: Fat Free Mass
    ///   - softLeanMass: Soft Lean Mass
    ///   - bodyWaterMass: Body Water Mass
    ///   - impedance: Impedance
    ///   - weight: Weight
    ///   - height: Height
    ///   - multiplePacketMeasurement: Multiple Packet Measurement
    public init(bodyFat: Measurement<UnitPercent>,
                currentTime: DateTime?,
                userID: User?,
                basalMetabolism: Measurement<UnitEnergy>?,
                musclePercentage: Measurement<UnitPercent>?,
                muscleMass: Measurement<UnitMass>?,
                fatFreeMass: Measurement<UnitMass>?,
                softLeanMass: Measurement<UnitMass>?,
                bodyWaterMass: Measurement<UnitMass>?,
                impedance: Measurement<UnitElectricResistance>?,
                weight: Measurement<UnitMass>?,
                height: Measurement<UnitLength>?,
                multiplePacketMeasurement: Bool) {
        
        self.bodyFat = bodyFat
        self.currentTime = currentTime
        self.userID = userID
        self.basalMetabolism = basalMetabolism
        self.musclePercentage = musclePercentage
        self.muscleMass = muscleMass
        self.fatFreeMass = fatFreeMass
        self.softLeanMass = softLeanMass
        self.bodyWaterMass = bodyWaterMass
        self.impedance = impedance
        self.weight = weight
        self.height = height
        self.multiplePacketMeasurement = multiplePacketMeasurement
    }
    
    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    public class func decode(with data: Data) -> Result<CharacteristicBodyCompositionMeasurement, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let flags = Flags(rawValue: decoder.decodeUInt16(data))
        
        let bfatValue = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
        let bFat = Measurement(value: bfatValue, unit: UnitPercent.percent)
        
        var currentTime: DateTime?
        if flags.contains(.timeStampPresent) {
            currentTime = DateTime.decode(data, decoder: &decoder)
        }
        
        var userID: User?
        if flags.contains(.userIDPresent) {
            userID = User.create(decoder.decodeUInt8(data))
        }
        
        var basalMetabolism: Measurement<UnitEnergy>?
        if flags.contains(.basalMetabolismPresent) {
            let value = Double(decoder.decodeUInt16(data))
            basalMetabolism = Measurement(value: value, unit: UnitEnergy.kilojoules)
        }
        
        var musclePercentage: Measurement<UnitPercent>?
        if flags.contains(.musclePercentagePresent) {
            let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
            musclePercentage = Measurement(value: value, unit: UnitPercent.percent)
        }
        
        var muscleMass: Measurement<UnitMass>?
        if flags.contains(.muscleMassPresent) {
            
            if flags.contains(.imperialUnits) {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
                muscleMass = Measurement(value: value, unit: UnitMass.pounds)
            } else {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneFiveThousandth)
                muscleMass = Measurement(value: value, unit: UnitMass.kilograms)
            }
        }
        
        var fatFreeMass: Measurement<UnitMass>?
        if flags.contains(.fatFreeMassPresent) {
            
            if flags.contains(.imperialUnits) {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneHundredth)
                fatFreeMass = Measurement(value: value, unit: UnitMass.pounds)
            } else {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneFiveThousandth)
                fatFreeMass = Measurement(value: value, unit: UnitMass.kilograms)
            }
        }
        
        var softLeanMass: Measurement<UnitMass>?
        if flags.contains(.softLeanMassPresent) {
            
            if flags.contains(.imperialUnits) {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneHundredth)
                softLeanMass = Measurement(value: value, unit: UnitMass.pounds)
            } else {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneFiveThousandth)
                softLeanMass = Measurement(value: value, unit: UnitMass.kilograms)
            }
        }
        
        var bodyWaterMass: Measurement<UnitMass>?
        if flags.contains(.bodyWaterMassPresent) {
            
            if flags.contains(.imperialUnits) {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneHundredth)
                bodyWaterMass = Measurement(value: value, unit: UnitMass.pounds)
            } else {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneFiveThousandth)
                bodyWaterMass = Measurement(value: value, unit: UnitMass.kilograms)
            }
        }
        
        var impedance: Measurement<UnitElectricResistance>?
        if flags.contains(.impedancePresent) {
            let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneTenth)
            impedance = Measurement(value: value, unit: UnitElectricResistance.ohms)
        }
        
        var weight: Measurement<UnitMass>?
        if flags.contains(.weightPresent) {
            
            if flags.contains(.imperialUnits) {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneHundredth)
                weight = Measurement(value: value, unit: UnitMass.pounds)
            } else {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneFiveThousandth)
                weight = Measurement(value: value, unit: UnitMass.kilograms)
            }
        }
        
        var height: Measurement<UnitLength>?
        if flags.contains(.heightPresent) {
            
            if flags.contains(.imperialUnits) {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneHundredth)
                height = Measurement(value: value, unit: UnitLength.inches)
            } else {
                let value = decoder.decodeUInt16(data).resolution(.removing, resolution: Resolution.oneThousandth)
                height = Measurement(value: value, unit: UnitLength.meters)
            }
        }
        
        let multiPacket = flags.contains(.multiplePacketMeasrement)
        
        let char = CharacteristicBodyCompositionMeasurement(bodyFat: bFat,
                                                            currentTime: currentTime,
                                                            userID: userID,
                                                            basalMetabolism: basalMetabolism,
                                                            musclePercentage: musclePercentage,
                                                            muscleMass: muscleMass,
                                                            fatFreeMass: fatFreeMass,
                                                            softLeanMass: softLeanMass,
                                                            bodyWaterMass: bodyWaterMass,
                                                            impedance: impedance,
                                                            weight: weight,
                                                            height: height,
                                                            multiplePacketMeasurement: multiPacket)
        return.success(char)
    }
    
    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    public func encode() -> Result<Data, BluetoothEncodeError> {
        /// not yet supportable
        return.failure(BluetoothEncodeError.notSupported)
    }
}

private extension CharacteristicBodyCompositionMeasurement {
    
    /// Flags
    struct Flags: OptionSet {
        public let rawValue: UInt16
        public init(rawValue: UInt16) { self.rawValue = rawValue }
        
        /// Imperial (Weight and Mass in units of pound (lb) and Height in units of inch (in))
        public static let imperialUnits             = Flags(rawValue: 1 << 0)
        /// Time Stamp Present
        public static let timeStampPresent          = Flags(rawValue: 1 << 1)
        /// User ID present
        public static let userIDPresent             = Flags(rawValue: 1 << 2)
        /// Basal Metabolism present
        public static let basalMetabolismPresent    = Flags(rawValue: 1 << 3)
        /// Muscle Percentage present
        public static let musclePercentagePresent   = Flags(rawValue: 1 << 4)
        /// Muscle Mass present
        public static let muscleMassPresent         = Flags(rawValue: 1 << 5)
        /// Fat Free Mass present
        public static let fatFreeMassPresent        = Flags(rawValue: 1 << 6)
        /// Soft Lean Mass present
        public static let softLeanMassPresent       = Flags(rawValue: 1 << 7)
        /// Body Water Mass present
        public static let bodyWaterMassPresent      = Flags(rawValue: 1 << 8)
        /// Impedance present
        public static let impedancePresent          = Flags(rawValue: 1 << 9)
        /// Weight present
        public static let weightPresent             = Flags(rawValue: 1 << 10)
        /// Height present
        public static let heightPresent             = Flags(rawValue: 1 << 11)
        /// Multiple Packet Measurement
        public static let multiplePacketMeasrement  = Flags(rawValue: 1 << 12)
    }
    
}
