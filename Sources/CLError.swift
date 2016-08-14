//
//  CLError.swift
//  opencl-swift
//
//  Created by Ben Johnson on 12/08/2016.
//  Copyright © 2016 Ben Johnson. All rights reserved.
//

public enum CLError: Int32, Error {
 //   case success = 0, Success code 0, is not a error
    case deviceNotFound = -1
    case deviceNotAvailable = -2
    case compilerNotAvailable = -3
    case memObjectAllocationFailure = -4
    case outOfResources = -5
    case outOfHostMemory = -6
    case profilingInfoNotAvailable = -7
    case memCopyOverlap = -8
    case imageFormatMismatch = -9
    case imageFormatNotSupported = -10
    case buildProgramFailure = -11
    case mapFailure = -12
    case misalignedSubBufferOffset = -13
    case execStatusErrorForEventsInWaitList = -14
    case compileProgramFailure = -15
    case linkerNotAvailable = -16
    case linkProgramFailure = -17
    case devicePartitionFailed = -18
    case kernelArgInfoNotAvailable = -19
    case invalidValue = -30
    case invalidDeviceType = -31
    case invalidPlatform = -32
    case invalidDevice = -33
    case invalidContext = -34
    case invalidQueueProperties = -35
    case invalidCommandQueue = -36
    case invalidHostPtr = -37
    case invalidMemObject = -38
    case invalidImageFormatDescriptor = -39
    case invalidImageSize = -40
    case invalidSampler = -41
    case invalidBinary = -42
    case invalidBuildOptions = -43
    case invalidProgram = -44
    case invalidProgramExecutable = -45
    case invalidKernelName = -46
    case invalidKernelDefinition = -47
    case invalidKernel = -48
    case invalidArgIndex = -49
    case invalidArgValue = -50
    case invalidArgSize = -51
    case invalidKernelArgs = -52
    case invalidWorkDimension = -53
    case invalidWorkGroupSize = -54
    case invalidWorkItemSize = -55
    case invalidGlobalOffset = -56
    case invalidEventWaitList = -57
    case invalidEvent = -58
    case invalidOperation = -59
    case invalidGlObject = -60
    case invalidBufferSize = -61
    case invalidMipLevel = -62
    case invalidGlobalWorkSize = -63
    case invalidProperty = -64
    case invalidImageDescriptor = -65
    case invalidCompilerOptions = -66
    case invalidLinkerOptions = -67
    case invalidDevicePartitionCount = -68
}
