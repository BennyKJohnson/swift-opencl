//
//  CLContext.swift
//  opencl-swift
//
//  Created by Ben Johnson on 10/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

enum CLContextError: Error {
    case failedToCreateContext
}

public class CLContext: CLObject {
    
    public let context: cl_context
    
    public init(context: cl_context) {
        self.context = context
    }
    
    public var reference: OpaquePointer {
        return context
    }
    
    public var size:Int {
        return sizeof(cl_mem.self)
    }
    
    public convenience init(device: CLDevice) throws {
        
        var error: cl_int = CL_SUCCESS
        var deviceID: cl_device_id? = device.deviceID
        
        guard let context = clCreateContext(nil, 1, &deviceID, nil, nil, &error)  , error == CL_SUCCESS else {
            throw CLError(rawValue: error)!
        }
        
        self.init(context: context)
        
    }
    
    public convenience init() throws {
        
        let device = try CLDevice()
        try self.init(device: device)
    }
    
    deinit {
        clReleaseContext(context)
    }
}

extension CLContext: CLInfoProvider {
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetContextInfo(context, param, size, buffer, nil)
    }
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetContextInfo(context, param, 0, nil, &size)
        return size
    }
}
