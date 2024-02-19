//
//  XLogConsoleBottomBar.swift
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//

import UIKit

protocol XLogConsoleBottomBarDelegate {
    func levelButtonAction(_ sender: UIButton)
    func nameButtonAction(_ sender: UIButton)
    func fullButtonAction(full: Bool)
    func exportButtonAction()
    func historyButtonAction()
    func clearButtonAction()
    func searchTextChangeAction(text: String?)
    func keyboardWillChangeFrame(frame: CGRect)
}

class XLogConsoleBottomBar: UIView {
    var delegate: XLogConsoleBottomBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        levelButton.isHidden = true
        nameButton.isHidden = true
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func showLevel() {
        if !levelButton.isHidden {
            return
        }
        levelButton.isHidden = false
    }

    func showName() {
        if !nameButton.isHidden {
            return
        }
        nameButton.isHidden = false
    }

    func hideFilter() {
        levelButton.isHidden = true
        nameButton.isHidden = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadUI()
    }

    override func layoutSubviews() {
        var safeAreaInsets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safeAreaInsets = self.safeAreaInsets
        }
        contentView.frame = CGRect(x: 8 + safeAreaInsets.left, y: 0, width: frame.width - 16 - safeAreaInsets.right - safeAreaInsets.left, height: 28)
    }

    func loadUI() {
        addSubview(contentView)
        let halfImage = UIImage.log_image(named: "half")
        fullButton.setImage(halfImage?.withRenderingMode(.alwaysTemplate), for: .selected)
        fullButton.setImage(halfImage?.withRenderingMode(.alwaysTemplate), for: [.selected, .highlighted])
        fullButton.adjustsImageWhenHighlighted = false
        fullButton.addTarget(self, action: #selector(fullButtonClick), for: .touchUpInside)
        levelButton.addTarget(self, action: #selector(levelButtonClick), for: .touchUpInside)
        nameButton.addTarget(self, action: #selector(nameButtonClick), for: .touchUpInside)
        exportButton.addTarget(self, action: #selector(exportButtonClick), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(historyButtonClick), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonClick), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            delegate?.keyboardWillChangeFrame(frame: frame)
        }
    }

    @objc func textFiledValueChange(_ sender: UITextField) {
        delegate?.searchTextChangeAction(text: sender.text)
    }

    @objc func levelButtonClick() {
        delegate?.levelButtonAction(levelButton)
    }

    @objc func nameButtonClick() {
        delegate?.nameButtonAction(nameButton)
    }

    @objc func fullButtonClick() {
        fullButton.isSelected = !fullButton.isSelected
        delegate?.fullButtonAction(full: fullButton.isSelected)
    }

    @objc func exportButtonClick() {
        delegate?.exportButtonAction()
    }

    @objc func historyButtonClick() {
        delegate?.historyButtonAction()
    }

    @objc func clearButtonClick() {
        delegate?.clearButtonAction()
        hideFilter()
    }

    func normalButton(imageName: String, setEdgeInsets: Bool = true) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        button.adjustsImageWhenHighlighted = false
        if setEdgeInsets {
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setImage(UIImage.log_image(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = console.textAttributes[.foregroundColor] as? UIColor
        return button
    }

    lazy var levelButton = normalButton(imageName: "filter_level", setEdgeInsets: false)
    lazy var nameButton = normalButton(imageName: "filter_name", setEdgeInsets: false)
    lazy var exportButton = normalButton(imageName: "export")
    lazy var fullButton = normalButton(imageName: "full")
    lazy var clearButton = normalButton(imageName: "trash")
    lazy var historyButton = normalButton(imageName: "history")
    lazy var textField: XLogTextFiled = {
        let textField = XLogTextFiled()
        textField.clearButtonTintColor = console.textAttributes[.foregroundColor] as? UIColor
        var att = console.textAttributes
        var originTextColor: UIColor = (att[.foregroundColor] as? UIColor ?? UIColor.white)
        att[.foregroundColor] = originTextColor.withAlphaComponent(0.4)
        textField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: att)
        textField.returnKeyType = .done
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.tintColor = originTextColor
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.textColor = originTextColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.layer.borderColor = borderColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5
        textField.addTarget(self, action: #selector(textFiledValueChange(_:)), for: .editingChanged)
        return textField
    }()

    lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, levelButton, nameButton, fullButton, exportButton, historyButton, clearButton])
        stackView.spacing = 5
        [levelButton, nameButton, fullButton, exportButton, historyButton, clearButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 28).isActive = true
            button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        }
        stackView.distribution = .fill
        return stackView
    }()

    lazy var borderColor = UIColor.gray.withAlphaComponent(0.6).cgColor
}

extension XLogConsoleBottomBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class XLogTextFiled: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: 8, dy: 0).offsetBy(dx: 0, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.insetBy(dx: 8, dy: 0).offsetBy(dx: 0, dy: 0)
    }

    var clearButton: UIButton? {
        return value(forKey: "clearButton") as? UIButton
    }

    var clearButtonTintColor: UIColor? {
        get {
            return clearButton?.tintColor
        }
        set {
            let image = clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton?.setImage(image, for: .normal)
            clearButton?.tintColor = newValue
        }
    }
}
