//
//  CharacteristicWindChill.swift
//  BluetoothMessageProtocol
//
//  Created by Kevin Hoogheem on 8/6/17.
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

/// BLE Wind Chill Characteristic
///
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicWindChill: Characteristic {

    /// Characteristic Name
    public static var name: String {
        return "Wind Chill"
    }
    
    /// Characteristic UUID
    public static var uuidString: String {
        return "2A79"
    }

    /// Wind Chill
    private(set) public var windChill: Measurement<UnitTemperature>

    /// Creates Wind Chill Characteristic
    ///
    /// - Parameter windChill: Wind Chill
    public init(windChill: Measurement<UnitTemperature>) {
        self.windChill = windChill

        super.init(name: CharacteristicWindChill.name,
                   uuidString: CharacteristicWindChill.uuidString)
    }

    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    open override class func decoder<C: CharacteristicWindChill>(data: Data) -> Result<C, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let windChill = Measurement(value: Double(decoder.decodeInt8(data)), unit: UnitTemperature.celsius)

        let char = CharacteristicWindChill(windChill: windChill)
        return.success(char as! C)
    }

    /// Deocdes the BLE Data
    ///
    /// - Parameter data: Data from sensor
    /// - Returns: Characteristic Instance
    /// - Throws: BluetoothDecodeError
    @available(*, deprecated, message: "use results based decoder instead")
    open override class func decode(data: Data) throws -> CharacteristicWindChill {
        return try decoder(data: data).get()
    }

    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    open override func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()

        //Make sure we put this back to Celsius before we create Data
        let chill = windChill.converted(to: UnitTemperature.celsius).value

        msgData.append(Data(from: Int8(chill)))
        
        return.success(msgData)
    }
}
