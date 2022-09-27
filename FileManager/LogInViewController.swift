//
//  LogInViewController.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 22.09.2022.
//

import UIKit

class LogInViewController: UIViewController {

    private var firstPassword: String? = nil

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.toAutoLayout()
        textField.placeholder = " Enter password"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(named: "AccentColor")?.cgColor

        return textField
    }()

    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "AccentColor")
        button.addTarget(self, action: #selector(passwordButtonTap), for: .touchUpInside)


        return button
    }()

    private lazy var passwordVisibilityButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.layer.cornerRadius = 10
        button.setBackgroundImage(UIImage(systemName: "eye.square"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = UIColor(named: "AccentColor")
        button.addTarget(self, action: #selector(passwordVisibilityButtonTap), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewInitialSettings()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        firstPassword = nil
        passwordTextField.text = ""
        viewInitialSettings()
    }
    
    private func viewInitialSettings() {
        view.backgroundColor = .white
        setupSubviews()
        setupSubviewsLayout()

        if UserDefaultSettings.passwordState.rawValue == 1 {
            passwordButton.setTitle("Введите пароль", for: .normal)
        } else {
            passwordButton.setTitle("Создать пароль", for: .normal)
        }
    }

    private func setupSubviews() {
        view.addSubviews(passwordTextField, passwordButton, passwordVisibilityButton)
    }

    private func setupSubviewsLayout() {
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),

            passwordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            passwordButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            passwordButton.trailingAnchor.constraint(equalTo: passwordVisibilityButton.leadingAnchor, constant: -16),

            passwordVisibilityButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            passwordVisibilityButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            passwordVisibilityButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
            passwordVisibilityButton.widthAnchor.constraint(equalTo: passwordVisibilityButton.heightAnchor)
        ])
    }

    private func checkPassword(completion: ((_ password: String) -> Void)?) throws {
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces),
              password != "" else {
            throw AppErrors.emptyPassword
        }
        if password.count < 4 {
            showAlert(message: AppErrors.shortPassword.description)
            throw AppErrors.shortPassword
        }

        debugPrint("first: \(firstPassword)")
        if firstPassword != nil, password == firstPassword {
            // create password
            KeyChain.addPassword(login: UserDefaultSettings.username, password: password, serviceName: UserDefaultSettings.service)
            debugPrint("Пароль создан")
//            viewState = .exist
            UserDefaultSettings.passwordState = .exist
            showVC()
        } else if firstPassword != nil, password != firstPassword {
            firstPassword = nil
            passwordButton.setTitle("Создать пароль", for: .normal)
            passwordTextField.text = ""
            throw AppErrors.mismatchPassword
        }

        completion?(password)

    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default)
        alertController.addAction(closeAction)

        present(alertController, animated: true)
    }

    private func showVC() {
        let vc = MainTabBarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func passwordButtonTap() {

        switch UserDefaultSettings.passwordState {

        case .existNot:
            do {
                try checkPassword(completion: nil)
                firstPassword = passwordTextField.text
                passwordButton.setTitle("Повторите пароль", for: .normal)
                passwordTextField.text = ""
            } catch {
                if let appError = error as? AppErrors{
                    showAlert(message: appError.description)
                }
            }

        case .exist:
            do {
                try checkPassword() { [weak self] password in
                    if let keyPassword = KeyChain.getPassword(login: UserDefaultSettings.username, serviceName: UserDefaultSettings.service),
                    password == keyPassword {
                        self?.showVC()
                    } else {
                        self?.showAlert(message: AppErrors.mismatchPassword.description)
                    }
                }
            } catch {
                if let appError = error as? AppErrors{
                    showAlert(message: appError.description)
                }
            }

        }

    }

    @objc private func passwordVisibilityButtonTap() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
}
