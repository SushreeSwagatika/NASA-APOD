//
//  APODCollectionCell.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import UIKit

class APODCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var apodData : APODData? {
        didSet {
            if let apodData = apodData {
                let url = URL(string:apodData.imageURL!)
                if let data = try? Data(contentsOf: url!)
                {
                    apodImageView.image = UIImage(data: data)
                }
                title.text = apodData.title
                desc.text = apodData.desc
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
