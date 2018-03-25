# GitHub Explorer

![alt text](https://i.imgur.com/hgJY2cm.png)![alt text](https://i.imgur.com/2ilwsNO.png)





# A simple app to explore repos by language for any given account

The app uses the GitHub API endpoint: api.github.com/users/user/repos to pull down data on a given user's repos. It fetches data recursively for accounts with more than 30 repos.

The model keeps a copy of the fetched data in memory to avoid waste of time and resources.

The model creates a set of each occurance of a language on the account's repos and then makes a tupple array of each language with a count of instances, the tupple array is sorted from highest to lowest.

Basic repo data is serialized using a codable struct which can be used to display more details about each repo.

The project uses no third party libraries or frameworks.
