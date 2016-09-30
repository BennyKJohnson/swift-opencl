//
//  CLImage.swift
//  swift-opencl
//
//  Created by Ben Johnson on 21/09/2016.
//
//

import Foundation
import OpenCL

struct CLImageFormat {
    let imageChannelOrder: cl_channel_order
    let imageChannelDatatype: cl_channel_type
    
    var cl: cl_image_format
}

struct CLImage {
    
    let reference: cl_mem?
    
    init(context: CLContext, memFlags: CLMemType, format: cl_image_format, width: Int, height: Int , hostPointer: UnsafeMutableRawPointer) throws {
        
        var imageDescription = cl_image_desc(image_type: cl_mem_object_type(CL_MEM_OBJECT_IMAGE2D), image_width: width, image_height: height, image_depth: 1, image_array_size: 1, image_row_pitch: 0, image_slice_pitch: 0, num_mip_levels: 0, num_samples: 0, buffer: nil)
        
        var errorCode: cl_int = 0
        var formatted = format
        reference = clCreateImage(context.reference, cl_mem_flags(Int32(memFlags.rawValue)), &formatted, &imageDescription, hostPointer, &errorCode)
        
        if let error = CLError(rawValue: errorCode) {
            throw error
        }
    }
}
