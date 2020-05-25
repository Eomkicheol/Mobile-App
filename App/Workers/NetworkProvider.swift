//
//  NetworkProvider.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

import Foundation

public protocol TargetType {
    var path: String { get }
}

protocol ProviderType: AnyObject {
    associatedtype Target: TargetType
    func request<T: Decodable>(with target: Target, objectType: T.Type, completion: @escaping (Result<T, AppError>) -> Void)
}

class NetworkProvider<Target: TargetType>: ProviderType {
    var session = URLSession.shared

    func request(with target: Target, completion: @escaping (Result<Data, AppError>) -> Void) {
        let dataURL = URL(string: target.path)!
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        let task = session.dataTask(with: request, completionHandler: { data, _, error in
            guard error == nil else {
                completion(Result.failure(AppError.networkError(error!)))
                return
            }

            guard let data = data else {
                completion(Result.failure(AppError.notFound))
                return
            }

            completion(Result.success(data))
        })
        task.resume()
    }

    func request<T: Decodable>(with target: Target, objectType: T.Type, completion: @escaping (Result<T, AppError>) -> Void) {
        request(with: target) { result in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let data):
                do {
                    let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                    completion(Result.success(decodedObject))
                } catch let error {
                    completion(Result.failure(AppError.jsonParsingError(error)))
                }
            }
        }
    }
}
