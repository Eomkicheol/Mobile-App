//
//  ViewItemPageWorker.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

class ViewItemPageWorker {
    private var cloud: ItemPageStore!

    init(_ cloud: ItemPageStore = ItemPageCloud()) {
        self.cloud = cloud
    }

    func fetchItemURIs(completed: @escaping (Result<ViewItemPageResponseModel, AppError>) -> Void) {
        cloud.get(APIConfig.carId) { result in
            switch result {
            case .failure(let error):
                completed(Result.failure(error))
            case .success(let itemPage):
                let responseModel = ViewItemPageResponseModel(sourceURIs: itemPage.images.compactMap { $0.uri })
                completed(Result.success(responseModel))
            }
        }
    }

    func fetchItemThumbnail(from uri: String, completed: @escaping (Result<ViewItemResponseModel, AppError>) -> Void) {
        cloud.getThumbnail(from: uri) { result in
            switch result {
            case .success(let thumbnail):
                let image = UIImage(data: thumbnail)
                let responseModel = ViewItemResponseModel(sourceURI: uri, image: image)
                completed(Result.success(responseModel))
            case .failure(let error):
                completed(Result.failure(error))
            }
        }
    }
}
