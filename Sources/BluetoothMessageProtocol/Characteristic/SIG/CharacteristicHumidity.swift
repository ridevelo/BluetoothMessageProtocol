//
//  CharacteristicHumidity.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/19/17.
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

/// BLE Humidity Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicHumidity: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Humidity"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2A6F"
    }

    /// Humidity Percentage
    private(set) public var humidity: Measurement<UnitPercent>

    /// Creates Humidity Characteristic
    ///
    /// - Parameter humidity: Humidity Percentage
    public init(humidity: Measurement<UnitPercent>) {
        self.humidity = humidity

        super.init(name: CharacteristicHumidity.name,
                   uuidString: CharacteristicHumidity.uuidString)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothMessageProtocolError
    open override class func decode(data: Data) throws -> CharacteristicHumidity {
        var decoder = DecodeData()

        let value = decoder.decodeUInt16(data).resolution(0.01)

        let humidity = Measurement(value: value, unit: UnitPercent.percent)

        return CharacteristicHumidity(humidity: humidity)
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Data representation of the Characteristic
    /// - Throws: BluetoothMessageProtocolError
    open override func encode() throws -> Data {
        var msgData = Data()

        let value = UInt16(humidity.value.resolution(1 / 0.01))

        msgData.append(Data(from: value))

        return msgData
    }
}
