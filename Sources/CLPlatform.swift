//
//  CLPlatform.swift
//  opencl-swift
//
//  Created by Ben Johnson on 12/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

public class CLPlatform {
    
    public let platformID: cl_platform_id
    
    public init(platformID: cl_platform_id) {
        self.platformID = platformID
    }
    
    public static func numberOfAvailablePlatforms() -> Int {
        var value: cl_uint = 0
        clGetPlatformIDs(0, nil, &value)
        return Int(value)
    }
    
    public static func allPlatforms() -> [CLPlatform] {
        let numPlatforms = numberOfAvailablePlatforms()
        let platformIDs = UnsafeMutablePointer<cl_platform_id?>.allocate(capacity: numPlatforms)
        
        clGetPlatformIDs(cl_uint(numPlatforms), platformIDs, nil)
        
        var platforms: [CLPlatform] = []
        for i in 0..<numPlatforms {
            if let platformID = platformIDs[i] {
                platforms.append(CLPlatform(platformID: platformID))
            }
        }
        
        // Free memory
        platformIDs.deinitialize()
        platformIDs.deallocate(capacity: numPlatforms)
        
        return platforms
    }
    
    public lazy var profile: String = {
        return self.getInfoString(cl_platform_info(CL_PLATFORM_PROFILE))
    }()
    
    public lazy var version: String = {
       return self.getInfoString(cl_platform_info(CL_PLATFORM_VERSION))
    }()
    
    public lazy var name: String = {
        return self.getInfoString(cl_platform_info(CL_PLATFORM_NAME))
    }()
    
    public lazy var vendor: String = {
       return self.getInfoString(cl_platform_info(CL_PLATFORM_VENDOR))
    }()
    
    public lazy var extensions: String = {
        return self.getInfoString(cl_platform_info(CL_PLATFORM_EXTENSIONS))
    }()
}

extension CLPlatform: CLInfoProvider {
    
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        clGetPlatformInfo(platformID, param, size, buffer, nil)
    }
    
    func infoSize(for param: uint) -> Int {
        var size: Int = 0
        clGetPlatformInfo(platformID, param, 0, nil, &size)
        return size
    }
}


