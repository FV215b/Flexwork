//
//  CommonBluetooth.swift
//  Bluetooth
//
//  Created by Ric Telford on 9/20/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit
import CoreBluetooth

let SERVICE_UUID = "973A007E-3C39-45C6-B2DD-0141DD82F973"
let CHARACTERISTIC_UUID = "1D04E43A-4B06-41D9-A499-7594D94A7814"
let MTU = 100  // any more than this seems to cause problems
let serviceUUIDs:[CBUUID] = [CBUUID(string: SERVICE_UUID)]
let serviceUUID = CBUUID(string: SERVICE_UUID)
let characteristicUUIDs:[CBUUID] = [CBUUID(string: CHARACTERISTIC_UUID)]
let characteristicUUID = CBUUID(string: CHARACTERISTIC_UUID)
let endOfMessage = "EOM".data(using: String.Encoding.utf8)

