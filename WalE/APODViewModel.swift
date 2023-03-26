//
//  APODViewModel.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import Foundation
import UIKit
import CoreData

class APODViewModel: NSObject {
    
    private var serviceHandler: APODDelegate!
    private var databasehandler: DatabaseDelegate!
    
    let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
    
    private(set) var apodModelData : APODData? {
        didSet {
            self.bindAPODViewModelToController()
        }
    }
    
    var bindAPODViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        
        self.serviceHandler = ServiceHandler()
        self.databasehandler = DatabaseHandler()
        
        addNotificationObservers()
        self.fetchAPOD()
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAPOD), name: .networkConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAPOD), name: .networkDisconnected, object: nil)
    }
    
    private func isConnected() -> Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    @objc func fetchAPOD() {
        if isConnected() {
            ServiceHandler().fetchAstronomyPicture {
                result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        print("new pic fetched")
                        self.apodModelData = data
                        
                        DatabaseHandler().saveAstronomyPicture(url: data.imageURL!, title: data.title!, description: data.desc!)
                    case .failure(let error):
                        print("failed to fetch pic with error \(error)")
                    }
                }
            }
        } else {
            if let model: APODCoreDataModel = fetchRecordFromDatabase() {
                self.apodModelData = APODData(title: model.title, desc: model.explanation, imageURL: model.url)
            } else {
                self.apodModelData = APODData(title: "Title", desc: "Explanation", imageURL: "https://apod.nasa.gov/apod/image/2303/_GHR3094-venerelunafirma.jpg")
                // dummy data
            }
        }
    }
    
    private func fetchRecordFromDatabase() -> APODCoreDataModel? {
        let fetchRequest: NSFetchRequest<APODCoreDataModel> = APODCoreDataModel.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try coreDataStack.managedContext.fetch(fetchRequest)
            return result[0]
        } catch {
            print("Failed to fetch CoreData model")
        }
        return nil
    }
}
