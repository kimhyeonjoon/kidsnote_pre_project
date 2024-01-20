//
//  NetworkManager.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import Foundation
import UIKit

let apiKey = "AIzaSyC2B0T-WoMBLzp_neZ7Uy-9leYEPV0SWks"

public typealias ApiSuccess<T:Decodable> = ( _ item: T? ) -> Void
public typealias ApiImageSuccess = ( _ image: UIImage ) -> Void
public typealias ApiFail = ( _ error: Error ) -> Void

enum Urls {
    case search(startIndex: String, keyword: String)
    case detail(volumeId: String)
    
    var path: String {
        switch self {
        case let .search(startIndex, keyword):
            guard let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
            return "https://www.googleapis.com/books/v1/volumes?q=\(query)&startIndex=\(startIndex)&maxResults=40&key=\(apiKey)"
        case .detail(let volumeId):
            return "https://www.googleapis.com/books/v1/volumes/\(volumeId)?key=\(apiKey)"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<T: Decodable>(path: String, completed:@escaping ApiSuccess<T>, failure:@escaping ApiFail) {
        
        guard let url = URL(string: path) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    failure(self.commonError(msg: "Error: HTTP request failed"))
                }
                return
            }
            
            if let data = data {
                do {
                    let item = try JSONDecoder().decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completed(item)
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    failure(self.commonError(msg: "Error: Request Error"))
                }
            }
            
        }.resume()
    }
    
    func requestImage(path: String, completed:@escaping ApiImageSuccess, failure:@escaping ApiFail) {
        
        guard let url = URL(string: path) else {
            DispatchQueue.main.async {
                failure(self.commonError(msg: "Error: image url"))
            }
            return
        }
        
        // image cache
        if let image = ImageCacheManager.shared.object(forKey: path as NSString) {
            DispatchQueue.main.async {
                completed(image)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                failure(self.commonError(msg: "Error: HTTP request failed"))
                return
            }
            
            guard let mimeType = response.mimeType, mimeType.hasPrefix("image") else {
                failure(self.commonError(msg: "Error: Image Type"))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCacheManager.shared.setObject(image, forKey: path as NSString)
                    completed(image)                    
                }
            } else {
                DispatchQueue.main.async {
                    failure(self.commonError(msg: "Error: Request Error"))
                }
            }
            
        }.resume()
    }
    
    func commonError(msg: String) -> NSError {
        print(msg)
        let userInfo = [NSLocalizedFailureReasonErrorKey: msg]
        return NSError(domain: "kidsnote_error", code: -999, userInfo: userInfo)
    }
}


class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
