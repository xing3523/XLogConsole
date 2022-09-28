//
//  Logger.swift
//  XLogConsole_Example
//
//  Created by Xing on 2022/9/24.
//

import UIKit

public extension XLogLevel {
    static let warn = XLogLevel(rawValue: "Warn", color: .orange)
    static let error = XLogLevel(rawValue: "Error", color: .red)
}

public func XLog(_ content: String?, name: String? = nil,
                 _ file: String = #file,
                 _ fn: String = #function,
                 _ line: Int = #line) {
    _log(content, name: name, level: .default, file, fn, line)
}

public func XLogWarn(_ content: String?, name: String? = nil,
                     _ file: String = #file,
                     _ fn: String = #function,
                     _ line: Int = #line) {
    _log(content, name: name, level: .warn, file, fn, line)
}

public func XLogError(_ content: String?, name: String? = nil,
                      _ file: String = #file,
                      _ fn: String = #function,
                      _ line: Int = #line) {
    _log(content, name: name, level: .error, file, fn, line)
}

private func _log(_ content: String?, name: String? = nil, level: XLogLevel,
                  _ file: String = #file,
                  _ fn: String = #function,
                  _ line: Int = #line) {
    level.log(content, name: name, file, fn, line)
}

// For used on OC
open class XLogger: NSObject {
    @objc public class func log(_ content: String?, name: String? = nil, _ file: String = #file,
                                _ fn: String = #function,
                                _ line: Int = #line) {
        _log(content, name: name, level: .default, file, fn, line)
    }

    @objc public class func logWarn(_ content: String?, name: String? = nil, _ file: String = #file,
                                    _ fn: String = #function,
                                    _ line: Int = #line) {
        _log(content, name: name, level: .warn, file, fn, line)
    }

    @objc public class func logError(_ content: String?, name: String? = nil, _ file: String = #file,
                                     _ fn: String = #function,
                                     _ line: Int = #line) {
        _log(content, name: name, level: .error, file, fn, line)
    }
}
