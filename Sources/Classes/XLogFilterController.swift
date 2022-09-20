//
//  XLogFilterController.swift
//  XLogConsole
//
//  Created by Xing on 2022/9/24.
//

import UIKit

class XLogFilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var filterChangeBlock: (([String]) -> Void)?
    var dataArray = [String]() {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(XLogFilterCell.self)) as! XLogFilterCell
        cell.titleLabel.text = dataArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterChangeAction()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        filterChangeAction()
    }

    func filterChangeAction() {
        var selectArray: [String] = []
        if let selectRows = tableView.indexPathsForSelectedRows {
            selectArray = selectRows.map({ indexPath in
                dataArray[indexPath.row]
            })
        }
        filterChangeBlock?(selectArray)
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 24
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(XLogFilterCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(XLogFilterCell.self))

        return tableView
    }()

    class XLogFilterCell: UITableViewCell {
        let titleLabel = UILabel()
        let selectLabel = UILabel()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            loadUI()
        }

        func loadUI() {
            backgroundColor = .white
            selectionStyle = .none
            contentView.addSubview(titleLabel)
            contentView.addSubview(selectLabel)
            titleLabel.font = UIFont.systemFont(ofSize: 10)
            titleLabel.textColor = .black
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.6

            selectLabel.text = "✔️"
            selectLabel.font = UIFont.systemFont(ofSize: 10)
            selectLabel.textColor = .black

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true

            selectLabel.translatesAutoresizingMaskIntoConstraints = false
            selectLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
            selectLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            selectLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            selectLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
            selectLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            selectLabel.isHidden = !selected
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
