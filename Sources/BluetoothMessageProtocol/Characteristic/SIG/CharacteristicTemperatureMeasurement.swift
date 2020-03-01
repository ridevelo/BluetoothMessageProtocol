//
//  CharacteristicTemperatureMeasurement.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/26/17.
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

/// BLE Temperature Measurement Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
final public class CharacteristicTemperatureMeasurement: Characteristic {
    
    /// Characteristic Name
    public static var name: String { "Temperature Measurement" }
    
    /// Characteristic UUID
    public static var uuidString: String { "2A1C" }
    
    /// Name of the Characteristic
    public var name: String { Self.name }
    
    /// Characteristic UUID String
    public var uuidString: String { Self.uuidString }
    
    /// Temperature
    private(set) public var temperature: Measurement<UnitTemperature>
    
    /// Timestamp
    private(set) public var timestamp: DateTime?
    
    /// Temperature Type
    private(set) public var type: TemperatureType?
    
    /// Creates Temperature Measurement Characteristic
    ///
    /// - Parameters:
    ///   - temperature: Temperature
    ///   - timestamp: Timestamp
    ///   - type: Temperature Type
    public init(temperature: Measurement<UnitTemperature>, timestamp: DateTime?, type: TemperatureType?) {
        self.temperature = temperature
        self.timestamp = timestamp
        self.type = type
    }
    
    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    public class func decode(with data: Data) -> Result<CharacteristicTemperatureMeasurement, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let flags = Flags(rawValue: decoder.decodeUInt8(data))
        
        let tmpValue = Double(decoder.decodeFloatValue(data))
        var temperature: Measurement<UnitTemperature>
        
        if flags.contains(.unitsFahrenheit) {
            temperature = Measurement(value: tmpValue, unit: UnitTemperature.fahrenheit)
        } else {
            temperature = Measurement(value: tmpValue, unit: UnitTemperature.celsius)
        }
        
        var timestamp: DateTime?
        if flags.contains(.timestampPresent) {
            timestamp = DateTime.decode(data, decoder: &decoder)
        }
        
        var type: TemperatureType?
        if flags.contains(.temperatureTypePresent) {
            type = TemperatureType(rawValue: decoder.decodeUInt8(data)) ?? .unknown
        }
        
        let char = CharacteristicTemperatureMeasurement(temperature: temperature,
                                                        timestamp: timestamp,
                                                        type: type)
        return.success(char)
    }
    
    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    public func encode() -> Result<Data, BluetoothEncodeError> {
        /// Not Yet Supported
        return.failure(BluetoothEncodeError.notSupported)
    }
}

private extension CharacteristicTemperatureMeasurement {
    
    /// Flags
    struct Flags: OptionSet {
        public let rawValue: UInt8
        public init(rawValue: UInt8) { self.rawValue = rawValue }
        
        /// Temperature Measurement Value in units of Fahrenheit
        public static let unitsFahrenheit            = Flags(rawValue: 1 << 0)
        /// Time Stamp field present
        public static let timestampPresent           = Flags(rawValue: 1 << 1)
        /// Temperature Type field present
        public static let temperatureTypePresent     = Flags(rawValue: 1 << 2)
    }
    
}
