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
    
    @IBOutlet var backButton: UIBarButtonItem!
    
    private var alphabeticalWordList: [Word] = []
     
    private var searchedWordList : [Word] = []
    
    private var searching : Bool = false
    
    private var searchbarHidden : Bool = false
    
    var delegate: MainMenuDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.prefersLargeTitles = true

        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        hideNavBar()
        
        loadAlphabeticalWordList()
    }
    
    @objc func loadAlphabeticalWordList() {
        
        alphabeticalWordList = WordManager.sharedInstance.getAllWordAlphabetical()
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
        return searching ?
                searchedWordList.count == 0 ? 1 : searchedWordList.count
                :
                alphabeticalWordList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib.init(nibName: "WordListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "wordListCell")
        
        if (searching && searchedWordList.count == 0) {
            return emptyCell(forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordListCell", for: indexPath) as! WordListTableViewCell
        
        cell.word = searching ? searchedWordList[indexPath.row] : alphabeticalWordList[indexPath.row]
        
        cell.wordLabel.text = searching ? searchedWordList[indexPath.row].word : alphabeticalWordList[indexPath.row].word
        
        cell.correctLabel.text = searching ? "\(searchedWordList[indexPath.row].correctCount)" : "\(alphabeticalWordList[indexPath.row].correctCount)"
        
        cell.incorrectLabel.text = searching ? "\(searchedWordList[indexPath.row].incorrectCount)" : "\(alphabeticalWordList[indexPath.row].incorrectCount)"
        
        cell.genderIndicatorView.backgroundColor = searching ? {searchedWordList[indexPath.row].gender ? UIColor.flatRedDark() : UIColor.flatTealDark()}() : {alphabeticalWordList[indexPath.row].gender ? UIColor.flatRedDark() : UIColor.flatTealDark()}()
        
        cell.updateStar()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func emptyCell(forIndexPath index : IndexPath) -> WordListTableViewCell {
        
        let emptyCell = tableView.dequeueReusableCell(withIdentifier: "wordListCell", for: index) as! WordListTableViewCell
        
        emptyCell.wordLabel.text = "No results found 😢"
        emptyCell.correctLabel.text = "NA"
        emptyCell.incorrectLabel.text = "NA"
        
        return emptyCell
    }
    
    var selectedWord: Word = Word()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
         
        self.selectedWord = searching ? searchedWordList[indexPath.row] : alphabeticalWordList[indexPath.row]
        
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToDetail") {
            if let detailVC = segue.destination as? WordDetailViewController {

                detailVC.word = self.selectedWord
            }
        }
    }
    
    var previousScrollY: CGFloat = 0.0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentScrollY = scrollView.contentOffset.y
        
        print(currentScrollY)
        
        if (currentScrollY > previousScrollY &&
            !searchbarHidden &&
            currentScrollY > 0) {
            
        }
        else {
            showSearchBar()
        }
        
        previousScrollY = currentScrollY
    }
    
    func hideSearchBar() {
        searchbarHidden = true
        UIView.animate(withDuration: 0.3) {
            self.searchBar.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 0)
        }
    }

    func showSearchBar() {
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.showsLargeContentViewer = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.delegate?.shrinkMenu()
        self.delegate?.showButtons()
        
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension WordListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let textfieldNotEmpty = searchText.count != 0
        searching = textfieldNotEmpty
        
        searchedWordList = alphabeticalWordList.filter({ (word) -> Bool in
            word.word!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
        
    }
    
}
