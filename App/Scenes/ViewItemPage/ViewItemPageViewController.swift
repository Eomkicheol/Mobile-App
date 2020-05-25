//
//  ViewItemPageViewController.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

protocol ViewItemPageDisplayLogic: class {
    func showItemPage(_ viewModel: ViewItemPageViewModel)
    func updateItemWithThumbnail(_ item: ViewItemPageRow, indexPath: IndexPath)
    func showItemPageFailure(_ title: String, errorDescription: String)
    func showDetails()
}

final class ViewItemPageViewController: UIViewController {
    var interactor: ViewItemPageBusinessLogic?
    var router: (NSObjectProtocol & ViewItemPageRoutingLogic & ViewItemPageDataPassing)?
    var dataSource = ViewItemPageDataSource()

    @IBOutlet var pageCollection: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = ViewItemPageInteractor()
        let presenter = ViewItemPagePresenter()
        let router = ViewItemPageRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localized.appTitle()
        setupCollectionView()
        interactor?.getItemPage()
    }

    private func setupCollectionView() {
        dataSource.delegate = self
        pageCollection.delegate = self
        pageCollection.dataSource = dataSource
        pageCollection.register(R.nib.itemCell)
    }
}

extension ViewItemPageViewController: ViewItemPageDisplayLogic {
    func showItemPage(_ viewModel: ViewItemPageViewModel) {
        dataSource.dataStore = viewModel
        pageCollection.reloadData()
    }

    func updateItemWithThumbnail(_ item: ViewItemPageRow, indexPath: IndexPath) {
        guard var newDataSource = dataSource.dataStore else { return }
        newDataSource.sections[indexPath.section].rows[indexPath.row] = item
        dataSource.dataStore = newDataSource
        pageCollection.reloadItems(at: [indexPath])
    }

    func showItemPageFailure(_ title: String, errorDescription: String) {
        let okAction = UIAlertAction(title: R.string.localized.okActionTitle(), style: .default)
        showSystemAlert(title: title, message: errorDescription, actions: [okAction])
    }

    func showDetails() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: R.string.localized.viewItemDetailPageBackTitle(), style: .plain, target: nil, action: nil)
        router?.toViewItemDetailPage()
    }
}

extension ViewItemPageViewController: ViewItemPageCollectionDelegate {
    func getItemThumbnail(with details: ViewItemRequestModel) {
        interactor?.getItemThumbnail(with: details)
    }
}

extension ViewItemPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.dataStore?.sections[indexPath.section].rows[indexPath.row] else { return }
        let requestModel = ViewItemRequestModel(uri: item.sourceURI, indexPath: indexPath)
        interactor?.storeItemDetails(for: requestModel)
    }
}
