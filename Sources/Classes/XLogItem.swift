//
//  XLogItem.swift
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//

import UIKit

class XLogItem {
    let level: XLogLevel
    let name: String
    var timeAttString: NSAttributedString?
    var logAttString: NSAttributedString?
    var showAttString: NSAttributedString?

    init(level: XLogLevel, name: String) {
        self.level = level
        self.name = name
    }

    var cacheHeight: CGFloat?
    func showString() -> String {
        return showAttString?.string ?? ""
    }

    func resetHeight() {
        cacheHeight = nil
    }

    func searchContain(text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        if let logString = logAttString?.string {
            return logString.lowercased().contains(text.lowercased())
        }
        return false
    }

    static func log(level: XLogLevel, name: String? = nil, content: String) -> XLogItem {
        let logItem = XLogItem(level: level, name: name ?? "Default")
        logItem.timeAttString = NSAttributedString(string: console.timeFormatter.string(from: Date()), attributes: console.timeAttributes)
        var textAttributes = console.textAttributes
        if level != .default {
            textAttributes[.foregroundColor] = level.color
        }
        logItem.logAttString = NSAttributedString(string: content, attributes: textAttributes)
        let showAttString: NSMutableAttributedString = NSMutableAttributedString(attributedString: logItem.timeAttString!)
        showAttString.append(NSAttributedString(string: "  "))
        showAttString.append(logItem.logAttString!)
        logItem.showAttString = showAttString
        return logItem
    }
}
