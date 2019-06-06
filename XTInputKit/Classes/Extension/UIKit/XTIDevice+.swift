//
//  XTIDevice+.swift
//  XTInputKit
//
//  Created by xt-input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//
import UIKit

public enum UIDeviceType: String {
    public typealias RawValue = String

    case iPodTouch4 = "iPod Touch 4"
    case iPodTouch5 = "iPod Touch 5"
    case iPodTouch6 = "iPod Touch 6"

    case iPhone4 = "iPhone 4"
    case iPhone4s = "iPhone 4s"
    case iPhone5 = "iPhone 5"
    case iPhone5c = "iPhone 5c"
    case iPhone5s = "iPhone 5s"
    case iPhoneSE = "iPhone SE"
    case iPhone6 = "iPhone 6"
    case iPhone6s = "iPhone 6s"
    case iPhone7 = "iPhone 7"
    case iPhone8 = "iPhone 8"
    case iPhone6P = "iPhone 6 Plus"
    case iPhone6sP = "iPhone 6s Plus"
    case iPhone7P = "iPhone 7 Plus"
    case iPhone8P = "iPhone 8 Plus"
    case iPhoneX = "iPhone X"
    case iPhoneXR = "iPhone XR"
    case iPhoneXS = "iPhone XS"
    case iPhoneXSMax = "iPhone XS Max"

    case iPad
    case iPad2 = "iPad 2"
    case iPad3 = "iPad 3"
    case iPad4 = "iPad 4"
    case iPad5 = "iPad 5"
    case iPad6 = "iPad 6"

    case iPadAir = "iPad Air"
    case iPadAir2 = "iPad Air 2"

    case iPadPro9_7 = "iPad Pro 9.7"
    case iPadPro12_9 = "iPad Pro 12.9"

    case iPadPro10_5 = "iPad Pro 10.5"

    case iPadPro12_9_2 = "iPad Pro 12.9 2"

    case iPadPro11 = "iPad Pro 11"
    case iPadPro12_9_3 = "iPad Pro 12.9 3"

    case iPadMini = "iPad Mini"
    case iPadMini2 = "iPad Mini 2"
    case iPadMini3 = "iPad Mini 3"
    case iPadMini4 = "iPad Mini 4"

    case Simulator
    case Unkown
}

extension UIDevice: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == UIDevice {
    // 获取设备具体详细的型号
    var modelName: UIDeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod4,1":
            return .iPodTouch4
        case "iPod5,1":
            return .iPodTouch5
        case "iPod7,1":
            return .iPodTouch6

        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return .iPhone4
        case "iPhone4,1":
            return .iPhone4s
        case "iPhone5,1", "iPhone5,2":
            return .iPhone5
        case "iPhone5,3", "iPhone5,4":
            return .iPhone5c
        case "iPhone6,1", "iPhone6,2":
            return .iPhone5s
        case "iPhone7,2":
            return .iPhone6
        case "iPhone7,1":
            return .iPhone6P
        case "iPhone8,1":
            return .iPhone6s
        case "iPhone8,2":
            return .iPhone6sP
        case "iPhone8,4":
            return .iPhoneSE
        case "iPhone9,1", "iPhone9,3":
            return .iPhone7
        case "iPhone9,2", "iPhone9,4":
            return .iPhone7P
        case "iPhone10,1", "iPhone10,4":
            return .iPhone8
        case "iPhone10,2", "iPhone10,5":
            return .iPhone8P
        case "iPhone10,3", "iPhone10,6":
            return .iPhoneX
        case "iPhone11,8":
            return .iPhoneXR
        case "iPhone11,2":
            return .iPhoneXS
        case "iPhone11,6":
            return .iPhoneXSMax

        case "iPad1,1":
            return .iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return .iPadAir
        case "iPad5,3", "iPad5,4":
            return .iPadAir2

        case "iPad2,5", "iPad2,6", "iPad2,7":
            return .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return .iPadMini2
        case "iPad4, 7", "iPad4, 8", "iPad4, 9":
            return .iPadMini3
        case "iPad5,1", "iPad5,2":
            return .iPadMini4

        case "iPad6,7", "iPad6,8":
            return .iPadPro12_9
        case "iPad6,3", "iPad6,4":
            return .iPadPro9_7
        case "iPad6,11", "iPad6,12":
            return .iPad5
        case "iPad7,1", "iPad7,2":
            return .iPadPro12_9_2
        case "iPad7,3", "iPad7,4":
            return .iPadPro10_5
        case "iPad7,5", "iPad7,6":
            return .iPad6
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return .iPadPro11
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return .iPadPro12_9_3
        case "i386", "x86_64":
            return .Simulator
        default:
            return .Unkown
        }
    }
}
