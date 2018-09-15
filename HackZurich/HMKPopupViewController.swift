import UIKit

class HMKPopupViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.shadowOffset = CGSize(width: 0, height: 0)
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowOpacity = 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
