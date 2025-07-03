//
//  ConfirmDeletePopupVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import UIKit

class ConfirmDeletePopupVC: UIViewController {

    var onConfirm: (() -> Void)?
    var titleText: String = "Are you sure you want to delete this client?"


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)

        // Close Button (Top Right)
        let closeButton = UIButton(type: .custom)
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        alertView.addSubview(closeButton)

        // Buttons
        let noButton = UIButton(type: .system)
        noButton.setTitle("No", for: .normal)
        noButton.backgroundColor = .red
        noButton.setTitleColor(.white, for: .normal)
        noButton.layer.cornerRadius = 0
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)

        let yesButton = UIButton(type: .system)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.3803921569, blue: 0.1058823529, alpha: 1)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.layer.cornerRadius = 0
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 0
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(buttonStack)

        // Constraints
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 400),
            alertView.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),

            closeButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            buttonStack.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func dismissPopup() {
        self.dismiss(animated: true)
    }

    @objc private func confirmAction() {
        self.dismiss(animated: true) {
            self.onConfirm?()
        }
    }
}
