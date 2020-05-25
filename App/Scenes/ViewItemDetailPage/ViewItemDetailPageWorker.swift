//
//  ViewItemDetailPageWorker.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

class ViewItemDetailPageWorker {
    private var cloud: ItemPageStore!

    init(_ cloud: ItemPageStore = ItemPageCloud()) {
        self.cloud = cloud
    }

    func fetchDetailImage(form uri: String, completed: @escaping (Result<Data, AppError>) -> Void) {
        cloud.getDetailImage(from: uri) { result in
            completed(result)
        }
    }
}
