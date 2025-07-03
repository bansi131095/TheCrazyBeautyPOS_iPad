//
//  TagView.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import UIKit


class TagView: UIView {

    private let label = UILabel()
    private let removeButton = UIButton(type: .custom)

    var onRemove: (() -> Void)?

    init(text: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.systemPurple
        layer.cornerRadius = 16
        clipsToBounds = true

        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white

        removeButton.setTitle("✕", for: .normal)
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [label, removeButton])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func removeTapped() {
        onRemove?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

