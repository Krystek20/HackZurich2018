import UIKit

class HMKEmptyDrugViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var backWithAction = { }
    
    override func viewDidLoad() {
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.1
    }
    
    @IBAction func openMapAction(_ sender: Any) {
        backWithAction()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
