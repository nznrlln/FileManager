//
//  FileManagerViewController.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 18.09.2022.
//

import UIKit
import PhotosUI

class FileManagerViewController: UIViewController {

    private var currentDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    private var currentDirectoryFilesURL: [URL] {
        guard let array = try? FileManager.default.contentsOfDirectory(at: currentDirectoryURL, includingPropertiesForKeys: nil) else {return []}

        switch UserDefaultSettings.sorting {
        case .alphabet:
            let sortedArray = array.sorted { url1, url2 in
                return url1.lastPathComponent < url2.lastPathComponent
            }
            return sortedArray

        case .reverseAlphabed: let sortedArray = array.sorted { url1, url2 in
            return url1.lastPathComponent > url2.lastPathComponent
        }
        return sortedArray
        }

    }

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
//        debugPrint(currentDirectoryURL)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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

    enum alertMode {
        case createNote
        case createFolder
        case createImage
        case showNote
        case showImage
    }

    private func showAlert(mode: alertMode, content: String?, image: UIImage?, url: URL?) {
        switch mode {
        case .createNote:
            let alertController = UIAlertController(title: "Create Note", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Note name"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Note content"
            }

            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] action in
                if let noteName = alertController.textFields![0].text,
                   let noteContent = alertController.textFields![1].text,
                   noteName != "",
                   noteContent != "" {
                    let newURL = self?.currentDirectoryURL.appendingPathComponent(noteName + ".txt")
                    let newPath = newURL?.path
                    do {
                        try NSString(string: noteContent).write(toFile: newPath!, atomically: true, encoding: String.Encoding.utf8.rawValue)
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                    self?.tableView.reloadData()
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(createAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true)

        case .createImage:
            let alertController = UIAlertController(title: "Create Image", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Image name"
            }

            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] action in
                if let imageName = alertController.textFields![0].text, imageName != "" {
                    do {
                        // Логика: сначала в PHPicker создается картинка, а уже здесь я ее меняю на такое же, но с нормальным именем. Иначе картинка успевает выгрузиться из памяти до того, как придет название из UIAlert
                        if let destinationURL = self?.currentDirectoryURL.appendingPathComponent(imageName + ".jpeg") {
                            try FileManager.default.replaceItemAt(destinationURL, withItemAt: url!)
                            try FileManager.default.removeItem(at: url!)
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                    self?.tableView.reloadData()
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] action in
                do {
                    try FileManager.default.removeItem(at: url!)
                } catch {
                    debugPrint(error.localizedDescription)
                }
                self?.tableView.reloadData()
            }



            alertController.addAction(createAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true)

        case .createFolder:
            let alertController = UIAlertController(title: "Create Folder", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Folder name"
            }

            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] action in
                if let folderName = alertController.textFields![0].text, folderName != "" {
                    let newDirectoryURL = self?.currentDirectoryURL.appendingPathComponent(folderName)
                    do {
                        try FileManager.default.createDirectory(at: newDirectoryURL!, withIntermediateDirectories: false)
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                    self?.tableView.reloadData()
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(createAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true)

        case .showNote:
            let alertController = UIAlertController(title: "Note content", message: content, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .default)
            alertController.addAction(closeAction)

            present(alertController, animated: true)

        case .showImage:
            let alertController = UIAlertController(title: "Image", message: nil, preferredStyle: .alert)

            let imageAction = UIAlertAction(title: "", style: .default)
            imageAction.isEnabled = false

            // отступ подобрал на шару
            let left = (alertController.view.bounds.width - image!.size.width) / 6
            imageAction.setValue(image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0)).withRenderingMode(.alwaysOriginal), forKey: "image")
            

            let closeAction = UIAlertAction(title: "Close", style: .default)

            alertController.addAction(imageAction)
            alertController.addAction(closeAction)

            present(alertController, animated: true)
        }
    }

    @objc private func addNoteButtonTap() {
        debugPrint("addNoteButtonTap")
        showAlert(mode: .createNote, content: nil, image: nil, url: nil)
    }

    @objc private func addFolderButtonTap() {
        debugPrint("addFolderButtonTap")
        showAlert(mode: .createFolder, content: nil, image: nil, url: nil)
    }

    @objc private func addPictureButtonTap() {
        debugPrint("addPictureButtonTap")
        showImagePicker()
    }
}

// MARK: - UITableViewDataSource
extension FileManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentDirectoryFilesURL.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()

        let itemURL = currentDirectoryFilesURL[indexPath.row]
        content.text = itemURL.deletingPathExtension().lastPathComponent

        var isFolder: ObjCBool = false
        _ = try? FileManager.default.fileExists(atPath: itemURL.path, isDirectory: &isFolder)
        if isFolder.boolValue {
            content.secondaryText = "Folder"
        } else {
            content.secondaryText = "File extension: \(itemURL.pathExtension)"
        }
        cell.contentConfiguration = content

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

        let itemURL = currentDirectoryFilesURL[indexPath.row]
        var isFolder: ObjCBool = false
        _ = try? FileManager.default.fileExists(atPath: itemURL.path, isDirectory: &isFolder)
        if isFolder.boolValue {
            let newDirectoryVC = FileManagerViewController()
            newDirectoryVC.currentDirectoryURL = itemURL
            navigationController?.pushViewController(newDirectoryVC, animated: true)

        } else if itemURL.pathExtension == "txt" {
            do {
                let text = try NSString(contentsOfFile: itemURL.path, encoding: String.Encoding.utf8.rawValue)
                showAlert(mode: .showNote, content: text as String, image: nil, url: nil)
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            let image = UIImage(contentsOfFile: itemURL.path)?.resized(toWidth: UIScreen.main.bounds.width / 2)
            showAlert(mode: .showImage, content: nil, image: image, url: nil)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemURL = currentDirectoryFilesURL[indexPath.row]
            _ = try? FileManager.default.removeItem(at: itemURL)
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - PHPickerViewControllerDelegate
extension FileManagerViewController: PHPickerViewControllerDelegate {
    func showImagePicker() {
        var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfiguration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: pickerConfiguration)
        picker.delegate = self
        present(picker, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { [weak self] result in
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { url, error in
                if error == nil {
                    if let destinationURL = self?.currentDirectoryURL.appendingPathComponent("\(Date()).jpeg") {
                        _ = try? FileManager.default.replaceItemAt(destinationURL, withItemAt: url!)
                        DispatchQueue.main.async {
                            self?.showAlert(mode: .createImage, content: nil, image: nil, url: destinationURL)
                        }
                    }
                } else {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.heic") { url, error in
                        if error == nil {
                            if let destinationURL = self?.currentDirectoryURL.appendingPathComponent("\(Date()).jpeg") {
                                _ = try? FileManager.default.replaceItemAt(destinationURL, withItemAt: url!)
                                DispatchQueue.main.async {
                                    self?.showAlert(mode: .createImage, content: nil, image: nil, url: destinationURL)
                                }
                            }
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: .none)
    }

}
