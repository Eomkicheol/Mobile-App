//
//  ViewItemPagePresenterTests.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemPagePresenterTests: XCTestCase {
    var sut: ViewItemPagePresenter!
    let spy = DisplaySpy()

    override func setUp() {
        super.setUp()
        sut = ViewItemPagePresenter()
        sut.viewController = spy
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_presentItem_callsUpdateItemWithThumbnail() {
        // given
        let sourceURI = "testURI123"
        let response = ViewItemResponseModel(sourceURI: sourceURI, image: R.image.placeholder())
        let indexPath = IndexPath(row: 3, section: 4)
        let expectedItem = ViewItemPageRow(sourceURI: sourceURI,
                                           state: .downloaded,
                                           image: R.image.placeholder())

        // when
        sut.presentItem(response, indexPath: indexPath)

        // then
        expect(self.spy.didCallUpdateItem).toEventually(equal(1))
        expect(self.spy.responseItem).toEventually(equal(expectedItem))
        expect(self.spy.responseIndexPath).toEventually(equal(indexPath))
    }

    func test_presentItemList_callsShowItemPage() {
        // given
        let sourceURIs = ["123", "abc", "GFD"]
        let response = ViewItemPageResponseModel(sourceURIs: sourceURIs)
        let section = ViewItemPageSection(rows: [ViewItemPageRow(sourceURI: sourceURIs[0]),
                                                 ViewItemPageRow(sourceURI: sourceURIs[1]),
                                                 ViewItemPageRow(sourceURI: sourceURIs[2])])
        let expectedViewModel = ViewItemPageViewModel(sections: [section])

        // when
        sut.presentItemList(response)

        // then
        expect(self.spy.didCallShowItemPage).toEventually(equal(1))
        expect(self.spy.responseViewModel).toEventually(equal(expectedViewModel))
    }

    func test_presentItemFailed_callsUpdateItemWithThumbnail() {
        // given
        let sourceURI = "uri123Test"
        let response = ViewItemResponseModel(sourceURI: sourceURI, image: nil)
        let indexPath = IndexPath(row: 1, section: 33)
        let expectedItem = ViewItemPageRow(sourceURI: sourceURI,
                                           state: .failed)

        // when
        sut.presentItemFailed(response, indexPath: indexPath)

        // then
        expect(self.spy.didCallUpdateItem).toEventually(equal(1))
        expect(self.spy.responseItem).toEventually(equal(expectedItem))
        expect(self.spy.responseIndexPath).toEventually(equal(indexPath))
    }

    func test_presentItemListFailed_callsSowItemPageFailure() {
        // given
        let responseError = AppError.networkError(NSError(domain: "", code: NSURLErrorNotConnectedToInternet, userInfo: nil))
        let expectedTitleDescription = responseError.errorTitle + responseError.errorDescription!

        // when
        sut.presentItemListFailed(responseError)

        // then
        expect(self.spy.didCallShowItemPageFailure).toEventually(equal(1))
        expect(self.spy.errorTitleDescription).toEventually(equal(expectedTitleDescription))
    }

    func test_presentDetailView_callsShowDetails() {
        // when
        sut.presentDetailView()

        // then
        expect(self.spy.didCallShowDetails).to(equal(1))
    }
}

extension ViewItemPagePresenterTests {
    class DisplaySpy: ViewItemPageDisplayLogic {

        var didCallShowItemPage = 0
        var didCallUpdateItem = 0
        var didCallShowItemPageFailure = 0
        var didCallShowDetails = 0

        var responseViewModel: ViewItemPageViewModel?
        var responseItem: ViewItemPageRow?
        var responseIndexPath: IndexPath?
        var errorTitleDescription: String?

        func showItemPage(_ viewModel: ViewItemPageViewModel) {
            didCallShowItemPage += 1
            responseViewModel = viewModel
        }

        func updateItemWithThumbnail(_ item: ViewItemPageRow, indexPath: IndexPath) {
            didCallUpdateItem += 1
            responseItem = item
            responseIndexPath = indexPath
        }

        func showItemPageFailure(_ title: String, errorDescription: String) {
            didCallShowItemPageFailure += 1
            errorTitleDescription = title + errorDescription
        }

        func showDetails() {
            didCallShowDetails += 1
        }
    }
}
