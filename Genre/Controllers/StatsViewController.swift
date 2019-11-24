//
//  StatsReskinViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit


class StatsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var leftHeaderLabel: UILabel!
    @IBOutlet weak var rightHeaderLabel: UILabel!
    @IBOutlet weak var leftHeaderStat: UILabel!
    @IBOutlet weak var rightHeaderStat: UILabel!
    
    @IBOutlet weak var headerExpandButton: UIButton!
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: Properties
    var leftDisplayLink: CADisplayLink?
    var rightDisplayLink: CADisplayLink?
    let animationDuration: Double = 1.5
    let animationStart: Date = Date()

    var delegate: MainMenuDelegate?
    
    var statsToDisplay: [Double] = [Double]()
    var cellColourArray: [UIColor] = [.systemBlue, .systemPink, .systemOrange, .systemGreen]
    var cellDescArray: [String] = ["Overall", "Exceptions", "Masculine", "Feminine"]
    
    var originalHeaderFrame: CGRect?
    var originalCellFrame: CGRect?
    
    //MARK: Lifecycle
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
    
    //MARK: Setup
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
    
    //MARK: Load Stats
    func loadStats() {
        statsToDisplay.append(StatsManager.sharedInstance.getOverallCorrectPercentage())
        statsToDisplay.append(69.0)
        statsToDisplay.append(StatsManager.sharedInstance.getOverallCorrectPercentage(forGender: true))
        statsToDisplay.append(StatsManager.sharedInstance.getOverallCorrectPercentage(forGender: false))
        statsToDisplay.append(Double(StatsManager.sharedInstance.getTotalSessionsCount()))
        statsToDisplay.append(Double(StatsManager.sharedInstance.getTotalAnswerCount()))
    }
    
    //MARK: CADisplayLink
    func setupLeftPercentLabelAnimation() {
        leftDisplayLink = CADisplayLink(target: self, selector: #selector(animateLeftPercentLabel))
        leftDisplayLink?.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    @objc func animateLeftPercentLabel() {
        
        let start: Double = 0
        let end = statsToDisplay[4]
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
       
        if elapsedTime > 1.0 {
        self.leftHeaderStat.text = "\(Int(end))"
        self.leftDisplayLink?.invalidate()
        self.leftDisplayLink = nil
       }
       else {
        let percentComplete = elapsedTime / animationDuration
        let value = Int(start + percentComplete * (Double(end) - start))
        self.leftHeaderStat.text = "\(value)"
       }
    }
    
    func setupRightLabelAnimation() {
        rightDisplayLink = CADisplayLink(target: self, selector: #selector(animateRightPercentLabel))
        rightDisplayLink?.add(to: .main, forMode: RunLoop.Mode.default)
    }
    
    @objc func animateRightPercentLabel() {
        
        let start: Double = 0
        let end = statsToDisplay[5]
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStart)
    
        if elapsedTime > 1.0 {
        self.rightHeaderStat.text = "\(Int(end))"
        self.rightDisplayLink?.invalidate()
        self.rightDisplayLink = nil
       }
       else {
        let percentComplete = elapsedTime / animationDuration
        let value = Int(start + percentComplete * (Double(end) - start))
        self.rightHeaderStat.text = "\(value)"
       }
    }
    
    //MARK:IB Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.delegate?.shrinkMenu()
        self.delegate?.showButtons()
        
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func headerExpandButtonPressed(_ sender: UIButton) {
        self.expandOrShrinkHeader()
    }
    
    //MARK:UI Animations
    func expandOrShrinkHeader() {
        
        if self.headerHeightConstraint.constant != 535 {
           self.headerHeightConstraint.constant = 535
        }
        else {self.headerHeightConstraint.constant = 200}
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completion) in
            
            self.showChartView()
        }
        
    }
    
    func expandOrShrinkCell(_ cell:StatsCircleProgressCell) {
        cell.removeCircularProgressBar()
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            if (cell.frame != self.collectionView.bounds) {
                self.originalCellFrame = cell.frame
                cell.frame = self.collectionView.bounds
            }
            else {cell.frame = self.originalCellFrame!}
            
            cell.positionCircularProgressBar()
            
        }) { (completion) in
            return
        }
    }
    
    //MARK:Macaw Chart View
    
    @IBOutlet weak var chartView: MacawChartView!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chartViewWidth: NSLayoutConstraint!
    
    func showChartView() {
        
        chartView.contentMode = .scaleAspectFit
        chartView.isHidden = !chartView.isHidden
        MacawChartView.reloadSessions()
        MacawChartView.playAnimation()
        
//        chartViewWidth.constant = self.chartView.frame.size.width * 0.8
//        chartViewHeight.constant =  self.chartView.frame.size.height * 0.5

        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (completion) in
            return
        }
    }
    
}

//MARK: UICollectionViewDelegate
extension StatsViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statsToDisplay.count-2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! StatsCircleProgressCell
        
        expandOrShrinkCell(cell)
        
        collectionView.isScrollEnabled = false
        collectionView.bringSubviewToFront(cell)
    }
}

//MARK: UICollectionViewDataSource
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

//MARK: UICollectionViewDelegateFlowLayout
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

//MARK: Shadow Helper
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

