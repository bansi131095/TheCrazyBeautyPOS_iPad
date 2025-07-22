//
//  ShiftTableViewCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 18/07/25.
//

import UIKit


class ShiftTableViewCell: UITableViewCell {
    static let identifier = "ShiftTableViewCell"

    let nameLabel = UILabel()
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true

        scrollView.showsHorizontalScrollIndicator = true

        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually

        scrollView.addSubview(stackView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(scrollView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            scrollView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

   /* func configure(with member: TeamMember) {
        nameLabel.text = member.name
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for shift in member.shifts {
            let label = UILabel()
            label.text = shift.time
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.backgroundColor = .secondarySystemBackground
            label.widthAnchor.constraint(equalToConstant: 100).isActive = true
            stackView.addArrangedSubview(label)
        }
    } */
}
