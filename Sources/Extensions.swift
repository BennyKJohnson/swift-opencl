//
//  Extensions.swift
//  opencl-swift
//
//  Created by Ben Johnson on 12/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

import Foundation
import OpenCL

extension cl_bool {
    
    init(bool: Bool) {
        
        if bool {
            self.init(1)
        } else {
            self.init(0)
        }
      
    }
    
    
}
