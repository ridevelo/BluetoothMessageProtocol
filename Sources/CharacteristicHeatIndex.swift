//
//  CharacteristicHeatIndex.swift
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

/// BLE Heat Index Characteristic
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
open class CharacteristicHeatIndex: Characteristic {

    public static var name: String {
        return "Heat Index"
    }

    public static var uuidString: String {
        return "2A7A"
    }

    /// Heat Index
    private(set) public var heatIndex: Measurement<UnitTemperature>

    public init(heatIndex: Measurement<UnitTemperature>) {

        self.heatIndex = heatIndex

        super.init(name: CharacteristicHeatIndex.name, uuidString: CharacteristicHeatIndex.uuidString)
    }

    open override class func decode(data: Data) throws -> CharacteristicHeatIndex {

        var decoder = DataDecoder(data)

        let heatIndex: Measurement = Measurement(value: Double(decoder.decodeInt8()), unit: UnitTemperature.celsius)

        return CharacteristicHeatIndex(heatIndex: heatIndex)
    }

    open override func encode() throws -> Data {
        var msgData = Data()

        //Make sure we put this back to Celsius before we create Data
        let temperature = heatIndex.converted(to: UnitTemperature.celsius).value

        msgData.append(Data(from: Int8(temperature)))

        return msgData
    }

}

