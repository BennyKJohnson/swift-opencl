//
//  CLInfoProvider.swift
//  opencl-swift
//
//  Created by Ben Johnson on 10/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

protocol CLInfoProvider {
    func infoSize(for param: uint) -> Int
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!)
}

protocol CLNumberValue {}
extension size_t: CLNumberValue {}
extension cl_uint: CLNumberValue {}
extension cl_ulong: CLNumberValue {}

extension CLInfoProvider {
    
    func getInfoString(_ param: uint) -> String {
        
        let size = infoSize(for: param)
        let stringBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: size)
        
        // Get Results
        getInfo(for: param, size: size, in: stringBuffer)
        let infoString = String(cString: stringBuffer)
        
        
        // Free memory
        stringBuffer.deinitialize()
        stringBuffer.deallocate(capacity: size)
        
        return infoString
    }
    
    func getInfoBool(_ param: uint) -> Bool {
        var resultBoolean: cl_bool! = 0
        getInfo(for: param, size: 4, in: &resultBoolean)
        
        if resultBoolean == 0 {
            return false
        } else {
            return true
        }

    }
    
    func getInfoInteger(_ param: uint) -> Int {
        var resultInteger: cl_uint! = 0
        getInfo(for: param, size: sizeof(cl_uint.self), in: &resultInteger)
        return Int(resultInteger)
        
    }
  
    func getInfo<T>(_ param: uint) -> T {
        
        var resultInteger: T!
        let size = infoSize(for: param)
        getInfo(for: param, size: size, in: &resultInteger)
        return resultInteger
    }
    
    func getType(for param: uint) -> OpaquePointer {
        
        var placeholder: OpaquePointer!
        getInfo(for: param, size: sizeof(OpaquePointer.self), in: &placeholder)
        
        return placeholder
    }
    
}

extension CLProgram: CLInfoProvider {
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetProgramInfo(program, param, 0, nil, &size)
        return size
    }
    
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetProgramInfo(program, param, size, buffer, nil)
    }
}

extension CLDevice: CLInfoProvider {
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetDeviceInfo(deviceID, param, 0, nil, &size)
        return size
    }
    
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetDeviceInfo(deviceID, param, size, buffer, nil)
    }

    
}
