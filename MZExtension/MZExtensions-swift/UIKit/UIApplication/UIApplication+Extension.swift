//
//  UIApplication+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/22.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

extension UIApplication {
    
    /// url of 'Document' folder in app`s sandbox
    public var documentUrl: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    /// path of 'Document' folder in app`s sandbox
    public var documentPath: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    /// url of 'Caches' folder in this app`s sandbox
    public var cachesUrl: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    
    /// path of 'Caches' folder in this app`s sandbox
    public var cachesPath: String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    /// url of 'Library' folder in this app`s sandbox
    public var libraryUrl: URL? {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    
    /// path of 'Library' folder in this app`s sandbox
    public var libraryPath: String? {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }
    
    /// Application`s Bundle Name
    public var appBundleName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    /// Application`s Bundle Id e.g 'com.xxxxxx.app'
    public var appBundleId: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
    
    /// Application`s Bundle Version e.g '1.0.0'
    public var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// Application`s Bundle Version e.g '12'
    public var appBundleVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    /// wether this app is not install from appstroe
    public var isPirated: Bool {
        if UIDevice.current.isSimulator {
            return true
        }
        // process Id shouldn't be root
        if getgid() <= 10 {
            return true
        }
        if Bundle.main.infoDictionary!["SignerIdentity"] != nil {
            return true
        }
        if self.fileExistInMainBundle(name: "_CodeSignature") {
            return true
        }
        if self.fileExistInMainBundle(name: "SC_Info") {
            return true
        }
        return false
    }
    
    fileprivate func fileExistInMainBundle(name: String) -> Bool {
        let bundlePath = Bundle.main.bundlePath
        let path = String(format: "%@%@", bundlePath, name)
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// whether this app is being debugged
    public var isBeingDebugged: Bool {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    
    /// current thread real memory used in byte
    public var memoryUsage: Float? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) { infoPtr in
            return infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { (machPtr: UnsafeMutablePointer<integer_t>) in
                return task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), machPtr, &count)
            }
        }
        guard kerr == KERN_SUCCESS else {
            return nil
        }
        return Float(info.resident_size) / (1024 * 1024)
    }
    
    /// YY原方法不是很准确,计算出来的CPU占用率会维持一个值基本没有变化, 代码中的_prevCPUInfo和_numPrevCPUInfo 等使用的是局部变量, 这会造成对_prevCPUInfo非空的判断总是为假, 最终计算_cpuInfo和_prevCPUInfo差值的那段代码根本不会执行
    public var cpuUsage: Float {
        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        var previous_info = host_cpu_load_info()
        var cpuLoadInfo = host_cpu_load_info()
        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        if result != KERN_SUCCESS {
            return -1
        }
        let user = cpuLoadInfo.cpu_ticks.0 - previous_info.cpu_ticks.0
        let system = cpuLoadInfo.cpu_ticks.1 - previous_info.cpu_ticks.1
        let idle = cpuLoadInfo.cpu_ticks.2 - previous_info.cpu_ticks.2
        let nice = cpuLoadInfo.cpu_ticks.3 - previous_info.cpu_ticks.3
        let total = user + nice + idle + system
        previous_info = cpuLoadInfo
        return Float((user + nice + system) * 100 / total)
    }
}
