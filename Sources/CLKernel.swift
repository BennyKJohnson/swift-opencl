//
//  CLKernel.swift
//  opencl-swift
//
//  Created by Ben Johnson on 10/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL


public protocol CLVectorType {}
extension cl_uint2: CLVectorType {}
extension cl_uint4: CLVectorType {}
extension cl_uint8: CLVectorType {}
extension cl_uint16: CLVectorType {}
extension cl_int4: CLVectorType {}



public class CLKernel {
    
    public let kernel: cl_kernel
    
    public init(kernel: cl_kernel) {
        self.kernel = kernel
    }
    
    public convenience init(program: CLProgram, name: String) throws {
        var error: cl_int = 0
        var nameCStr = name.cString(using: String.Encoding.utf8)!
        let namePTR: UnsafePointer<Int8>? = UnsafePointer<Int8>?(&nameCStr)
        
        guard let kernel = clCreateKernel(program.program, namePTR, &error) else {
            throw CLError(rawValue: error)!
        }
        
        
        self.init(kernel: kernel)
        
    }
    
    public var contextReference: cl_context {
        return self.getType(for: cl_kernel_info(CL_KERNEL_CONTEXT))
    }
    
    public var programReference: cl_program {
        return self.getType(for: cl_kernel_info(CL_KERNEL_PROGRAM))
    }
    
    public var attributes: String {
        return self.getInfoString(cl_kernel_info(CL_KERNEL_ATTRIBUTES))
    }
    
    lazy public var functionName: String = {
        return self.getInfoString(cl_kernel_info(CL_KERNEL_FUNCTION_NAME))
    }()
    
    lazy public var numberOfArguments: Int = {
        return self.getInfoInteger(cl_kernel_info(CL_KERNEL_NUM_ARGS))
    }()
    
    public var referenceCount: Int {
        return self.getInfoInteger(cl_kernel_info(CL_KERNEL_REFERENCE_COUNT))
    }
    
    public var device: CLDevice?
    
    private func setValue(_ pointer: UnsafePointer<Void>!, withSize size: Int, forArgAtIndex argIndex: Int) {
        let argumentIndex = cl_uint(argIndex)
        clSetKernelArg(kernel, argumentIndex, size, pointer)
    }
    
    public func setValue(_ value: Int, forArgAtIndex argIndex: Int) {
        //var value = value
        var converted = cl_int(value)
        setValue(&converted, withSize: MemoryLayout<cl_int>.size, forArgAtIndex: argIndex)
    }
    
    public func setValue<T: BinaryFloatingPoint>(_ value: T, forArgAtIndex argIndex: Int) {
        var value = value
        
        setValue(&value, withSize: MemoryLayout<T>.size, forArgAtIndex: argIndex)
    }
    
    public func setValue<T: CLVectorType>(_ value: T, forArgAtIndex argIndex: Int) {
        var value = value
        
        setValue(&value, withSize: MemoryLayout<T>.size, forArgAtIndex: argIndex)
    }
    
    
    public func setValue(_ value: CLObject, forArgAtIndex argIndex: Int) {
        let argumentIndex = cl_uint(argIndex)
        
        var objectReference = value.reference
        clSetKernelArg(kernel, argumentIndex, MemoryLayout<OpaquePointer>.size, &objectReference)
        
    }
    
    
    public func workGroup(for device: CLDevice) -> CLWorkGroup {
        return CLWorkGroup(kernel: self, device: device)
    }
    
    deinit {
        clReleaseKernel(kernel)
    }
}

extension CLKernel: CLInfoProvider {
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetKernelInfo(kernel, param, 0, nil, &size)
        return size
    }
    
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetKernelInfo(kernel, param, size, buffer, nil)
    }
}
