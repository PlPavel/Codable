//
//  RestApiClient.swift
//  hw27_Codable
//
//  Created by Pavel Plyago on 05.07.2024.
//

import Foundation
import UIKit



class RestApiClient {
    private let urlSession = URLSession.shared
    
    //использование синглтона
    public static let shared = RestApiClient()
    private init() {}
    
    // обработчик результатов UrlRequest запросов
    
    func performRequest(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.customError(error.localizedDescription)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
    
    
}
