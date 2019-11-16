//
//  WordListTableViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-04.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

enum FilterOption : Int {
    case all = 0
    case incorrect = 1
    case favourite = 2
    case lastGame = 3
}


class WordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBOutlet var coverView: UIView!
    
    @IBOutlet var filterStackView: UIStackView!
    
    @IBOutlet var filterStackViewHeight: NSLayoutConstraint!
    
    private var filteredWordList: [Word] = []
     
    private var searchedWordList : [Word] = []
    
    private var searching : Bool = false
    
    private var filterBarHidden : Bool = false
    
    var selectedFilter : FilterOption?
    
    var delegate: MainMenuDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//        navigationController?.hidesBarsOnSwipe = true

        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        selectedFilter = FilterOption.all
        
        hideNavBar()
        
        loadAlphabeticalWordList()
        
        setupCoverView()
        
        hideCoverView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return UIStatusBarStyle.darkContent
        } else {
            return UIStatusBarStyle.default
        }
    }
    
    func setupCoverView() {
        self.coverView.backgroundColor = UIColor.white
    }
    
    func hideCoverView() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0
        }) { (success) in
            return
        }
    }
    
    func loadAlphabeticalWordList() {
        filteredWordList = WordManager.sharedInstance.getWordsFor(Filter: .all)
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
                filteredWordList.count == 0 ? 1 : filteredWordList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib.init(nibName: "WordListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "wordListCell")
        
        if ((searching && searchedWordList.count == 0) || (!searching && filteredWordList.count == 0)) {
            return emptyCell(forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordListCell", for: indexPath) as! WordListTableViewCell
        
        cell.word = searching ? searchedWordList[indexPath.row] : filteredWordList[indexPath.row]
        
        cell.wordLabel.text = searching ? searchedWordList[indexPath.row].word : filteredWordList[indexPath.row].word
        
        cell.correctLabel.text = searching ? "\(searchedWordList[indexPath.row].correctCount)" : "\(filteredWordList[indexPath.row].correctCount)"
        
        cell.incorrectLabel.text = searching ? "\(searchedWordList[indexPath.row].incorrectCount)" : "\(filteredWordList[indexPath.row].incorrectCount)"
        
        cell.genderIndicatorView.backgroundColor = searching ? {searchedWordList[indexPath.row].gender ? UIColor.flatRedDark() : UIColor.flatTealDark()}() : {filteredWordList[indexPath.row].gender ? UIColor.flatRedDark() : UIColor.flatTealDark()}()
        
        cell.updateStar()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func loadWordListFor(Filter filter:FilterOption) {
        
        filteredWordList = WordManager.sharedInstance.getWordsFor(Filter: filter)
    }
    
    func emptyCell(forIndexPath index : IndexPath) -> WordListTableViewCell {
        
        let emptyCell = tableView.dequeueReusableCell(withIdentifier: "wordListCell", for: index) as! WordListTableViewCell
        
        emptyCell.wordLabel.text = emptyCellText()
        emptyCell.correctLabel.text = "NA"
        emptyCell.incorrectLabel.text = "NA"
        
        return emptyCell
    }
    
    func emptyCellText()->String{
        switch (selectedFilter){
        case .incorrect: return "You haven't gotten any wrong, yet!"
        case .favourite: return "Click the ⭐️ to favourite a word"
        case .lastGame: return "No previous game found, go play!"
        default: return "No results found 😢"
        }
    }
    
    var selectedWord: Word = Word()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
         
        self.selectedWord = searching ? searchedWordList[indexPath.row] : filteredWordList[indexPath.row]
        
        self.performSegue(withIdentifier: "goToDetail", sender: self)
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:.main)
//
//        let detailVC = storyboard!.instantiateViewController(withIdentifier: "WordDetailViewController") as? WordDetailViewController
//
//        detailVC?.word = selectedWord
//
//        guard let push = detailVC else {return}
//
//        navigationController?.pushViewController(push, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToDetail") {
            if let detailVC = segue.destination as? WordDetailViewController {
                
                detailVC.word = self.selectedWord
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
 
        scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 ? hideFilterBar() : showFilterBar()
    }
    
    func hideFilterBar() {
        filterBarHidden = true
        self.filterStackViewHeight.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func showFilterBar() {
        filterBarHidden = false
        self.filterStackViewHeight.constant = 50
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func filterPressed(_ filterButton: UIButton) {
        
        selectedFilter = FilterOption(rawValue: filterButton.tag)
        
        loadWordListFor(Filter: selectedFilter!)
        
        tableView.reloadData()
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
        
        searchedWordList = filteredWordList.filter({ (word) -> Bool in
            word.word!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
        
    }
 
    
}

extension UINavigationController {

   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
