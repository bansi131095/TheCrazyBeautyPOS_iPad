//
//  DropdownManager.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import Foundation
import UIKit


class DropdownManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    static let shared = DropdownManager()
    
    private var dropdowns: [UITextField: UITableView] = [:]
    private var selectedTextField: UITextField?
    var dropdownData: [UITextField: [String]] = [:]
    private weak var parentView: UIView?
    private var selectionActionMap: [UITextField: (String) -> Void] = [:]

    private override init() {}
    
    func setupDropdown(for textField: UITextField, in view: UIView, with data: [String], width: CGFloat = 0, selectionAction: @escaping (String) -> Void) {
        parentView = view
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        textField.addGestureRecognizer(tapGesture)
        textField.isUserInteractionEnabled = true
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 10
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        // Store data and selection handler
        dropdowns[textField] = tableView
        dropdownData[textField] = data
        selectionActionMap[textField] = selectionAction
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: -30),
            tableView.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            width == 0 ? tableView.widthAnchor.constraint(equalTo: textField.widthAnchor) : tableView.widthAnchor.constraint(equalToConstant: width),
            tableView.heightAnchor.constraint(equalToConstant: data.count < 10 ? CGFloat(data.count * 45) : 450)
        ])
    }

    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let textField = gesture.view as? UITextField,
              let tableView = dropdowns[textField] else { return }
        
        selectedTextField = textField
        parentView?.endEditing(true)
        // Determine the new visibility for the tapped textField's dropdown
        let shouldShow = tableView.isHidden // we will toggle this
        
        // Hide all other dropdowns
        for (tf, tbl) in dropdowns {
            tbl.isHidden = true
        }

        // Show only the tapped one if it was hidden
        if shouldShow {
            tableView.reloadData()
            tableView.isHidden = false
        }
        
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let textField = selectedTextField else { return 0 }
        return dropdownData[textField]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let textField = selectedTextField,
                  let items = dropdownData[textField] else {
                cell.textLabel?.text = ""
                return cell
        }
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let textField = selectedTextField,
              let items = dropdownData[textField],
              indexPath.row >= 0, indexPath.row < items.count else {
            return
        }
        selectedTextField?.text = items[indexPath.row]
        let selectedItem = items[indexPath.row]
        textField.text = selectedItem
        tableView.isHidden = true

        if let handler = selectionActionMap[textField] {
            handler(selectedItem)
        }
    }


}
