//
//  StatsReskinViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let cellSquareSize: CGFloat = screenWidth / 2.5


class StatsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var leftHeaderLabel: UILabel!
    @IBOutlet weak var rightHeaderLabel: UILabel!
    @IBOutlet weak var leftHeaderStat: UILabel!
    @IBOutlet weak var rightHeaderStat: UILabel!
    
    var displayLink: CADisplayLink?
    let animationDuration: Double = 1.5
    let animationStart: Date = Date()
    
    let statsNibName = "StatsCircleProgressCell"
    let statsCellId = "statsCellId"

    var delegate: MainMenuDelegate?
    
    var statsToDisplay: [Double] = [Double]()
    var cellColourArray: [UIColor] = [.systemBlue, .systemPink, .systemOrange, .systemGreen]
    var cellDescArray: [String] = ["Overall", "Exceptions", "Masculine", "Feminine"]
    
    var originalFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) { overrideUserInterfaceStyle = .light }
        
        self.loadStats()
        self.setupNavigationController()
        self.setupView()
        self.setupCollectionView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return UIStatusBarStyle.darkContent } else { return UIStatusBarStyle.default }
    }
    
    func setupView() {
        
        self.headerView.layer.cornerRadius = 15
        
        self.headerView.addDefaultShadow()
        
        setupLeftPercentLabelAnimation()
        setupRightLabelAnimation()
        animateLeftPercentLabel()
        animateRightPercentLabel()
    }
    
    func setupCollectionView() {
    
        self.collectionView.layer.masksToBounds = false
        
        collectionView.register(UINib(nibName: statsNibName, bundle: nil), forCellWithReuseIdentifier: statsCellId)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func setupNavigationController() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    func setupCell(_ cell: StatsCircleProgressCell, atIndexPath ip: IndexPath) {
        
        cell.valueToDisplay = statsToDisplay[ip.row]
        cell.statDescriptionLabel.text = cellDescArray[ip.row]
        cell.backgroundColor = cellColourArray[ip.row]
    }
    
    func loadStats() {
        statsToDisplay.append(Double(StatsManager.sharedInstance.getTotalSessionsCount()))
        statsToDisplay.append(Double(StatsManager.sharedInstance.getTotalAnswerCount()))
        statsToDisplay.append(StatsManager.sharedInstance.getOverallCorrectPercentage())
        statsToDisplay.append(33.0)
        statsToDisplay.append(StatsManager.sharedInstance.getOverallCorrectPercentage(forGender: true))
        statsToDisplay.append(StatsManager.sharedInstance.getOverallCorrectPercentage(forGender: false))
    }
    
    func setupLeftPercentLabelAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(animateLeftPercentLabel))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    @objc func animateLeftPercentLabel() {
        
        let start: Double = 0
        let end = statsToDisplay[0]
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
       
        if elapsedTime > 1.0 {
        self.leftHeaderStat.text = "\(Int(end))%"
        self.displayLink!.invalidate()
        self.displayLink = nil
       }
       else {
        let percentComplete = elapsedTime / animationDuration
        let value = Int(start + percentComplete * (Double(end) - start))
        self.leftHeaderStat.text = "\(value)%"
       }
    }
    
    func setupRightLabelAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(animateRightPercentLabel))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    @objc func animateRightPercentLabel() {
        
        let start: Double = 0
        let end = statsToDisplay[1]
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
    
        if elapsedTime > 1.0 {
        self.rightHeaderStat.text = "\(Int(end))%"
        self.displayLink!.invalidate()
        self.displayLink = nil
       }
       else {
        let percentComplete = elapsedTime / animationDuration
        let value = Int(start + percentComplete * (Double(end) - start))
        self.rightHeaderStat.text = "\(value)%"
       }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.delegate?.shrinkMenu()
        self.delegate?.showButtons()
        
        self.navigationController?.popViewController(animated: false)
    }
}


extension StatsViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statsToDisplay.count-2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! StatsCircleProgressCell
        collectionView.isScrollEnabled = false
        collectionView.bringSubviewToFront(cell)
        
        cell.removeCircularProgressBar()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            
            if (cell.frame != collectionView.bounds) {
                self.originalFrame = cell.frame
                cell.frame = collectionView.bounds
            }
            else {cell.frame = self.originalFrame!}
            
            cell.positionCircularProgressBar()
            
        }) { (completion) in
            return
        }
    }
    
}

extension StatsViewController: UICollectionViewDataSource {
        
    func collectionView(_ cv: UICollectionView, cellForItemAt ip: IndexPath) -> UICollectionViewCell {
        
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: statsCellId, for: ip) as? StatsCircleProgressCell else {fatalError()}
        
        cell.backgroundColor = cellColourArray[ip.row]
        cell.valueToDisplay = statsToDisplay[ip.row]
        cell.statDescriptionLabel.text = cellDescArray[ip.row]
        cell.setupPercentLabelAnimation()
        cell.positionCircularProgressBar()

        cell.animateProgressCircle()
        cell.animatePercentLabel()
        
        return cell
    }
    
}

extension StatsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:cellSquareSize, height:cellSquareSize);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension UIView {
    
    func addDefaultShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowRadius = CGFloat(6)
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

