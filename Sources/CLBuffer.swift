//
//  CLBuffer.swift
//  opencl-swift
//
//  Created by Ben Johnson on 11/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL
/*
 public enum CLMemType {
 case readWrite
 case readOnly
 case writeOnly
 
 public var flags: cl_mem_flags {
 switch self {
 case .readOnly:
 return cl_mem_flags(CL_MEM_READ_ONLY)
 case .readWrite:
 return cl_mem_flags(CL_MEM_READ_WRITE)
 case .writeOnly:
 return cl_mem_flags(CL_MEM_WRITE_ONLY)
 }
 }
 }
 */
public struct CLMemType: OptionSet {
    public let rawValue: Int32
    
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    static let readOnly = CLMemType(rawValue: CL_MEM_READ_ONLY)
    static let readWrite = CLMemType(rawValue: CL_MEM_READ_WRITE)
    static let writeOnly = CLMemType(rawValue: CL_MEM_WRITE_ONLY)
    static let copyHostPointer = CLMemType(rawValue: CL_MEM_COPY_HOST_PTR)
    static let useHostPointer = CLMemType(rawValue: CL_MEM_USE_HOST_PTR)
    static let hostNoAccess = CLMemType(rawValue: CL_MEM_HOST_NO_ACCESS)
    
    var flags: cl_mem_flags {
        return cl_mem_flags(rawValue)
    }
}



public class CLBuffer: CLObject {
    
    public let memory: CLMemory
    
    public init(mem: cl_mem) {
        self.memory = CLMemory(mem: mem)
    }
    
    public var reference: OpaquePointer {
        return memory.mem
    }
    
    public convenience init<T>(context: CLContext, type: CLMemType, array: inout [T] ) throws {
        if type.contains(.copyHostPointer) || type.contains(.useHostPointer) {
            let pointer = UnsafeMutableRawPointer(mutating: array)
            try self.init(context: context, type: type, size: array.byteSize, hostPointer: pointer)
        } else {
            try self.init(context: context, type: type, size: array.byteSize, hostPointer: nil)
        }
    }
    
    public convenience init(context: CLContext, type: CLMemType, size: Int, hostPointer: UnsafeMutableRawPointer!) throws {
        var error: cl_int = 0
        
        guard let mem = clCreateBuffer(context.context, type.flags, size, hostPointer, &error) else {
            throw CLError(rawValue: error)!
        }
        
        self.init(mem: mem)
    }
}







