//
//  NetworkError.swift
//  hw27_Codable
//
//  Created by Pavel Plyago on 04.07.2024.
//

import Foundation


enum NetworkError: Error{
    case customError(String)
    case emptyData
    case invalidStatusCode
    case decodingError(Error)
}
