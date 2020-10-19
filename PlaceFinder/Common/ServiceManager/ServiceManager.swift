//
//  ServiceManager.swift
//  PlaceFinder
//
//  Created by Milton Palaguachi on 10/18/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case serverError
    case decodingFailed
}

class ServiceManager {
    
    static let manager = ServiceManager()
       
       private init() {}
       // swiftlint:disable type_name superfluous_disable_command
       // swiftlint:disable identifier_name
    func request<T: Decodable>(_ t: T.Type, withRequest urlRequest: URLRequest, complitionHandler: @escaping (Result < T, CustomError>) -> Void ) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, reponse, error in
            guard let httpResponse = reponse as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data else {
                DispatchQueue.main.async {
                    complitionHandler(.failure(.serverError))
                }
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    complitionHandler(.success(obj))
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    complitionHandler(.failure(.decodingFailed))
                }
            }
        }
        task.resume()
    }
}
