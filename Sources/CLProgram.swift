//
//  CLProgram.swift
//  opencl-swift
//
//  Created by Ben Johnson on 10/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import OpenCL

public class CLBuildInfo {
    
    let deviceID: cl_device_id
    let program: cl_program
    
    public init(deviceID: cl_device_id, program: cl_program) {
        self.deviceID = deviceID
        self.program = program
    }
    
    public lazy var status: cl_int = {
       return self.getInfo(cl_program_build_info(CL_PROGRAM_BUILD_STATUS))
    }()
    
    public lazy var buildLog: String = {
        return self.getInfoString(cl_program_build_info(CL_PROGRAM_BUILD_LOG))
    }()
    
}

extension CLBuildInfo: CLInfoProvider {
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetProgramBuildInfo(program, deviceID, param , size, buffer, nil)
    }
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetProgramBuildInfo(program, deviceID, param, 0, nil, &size)
        return size
    }
}

public class CLProgram {
    
    let program: cl_program
    
    public init(program: cl_program) {
        self.program = program
    }
    
    public lazy var source: String? = {
        return self.getInfoString(cl_program_info(CL_PROGRAM_SOURCE))
    }()
    
    public convenience init(context: CLContext, source: String) throws {
  
        var error: cl_int = 0
       
        var sourcePtr = [UnsafePointer<Int8>(strdup(source))]
        guard let program =  clCreateProgramWithSource(context.context, 1, &sourcePtr, nil, &error) else {
            throw CLError(rawValue: error)!
        }

        self.init(program: program)
    }
    
    public convenience init(context: CLContext, withContentsOfFile path: String) throws {
       
        let source = try String(contentsOfFile: path)
        try self.init(context: context, source: source)
        
    }
    
    public func buildInfo(for device: CLDevice) -> CLBuildInfo {
       return CLBuildInfo(deviceID: device.deviceID, program: program)
    }
    public func build(forDevice device: CLDevice) throws -> CLBuildInfo  {
        
        var devicePTR: cl_device_id? = device.deviceID
        let result = clBuildProgram(program, 1, &devicePTR, nil, nil, nil)
        let buildInfo = CLBuildInfo(deviceID: device.deviceID, program: program)
        print(buildInfo.buildLog)
        if let error = CLError(rawValue: result) {
            throw error
        }
        
        
        
        return buildInfo
    }
    deinit {
        clReleaseProgram(program)
    }
}

