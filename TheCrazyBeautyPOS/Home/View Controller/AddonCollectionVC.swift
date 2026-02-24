//
//  AddonCollectionVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 16/02/26.
//

import UIKit

class AddonCollectionVC: UIViewController {

    
    
    var AddonSelected:[String] = []
    var addonList: [InventoryData] = []
    var onComplete: (([String]) -> Void)?
    
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let collectionView: UICollectionView
    private let continueButton = UIButton(type: .system)

    // CollectionView Layout
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        return layout
    }()

    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updatePopupHeight()
    }
    

    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        // Container View
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 300),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -300),
            containerView.heightAnchor.constraint(equalToConstant: 250)
        ])

        // Title Label
        titleLabel.text = " "
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        // Close Button
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        containerView.addSubview(closeButton)

        // CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        containerView.addSubview(collectionView)

        // Continue Button
//        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitle(NSLocalizedString("Continue",comment: ""), for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 30
        continueButton.clipsToBounds = true
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        containerView.addSubview(continueButton)
        applyGradient(to: continueButton)

        // Add Constraints
        applyConstraints()
    }
    
    private func updatePopupHeight() {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        let totalHeight = contentHeight + 240 // 👈 extra padding
        let maxHeight = UIScreen.main.bounds.height * 0.8 // safety limit

        containerView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = min(totalHeight, maxHeight)
            }
        }
    }

    private func applyConstraints() {
        [titleLabel, closeButton, collectionView, continueButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 200),

            continueButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 40),
//            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
//            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.widthAnchor.constraint(equalToConstant: 300),
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            continueButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }
    
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func continueTapped() {
        onComplete?(Array(AddonSelected))
        dismiss(animated: true)
    }

    private func applyGradient(to button: UIButton) {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.8039215686, green: 0.1882352941, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.4784313725, green: 0.2235294118, blue: 0.9725490196, alpha: 1).cgColor]
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 300, height: 60))
        gradient.cornerRadius = 30
        button.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension AddonCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addonList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        
        let name = (addonList[indexPath.item].addon_name) + " " + (LocalData.symbol) + String((addonList[indexPath.item].addon_price))
        cell.configure(with: name, selected: AddonSelected.contains("\(addonList[indexPath.item].id ?? 0)"))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let staff = addonList[indexPath.item].id ?? 0
        if AddonSelected.contains("\(staff)") {
            if let index = AddonSelected.firstIndex(of: "\(staff)") {
                AddonSelected.remove(at: index)
            }
        } else {
            AddonSelected.append("\(staff)")
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
}

