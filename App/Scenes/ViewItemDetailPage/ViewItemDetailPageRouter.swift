//
//  ViewItemDetailPageRouter.swift
//  App
//
//  Created by Schön, Ralph on 17.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

import UIKit

@objc protocol ViewItemDetailPageRoutingLogic {}

protocol ViewItemDetailPageDataPassing {
    var dataStore: ViewItemDetailPageDataStore? { get }
}

class ViewItemDetailPageRouter: NSObject, ViewItemDetailPageRoutingLogic, ViewItemDetailPageDataPassing {
    weak var viewController: ViewItemDetailPageViewController?
    var dataStore: ViewItemDetailPageDataStore?
}
