//
//  ViewController.swift
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//  Copyright (c) 2022 Xing. All rights reserved.
//

import UIKit
import XLogConsole

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        logTest()
    }

    @IBAction func logNormal(_ sender: UIButton) {
        let isLongText = arc4random() % 2 == 1
        XLog(getNormalText(isLongText: isLongText), name: isLongText ? "long" : nil)
    }

    @IBAction func logWarn(_ sender: UIButton) {
        let isLongText = arc4random() % 2 == 1
        XLogWarn(getWarnText(isLongText: isLongText), name: isLongText ? "long" : nil)
    }

    @IBAction func logError(_ sender: UIButton) {
        let isLongText = arc4random() % 2 == 1
        XLogError(getErrorText(isLongText: isLongText), name: isLongText ? "long" : nil)
    }

    @IBAction func logOcTest(_ sender: UIButton) {
        TestOC.logTest()
        TestOC().logTest(withName: "logOC")
    }

    @IBAction func showConsole(_ sender: UIButton) {
        XLogConsole.show()
    }

    func logTest() {
        XLog(getNormalText(isLongText: false))
        XLogError(getErrorText(isLongText: true), name: "long")
        XLogLevel.warn.log("use direct")
        XLogLevel.default.log("use direct")
    }

    func getNormalText(isLongText: Bool) -> String {
        let normalStr = "normal"
        if isLongText {
            return normalStr + getLongStr()
        } else {
            return normalStr
        }
    }

    func getWarnText(isLongText: Bool) -> String {
        let warnStr = "Warn"
        if isLongText {
            return warnStr + getLongStr()
        } else {
            return warnStr
        }
    }

    func getErrorText(isLongText: Bool) -> String {
        let errorStr = "Error"
        if isLongText {
            return errorStr + getLongStr()
        } else {
            return errorStr
        }
    }

    func getLongStr() -> String {
        var longStr = ""
        for _ in 0 ..< (arc4random() % 10 + 5) {
            longStr += ",this is a long data"
        }
        return longStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
