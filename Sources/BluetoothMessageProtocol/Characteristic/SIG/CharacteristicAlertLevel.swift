//
//  CharacteristicAlertLevel.swift
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

/// BLE Alert Level Characteristic
///
/// The level of an alert a device is to sound. If this level is changed while the
/// alert is being sounded, the new level should take effect.
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
final public class CharacteristicAlertLevel: Characteristic {
    
    /// Characteristic Name
    public static var name: String { "Alert Level" }
    
    /// Characteristic UUID
    public static var uuidString: String { "2A06" }
    
    /// Alert Level Types
    public enum AlertLevel: UInt8 {
        /// No Alert
        case noAlert        = 0
        /// Mild Alert
        case mildAlert      = 1
        /// High Alert
        case highAlert      = 2
        
        /// String Value for AlertLevel
        public var stringValue: String {
            switch self {
            case .noAlert:
                return "No Alert"
            case .mildAlert:
                return "Mild Alert"
            case .highAlert:
                return "High Alert"
            }
        }
    }
    
    /// Name of the Characteristic
    public var name: String { Self.name }
    
    /// Characteristic UUID String
    public var uuidString: String { Self.uuidString }
    
    /// Alert Level
    private(set) public var alertLevel: AlertLevel
    
    /// Creates Alert Level Characteristic
    ///
    /// - Parameter alertLevel: AlertLevel
    public init(alertLevel: AlertLevel) {
        self.alertLevel = alertLevel
    }
    
    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    public class func decode(with data: Data) -> Result<CharacteristicAlertLevel, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let alertLevel: AlertLevel = AlertLevel(rawValue: decoder.decodeUInt8(data)) ?? .noAlert
        
        return.success(CharacteristicAlertLevel(alertLevel: alertLevel))
    }
    
    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    public func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()
        
        msgData.append(alertLevel.rawValue)
        
        return.success(msgData)
    }
}
