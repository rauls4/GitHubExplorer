//
//  UserFinder.swift
//  GitHubExplorer
//
//  Created by Raul Silva on 3/23/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

class UserFinder: UIViewController, UITableViewDataSource, UITableViewDelegate {        //Standard UITableView delegations
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!                      //To indicate loading in progress
    @IBOutlet weak var tableView: UITableView!
    
    private var searchController:UISearchController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false                          //Let's show the search box by default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        self.activityIndicator.stopAnimating()
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search for a GitHub account"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Manager.shared.repos.langTupleArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LanguageTableViewCell
        if(indexPath.row < Manager.shared.repos.langTupleArray.count){
            cell.languageLable.text = Manager.shared.repos.langTupleArray[indexPath.row].key
            cell.countLabel.text = String(Manager.shared.repos.langTupleArray[indexPath.row].value)
        }
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reposViewer = self.storyboard!.instantiateViewController(withIdentifier: "reposViewIdentifier") as! ReposViewController
        reposViewer.language = Manager.shared.repos.langTupleArray[indexPath.row].key
        let reposByLanguage = Manager.shared.repos.combinedData.filter{$0.language == reposViewer.language}
        reposViewer.repos = reposByLanguage.sorted(by: { $0.stars > $1.stars })
        self.navigationController?.pushViewController(reposViewer, animated: true)
    }

}

extension UserFinder: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if (self.searchBarIsEmpty()){
            Manager.shared.repos.clearData()
            self.tableView.reloadData()
        }else{
            self.activityIndicator.startAnimating()
            Manager.shared.repos.search(term: searchController.searchBar.text!,completion: {[unowned self] _ in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            })
        }
    }
}
