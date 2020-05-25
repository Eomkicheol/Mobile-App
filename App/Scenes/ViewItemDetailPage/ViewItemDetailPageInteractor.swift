//
//  ViewItemDetailPageInteractor.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemDetailPageBusinessLogic {
    func getItemImage()
}

protocol ViewItemDetailPageDataStore {
    var itemURI: String { get set }
}

class ViewItemDetailPageInteractor: ViewItemDetailPageBusinessLogic, ViewItemDetailPageDataStore {
    var presenter: ViewItemDetailPagePresentationLogic?
    var worker: ViewItemDetailPageWorker?
    var itemURI: String = ""

    init() {
        worker = ViewItemDetailPageWorker()
    }

    func getItemImage() {
        worker?.fetchDetailImage(form: itemURI, completed: { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter?.presentDetailImage(response)
            case .failure(let error):
                self?.presenter?.presentDetailFailed(with: error)
            }
        })
    }
}
