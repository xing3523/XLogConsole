//
//  XLogConsoleViewController.swift
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//

import UIKit

class XLogConsoleViewController: UIViewController {
    var showLarge = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.reloadSize()
            }
        }
    }

    var searchText: String = ""
    var levelDataSet = NSMutableOrderedSet()
    var nameDataSet = NSMutableOrderedSet()
    let levelFilterSet = NSMutableSet()
    let nameFilterSet = NSMutableSet()
    var dataArray = [XLogItem]()
    var showArray = [XLogItem]()
    var backgroundColor: UIColor? = .black.withAlphaComponent(0.8) {
        didSet {
            if isViewLoaded {
                contentView.backgroundColor = backgroundColor
            }
        }
    }

    var viewFrame: CGRect = .zero
    var keyboardFrame: CGRect = .zero
    var showBtnTransformScalePoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        loadUI()
    }

    func loadUI() {
        view.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(toolBar)
        toolBar.delegate = self
    }

    override func viewDidLayoutSubviews() {
        if viewFrame.equalTo(view.frame) {
            return
        }
        viewFrame = view.frame
        reloadSize()
        checkShowButtonFrame()
    }

    func reloadSize() {
        var frame = view.frame
        var safeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            safeAreaInsets = view.safeAreaInsets
        }
        frame.size.height = ceil(showLarge ? view.frame.height - safeAreaInsets.top : max(100, view.frame.height / 3))
        frame.origin.y = view.frame.height - frame.size.height
        if !keyboardFrame.isEmpty, keyboardFrame.minY < view.frame.height {
            frame.size.height = min(frame.size.height, view.frame.height - safeAreaInsets.top - keyboardFrame.height)
            frame.origin.y = view.frame.height - frame.height - keyboardFrame.height
        }
        contentView.frame = frame
        let toolBarHeight = safeAreaInsets.bottom + 28
        tableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - toolBarHeight - 8)
        toolBar.frame = CGRect(x: 0, y: frame.height - toolBarHeight, width: frame.width, height: toolBarHeight)
    }

    func checkShowButtonFrame(hasChange: Bool = false) {
        var safeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            safeAreaInsets = view.safeAreaInsets
        }
        if !hasChange {
            showButton.center = CGPoint(x: showBtnTransformScalePoint.x * view.frame.width, y: showBtnTransformScalePoint.y * view.frame.height)
        }
        let showContentView = contentView.alpha == 1
        if showContentView {
            showButton.center = CGPoint(x: view.frame.width - safeAreaInsets.right - showButton.frame.width / 2 - 8, y: view.frame.height - max(100, view.frame.height / 3) + 30)
        }
        var showBtnCenter = showButton.center
        showBtnCenter.x = max(showBtnCenter.x, safeAreaInsets.left + showButton.frame.width / 2)
        showBtnCenter.x = min(showBtnCenter.x, view.frame.width - safeAreaInsets.right - showButton.frame.width / 2)
        showBtnCenter.y = max(showBtnCenter.y, safeAreaInsets.top + showButton.frame.height / 2)
        showBtnCenter.y = min(showBtnCenter.y, view.frame.height - safeAreaInsets.bottom - showButton.frame.height / 2)
        showButton.center = showBtnCenter
        if !showContentView {
            showBtnTransformScalePoint = CGPoint(x: showBtnCenter.x / view.frame.width, y: showBtnCenter.y / view.frame.height)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if !view.frame.size.equalTo(size) {
            for item in showArray {
                item.resetHeight()
            }
            tableView.reloadData()
        }
    }

    lazy var levelFilterController: XLogFilterController = {
        let vc = XLogFilterController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 64, height: 72)
        vc.filterChangeBlock = { [weak self] selectLevels in
            self?.levelFilterSet.removeAllObjects()
            self?.levelFilterSet.addObjects(from: selectLevels)
            self?.searchTextChangeAction(text: self?.searchText)
        }
        return vc
    }()

    lazy var nameFilterController: XLogFilterController = {
        let vc = XLogFilterController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 80, height: 72)
        vc.filterChangeBlock = { [weak self] selectNames in
            self?.nameFilterSet.removeAllObjects()
            self?.nameFilterSet.addObjects(from: selectNames)
            self?.searchTextChangeAction(text: self?.searchText)
        }
        return vc
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = 0
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(XLogConsoleItemCell.self, forCellReuseIdentifier: XLogConsoleItemCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()

    lazy var showButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.setImage(UIImage.log_image(named: "icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(touchConsoleAction(_:)), for: .touchUpInside)
        button.addGestureRecognizer(longPressGesture)
        button.addGestureRecognizer(panGesture)
        panGesture.require(toFail: longPressGesture)
        return button
    }()

    lazy var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))

    let toolBar = XLogConsoleBottomBar()
}

/// Actions
extension XLogConsoleViewController {
    func log(item: XLogItem) {
        dataArray.append(item)
        let levelCount = levelDataSet.count
        let nameCount = nameDataSet.count
        levelDataSet.add(item.level.rawValue)
        nameDataSet.add(item.name)
        if levelDataSet.count > 1 {
            toolBar.showLevel()
        }
        if nameDataSet.count > 1 {
            toolBar.showName()
        }
        if levelCount != levelDataSet.count {
            levelFilterController.dataArray = levelDataSet.array as! [String]
        }
        if nameCount != nameDataSet.count {
            nameFilterController.dataArray = nameDataSet.array as! [String]
        }
        var hasNewShow = false
        if isFilter(item: item) {
            if searchText.isEmpty {
                showArray.append(item)
                hasNewShow = true
            } else {
                if item.searchContain(text: searchText) {
                    showArray.append(item)
                    hasNewShow = true
                }
            }
        }
        if hasNewShow {
            tableView.reloadData()
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: IndexPath(row: self.showArray.count - 1, section: 0), at: .bottom, animated: true)
            }

            if showButton.isHidden {
                showButton.isHidden = false
                view.addSubview(showButton)
                showButton.center = CGPoint(x: 30, y: view.frame.height - 100)
                checkShowButtonFrame(hasChange: true)
            }
        }
    }

    func isFilter(item: XLogItem) -> Bool {
        var isLevelFilter = false, isNameFilter = false
        if levelFilterSet.count == 0 || levelFilterSet.count == levelDataSet.count {
            isLevelFilter = true
        } else {
            isLevelFilter = levelFilterSet.contains(item.level.rawValue)
        }
        if nameFilterSet.count == 0 || nameFilterSet.count == nameDataSet.count {
            isNameFilter = true
        } else {
            isNameFilter = nameFilterSet.contains(item.name)
        }
        return isLevelFilter && isNameFilter
    }

    func filterData() -> [XLogItem] {
        if levelFilterSet.count == 0 || levelFilterSet.count == levelDataSet.count, nameFilterSet.count == 0 || nameFilterSet.count == nameDataSet.count {
            return dataArray
        } else {
            return dataArray.filter { isFilter(item: $0) }
        }
    }

    @objc func touchConsoleAction(_ sender: UIButton) {
        let willShow = contentView.alpha == 0
        UIView.animate(withDuration: 0.25) {
            self.contentView.alpha = willShow ? 1 : 0
            sender.alpha = 0
            sender.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { _ in
            sender.transform = .identity
            self.checkShowButtonFrame()
            sender.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.25) {
                sender.transform = .identity
                sender.alpha = willShow ? 0.4 : 1
            } completion: { _ in
                if !willShow {
                    self.view.endEditing(true)
                }
            }
        }
        longPressGesture.isEnabled = !willShow
        panGesture.isEnabled = !willShow
    }

    @objc func longPressGestureAction(_ recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            UIView.animate(withDuration: 0.2) {
                self.showButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                XLogConsole.hide()
                self.showButton.transform = .identity
            }
        }
    }

    @objc func panGestureAction(_ recog: UIPanGestureRecognizer) {
        switch recog.state {
        case .changed:
            let translation = recog.translation(in: view)
            showButton.center = CGPoint(x: showButton.center.x + translation.x, y: showButton.center.y + translation.y)
            recog.setTranslation(.zero, in: view)
        case .ended:
            checkShowButtonFrame(hasChange: true)
        case .cancelled, .failed:
            checkShowButtonFrame()
        default:
            break
        }
    }
}

extension XLogConsoleViewController: UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XLogConsoleItemCell.description()) as! XLogConsoleItemCell
        let item = showArray[indexPath.row]
        if console.showLogNum {
            let att = item.showAttString?.mutableCopy() as! NSMutableAttributedString
            att.insert(NSAttributedString(string: "[\(indexPath.row + 1)] ", attributes: console.textAttributes), at: 0)
            cell.textView.attributedText = att
        } else {
            cell.textView.attributedText = item.showAttString
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return showArray[indexPath.row].cacheHeight ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if showArray[indexPath.row].cacheHeight == nil {
            showArray[indexPath.row].cacheHeight = cell.frame.height
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension XLogConsoleViewController: XLogConsoleBottomBarDelegate {
    func levelButtonAction(_ sender: UIButton) {
        showFilterController(levelFilterController, onSender: sender)
    }

    func nameButtonAction(_ sender: UIButton) {
        showFilterController(nameFilterController, onSender: sender)
    }

    func showFilterController(_ vc: XLogFilterController, onSender sender: UIButton) {
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.sourceView = sender
        vc.popoverPresentationController?.sourceRect = sender.bounds
        vc.popoverPresentationController?.backgroundColor = .white
        present(vc, animated: true, completion: nil)
    }

    func fullButtonAction(full: Bool) {
        showLarge = full
    }

    func keyboardWillChangeFrame(frame: CGRect) {
        if frame.minY < view.frame.height {
            keyboardFrame = frame
        } else {
            keyboardFrame = .zero
        }
        UIView.animate(withDuration: 0.25) {
            self.reloadSize()
            if self.keyboardFrame.isEmpty {
                self.showButton.transform = .identity
            } else {
                self.showButton.transform = CGAffineTransform(translationX: 0, y: -frame.height)
            }
        }
    }

    func exportButtonAction() {
        let activityViewController = UIActivityViewController(activityItems: [getLogText()], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    func getLogText() -> String {
        var text = ""
        if console.showLogNum {
            var num = 0
            text = showArray.reduce("") { partialResult, logItem in
                num += 1
                return partialResult + "[\(num)] " + logItem.showString() + "\n"
            }
        } else {
            text = showArray.reduce("") { partialResult, logItem in
                partialResult + logItem.showString() + "\n"
            }
        }
        return text
    }

    func clearButtonAction() {
        levelDataSet.removeAllObjects()
        levelFilterSet.removeAllObjects()
        nameDataSet.removeAllObjects()
        nameFilterSet.removeAllObjects()
        dataArray.removeAll()
        showArray.removeAll()
        tableView.reloadData()
    }

    func searchTextChangeAction(text: String?) {
        searchText = text ?? ""
        if searchText.isEmpty {
            showArray = filterData()
        } else {
            showArray = filterData().filter { $0.searchContain(text: searchText) }
        }
        tableView.reloadData()
    }
}

class XLogConsoleItemCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(textView)
        textView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]
    }

    func sizeThatFits(size: CGSize) -> CGSize {
        var size = textView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        size.height = ceil(size.height)
        return size
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return sizeThatFits(size: targetSize)
    }

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.frame = contentView.bounds
        textView.textContainerInset = .init(top: 2, left: 0, bottom: 2, right: 0)
        textView.backgroundColor = .clear
        textView.scrollsToTop = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        }
        return textView
    }()
}
