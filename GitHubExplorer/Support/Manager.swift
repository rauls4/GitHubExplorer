//
//  Manager.swift
//  GitHubExplorer
//
//  Created by Raul Silva on 3/23/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import Foundation

final class Manager {               //Singleton
    private init() {
    }
    let repos = Repos()
    static let shared = Manager()
    
    var usersData = [String:[Repos.gitHubResults]]()
    
    class func stringToDate(string:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    class func dateToString(date:Date) -> String{
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MM-dd-yy"
        let timeIn12HourFormat = formatter2.string(from: date) //"10:22 AM"
        return timeIn12HourFormat
    }
}

