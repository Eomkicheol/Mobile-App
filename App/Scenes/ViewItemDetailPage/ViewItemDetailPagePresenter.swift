//
//  ViewItemDetailPagePresenter.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemDetailPagePresentationLogic {
    func presentDetailImage(_ imageData: Data)
    func presentDetailFailed(with error: AppError)
}

class ViewItemDetailPagePresenter: ViewItemDetailPagePresentationLogic {
    weak var viewController: ViewItemDetailPageDisplayLogic?

    func presentDetailImage(_ imageData: Data) {
        let viewModel = ViewItemDetailPageViewModel(image: UIImage(data: imageData))
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showDetailImage(viewModel)
        }
    }

    func presentDetailFailed(with error: AppError) {
        DispatchQueue.main.async { [weak self] in
            let errorDescription = error.errorDescription ?? R.string.localized.errorUnknown()
            self?.viewController?.showDetailFailure(error.errorTitle, errorDescription: errorDescription)
        }
    }
}
