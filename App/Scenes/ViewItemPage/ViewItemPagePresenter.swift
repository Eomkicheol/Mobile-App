//
//  ViewItemPagePresenter.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemPagePresentationLogic {
    func presentItem(_ response: ViewItemResponseModel, indexPath: IndexPath)
    func presentItemList(_ response: ViewItemPageResponseModel)
    func presentItemFailed(_ response: ViewItemResponseModel, indexPath: IndexPath)
    func presentItemListFailed(_ error: AppError)
    func presentDetailView()
}

class ViewItemPagePresenter: ViewItemPagePresentationLogic {
    weak var viewController: ViewItemPageDisplayLogic?

    func presentItem(_ response: ViewItemResponseModel, indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            let viewModel = ViewItemPageRow(sourceURI: response.sourceURI,
                                            state: .downloaded,
                                            image: response.image)
            self?.viewController?.updateItemWithThumbnail(viewModel, indexPath: indexPath)
        }
    }

    func presentItemList(_ response: ViewItemPageResponseModel) {
        let section = ViewItemPageSection(rows:
            response.sourceURIs.map {
                ViewItemPageRow(sourceURI: $0)
            }
        )
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showItemPage(ViewItemPageViewModel(sections: [section]))
        }
    }

    func presentItemFailed(_ response: ViewItemResponseModel, indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            let viewModel = ViewItemPageRow(sourceURI: response.sourceURI,
                                            state: .failed)
            self?.viewController?.updateItemWithThumbnail(viewModel, indexPath: indexPath)
        }
    }

    func presentItemListFailed(_ error: AppError) {
        let errorDescription = error.errorDescription ?? R.string.localized.errorUnknown()
        viewController?.showItemPageFailure(error.errorTitle, errorDescription: errorDescription)
    }

    func presentDetailView() {
        viewController?.showDetails()
    }
}
