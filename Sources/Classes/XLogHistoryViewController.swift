//
//  XLogHistoryViewController.swift
//  XLogConsole
//
//  Created by xing on 2024/2/18.
//

import UIKit

class XLogHistoryViewController: UIViewController {
    var logDir: URL?
    var fileNames = [String]()
    lazy var tableView = UITableView(frame: view.bounds, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "History"
        view.backgroundColor = .white
        loadUI()
        loadData()
    }
    
    func loadUI() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.log_image(named: "clear"), style: .plain, target: self, action: #selector(clearAction))
    }
    
    func loadData() {
        if let logDir = logDir {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: logDir, includingPropertiesForKeys: nil)
                fileNames = fileURLs.map { $0.lastPathComponent }.filter { $0.hasSuffix(".txt") }.sorted().reversed()
            } catch {
                print("Error while fetching files in log directory: \(error)")
            }
        }
    }
    
    @objc func clearAction() {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure to clear all history?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: { _ in
            if let logDir = self.logDir {
                try? FileManager.default.removeItem(at: logDir)
                self.fileNames.removeAll()
                self.tableView.reloadData()
                try? FileManager.default.createDirectory(at: logDir, withIntermediateDirectories: true)
            }
        }))
        present(alert, animated: true)
    }
    
    func showIn(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: self)
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .crossDissolve
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = closeButton
        vc.present(nav, animated: true, completion: nil)
    }
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
extension XLogHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let fileName = fileNames[indexPath.row]
        cell.textLabel?.text = String(fileName.prefix(fileName.count - 4))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let fileUrl = self.logDir?.appendingPathComponent(fileNames[indexPath.row]) {
                try? FileManager.default.removeItem(at: fileUrl)
                fileNames.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let preVC = XLogPreViewController()
        let fileUrl = self.logDir?.appendingPathComponent(fileNames[indexPath.row])
        if let fileUrl = fileUrl {
            preVC.content = try? String(contentsOf: fileUrl, encoding: .utf8)
        }
        navigationController?.pushViewController(preVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

class XLogPreViewController: UIViewController {
    var content: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Log"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.log_image(named: "log_export"), style: .plain, target: self, action: #selector(exportAction))
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.text = content
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func exportAction() {
        if let content = content {
            let activityViewController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
}
