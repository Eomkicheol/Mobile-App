//
//  ViewItemPageInteractorTests.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemPageInteractorTests: XCTestCase {
    var sut: ViewItemPageInteractor!
    let spy = PresenterSpy()
    let mock = WorkerMock()

    let thumbnailRequestModel = ViewItemRequestModel(uri: "test", indexPath: IndexPath(row: 0, section: 0))
    
    override func setUp() {
        super.setUp()
        sut = ViewItemPageInteractor()
        sut.presenter = spy
        sut.worker = mock
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_getItemPage_returnsError() {
        // given
        mock.itemURIResponse = Result.failure(AppError.notFound)

        // when
        sut.getItemPage()

        // then
        expect(self.spy.didCallPresentItemListFailed).to(equal(1))
        expect(self.spy.didCallPresentItemList).to(equal(0))
    }

    func test_getItemPage_returnsItemList() {
        // given
        let response = ViewItemPageResponseModel(sourceURIs: ["test", "abc", "123"])
        mock.itemURIResponse = Result.success(response)

        // when
        sut.getItemPage()

        // then
        expect(self.spy.didCallPresentItemList).to(equal(1))
        expect(self.spy.didCallPresentItemListFailed).to(equal(0))
    }

    func test_getItemThumbnail_returnsError() {
        // given
        mock.itemThumbnailResponse = Result.failure(AppError.notFound)

        // when
        sut.getItemThumbnail(with: thumbnailRequestModel)

        // then
        expect(self.spy.didCallPresentItemFailed).to(equal(1))
        expect(self.spy.didCallPresentItem).to(equal(0))
    }

    func test_getItemThumbnail_returnsThumbnail() {
        // given
        let responseModel = ViewItemResponseModel(sourceURI: "test", image: R.image.placeholder())
        mock.itemThumbnailResponse = Result.success(responseModel)

        // when
        sut.getItemThumbnail(with: thumbnailRequestModel)

        // then
        expect(self.spy.didCallPresentItem).to(equal(1))
        expect(self.spy.didCallPresentItemFailed).to(equal(0))
    }

    func test_storeItemDetails_callsPresentDetailView() {
        // when
        sut.storeItemDetails(for: thumbnailRequestModel)

        // then
        expect(self.spy.didCallPresentDetails).to(equal(1))
    }
}

extension ViewItemPageInteractorTests {
    class PresenterSpy: ViewItemPagePresentationLogic {

        var didCallPresentItem = 0
        var didCallPresentItemList = 0
        var didCallPresentItemFailed = 0
        var didCallPresentItemListFailed = 0
        var didCallPresentDetails = 0

        func presentItem(_ response: ViewItemResponseModel, indexPath: IndexPath) {
            didCallPresentItem += 1
        }

        func presentItemList(_ response: ViewItemPageResponseModel) {
            didCallPresentItemList += 1
        }

        func presentItemFailed(_ response: ViewItemResponseModel, indexPath: IndexPath) {
            didCallPresentItemFailed += 1
        }

        func presentItemListFailed(_ error: AppError) {
            didCallPresentItemListFailed += 1
        }

        func presentDetailView() {
            didCallPresentDetails += 1
        }
    }

    class WorkerMock: ViewItemPageWorker {
        var itemURIResponse: Result<ViewItemPageResponseModel, AppError> = Result.failure(AppError.notFound)
        var itemThumbnailResponse: Result<ViewItemResponseModel, AppError> = Result.failure(AppError.notFound)

        override func fetchItemURIs(completed: @escaping (Result<ViewItemPageResponseModel, AppError>) -> Void) {
            completed(itemURIResponse)
        }

        override func fetchItemThumbnail(from uri: String, completed: @escaping (Result<ViewItemResponseModel, AppError>) -> Void) {
            completed(itemThumbnailResponse)
        }
    }
}
