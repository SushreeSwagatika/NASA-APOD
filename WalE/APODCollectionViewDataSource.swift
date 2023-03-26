//
//  APODCollectionViewDataSource.swift
//  WalE
//
//  Created by Sushree Swagatika on 26/03/23.
//

import UIKit

class APODCollectionViewDataSource<APODCollectionCell : UICollectionViewCell,T> : NSObject, UICollectionViewDataSource {
    
    private var cellIdentifier : String!
    private var items : [T]?
    var configureCell : (APODCollectionCell, T) -> () = {_,_ in }
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (APODCollectionCell, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  Constants.collectionCellIdentifier, for: indexPath) as? APODCollectionCell {
            if let item = self.items?[indexPath.row] {
                self.configureCell(cell, item)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
}
