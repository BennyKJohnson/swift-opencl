//
//  CLEvent.swift
//  opencl-swift
//
//  Created by Ben Johnson on 12/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import OpenCL

public class CLEvent {
    
    public let reference: cl_event
    
    public init(event: cl_event) {
        self.reference = event
    }
    
    public var contextReference: cl_context {
        let context: cl_context = getInfo(cl_event_info(CL_EVENT_CONTEXT))
        return context
    }
    
    public var commandQueueReference: cl_command_queue {
        let commandQueue: cl_command_queue = getInfo(cl_event_info(CL_EVENT_COMMAND_QUEUE))
        return commandQueue
    }
}

extension CLEvent: CLInfoProvider {
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetEventInfo(reference, cl_event_info(param), size, buffer, nil)
    }
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetEventInfo(reference, param, 0, nil, &size)
        return size
    }
    
}
