import UIKit

class HMKDashboardViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let TITLE = "HomeMedKIT"
    @IBOutlet weak var addPilsButton: UIView!
    @IBOutlet weak var findShop: UIView!
    @IBOutlet weak var listButton: UIView!
    @IBOutlet weak var settingsButton: UIView!
    
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
