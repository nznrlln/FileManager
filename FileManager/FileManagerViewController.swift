//
//  FileManagerViewController.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 18.09.2022.
//

import UIKit
import Photos
import PhotosUI

class FileManagerViewController: UIViewController {

    private var currentDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var currentDirectoryFilesURL: [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: currentDirectoryURL, includingPropertiesForKeys: nil)) ?? []
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
        print(currentDirectoryFilesURL)
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
            content.secondaryText = "File"
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


//extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func showImagePicker() {
////        let imagePicker = UIImagePickerController()
////        imagePicker.delegate = self
////        present(imagePicker, animated: true)
//    }
//}
    
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
                    if let destinationURL = self?.currentDirectoryURL.appendingPathComponent("\(Date())") {
                        _ = try? FileManager.default.replaceItemAt(destinationURL, withItemAt: url!)
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: .none)
    }


}
