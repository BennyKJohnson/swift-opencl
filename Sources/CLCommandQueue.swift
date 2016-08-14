//
//  CLCommandQueue.swift
//  opencl-swift
//
//  Created by Ben Johnson on 10/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL


public class CLCommandQueue {
    
    let queue: cl_command_queue
    
    init(queue: cl_command_queue) {
        self.queue = queue
    }
    
    public convenience init(context: CLContext, device: CLDevice) throws {
        var error: cl_int = 0
        guard let commandQueue = clCreateCommandQueue(context.context, device.deviceID, 0, &error) else {
            throw CLError(rawValue: error)!
        }
        
        self.init(queue: commandQueue)
    }
    
    public func enqueueNDRange(with kernel: CLKernel, dimensions: Int, globalWorkSize:inout Int, localWorkSize:inout Int,  globalWorkOffset: Int? = nil,numberOfEventsInWaitList: Int = 0, eventWaitList: cl_event? = nil, event: cl_event? = nil) throws {
        
      
        var event = event
        var gwo = globalWorkOffset
        var eventWaitList = eventWaitList
     
        let result = clEnqueueNDRangeKernel(queue, kernel.kernel, cl_uint(dimensions), nil, &globalWorkSize, &localWorkSize, 0, nil, &event)
        if let errorCode = CLError(rawValue: result) {
            throw errorCode
        }
    }
    
    public func enqueueWrite(_ data:UnsafePointer<Swift.Void>, toBuffer buffer: CLBuffer, size: Int) {
    
        let result = clEnqueueWriteBuffer(queue, buffer.reference, cl_bool(CL_TRUE), 0, size, data, 0, nil, nil)
        if let error = CLError(rawValue: result) {
            fatalError("\(error)")
        }
    }
    
    public func enqueueRead(withBuffer buffer: CLBuffer, blockingRead: Bool, offset: Int, readSize: Int, writeTo pointer: UnsafeMutablePointer<Void>) -> cl_event? {
        
        var event: cl_event? = nil
        
        clEnqueueReadBuffer(queue, buffer.reference, cl_bool(bool: blockingRead), offset, readSize, pointer, cl_uint(0), nil, &event)
        
        return event
        
    }
    
    public func enqueueRead(withBuffer buffer: CLBuffer, blockingRead: Bool, offset: Int, readSize: Int, writeTo pointer: UnsafeMutablePointer<Void>, numberEventsInWaitList: Int, eventWaitList: inout cl_event?) -> cl_event? {
        var event: cl_event? = nil
        
        clEnqueueReadBuffer(queue, buffer.reference, cl_bool(bool: blockingRead), offset, readSize, pointer, cl_uint(numberEventsInWaitList), &eventWaitList, &event)
        
        return event
    }
    
    public func finish() {
        clFinish(queue)
    }
    
    deinit {
        clReleaseCommandQueue(queue)
    }
}

