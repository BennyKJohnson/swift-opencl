//
//  CLMemory.swift
//  opencl-swift
//
//  Created by Ben Johnson on 12/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

public class CLMemory {
    public let mem: cl_mem
    
    public init(mem: cl_mem) {
        self.mem = mem
    }
    
    public var size: Int {
        let value: size_t = getInfo(cl_mem_info(CL_MEM_SIZE))
        return value
    }
    
    public var referenceCount: Int {
        let value: cl_uint = getInfo(cl_mem_info(CL_MEM_REFERENCE_COUNT))
        return Int(value)
    }
    
    public var mapCount: Int {
        let value: cl_uint = getInfo(cl_mem_info(CL_MEM_MAP_COUNT))
        return Int(value)
    }
    
    public var hostPointer: UnsafePointer<Void> {
        let value: UnsafePointer<Void> = getInfo(cl_mem_info(CL_MEM_HOST_PTR))
        return value
    }
    
    public var context: cl_context {
        return getInfo(cl_mem_info(CL_MEM_CONTEXT))
    }
    
    deinit {
        clReleaseMemObject(mem)
    }
}

extension CLMemory: CLInfoProvider {
    
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetMemObjectInfo(mem, param, size, buffer, nil)
    }
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetMemObjectInfo(mem, param, 0, &size, nil)
        return size
    }
    
    
}
