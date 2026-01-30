//
//  PaymentConfirmationPopupVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 24/07/25.
//

import UIKit

class PaymentConfirmationPopupVC: UIViewController {

    var onConfirm: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let dialogView = UIView()
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 12
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogView)

        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm Payment Status", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 18)
        confirmButton.layer.cornerRadius = 12
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 206/255, green: 71/255, blue: 250/255, alpha: 1).cgColor,
            UIColor(red: 146/255, green: 93/255, blue: 249/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        gradient.cornerRadius = 12

        let gradientContainer = UIView()
        gradientContainer.layer.insertSublayer(gradient, at: 0)
        gradientContainer.layer.cornerRadius = 12
        gradientContainer.translatesAutoresizingMaskIntoConstraints = false
        gradientContainer.addSubview(confirmButton)

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        dialogView.addSubview(gradientContainer)
        dialogView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialogView.widthAnchor.constraint(equalToConstant: 300),

            gradientContainer.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
            gradientContainer.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 20),
            gradientContainer.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -20),
            gradientContainer.heightAnchor.constraint(equalToConstant: 50),

            confirmButton.leadingAnchor.constraint(equalTo: gradientContainer.leadingAnchor,constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: gradientContainer.trailingAnchor),
            confirmButton.topAnchor.constraint(equalTo: gradientContainer.topAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -5),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),

            dialogView.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor, constant: 20)
        ])

        confirmButton.addAction(UIAction { _ in
            self.onConfirm?()
        }, for: .touchUpInside)

        closeButton.addAction(UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
    }
}
