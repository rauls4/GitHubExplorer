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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false                          //Let's show the search box by default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.stopAnimating()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a GitHub account"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
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
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension UserFinder: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if (self.searchBarIsEmpty()){
            Manager.shared.repos.clearData()
            self.tableView.reloadData()
        }else{
            self.activityIndicator.startAnimating()
            Manager.shared.repos.search(term: searchController.searchBar.text!,completion: { _ in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            })
        }
    }
}
