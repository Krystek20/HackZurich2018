import UIKit
import Alamofire

class HMKDashboardViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let TITLE = "HomeMedKIT"
    @IBOutlet weak var addPilsButton: UIView!
    @IBOutlet weak var findShop: UIView!
    @IBOutlet weak var listButton: UIView!
    @IBOutlet weak var settingsButton: UIView!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var lowAmountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Alamofire.request("https://2be030bd.ngrok.io/drugs", method: .get, parameters: nil, encoding: Alamofire.JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let json = response.result.value as? [String : Any] {
                self.allLabel.text = String(json["all"] as? Int ?? 0)
                self.lowAmountLabel.text = String(json["low_amount_count"] as? Int ?? 0)
            }
        }
    }
    
    override func viewDidLoad() {

        prepareTitle()
        prepareShadow(addPilsButton)
        prepareShadow(findShop)
        prepareShadow(listButton)
        prepareShadow(settingsButton)
    }

    private func prepareShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.1
    }
    
    private func prepareTitle() {
        let attrString = NSMutableAttributedString(string: HMKDashboardViewController.TITLE)

        let string = NSString(string: HMKDashboardViewController.TITLE)
        let firstRangeTitle = "Home"
        let firstRange = string.range(of: firstRangeTitle)

        let secondRangeTitle = "MedKIT"
        let secondRange = string.range(of: secondRangeTitle)
        
        attrString.setAttributes([
            NSAttributedStringKey.font : UIFont(name: "Poppins-Light", size: 31)!,
            NSAttributedStringKey.foregroundColor : UIColor.hkmWhite
        ], range: firstRange)

        attrString.setAttributes([
            NSAttributedStringKey.font : UIFont(name: "Poppins-Bold", size: 31)!,
            NSAttributedStringKey.foregroundColor : UIColor.hkmWhite
        ], range: secondRange)

        titleLabel.attributedText = attrString
    }

}
