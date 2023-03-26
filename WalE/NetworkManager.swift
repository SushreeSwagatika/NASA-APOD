//
//  NetworkManager.swift
//  WalE
//
//  Created by Sushree Swagatika on 25/03/23.
//

import Foundation


enum APODError: Error {
    case badURL
    case noData
    case decodingError
}

protocol APIHandlerDelegate {
    func fetchData(url:URL, completion: @escaping (Result<Data,APODError>) -> Void)
}

protocol ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type:T.Type, data:Data, completion: @escaping (Result<T,APODError>) -> Void)
}


class NetworkManager {
    
    let apiHandler: APIHandler
    let responseHandler: ResponseHandler
    
    init(apiHandler: APIHandler = APIHandler(), responseHandler: ResponseHandler = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func fetchRequest<T: Codable>(type:T.Type, url:URL,completion: @escaping (Result<T,APODError>) -> Void) {
        
        apiHandler.fetchData(url: url, completion: { result in
            print(result)
            switch result {
            case .success(let data):
                self.responseHandler.fetchModel(type:type, data: data) { decodedResult in
                    switch decodedResult {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}




class APIHandler: APIHandlerDelegate {
    func fetchData(url:URL, completion: @escaping (Result<Data,APODError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            completion(.success(data))
        }.resume()
    }
}

class ResponseHandler: ResponseHandlerDelegate {
    func fetchModel<T: Codable>(type:T.Type, data:Data, completion: @escaping (Result<T,APODError>) -> Void) {
        let apodResponse = try? JSONDecoder().decode(type.self, from: data)
        if let apodResponse = apodResponse {
            return completion(.success(apodResponse))
        } else {
            return completion(.failure(.decodingError))
        }
    }
}
