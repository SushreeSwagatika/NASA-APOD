//
//  ServiceHandler.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import Foundation

protocol APODDelegate: AnyObject {
    func fetchAstronomyPicture(completion: @escaping (Result<APODData,APODError>) -> Void)
}

class ServiceHandler: APODDelegate {
    private let baseSearchURL = "https://api.nasa.gov"
    private let apiKey = "JxMEt8SPyyakmEojIRXXLSyeYxmIWRUu5aANcMuh"
    private let apiMethod = "planetary/apod"
    private let format = "json"
    private let noJsonCallback = "1"
    func fetchAstronomyPicture(completion: @escaping (Result<APODData,APODError>) -> Void)
    {
        guard let url = setupURL() else {
            return completion(.failure(.badURL))
        }
        NetworkManager().fetchRequest(type: APODData.self, url: url, completion: completion)
    }
    
    private func setupURL() -> URL? {
        guard var components = URLComponents(string: baseSearchURL) else {
            return nil
        }
        components.queryItems = [
            URLQueryItem(name: "method", value: apiMethod),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "nojsoncallback", value: noJsonCallback),
        ]
        return components.url
    }
}
