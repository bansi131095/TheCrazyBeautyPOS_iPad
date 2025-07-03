//
//  TagListView.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 03/07/25.
//

import UIKit


class TagListView: UIView {

    private let tagContainer = UIView()
    private var tagViews: [TagView] = []
    private var tags: [String] = []

    var onAddTapped: (() -> Void)?
    var onTagsChanged: (([String]) -> Void)?

    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 24

        let titleLabel = UILabel()
        titleLabel.text = "Select Preferred Staff"
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .gray

        addSubview(titleLabel)
        addSubview(tagContainer)
        tagContainer.addSubview(plusButton)

        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        // Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tagContainer.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            tagContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tagContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tagContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            tagContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            plusButton.heightAnchor.constraint(equalToConstant: 32),
            plusButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTags(_ newTags: [String]) {
        tags = newTags
        reloadTags()
    }

    private func reloadTags() {
        tagViews.forEach { $0.removeFromSuperview() }
        tagViews.removeAll()

        var x: CGFloat = 0
        var y: CGFloat = 0
        let padding: CGFloat = 8
        let maxWidth = self.frame.width - 48

        for tag in tags {
            let tagView = TagView(text: tag)
            tagView.onRemove = { [weak self] in
                self?.removeTag(tag)
            }
            tagContainer.addSubview(tagView)
            tagView.translatesAutoresizingMaskIntoConstraints = false
            let size = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if x + size.width > maxWidth {
                x = 0
                y += size.height + padding
            }
            tagView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            x += size.width + padding
            tagViews.append(tagView)
        }

        plusButton.frame = CGRect(x: x, y: y, width: 32, height: 32)
    }

    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
        reloadTags()
        onTagsChanged?(tags)
    }

    @objc private func plusTapped() {
        onAddTapped?()
    }
}
