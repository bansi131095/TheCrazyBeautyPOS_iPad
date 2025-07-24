//
//  TeamRosterCell.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 24/07/25.
//

import UIKit


class TeamRosterCell: UITableViewCell {
    
    let stack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStack() {
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(item: TeamRosterItem, dateCount: Int) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        stack.addArrangedSubview(makeLabel(text: item.name, status: ""))
        for schedule in item.schedule ?? []  {
            stack.addArrangedSubview(makeLabel(text: schedule.timeText, status: schedule.status))
        }
        stack.addArrangedSubview(makeLabel(text: item.totalHours, status: ""))
    }
    
    func makeLabel(text: String, status: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.borderWidth = 0.5
        label.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        // Total width: screen - 60 (30 padding on each side)
        let screenWidth = UIScreen.main.bounds.width
        let totalAvailableWidth = screenWidth - 60
        let columnWidth = totalAvailableWidth / 9 // 9 columns

        label.backgroundColor = status == "holiday" ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) :
                                status == "closed" ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear

        label.widthAnchor.constraint(equalToConstant: columnWidth).isActive = true
        return label
    }

}



