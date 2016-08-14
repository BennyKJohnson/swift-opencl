//
//  CLBuffer.swift
//  opencl-swift
//
//  Created by Ben Johnson on 11/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

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

public class CLBuffer: CLObject {
    
    public let memory: CLMemory
    
    public init(mem: cl_mem) {
        self.memory = CLMemory(mem: mem)
    }
    
    public var reference: OpaquePointer {
        return memory.mem
    }
    
    public convenience init(context: CLContext, type: CLMemType, size: Int) throws {
        var error: cl_int = 0
        
        guard let mem = clCreateBuffer(context.context, type.flags, size, nil, &error) else {
            throw CLError(rawValue: error)!
        }
        
        self.init(mem: mem)
    }
}




