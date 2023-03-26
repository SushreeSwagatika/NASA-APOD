//
//  APODViewController.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import UIKit

class APODViewController: UIViewController {
    
    private var apodViewModel: APODViewModel!
    
    @IBOutlet weak var apodCollectionView: UICollectionView!
    
    private var dataSource : APODCollectionViewDataSource<APODCollectionCell,APODData>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apodCollectionView.dataSource = self.dataSource
        callViewModelForUIUpdate()
    }
    
    //MARK: - 
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.apodCollectionView.reloadData()
        }
    }
    
    func isConnected() -> Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    func callViewModelForUIUpdate() {
        self.apodViewModel = APODViewModel()
        
        if !isConnected() {
            let alert = UIAlertController(title: "Alert", message: "We are not connected to the internet.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.apodViewModel.bindAPODViewModelToController = {
            self.updateDataSource()
            self.reloadCollectionView()
        }
    }
    
    func updateDataSource() {
        self.dataSource = APODCollectionViewDataSource(cellIdentifier: Constants.collectionCellIdentifier, items: [self.apodViewModel.apodModelData!], configureCell: { (cell, item) in
            cell.apodData = item
        })

        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.apodCollectionView.dataSource = self.dataSource
                self.reloadCollectionView()
            }
        }
    }
    
}


