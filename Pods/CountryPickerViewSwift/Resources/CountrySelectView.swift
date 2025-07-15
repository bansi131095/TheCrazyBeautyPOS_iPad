import UIKit

public enum DisplayLanguageType {
    case chinese
    case english
    case spanish
}

open class CountrySelectView: UIView {
    
    public static let shared = CountrySelectView()
    
    public var selectedCountryCallBack: ((_ countryDic: [String: Any]) -> Void)!
    
    private var countryTableView = UITableView()
    private var searchBarView = UISearchBar()
    private var regex = ""
    
    private var countryData: [[String: Any]] = CountryCodeJson
    private var searchResults: [[String: Any]] = []
    
    // MARK: - Configurable properties
    public var searchBarPlaceholder: String = "Search" {
        didSet { searchBarView.placeholder = searchBarPlaceholder }
    }
    
    public var countryNameFont: UIFont = .systemFont(ofSize: 16)
    public var countryPhoneCodeFont: UIFont = .systemFont(ofSize: 14)
    public var countryNameColor: UIColor = .black
    public var countryPhoneCodeColor: UIColor = .gray
    public var barTintColor: UIColor = .green {
        didSet { searchBarView.tintColor = barTintColor }
    }
    
    public var displayLanguage: DisplayLanguageType = .english
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Tap to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        // Search Bar
        searchBarView.placeholder = searchBarPlaceholder
        searchBarView.delegate = self
        searchBarView.barTintColor = .white
        searchBarView.backgroundImage = UIImage()
        searchBarView.showsCancelButton = false
        searchBarView.tintColor = barTintColor
        
        // TableView
        countryTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryTableViewCell")
        countryTableView.delegate = self
        countryTableView.dataSource = self
        countryTableView.separatorStyle = .none
        countryTableView.layer.cornerRadius = 5
        countryTableView.layer.masksToBounds = true
        
        self.addSubview(countryTableView)
        countryTableView.tableHeaderView = searchBarView
        
        searchResults = countryData
    }
    
    public func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            print("⚠️ No key window")
            return
        }
        self.frame = window.bounds
        window.addSubview(self)
        layoutConstraints()
        searchBarView.text = ""
        searchResults = countryData
        countryTableView.reloadData()
    }
    
    private func layoutConstraints() {
        countryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countryTableView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            countryTableView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            countryTableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ])
    }
    
    @objc public func dismiss() {
        self.removeFromSuperview()
    }
}

// MARK: - Gesture Delegate
extension CountrySelectView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: countryTableView) {
            return false
        }
        return true
    }
}


// MARK: - TableView Delegate/DataSource
extension CountrySelectView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        
        switch displayLanguage {
        case .english:
            cell.countryNameLabel.text = country["en"] as? String
        case .chinese:
            cell.countryNameLabel.text = country["zh"] as? String
        case .spanish:
            cell.countryNameLabel.text = country["es"] as? String
        }
        
        cell.countryNameLabel.font = countryNameFont
        cell.countryNameLabel.textColor = countryNameColor
        
        let locale = country["locale"] as? String ?? "US"
        let bundlePath = Bundle(for: CountrySelectView.self).resourcePath! + "/CountryPicker.bundle"
        let flagBundle = Bundle(path: bundlePath)
        cell.countryImageView.image = UIImage(named: locale, in: flagBundle, compatibleWith: nil)
        
        if let code = country["code"] as? NSNumber {
            cell.phoneCodeLabel.text = "+\(code)"
        }
        cell.phoneCodeLabel.font = countryPhoneCodeFont
        cell.phoneCodeLabel.textColor = countryPhoneCodeColor
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var country = searchResults[indexPath.row]
        selectedCountryCallBack(country)
        dismiss()
    }
}

// MARK: - SearchBar Delegate
extension CountrySelectView: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchResults = countryData
            countryTableView.reloadData()
            return
        }
        
        searchResults = countryData.filter { country in
            let texts = [
                (country["zh"] as? String ?? "").lowercased(),
                (country["en"] as? String ?? "").lowercased(),
                (country["es"] as? String ?? "").lowercased(),
                "\(country["code"] ?? "")"
            ]
            return texts.contains { $0.contains(searchText.lowercased()) }
        }
        countryTableView.reloadData()
    }
}
