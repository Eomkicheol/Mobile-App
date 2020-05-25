//
//  ViewItemPageRouter.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

@objc protocol ViewItemPageRoutingLogic {
    func toViewItemDetailPage()
}

protocol ViewItemPageDataPassing {
    var dataStore: ViewItemPageDataStore? { get }
}

class ViewItemPageRouter: NSObject, ViewItemPageRoutingLogic, ViewItemPageDataPassing {
    weak var viewController: ViewItemPageViewController?
    var dataStore: ViewItemPageDataStore?
    
    // MARK: Routing

    func toViewItemDetailPage() {
        let destinationVC = R.storyboard.viewItemDetailPage.viewItemDetailPageViewController()!
        var destinationDS = destinationVC.router!.dataStore!
        passDataToViewItemDetailPage(source: dataStore!, destination: &destinationDS)
        navigateToViewItemDetailPage(source: viewController!, destination: destinationVC)
    }

    // MARK: Navigation

    func navigateToViewItemDetailPage(source: ViewItemPageViewController, destination: ViewItemDetailPageViewController) {
        source.show(destination, sender: nil)
    }

    // MARK: Passing data

    func passDataToViewItemDetailPage(source: ViewItemPageDataStore, destination: inout ViewItemDetailPageDataStore) {
        destination.itemURI = source.itemURI
    }
}
