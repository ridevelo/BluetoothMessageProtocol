//
//  CharacteristicUnreadAlertStatus.swift
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

/// BLE Unread Alert Status Characteristic
///
/// Shows how many numbers of unread alerts exist in the specific category in the device.
@available(swift 3.1)
@available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
final public class CharacteristicUnreadAlertStatus: Characteristic {
    
    /// Characteristic Name
    public static var name: String { "Unread Alert Status" }
    
    /// Characteristic UUID
    public static var uuidString: String { "2A45" }
    
    /// Name of the Characteristic
    public var name: String { Self.name }
    
    /// Characteristic UUID String
    public var uuidString: String { Self.uuidString }
    
    /// Alert Type
    ///
    /// Category of the unread alert
    private(set) public var alertType: AlertCategory
    
    /// Number of Unread Alerts
    ///
    /// Provides the number of unread alerts in the server
    private(set) public var numberOfAlerts: UInt8
    
    /// Creates Unread Alert Status Characteristic
    ///
    /// - Parameters:
    ///   - alertType: Category of the unread alert
    ///   - numberOfAlerts: Number of unread alerts in the server
    public init(alertType: AlertCategory, numberOfAlerts: UInt8) {
        self.alertType = alertType
        self.numberOfAlerts = numberOfAlerts
    }
    
    /// Decodes Characteristic Data into Characteristic
    ///
    /// - Parameter data: Characteristic Data
    /// - Returns: Characteristic Result
    public class func decode(with data: Data) -> Result<CharacteristicUnreadAlertStatus, BluetoothDecodeError> {
        var decoder = DecodeData()
        
        let alertType = AlertCategory(rawValue: decoder.decodeUInt8(data)) ?? .simpleAlert
        let numberOfAlerts = decoder.decodeUInt8(data)
        
        let char = CharacteristicUnreadAlertStatus(alertType: alertType,
                                                   numberOfAlerts: numberOfAlerts)
        return.success(char)
    }
    
    /// Encodes the Characteristic into Data
    ///
    /// - Returns: Characteristic Data Result
    public func encode() -> Result<Data, BluetoothEncodeError> {
        var msgData = Data()
        
        msgData.append(alertType.rawValue)
        msgData.append(numberOfAlerts)
        
        return.success(msgData)
    }
}
