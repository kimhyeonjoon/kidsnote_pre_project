//
//  NetworkManager.swift
//  kidsnote
//
//  Created by Hyeonjoon Kim_M1 on 2024/01/17.
//

import Foundation

let apiKey = "AIzaSyC2B0T-WoMBLzp_neZ7Uy-9leYEPV0SWks"

public typealias ApiSuccess<T:Decodable> = ( _ item:T? ) -> Void
public typealias ApiFail = ( _ error: Error ) -> Void

enum Urls {
    case search(keyword: String)
    case detail(volumeId: String)
    
    var path: String {
        switch self {
        case .search(let keyword):
            guard let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
            return "https://www.googleapis.com/books/v1/volumes?q=\(query)&key=AIzaSyC2B0T-WoMBLzp_neZ7Uy-9leYEPV0SWks"
        case .detail(let volumeId):
            return "https://www.googleapis.com/books/v1/volumes/\(volumeId)?key=yourAPIKey"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<T: Decodable>(path: String,
                               completed:@escaping ApiSuccess<T> ,
                               failure:@escaping ApiFail) {
        
        guard let url = URL(string: path) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                failure(self.commonError(msg: "Error: HTTP request failed"))
                return
            }
            
            if let data = data {
                do {
                    let item = try JSONDecoder().decode(T.self, from: data)
                    completed(item)
                } catch let error {
                    failure(error)
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
