//
//  StatsReskinViewController.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-11-17.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class StatsReskinViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let statsNibName = "StatsCircleProgressCell"
    let statsCellId = "statsCellId"
    
    var statsToDisplay: [Double] = [25,50,75,100]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
    
        collectionView.register(UINib(nibName: statsNibName, bundle: nil), forCellWithReuseIdentifier: statsCellId)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func setupCell(_ cell: StatsCircleProgressCell, atIndexPath ip: IndexPath) {
        
        cell.valueToDisplay = statsToDisplay[ip.row]
        
    }
    
}

extension StatsReskinViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statsToDisplay.count
    }
    
}

extension StatsReskinViewController: UICollectionViewDataSource {
        
    func collectionView(_ cv: UICollectionView, cellForItemAt ip: IndexPath) -> UICollectionViewCell {
        
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: statsCellId, for: ip) as? StatsCircleProgressCell else {fatalError()}
        
        cell.valueToDisplay = statsToDisplay[ip.row]
        cell.setupPercentLabelAnimation()
        cell.setupCircularProgressBar()

        cell.animateProgressCircle()
        cell.animatePercentLabel()
        
        return cell
    }
    
}

extension StatsReskinViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellSquareSize: CGFloat = screenWidth / 2.2
        return CGSize(width:cellSquareSize, height:cellSquareSize);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
