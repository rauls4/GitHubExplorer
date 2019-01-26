//
//  Repos.swift
//  GitHubExplorer
//
//  Created by Raul Silva on 3/23/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import Foundation

class Repos {
    private let clientID = "71eecc10419c6ee246cb"                           //Github severly limits results w/o authentication
    private let clientSecret = "34b5b1be187f75ee86cab9f817185f8ea941e0fe"
    private var languageSet = Set<String>()                                 //So we can log one entry per language found
    var langTupleArray = [(key: String, value: Int)]()                      //So we can sort by instance count
    var combinedData = [Repos.GitHubResults]()                              //Holds the combined data for all pages
    private var pages = 1                                                   //Used in the recursive queries to get all records
    private let resultsPerPage = 30                                         //Chunks of repos data results per Github query
    
    //Codable to serialize the GitHub results into useful stuff
    struct GitHubResults: Codable {
        let language:String?
        let stars:Int
        let forks:Int?
        let name:String?
        let description:String?
        let date:String?
        
        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case language = "language"
            case stars = "stargazers_count"
            case forks = "forks"
            case description = "description"
            case date = "updated_at"
        }
    }
    
    func clearData(){                                                       //When we do a new search, let's clean the slate
        pages = 1                                                           //Back to page 1
        combinedData = [Repos.GitHubResults]()                              //Wipe all combined query data results
        languageSet = Set<String>()                                         //Clear our set of languages
        langTupleArray = [(key: String, value: Int)]()                      //Clear our tupple array of sorted languages (by how many repoes use it)
    }

    private func loadPage(user:String, completion:@escaping (Bool) -> Void){  //Github results one page at a time
        
        var gitData:[Repos.GitHubResults]!
        
        guard let gitUrl =
            URL(string: "https://api.github.com/users/\(user)/repos?client_id=\(clientID)&client_secret=\(clientSecret)&page=\(pages)&per_page=\(resultsPerPage)") else {return}
        
        URLSession.shared.dataTask(with: gitUrl) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                gitData = try decoder.decode([GitHubResults].self, from: data)
                self.combinedData = self.combinedData + gitData                //Let's add these results to any previous pages
            } catch {
                self.clearData()
                completion(true)
                print("Error deserializing JSON: \(error)")
            }
            if let gitData = gitData {
                if(gitData.count != 0){                                            //This result wasn't empty, let's check for a next page
                    self.pages = self.pages + 1
                    self.loadPage(user: user, completion: completion)              //Recurse
                }else{                                                             //We must have all the data we need…
                    self.defineLanguageSet()                                       //Let's build a set of each language instance
                    self.quantifyLanguageInstances()                               //Let's quantify their use and sort tem
                    Manager.shared.usersData[user] = self.combinedData             //Let's save this data in memory so we don't waste
                                                                                   //Time and resources if we need it again
                    
                    //Normally, I would proabably store this data on the device and provide a refesh mechanism
                    
                    completion(true)                                                //We are done here! Back to our view controller!
                }

            }else{
                completion(true)
            }
            }.resume()
    }
    
    private func defineLanguageSet(){                                          //The set is nifty because it only allows one instance of a value
        for record in combinedData{
            if let language = record.language{
                self.languageSet.insert(language)
            }else{
                self.languageSet.insert("Undeclared language")                 //Allow for undefined language repos
            }
        }
    }
    
    private func quantifyLanguageInstances(){                                   //Let's quantify how many times is each language used in repos
        var langInstances = [String:Int]()
        for language in self.languageSet {
            let instances = self.combinedData.filter{$0.language == language}.count
            langInstances[language] = instances
        }
        self.langTupleArray =  langInstances.sorted(by: { $0.value > $1.value })//Let's sort our tuple array
    }
    
    func search(term:String, completion:@escaping (Bool) -> Void){              //A search has been requested…
        self.clearData()                                                        //Let's clear all data
        if(Manager.shared.usersData[term] == nil){                              //Has this term been searched before?
            loadPage(user: term, completion: completion)                        //No, let's load it!
        }else{                                                                  //Yes, let's fetch data stored in memory
            if let combinedDataValues = Manager.shared.usersData[term]{
                combinedData = combinedDataValues
                self.defineLanguageSet()
                self.quantifyLanguageInstances()
            }
            completion(true)                                                    //We are done here, back to our view!
        }
    }
}
