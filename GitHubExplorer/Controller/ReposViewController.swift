//
//  ReposViewController.swift
//  GitHubExplorer
//
//  Created by Raul Silva on 3/24/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var language:String?
    var repos: [Repos.GitHubResults]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let selectedLanguage = language  {
            if let repos = repos{
                self.title = selectedLanguage + "(" + String(describing: (repos.count))  + ")"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = repos{
            return repos.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepoTableViewCell
        if let repos = repos {
            if let name = repos[indexPath.row].name {
                cell.repoNameLabel.text =  name
            }else{
                cell.repoDescriptionLabel.text =  "No name given"
            }
            
            if let description = repos[indexPath.row].description {
                cell.repoDescriptionLabel.text =  description
            }else{
                cell.repoDescriptionLabel.text =  "No description available"
            }
            
            cell.repoStarsLabel.text =  String(repos[indexPath.row].stars )
      
            if let forkCount = repos[indexPath.row].forks {
                cell.repoForksLabel.text =  String(forkCount)
            }else{
                cell.repoForksLabel.text =  "--"
            }
            
            if let creationDate = repos[indexPath.row].date {
                let date = Manager.stringToDate(string: creationDate)
                cell.reposDateLabel.text =  Manager.dateToString(date: date)
            }else{
                cell.reposDateLabel.text =  "--"
            }
        }
        return cell
    }
}
