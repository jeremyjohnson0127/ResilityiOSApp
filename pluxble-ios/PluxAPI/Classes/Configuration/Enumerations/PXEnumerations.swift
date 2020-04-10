//
//  PXEnumerations.swift
//  PluxAPI
//
//  Created by Carlos Dias on 07/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

/* @brief API Log level enumeration
 * case None: Use to disable API logs
 * case Simple: Use to display simple API logs
 */
@objc public enum PXLogLevel: Int {
    
    case none = 0
    case simple
}

/* @brief Identifier of a specific command
 * case Start: Start Command
 * case Stop: Stop Command
 * case Version: Version Command
 * case Description: Description Command
 * case Reset: Reset Command
 */
enum PXCommandIdentifier {

    case start
    case stop
    case version
    case description
    case reset
}

enum PXCommandError: UInt8 {
    
    case crcInvalid         = 0x00
    case badCommand         = 0x01 // Not recognized by the device
    case noSensor           = 0x02
    case read               = 0x03
    case numMaxSchedules    = 0x04 // No space for more schedules
    case badStart           = 0x05 // Start time not valid
    case badDuration        = 0x06 // Duration time not valid
    case badNumRepeats      = 0x07 // Number of repeats not valid
    case badRepeat          = 0x08 // Repeat time not valid
    case badCmdOverlap      = 0x09 // Overlap of sessions in time
    case badBaseFreq        = 0x0a // Base frequency not valid
    case badNumSensors      = 0x0b // Not recognized by the device
    case badDivisor         = 0x0c // Frequency divisor not valid
    case badChMask          = 0x0d // Channel mask not valid
    case sessionRunning     = 0x0e // Session is running
    case badPort            = 0x0f // Sensor port not valid
    case badParamIndex      = 0x10 // Parameter index not valid
    case badParamVal        = 0x11 // Parameter value not valid
    case badNumBlocks       = 0x12 // Number of blocks not valid
    case badClass           = 0x13 // Sensor class not valid
    case badSerialNum       = 0x14 // Sensor serial number not valid)
    case badStartAddr       = 0x15 // Start block address not valid)
    case badEndAddr         = 0x16 // End block address not valid)
    case badTextSize        = 0x17 // Schedule text size above limit)
    case sessionNotRunning  = 0x18 // Session of the given type is not running
    case badTime            = 0x19 // Time not valid
    case intMemory          = 0x80 // Error while accessing internal sd card
    case unknowError        = 0xff
}

enum PXDevicesPID: Int {
    
    case deviceUnknown = 0
    case bioPlux1
    case bioSignalsPlux8ch
    case bioSignalsPlux4ch
    case motionPlux
    case ee
    case usbDataCable
    case gestureWatch
    case muscleBan
    case bitalino1
    case bitalino2
}
