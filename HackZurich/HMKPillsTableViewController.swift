import UIKit

class HMKPillsTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}

extension HMKPillsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("blabla")
    }
}

extension HMKPillsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HMKPillCellViewID", for: indexPath) 
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = "lek -> \(indexPath.row)"
        }
        
        return cell
    }
    
    
}
