//
//  ViewItemDetailPageViewController.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemDetailPageDisplayLogic: class {
    func showDetailImage(_ viewModel: ViewItemDetailPageViewModel)
    func showDetailFailure(_ title: String, errorDescription: String) 
}

final class ViewItemDetailPageViewController: UIViewController {
    var interactor: ViewItemDetailPageBusinessLogic?
    var router: (NSObjectProtocol & ViewItemDetailPageRoutingLogic & ViewItemDetailPageDataPassing)?
    
    @IBOutlet weak var imageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = ViewItemDetailPageInteractor()
        let presenter = ViewItemDetailPagePresenter()
        let router = ViewItemDetailPageRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = R.image.placeholder()
        interactor?.getItemImage()
    }
}

extension ViewItemDetailPageViewController: ViewItemDetailPageDisplayLogic {
    func showDetailImage(_ viewModel: ViewItemDetailPageViewModel) {
        imageView.image = viewModel.image
    }

    func showDetailFailure(_ title: String, errorDescription: String) {
        let okAction = UIAlertAction(title: R.string.localized.okActionTitle(), style: .default)
        showSystemAlert(title: title, message: errorDescription, actions: [okAction])
    }
}
