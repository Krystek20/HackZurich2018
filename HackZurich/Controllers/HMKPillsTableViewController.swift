import UIKit
import Alamofire

class HMKPillsTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var session: DataRequest?
    var pills = [HMKPillResponseModel]()
    var currentDosage = [HMKDosageResponseModel]()
    var loaderViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.hkmWhite
        title = "Search Drugs"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.hkmWhite
        searchController.searchBar.barTintColor = UIColor.hkmWhite
        searchController.searchBar.placeholder = "Search drugs (min 3 characters)"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.hkmWhite]

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
}

extension HMKPillsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 2 {
            look(for: text)
        } else {
            pills.removeAll()
            tableView.reloadData()
        }
    }
    
    private func look(for text: String) {
        let headers = [
            "Authorization": "purple point",
            ]
        
        if let session = self.session {
            session.cancel()
        }
        
        session = Alamofire.request("https://health.axa.ch/hack/api/drugs?name=\(text)", method: .get, parameters: nil, encoding: Alamofire.JSONEncoding.default, headers: headers).responseJSON { response in

            if let json = response.result.value as? [[String : Any]] {
                self.pills = HMKPillsResponseBuilder(array: json).build()?.results ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension HMKPillsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pills.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HMKPillCellViewID", for: indexPath)
        let object = pills[indexPath.row]
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = object.title
        }
        
        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = object.authHolder
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = pills[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        downloadDosage(for: object)
    }
    
    private func downloadDosage(for pill: HMKPillResponseModel) {
        let swssMedicId = pill.swissMedicId ?? ""
        session = Alamofire.request("https://2be030bd.ngrok.io/drugs/dosage?swissid=\(swssMedicId)", method: .get, parameters: nil, encoding: Alamofire.JSONEncoding.default, headers: nil).responseJSON { response in

            if let json = response.result.value as? [[String : Any]] {
                
                self.currentDosage = HMKDosagesResponseBuilder(array: json).build()?.results ?? []
                let alertViewController = UIAlertController(title: "Choise Dosen", message: nil, preferredStyle: .actionSheet)
                for dosage in self.currentDosage {
                    let alertAction = UIAlertAction(title: dosage.dosage, style: .default, handler: { alert in
                        guard let dosage = self.currentDosage.first(where: { $0.dosage == alert.title }) else {
                            return
                        }
                        self.sendDrug(for: pill, dosage: dosage)
                    })
                    alertViewController.addAction(alertAction)
                }
                
                let alertAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertViewController.addAction(alertAction)
                
                self.present(alertViewController, animated: true)
            }
        }
    }
    
    private func sendDrug(for pill: HMKPillResponseModel, dosage: HMKDosageResponseModel) {
        let params: Parameters = [
            "swiss_id" : pill.swissMedicId,
            "name" : pill.title,
            "pack_type" : dosage.type,
            "tabs_number" : dosage.tabsNumber
        ]
        
        session = Alamofire.request("https://2be030bd.ngrok.io/drugs/", method: .post, parameters: params, encoding: Alamofire.JSONEncoding.default, headers: nil).responseJSON { response in
            
            if response.response?.statusCode == 200 {
                let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "HMKPopupViewControllerID")
                
                popupViewController?.modalTransitionStyle = .crossDissolve
                popupViewController?.modalPresentationStyle = .overCurrentContext
                
                if let presentedVC = self.presentedViewController {
                    presentedVC.present(popupViewController!, animated: true, completion: nil)
                } else {
                    self.present(popupViewController!, animated: true, completion: nil)
                }
            }
        }
    }
    
}
