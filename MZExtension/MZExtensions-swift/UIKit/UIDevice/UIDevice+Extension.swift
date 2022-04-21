//
//  UIDevice+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/22.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public var machineModel: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let model = String(cString: machine)
        return model
    }
    
    static public var systemVersion: String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    public var isPad: Bool {
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    }
    
    public var isSimulator: Bool {
        #if TARGET_OS_SIMULATOR
        return true
        #else
        return false
        #endif
    }
    
    public var isJailbroken: Bool {
        if self.isSimulator {
            return false
        }
        let paths = ["/Applications/Cydia.app", "/pravate/var/lib/apt/", "/private/var/lib/cydia", "/private/var/stash"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        let path = String.localizedStringWithFormat("/private/%@", UIDevice.uuid)
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    static public var uuid: String {
        let uuid = CFUUIDCreate(nil)
        let string = CFUUIDCreateString(nil, uuid)
        return string! as String
    }
    
    #if __IPHONE_OS_VERSION_MIN_REQUIRED
    public var isCallPhoneEnable: Bool {
        guard let url = URL(string: "tel://") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    #endif
    
    /// get WiFi Addess IP of this device
    public var ipAddressWIFI: String? {
        return self.ipAddress(with: "en0")
    }
    
    /// get cell Adress IP of this device
    public var ipAddressCell: String? {
        return self.ipAddress(with: "pdp_ip0")
    }
    
    fileprivate func ipAddress(with ifaName: String) -> String? {
        var address: String?
        // get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        // for each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == ifaName {
                    // convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}
