//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

enum ResponseError: Error {
    case unknownURL
    case unknownStatusCode
    case dataDoesNotExist
}

class DataManager {
    
    private let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    private let coreDataManager = CoreDataManager.shared
    
    func fetchQuotes(completionHandler: @escaping ([Quote]) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: path) else {
            errorHandler(ResponseError.unknownURL)
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url) { [unowned self] data, response, error in
            if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
                errorHandler(ResponseError.unknownStatusCode)
                return
            }
            
            if let error = error, data == nil {
                errorHandler(error)
                return
            }
            
            guard let data = data else {
                errorHandler(ResponseError.dataDoesNotExist)
                return
            }
            
            do {
                let data = try JSONDecoder().decode([Quote].self, from: data)
                let favData = fetchFavorites()
                let _data = data.map { model in
                    var _model = model
                    _model.isFavorite = favData.contains(where: { $0.name == model.name })
                    return _model
                }
                DispatchQueue.main.async {
                    completionHandler(_data)
                }
            } catch {
                errorHandler(error)
            }
        }.resume()
    }
    
    func addToFavorites(_ quote: Quote) {
        coreDataManager.save(quote: quote)
    }
    
    func fetchFavorites() -> [Quote] {
        coreDataManager.fetch()
    }
    
    func deleteFavorite(_ quote: Quote) {
        coreDataManager.delete(quote: quote)
    }
}
