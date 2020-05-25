//
//  ItemPageCloud.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

import Foundation
import Network

protocol ItemPageStore {
    /// Requests a item page for the given id
    ///
    /// - Parameters:
    ///   - itemId: the unique item identifier
    ///   - completed: a block object to be executed when the response arrived.
    ///   - result: a item page or a error object
    func get(_ itemId: String, completed: @escaping (_ result: Result<ItemPageDTO, AppError>) -> Void)

    /// Requests a thumbnail image for the given URI
    ///
    /// - Parameters:
    ///   - itemURI: a resource identifier
    ///   - completed: a block object to be executed when the response arrived.
    ///   - result: a jpg image as data or a error object
    func getThumbnail(from itemURI: String, completed: @escaping (_ result: Result<Data, AppError>) -> Void)


    /// Requests a full size image for the given URI
    ///
    /// - Parameters:
    ///   - itemURI: a resource identifier
    ///   - completed: a block object to be executed when the response arrived.
    ///   - result: a jpg image as data or a error object
    func getDetailImage(from itemURI: String, completed: @escaping (_ result: Result<Data, AppError>) -> Void)
}

enum ItemPageCloudAPI {
    case getItemPage(_ itemId: String)
    case getItemPageThumbnail(_ itemURI: String)
    case getItemPageDetail(_ itemURI: String)
}

extension ItemPageCloudAPI: TargetType {
    var path: String {
        switch self {
        case .getItemPage(let itemId):
            return "https://m.mobile.de/svc/a/\(itemId)"
        case .getItemPageThumbnail(let itemURI):
            return "https://\(itemURI)_2.jpg"
        case .getItemPageDetail(let itemURI):
            return "https://\(itemURI)_27.jpg"
        }
    }
}

class ItemPageCloud: ItemPageStore {
    var provider: NetworkProvider<ItemPageCloudAPI>?

    init() {
        provider = NetworkProvider()
    }

    func get(_ itemId: String, completed: @escaping (Result<ItemPageDTO, AppError>) -> Void) {
        provider?.request(with: .getItemPage(itemId), objectType: ItemPageDTO.self, completion: { result in
            completed(result)
        })
    }

    func getThumbnail(from itemURI: String, completed: @escaping (Result<Data, AppError>) -> Void) {
        provider?.request(with: .getItemPageThumbnail(itemURI), completion: { result in
            completed(result)
        })
    }

    func getDetailImage(from itemURI: String, completed: @escaping (Result<Data, AppError>) -> Void) {
        provider?.request(with: .getItemPageDetail(itemURI), completion: { result in
            completed(result)
        })
    }
}
