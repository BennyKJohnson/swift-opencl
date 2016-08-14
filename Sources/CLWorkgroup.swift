//
//  CLWorkgroup.swift
//  opencl-swift
//
//  Created by Ben Johnson on 11/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

public class CLWorkGroup {
    
    public let kernel: CLKernel
    
    public let device: CLDevice
    
    public init(kernel: CLKernel, device: CLDevice) {
        self.kernel = kernel
        self.device = device
    }
    
    public lazy var groupSize: Int = {
        let size: size_t = self.getInfo(cl_kernel_work_group_info(CL_KERNEL_WORK_GROUP_SIZE))
       return size
    }()
    
    public lazy var localMemorySize: UInt64 = {
        let value: cl_ulong = self.getInfo(cl_kernel_work_group_info(CL_KERNEL_LOCAL_MEM_SIZE))
        return value
    }()
    
    public lazy var preferredSizeMultiple: Int = {
        let value: size_t = self.getInfo(cl_kernel_work_group_info(CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE))
        return value
    }()
    
    public lazy var privateMemorySize: UInt64 = {
        let value: cl_ulong = self.getInfo(cl_kernel_work_group_info(CL_KERNEL_PRIVATE_MEM_SIZE))
        return value
    }()
}

extension CLWorkGroup: CLInfoProvider {
    
    func getInfo(for param: uint, size: Int, in buffer: UnsafeMutablePointer<Void>!) {
        
        clGetKernelWorkGroupInfo(kernel.kernel, device.deviceID, cl_kernel_work_group_info(CL_KERNEL_WORK_GROUP_SIZE), size, buffer, nil)
    }
    
    func infoSize(for param: uint) -> Int {
        var size = 0
         clGetKernelWorkGroupInfo(kernel.kernel, device.deviceID, cl_kernel_work_group_info(CL_KERNEL_WORK_GROUP_SIZE), 0, nil, &size)
        return size
    }
    
}
