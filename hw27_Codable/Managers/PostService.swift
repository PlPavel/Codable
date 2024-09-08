//
//  PostService.swift
//  hw27_Codable
//
//  Created by Pavel Plyago on 05.07.2024.
//

import Foundation

class PostService{
    
    private let apiClient = RestApiClient.shared
    private let defaults = UserDefaults.standard
    
    //Использование метода GET
    
    func fetchUser(completion: @escaping (Result<[Post], NetworkError>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            completion(.failure(.customError("Invalid Url")))
            return
        }
        
        let request = URLRequest(url: url)
        
        apiClient.performRequest(request: request) { result in
            switch result {
            case .success(let data):
                do{
                    self.defaults.set(data, forKey: "posts")
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Использование метода POST
    
    func createUser(user: Post, completion: @escaping (Result<Post, NetworkError>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            completion(.failure(.customError("Invalid Url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            completion(.failure(.customError("Encoding error \(error.localizedDescription)")))
            return
        }
        
        apiClient.performRequest(request: request){ result in
            switch result {
            case .success(let post):
                do {
                    let post = try JSONDecoder().decode(Post.self, from: post)
                    completion(.success(post))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    //Использоание метода DELETE
    
    func deleteUser(id: Int, completion: @escaping (Result<Void, NetworkError>) -> Void){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)") else {
            completion(.failure(.customError("Invalid Url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        apiClient.performRequest(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Использование метода PUT
    
    func updateUser(id: Int, post: Post, completion: @escaping (Result<Post, NetworkError>) -> Void){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)") else {
            completion(.failure(.customError("Invalid Url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(post)
            request.httpBody = requestBody
        } catch {
            completion(.failure(.decodingError(error)))
        }
        
        apiClient.performRequest(request: request) { result in
            switch result{
            case .success(let post):
                do {
                    let post = try JSONDecoder().decode(Post.self, from: post)
                    completion(.success(post))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case.failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
