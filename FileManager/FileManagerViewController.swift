//
//  FileManagerViewController.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 18.09.2022.
//

import UIKit

class FileManagerViewController: UIViewController {

    private lazy var addNoteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "note.text.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addNoteButtonTap)
        )
        button.tintColor = UIColor(named: "AccentColor")

        return button
    }()

    private lazy var addFolderButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "folder.fill.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addFolderButtonTap)
        )
        button.tintColor = UIColor(named: "AccentColor")

        return button
    }()

    private lazy var addPictureButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.center.inset.filled.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addPictureButtonTap)
        )
        button.tintColor = UIColor(named: "AccentColor")

        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.toAutoLayout()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor(named: "AccentColor")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewInitialSettings()
    }

    private func viewInitialSettings() {
        view.backgroundColor = .white

        setupNavigationBar()
        setupSubviews()
        setupSubviewsLayout()
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.rightBarButtonItems = [addFolderButton, addPictureButton, addNoteButton]
    }


    private func setupSubviews() {
        view.addSubview(tableView)
    }

    private func setupSubviewsLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func addNoteButtonTap() {
        debugPrint("addNoteButtonTap")
    }

    @objc private func addFolderButtonTap() {
        debugPrint("addFolderButtonTap")
    }

    @objc private func addPictureButtonTap() {
        debugPrint("addPictureButtonTap")
    }
}

// MARK: - UITableViewDataSource
extension FileManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)

        return cell
    }



}

// MARK: - UITableViewDataSource
extension FileManagerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "File Manager"
        return title
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
