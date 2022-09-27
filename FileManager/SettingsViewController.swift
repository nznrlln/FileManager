//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 25.09.2022.
//

import UIKit

class SettingsViewController: UIViewController {

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

        setupSubviews()
        setupSubviewsLayout()
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

}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 2
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                content.text = "Сортировать в алфавитном порядке"
            } else {
                content.text = "Сортировать в обратном порядке"
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                content.text = "Поменять пароль"
            } else {
                content.text = "Удалить пароль"
            }
        }
        cell.contentConfiguration = content

        return cell
    }

}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            let title = "Сортировка"
            return title
        } else if section == 1 {
            let title = "Настройки пароля"
            return title
        } else {
            return ""
        }
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

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                UserDefaultSettings.sorting = .alphabet
            } else {
                UserDefaultSettings.sorting = .reverseAlphabed
            }
            tableView.reloadData()

        }

        if indexPath.section == 1 {
            if indexPath.row == 0 {
                KeyChain.deletePassword(login: UserDefaultSettings.username, serviceName: UserDefaultSettings.service)
                UserDefaultSettings.passwordState = .existNot
                let vc = LogInViewController()
                present(vc, animated: true)
            } else {
                KeyChain.deletePassword(login: UserDefaultSettings.username, serviceName: UserDefaultSettings.service)
                UserDefaultSettings.passwordState = .existNot
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == UserDefaultSettings.sorting.rawValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
    }

}
