//
//  ViewItemPageInteractor.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemPageBusinessLogic {
    func getItemPage()
    func getItemThumbnail(with details: ViewItemRequestModel)
    func storeItemDetails(for item: ViewItemRequestModel)
}

protocol ViewItemPageDataStore {
    var itemURI: String { get set }
}

class ViewItemPageInteractor: ViewItemPageBusinessLogic, ViewItemPageDataStore {
    var presenter: ViewItemPagePresentationLogic?
    var worker: ViewItemPageWorker!
    var itemURI: String = ""

    init() {
        worker = ViewItemPageWorker()
    }

    func getItemPage() {
        worker.fetchItemURIs { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter?.presentItemList(response)
            case .failure(let error):
                self?.presenter?.presentItemListFailed(error)
            }
        }
    }

    func getItemThumbnail(with model: ViewItemRequestModel) {
        worker.fetchItemThumbnail(from: model.uri) { [weak self] result in
            switch result {
            case .success(let newItem):
                self?.presenter?.presentItem(newItem, indexPath: model.indexPath)
            case .failure(let error):
                let response = ViewItemResponseModel(sourceURI: model.uri, image: nil)
                self?.presenter?.presentItemFailed(response, indexPath: model.indexPath)
                print("Error fetching thumbnail: \(error)")
            }
        }
    }

    func storeItemDetails(for model: ViewItemRequestModel) {
        self.itemURI = model.uri
        presenter?.presentDetailView()
    }
}
