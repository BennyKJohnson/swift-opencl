//
//  CLDevice.swift
//  opencl-swift
//
//  Created by Ben Johnson on 10/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

public protocol CLObject {
    var reference: OpaquePointer { get }
}

/*
 #define CL_DEVICE_TYPE_DEFAULT                      (1 << 0)
 #define CL_DEVICE_TYPE_CPU                          (1 << 1)
 #define CL_DEVICE_TYPE_GPU                          (1 << 2)
 #define CL_DEVICE_TYPE_ACCELERATOR                  (1 << 3)
 #define CL_DEVICE_TYPE_CUSTOM                       (1 << 4)
 #define CL_DEVICE_TYPE_ALL                          0xFFFFFFFF
*/

 public struct CLDeviceType: OptionSet, CustomStringConvertible {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let `default` = CLDeviceType(rawValue: (1 << 0))
    public static let cpu = CLDeviceType(rawValue: (1 << 1))
    public static let gpu = CLDeviceType(rawValue: (1 << 2))
    public static let accelerator = CLDeviceType(rawValue: (1 << 3))
    public static let custom = CLDeviceType(rawValue: (1 << 4))
    public static let all = CLDeviceType(rawValue: 0xFFFFFFFF)
    
    public var description: String {
        switch self {
        case CLDeviceType.default:
            return "Default"
        case CLDeviceType.cpu:
            return "CPU"
        case CLDeviceType.gpu:
            return "GPU"
        case CLDeviceType.accelerator:
            return "Accelerator"
        case CLDeviceType.custom:
            return "Custom"
        case CLDeviceType.all:
            return "All"
        default:
            return "Unknown"
        }
    }
    
}


public class CLDevice {
    
    public var deviceID: cl_device_id
    
    init(deviceID: cl_device_id) {
        self.deviceID = deviceID
    }
    
    public convenience init() throws {
        if let gpuDevice = CLDevice.devices(with: .gpu).first {
            self.init(deviceID: gpuDevice.deviceID)
        } else if let cpuDevice = CLDevice.devices(with: .cpu).first {
            self.init(deviceID: cpuDevice.deviceID)

        } else {
            throw CLError.deviceNotFound
        }
        
    }
    
    public var isAvailable: Bool {
        return self.getInfoBool(cl_device_info(CL_DEVICE_AVAILABLE))
    }
    
    public var compilerAvailable: Bool {
        return self.getInfoBool(cl_device_info(CL_DEVICE_COMPILER_AVAILABLE))
    }
    
    lazy public var extensions: String = {
        return self.getInfoString(cl_device_info(CL_DEVICE_EXTENSIONS))
    }()
    
    lazy public var vendor: String = {
        return self.getInfoString(cl_device_info(CL_DEVICE_VENDOR))
    }()
    
    lazy public var version: String = {
        return self.getInfoString(cl_device_info(CL_DEVICE_VERSION))
    }()
    
    lazy public var driverVersion: String = {
        return self.getInfoString(cl_device_info(CL_DRIVER_VERSION))
    }()
    
    lazy public var name: String = {
       return self.getInfoString(cl_device_info(CL_DEVICE_NAME))
    }()
    
    public lazy var type: CLDeviceType = {
        let clDeviceType: cl_device_type = self.getInfo(cl_device_info(CL_DEVICE_TYPE))
       return CLDeviceType(rawValue: UInt(clDeviceType))
    }()
    
    public lazy var computeUnits: Int = {
        let units: cl_uint = self.getInfo(cl_device_info(CL_DEVICE_MAX_COMPUTE_UNITS))
       return Int(units)
    }()
    
    public lazy var workGroupSize: Int = {
        let units: size_t = self.getInfo(cl_device_info(CL_DEVICE_MAX_WORK_GROUP_SIZE))
        return units
    }()
    
    public lazy var workItemDimensions: Int = {
        let values: cl_uint = self.getInfo(cl_device_info(CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS))
        return Int(values)
    }()
    
    public lazy var workItemSizes: [Int] = {
        var values = Array<Int>(repeating: 0, count: self.workItemDimensions)
        self.getInfo(for: cl_device_info(CL_DEVICE_MAX_WORK_ITEM_SIZES), size: (MemoryLayout<size_t>.size * values.count), in: &values)
        return values
    }()
    
    
    public static func numberOfAvailableDevices(for type: CLDeviceType, on platform: CLPlatform? = nil) -> Int{
        
        var numberOfDevices: cl_uint = 0
        let platformID = platform?.platformID
        
        clGetDeviceIDs(platformID, cl_device_type(type.rawValue), 0, nil, &numberOfDevices)
        
        return Int(numberOfDevices)
    }
    
    public static func devices(with deviceType: CLDeviceType, onPlatform platform: CLPlatform? = nil) -> [CLDevice] {
        
        let numberOfDevices = numberOfAvailableDevices(for: deviceType, on: platform)
        let deviceIDs = UnsafeMutablePointer<cl_device_id?>.allocate(capacity: numberOfDevices)
        let platformID = platform?.platformID
        clGetDeviceIDs(platformID, cl_device_type(deviceType.rawValue), 2, deviceIDs, nil)
        var devices: [CLDevice] = []
        for i in 0..<numberOfDevices {
            let deviceID = deviceIDs[i]!
            devices.append(CLDevice(deviceID: deviceID))
        }
        
        // Free memory
        deviceIDs.deinitialize()
        deviceIDs.deallocate(capacity: numberOfDevices)
    
        return devices
    }
}

extension CLDevice: CustomStringConvertible {
    public var description: String {
        return "\(name) \nVendor: \(vendor)\nVersion: \(version)"
    }
}
