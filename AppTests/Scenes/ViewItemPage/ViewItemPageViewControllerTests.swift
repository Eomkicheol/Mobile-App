//
//  ViewItemPageViewControllerTests.swift
//  AppTests
//
//  Created by Schön, Ralph on 20.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemPageViewControllerTests: XCTestCase {
    var sut: ViewItemPageViewController!
    var window: UIWindow!
    let spy = BusinessSpy()
    let routerSpy = RouterSpy()

    override func setUp() {
        super.setUp()
        window = UIWindow()
        sut = R.storyboard.viewItemPage.viewItemPageViewController()!
        sut.interactor = spy
        sut.router = routerSpy
    }

    override func tearDown() {
        sut = nil
        window = nil
        super.tearDown()
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    func test_viewDidLoad() {
        // when
        loadView()

        // then
        expect(self.sut.title).to(equal(R.string.localized.appTitle()))
        expect(self.spy.didCallGetItemPage).to(equal(1))
    }

    func test_showDetails() {
        // given
        loadView()

        // when
        sut.showDetails()

        // then
        expect(self.routerSpy.didCallRouteToViewItemDetail).to(equal(1))
    }

    func test_collectionDelegate_getItemThumbnail_callsGetItemThumbnail() {
        // when
        sut.getItemThumbnail(with: ViewItemRequestModel(uri: "", indexPath: IndexPath(row: 0, section: 0)))

        // then
        expect(self.spy.didCallItemThumbnail).to(equal(1))
    }
}

extension ViewItemPageViewControllerTests {
    class BusinessSpy: ViewItemPageBusinessLogic {
        var didCallGetItemPage = 0
        var didCallItemThumbnail = 0
        var didCallStoreItemDetails = 0

        func getItemPage() {
            didCallGetItemPage += 1
        }

        func getItemThumbnail(with details: ViewItemRequestModel) {
            didCallItemThumbnail += 1
        }

        func storeItemDetails(for item: ViewItemRequestModel) {}
    }

    class RouterSpy: NSObject & ViewItemPageRoutingLogic & ViewItemPageDataPassing {
        var dataStore: ViewItemPageDataStore?
        var didCallRouteToViewItemDetail = 0

        func toViewItemDetailPage() {
            didCallRouteToViewItemDetail += 1
        }
    }
}
