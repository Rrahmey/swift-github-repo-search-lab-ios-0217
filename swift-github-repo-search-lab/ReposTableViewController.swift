//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    @IBAction func searchButton(_ sender: Any) {
        let searchAlert = UIAlertController(title: "Search Github Repos", message: nil, preferredStyle: .alert)
        searchAlert.addTextField()
        let searchAction = UIAlertAction(title: "Search", style: .default) { (uiAlert) in
            guard let answer = searchAlert.textFields?[0] else {return}
            guard let answerText = answer.text else {return}
            self.store.getRepos(with: answerText, handler: { (worked) in
                if worked == true {
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                }
            }) }
        searchAlert.addAction(searchAction)
        self.present(searchAlert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[indexPath.row]
        print(repository.fullName)
        print(repository.htmlURL)
        
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.store.repositories[indexPath.row]
        print(selectedCell)
        self.store.toggleStarStatus(for: selectedCell) { (wasStarred) in
            if wasStarred == true {
                let alertController = UIAlertController(title: "Alert", message: "You have succesfully starred the repo", preferredStyle: UIAlertControllerStyle.alert )
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Alert", message: "You have succesfully unstarred the repo", preferredStyle: UIAlertControllerStyle.alert )
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    

}
