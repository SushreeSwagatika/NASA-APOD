//
//  APODModel.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import UIKit

struct APODData: Codable
{
    let title: String?
    let desc: String?
    let imageURL: String?

    enum CodingKeys:String, CodingKey {
        case title
        case desc = "explanation"
        case imageURL = "hdurl"
    }
}
