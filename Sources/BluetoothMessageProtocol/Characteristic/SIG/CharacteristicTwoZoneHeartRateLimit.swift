//
//  CharacteristicTwoZoneHeartRateLimit.swift
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

/// BLE Two Zone Heart Rate Limit Characteristic
///
/// The limits between the heart rate zones for the 2-zone heart rate definition
/// - Fitness
/// - Fat Burn
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicTwoZoneHeartRateLimit: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Two Zone Heart Rate Limit"
    }

    /// Characteristic UUID
    public static var uuidString: String {
        return "2A95"
    }

    /// Fat burn / Fitness Limit
    private(set) public var zoneLimit: Measurement<UnitCadence>

    /// Creates Two Zone Heart Rate Limit Characteristic
    ///
    /// - Parameter zoneLimit: Fat burn / Fitness Limit
    public init(zoneLimit: UInt8) {
        self.zoneLimit = Measurement(value: Double(zoneLimit),
                                     unit: UnitCadence.beatsPerMinute)

        super.init(name: CharacteristicTwoZoneHeartRateLimit.name,
                   uuidString: CharacteristicTwoZoneHeartRateLimit.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decoder<C: CharacteristicTwoZoneHeartRateLimit>(data: Data) -> Result<C, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let zoneLimit: UInt8 = decoder.decodeUInt8(data)

        let char = CharacteristicTwoZoneHeartRateLimit(zoneLimit: zoneLimit)
        return.success(char as! C)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicTwoZoneHeartRateLimit {
        return try decoder(data: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()

        msgData.append(Data(from: UInt8(zoneLimit.value)))

        return.success(msgData)
    }
}
