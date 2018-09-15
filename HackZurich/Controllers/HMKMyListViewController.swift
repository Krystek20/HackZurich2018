import UIKit
import Alamofire

class HMKMyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = [HMKMyListItemResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        tableView.dataSource = self
        
        downloadList()
    }
    
    private func downloadList() {
        Alamofire.request("https://2be030bd.ngrok.io/drugs/full_list", method: .get, parameters: nil, encoding: Alamofire.JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let json = response.result.value as? [[String : Any]] {
                self.items = HMKMyListItemsResponseBuilder(array: json).build()?.results ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension HMKMyListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myListCellViewId", for: indexPath)
        let object = items[indexPath.row]
        
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = object.name
            titleLabel.alpha = object.isEmpty ? 0.2 : 1.0
        }
        
        if let subtitleLabel = cell.viewWithTag(2) as? UILabel {
            subtitleLabel.text = object.packType
            subtitleLabel.alpha = object.isEmpty ? 0.2 : 1.0
        }
        
        if let countLabel = cell.viewWithTag(3) as? UILabel, let tabsNumber = object.tabsNumber {
            countLabel.text = "Count: \(tabsNumber)"
            countLabel.alpha = object.isEmpty ? 0.2 : 1.0
        }
        
        if let buttonLabel = cell.viewWithTag(4) as? HMKButton {
            buttonLabel.identifier = String(object.swissId)
            buttonLabel.addTarget(self, action: #selector(pressButton(sender:)), for: .touchUpInside)
            buttonLabel.alpha = object.isEmpty ? 0.2 : 1.0
            buttonLabel.isEnabled = !object.isEmpty
        }
        
        return cell
    }
    
    @objc func pressButton(sender: HMKButton) {
        guard let swissId = sender.identifier, let loader = self.storyboard?.instantiateViewController(withIdentifier: "HMKLoaderViewControllerId") else { return }
        
        loader.modalTransitionStyle = .crossDissolve
        loader.modalPresentationStyle = .overCurrentContext
        
        present(loader, animated: true, completion: nil)
        
        Alamofire.request("https://2be030bd.ngrok.io/drugs/\(swissId)/take_a_pill", method: .post, parameters: nil, encoding: Alamofire.JSONEncoding.default, headers: nil).responseJSON { response in
            
            loader.dismiss(animated: true, completion: {
                if let json = response.result.value as? [String : Any] {
                    let isEmpty = (json["is_empty"] as? Int ?? 1) == 1
                    if let item = self.items.first(where: { String($0.swissId) == sender.identifier }), let index = self.items.index(where: { String($0.swissId) == sender.identifier }) {
                        let changedItem = HMKMyListItemResponseModel(tabsNumber: item.tabsNumber > 0 ? item.tabsNumber - 1 : 0, swissId: item.swissId, packType: item.packType, name: item.name, isEmpty: isEmpty)
                        self.items[index] = changedItem
                        self.tableView.reloadData()
                        
                        if isEmpty {
                            self.showEmptyPopup()
                        }
                    }
                }
            })
        }
    }
    
    private func showEmptyPopup() {
        if let emptyViewController = storyboard?.instantiateViewController(withIdentifier: "HMKEmptyDrugViewControllerID") as? HMKEmptyDrugViewController {
            emptyViewController.backWithAction = { [weak self] in
                emptyViewController.dismiss(animated: true, completion: {
                    self?.fireMapAction()
                })
            }
            emptyViewController.modalTransitionStyle = .crossDissolve
            emptyViewController.modalPresentationStyle = .overCurrentContext
            present(emptyViewController, animated: true, completion: nil)
        }
        
    }
    
    private func fireMapAction() {
        self.performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    
}
