//
//  XLogConsole.swift
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//

import UIKit

public struct XLogLevel: Hashable, RawRepresentable {
    /// init
    /// - Parameter rawValue: rawValue
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// init
    /// - Parameters:
    ///   - rawValue: rawValue
    ///   - color: show color
    public init(rawValue: String, color: UIColor) {
        self.rawValue = rawValue
        self.color = color
    }

    /// rawValue
    public let rawValue: String
    private(set) var color: UIColor = console.textAttributes[.foregroundColor] as! UIColor
    public static let `default` = XLogLevel(rawValue: "Default")

    public func log(_ content: String?, name: String? = nil,
                    _ file: String = #file,
                    _ fn: String = #function,
                    _ line: Int = #line) {
        console.log(level: self, name: name, content: content, file, fn, line)
    }
}

let console = XLogConsole.shared
open class XLogConsole {
    public static let shared = XLogConsole()

    /// Whether to enable, default true If false, there will be no events or logs, nothing will be happend
    open var enable = true
    /// The backgroundColor of the console
    open var backgroundColor: UIColor? {
        didSet {
            consoleViewController.backgroundColor = backgroundColor
        }
    }

    /// Whether to show the console icon automatically, default true, if false, console is only show when called method `show`
    open var showConsoleAutomatically = true
    /// Whether to show detailed log, including file name, method name, and line number, default false
    open var logDetail = false
    /// Whether to show current log line num, default false
    open var showLogNum = false
    /// Log text font style
    open var textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 15)] {
        didSet {
            if textAttributes[.foregroundColor] == nil {
                textAttributes[.foregroundColor] = UIColor.white
            }
        }
    }

    /// Log time text font style
    open var timeAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white.withAlphaComponent(0.6), .font: UIFont.systemFont(ofSize: 15)] {
        didSet {
            if timeAttributes[.foregroundColor] == nil {
                timeAttributes[.foregroundColor] = UIColor.white.withAlphaComponent(0.6)
            }
        }
    }

    /// Log formatter, default dateFormat: "HH:mm:ss.SSS"
    public let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f
    }()

    /// Current show log content
    open var logText: String {
        consoleViewController.getLogText()
    }

    /// Add a log
    /// - Parameters:
    ///   - level: log level, for filter and separate show color
    ///   - name: log name, for filter
    ///   - content: log content
    ///   - file: the log source file name
    ///   - fn: the log source function name
    ///   - line: the log source line num
    func log(level: XLogLevel = .default, name: String? = nil, content: String?, _ file: String = #file,
             _ fn: String = #function,
             _ line: Int = #line) {
        guard console.enable, let content = content else {
            return
        }
        var showContent = content
        if console.logDetail {
            showContent = "[" + (file.isEmpty ? "" : "\(((file as NSString).lastPathComponent as NSString).deletingPathExtension).") + "\(fn)" + ":\(line)]\n" + content
        }
        let logItem = XLogItem.log(level: level, name: name, content: showContent)
        console.consoleViewController.log(item: logItem)
        if console.showConsoleAutomatically {
            XLogConsole.show()
        }
    }

    /// show console with icon
    open class func show() {
        if !console.enable {
            print("[XLogConsole]: please set enable true")
            return
        }
        if !console.consoleWindow.isHidden {
            return
        }
        UIView.performWithoutAnimation {
            console.consoleWindow.alpha = 0
            console.consoleWindow.isHidden = false
        }
        UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseOut) {
            console.consoleWindow.alpha = 1
        }
    }

    /// hide console
    open class func hide() {
        console.consoleWindow.isHidden = true
        console.consoleViewController.view.endEditing(true)
    }

    lazy var consoleWindow: XLogWindow = {
        let window = XLogWindow()
        window.adjustWindowScene()
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level(rawValue: 1.0)
        window.rootViewController = consoleViewController
        return window
    }()

    lazy var consoleViewController = XLogConsoleViewController()
}

class XLogWindow: UIWindow {
    func adjustWindowScene() {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if windowScene.activationState.rawValue <= UIScene.ActivationState.foregroundActive.rawValue {
                    self.windowScene = windowScene as? UIWindowScene
                }
            }
            NotificationCenter.default.addObserver(forName: UIScene.willConnectNotification, object: nil, queue: nil) { notificatio in
                self.windowScene = notificatio.object as? UIWindowScene
            }
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            view?.endEditing(true)
            return nil
        }
        return view
    }
}

private let resourceBundle: Bundle = {
    let mainBundle = Bundle(for: XLogConsole.self)
    let podBundlePath = mainBundle.path(forResource: "XLogConsole", ofType: "bundle")
    let packetBundlePath = mainBundle.path(forResource: "XLogConsole_XLogConsole", ofType: "bundle") ?? ""
    return Bundle(path: podBundlePath ?? packetBundlePath) ?? Bundle.main
}()

extension UIImage {
    class func log_image(named: String!) -> UIImage? {
        return UIImage(named: named, in: resourceBundle, compatibleWith: nil)
    }
}
