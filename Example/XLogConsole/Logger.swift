//
//  Logger.swift
//  XLogConsole_Example
//
//  Created by Xing on 2022/9/24.
//

import UIKit
import XLogConsole

extension XLogLevel {
    public static let warn = XLogLevel(rawValue: "Warn", color: .orange)
    public static let error = XLogLevel(rawValue: "Error", color: .red)
}

func XLog(_ content: String?, name: String? = nil,
          _ file: String = #file,
          _ fn: String = #function,
          _ line: Int = #line) {
    _log(content, name: name, level: .default, file, fn, line)
}

func XLogWarn(_ content: String?, name: String? = nil,
              _ file: String = #file,
              _ fn: String = #function,
              _ line: Int = #line) {
    _log(content, name: name, level: .warn, file, fn, line)
}

func XLogError(_ content: String?, name: String? = nil,
               _ file: String = #file,
               _ fn: String = #function,
               _ line: Int = #line) {
    _log(content, name: name, level: .error, file, fn, line)
}

private func _log(_ content: String?, name: String? = nil, level: XLogLevel,
                  _ file: String = #file,
                  _ fn: String = #function,
                  _ line: Int = #line) {
    _ = config
    level.log(content, name: name, file, fn, line)
}

class Logger: NSObject {
    @objc class func log(_ content: String?, name: String? = nil, _ file: String = #file,
                         _ fn: String = #function,
                         _ line: Int = #line) {
        _log(content, name: name, level: .default, file, fn, line)
    }

    @objc class func logWarn(_ content: String?, name: String? = nil, _ file: String = #file,
                             _ fn: String = #function,
                             _ line: Int = #line) {
        _log(content, name: name, level: .warn, file, fn, line)
    }

    @objc class func logError(_ content: String?, name: String? = nil, _ file: String = #file,
                              _ fn: String = #function,
                              _ line: Int = #line) {
        _log(content, name: name, level: .error, file, fn, line)
    }
}

private var config: () = {
    let console = XLogConsole.shared
    #if !DEBUG
        console.enable = false
    #endif
    console.showLogNum = true
//    console.logDetail = true
//    console.textAttributes = [.font: UIFont.boldSystemFont(ofSize: 16)]
//    console.timeAttributes = [.font: UIFont.italicSystemFont(ofSize: 16)]
//    console.backgroundColor = .black
//    console.timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//    console.showConsoleAutomatically = false
}()
