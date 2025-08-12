//
//  ReportVC.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 12/06/25.
//

import UIKit

class ReportVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var lbl_TotalAmount: UILabel!
    
    @IBOutlet weak var img_Team: UIImageView!
    @IBOutlet weak var img_Sales: UIImageView!
    @IBOutlet weak var img_Service: UIImageView!
    
    @IBOutlet weak var vw_TeamSaleService: UIView!
    @IBOutlet weak var lbl_Sales: UILabel!
    @IBOutlet weak var lbl_Walkin: UILabel!
    @IBOutlet weak var lbl_GiftCard: UILabel!
    
    @IBOutlet weak var vw_SaleWalkinGift: UIView!
    
    @IBOutlet weak var vw_Sales: UIView!
    @IBOutlet weak var vw_Walkin: UIView!
    @IBOutlet weak var vw_GiftCard: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lbl_TotalSales: UILabel!
    
    @IBOutlet weak var lbl_TTeam: UILabel!
    @IBOutlet weak var lbl_TSales: UILabel!
    @IBOutlet weak var lbl_TService: UILabel!
    
    
    // Static method to set label text
    func updateTotalAmount(text: String) {
            lbl_TotalAmount.text = text
        }
    
    //MARK: - Global Variable
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_TotalAmount.font = UIFont(name: "Lato-Medium", size: 20.0)
        setCustomFont()
        vw_SaleWalkinGift.isHidden = true
        lbl_Sales.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        vw_Sales.backgroundColor = .white
        vw_Walkin.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_GiftCard.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        loadEmbeddedViewController(for: 0)
    }
    
    func setCustomFont() {
        if let customFont = UIFont(name: "Lato-Medium", size: 18.0) {
            lbl_Sales.font = customFont
            lbl_Walkin.font = customFont
            lbl_GiftCard.font = customFont
            
            lbl_TotalSales.font = customFont
            lbl_TTeam.font = customFont
            lbl_TSales.font = customFont
            lbl_TService.font = customFont
        }
    }
    
    //MARK: -  Button Action
    @IBAction func btn_DownloadReport(_ sender: Any) {
        if let currentVC = children.first as? ReportDownloadable {
            let formatterInput = DateFormatter()
            formatterInput.dateFormat = "MMM d, yyyy"

            let formatterOutput = DateFormatter()
            formatterOutput.dateFormat = "dd-MM-yyyy"

            let formattedStart = formatterOutput.string(from: formatterInput.date(from: currentVC.fromDate ?? "") ?? Date())
                let formattedEnd = formatterOutput.string(from: formatterInput.date(from: currentVC.toDate ?? "") ?? Date())
            print("From: \(formattedStart) To: \(formattedEnd)")
            currentVC.downloadReport(startDate: formattedStart, endDate: formattedEnd)
        }
        if let serviceReport = children.first as? Service_ReportVC {
            let formatterInput = DateFormatter()
            formatterInput.dateFormat = "MMM d, yyyy"

            let formatterOutput = DateFormatter()
            formatterOutput.dateFormat = "dd-MM-yyyy"

            let formattedStart = formatterOutput.string(from: formatterInput.date(from: serviceReport.fromDate ?? "") ?? Date())
                let formattedEnd = formatterOutput.string(from: formatterInput.date(from: serviceReport.toDate ?? "") ?? Date())
            print("From: \(formattedStart) To: \(formattedEnd)")
            serviceReport.downloadServiceReport(startDate: formattedStart, endDate: formattedEnd)
            
        }
        if let salesReporthistoryReport = children.first as? SalesReportHistory_VC {
            let formatterInput = DateFormatter()
            formatterInput.dateFormat = "MMM d, yyyy"

            let formatterOutput = DateFormatter()
            formatterOutput.dateFormat = "dd-MM-yyyy"

            let formattedStart = formatterOutput.string(from: formatterInput.date(from: salesReporthistoryReport.fromDate ?? "") ?? Date())
                let formattedEnd = formatterOutput.string(from: formatterInput.date(from: salesReporthistoryReport.toDate ?? "") ?? Date())
            print("From: \(formattedStart) To: \(formattedEnd)")
            salesReporthistoryReport.downloadSalesReport(startDate: formattedStart, endDate: formattedEnd)
        }
        if let walkingHistoryReport = children.first as? WalkinHistory_VC {
            let formatterInput = DateFormatter()
            formatterInput.dateFormat = "MMM d, yyyy"

            let formatterOutput = DateFormatter()
            formatterOutput.dateFormat = "dd-MM-yyyy"

            let formattedStart = formatterOutput.string(from: formatterInput.date(from: walkingHistoryReport.fromDate ?? "") ?? Date())
                let formattedEnd = formatterOutput.string(from: formatterInput.date(from: walkingHistoryReport.toDate ?? "") ?? Date())
            print("From: \(formattedStart) To: \(formattedEnd)")
            walkingHistoryReport.downloadWalkinHistoryReport(startDate: formattedStart, endDate: formattedEnd)
        }
        if let giftcardReport = children.first as? Giftcard_HistoryVC {
            let formatterInput = DateFormatter()
            formatterInput.dateFormat = "MMM d, yyyy"

            let formatterOutput = DateFormatter()
            formatterOutput.dateFormat = "dd-MM-yyyy"

            let formattedStart = formatterOutput.string(from: formatterInput.date(from: giftcardReport.fromDate ?? "") ?? Date())
                let formattedEnd = formatterOutput.string(from: formatterInput.date(from: giftcardReport.toDate ?? "") ?? Date())
            print("From: \(formattedStart) To: \(formattedEnd)")
            giftcardReport.downloadGiftReport(startDate: formattedStart, endDate: formattedEnd)
        }
        else{
            print("Current VC doesn't support download.")
        }
    }
    
    
    @IBAction func btn_Team(_ sender: Any) {
        loadEmbeddedViewController(for: 0)
        vw_SaleWalkinGift.isHidden = true
        img_Team.image = UIImage(named: "ic_Check")
        img_Sales.image = UIImage(named: "ic_Uncheck")
        img_Service.image = UIImage(named: "ic_Uncheck")
    }
    
    @IBAction func btn_Sales(_ sender: Any) {
        vw_SaleWalkinGift.isHidden = false
        loadEmbeddedViewController(for: 1)
        img_Team.image = UIImage(named: "ic_Uncheck")
        img_Sales.image = UIImage(named: "ic_Check")
        img_Service.image = UIImage(named: "ic_Uncheck")
        
        lbl_Sales.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_Walkin.textColor = .black
        lbl_GiftCard.textColor = .black
        
        vw_Sales.backgroundColor = .white
        vw_Walkin.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_GiftCard.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
    }
    
    @IBAction func btn_Service(_ sender: Any) {
        vw_SaleWalkinGift.isHidden = true
        img_Team.image = UIImage(named: "ic_Uncheck")
        img_Sales.image = UIImage(named: "ic_Uncheck")
        img_Service.image = UIImage(named: "ic_Check")
        loadEmbeddedViewController(for: 2)
    }
    
    
    
    @IBAction func btn_Sales_Second(_ sender: Any) {
        loadEmbeddedViewController(for: 1)
        lbl_Sales.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_Walkin.textColor = .black
        lbl_GiftCard.textColor = .black
        
        vw_Sales.backgroundColor = .white
        vw_Walkin.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_GiftCard.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
    }
    
    @IBAction func btn_Walkin(_ sender: Any) {
        loadEmbeddedViewController(for: 3)
        lbl_Sales.textColor = .black
        lbl_Walkin.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        lbl_GiftCard.textColor = .black
        
        vw_Sales.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_Walkin.backgroundColor = .white
        vw_GiftCard.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
    }
    
    
    @IBAction func btn_GiftCard(_ sender: Any) {
        loadEmbeddedViewController(for: 4)
        lbl_Sales.textColor = .black
        lbl_Walkin.textColor = .black
        lbl_GiftCard.textColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 1)
        
        vw_Walkin.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_Sales.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.4, blue: 0.8901960784, alpha: 0.3000000119)
        vw_GiftCard.backgroundColor = .white
    }
    
    //MARK: - Function
    func loadEmbeddedViewController(for index: Int) {
            // Optionally switch based on index if you have multiple VCs
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var selectedVC: UIViewController?

        switch index {
        case 0:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "Team_ReportVC") as? Team_ReportVC
        case 1:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "SalesReportHistory_VC") as? SalesReportHistory_VC
        case 2:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "Service_ReportVC") as? Service_ReportVC
        case 3:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "WalkinHistory_VC") as? WalkinHistory_VC
        case 4:
            selectedVC = storyboard.instantiateViewController(withIdentifier: "Giftcard_HistoryVC") as? Giftcard_HistoryVC
        default:
            print("Invalid index")
            return
        }

        // Remove old child
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        if let vc = selectedVC {
            addChild(vc)
            vc.view.frame = containerView.bounds
            containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    //MARK: - Web Api Calling
    
}

