//
//  WordListTableViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-04.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    private var alphabeticalWordList: [Word] = []
     
    private var searchedWordList : [Word] = []
    
    private var searching : Bool = false

    override func viewDidLoad() {
        
        super.viewDidLoad()

        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        hideNavBar()
        
        loadAlphabeticalWordList()
    }

    @objc func hideNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? searchedWordList.count : alphabeticalWordList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib.init(nibName: "WordListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "wordListCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordListCell", for: indexPath) as! WordListTableViewCell
        
        cell.wordLabel.text = searching ? searchedWordList[indexPath.row].word : alphabeticalWordList[indexPath.row].word
        
        cell.correctLabel.text = searching ? "\(searchedWordList[indexPath.row].correctCount)" : "\(alphabeticalWordList[indexPath.row].correctCount)"
        
        cell.incorrectLabel.text = searching ? "\(searchedWordList[indexPath.row].incorrectCount)" : "\(alphabeticalWordList[indexPath.row].incorrectCount)"
        
        cell.genderIndicatorView.backgroundColor = searching ? {searchedWordList[indexPath.row].gender ? UIColor.flatRedDark() : UIColor.flatTealDark()}() : {alphabeticalWordList[indexPath.row].gender ? UIColor.flatRedDark() : UIColor.flatTealDark()}()
        
        return cell
    }
    
    
    @objc func loadAlphabeticalWordList() {
        
        alphabeticalWordList = WordManager.sharedInstance.getAllWordAlphabetical()
    }

   

}

extension WordListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let textfieldNotEmpty = searchText.count != 0
        searching = textfieldNotEmpty
        searchBar.showsCancelButton = textfieldNotEmpty
        
        searchedWordList = alphabeticalWordList.filter({ (word) -> Bool in
            
            word.word!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
}
