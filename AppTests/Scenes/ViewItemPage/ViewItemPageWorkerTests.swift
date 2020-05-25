//
//  ViewItemPageWorkerTests.swift
//  App
//
//  Created by Schön, Ralph on 13.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemPageWorkerTests: XCTestCase {
    var sut: ViewItemPageWorker!
    let mock = CloudMock()

    override func setUp() {
        super.setUp()
        sut = ViewItemPageWorker(mock)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_fetchItemURIs_returnsError() {
        // given
        mock.getItemPageResponse = Result.failure(AppError.notFound)

        let expecting = expectation(description: "fetchItemURIs")

        // when
        var response: AppError?
        sut.fetchItemURIs { result in
            guard case let .failure(error) = result else {
                fail("expected error return")
                return
            }
            response = error
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.errorDescription).to(equal(AppError.notFound.errorDescription))
    }

    func test_fetchItemURIs_returnsList() {
        // given
        mock.getItemPageResponse = Result.success(ItemPageDTO(images: [ItemImageDTO(uri: "123"),
                                                                       ItemImageDTO(uri: "abc")]))
        let expecting = expectation(description: "fetchItemURIs")

        // when
        var response: ViewItemPageResponseModel?
        sut.fetchItemURIs { result in
            guard case let .success(itemPage) = result else {
                fail("expected successful return")
                return
            }
            response = itemPage
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.sourceURIs).to(equal(["123", "abc"]))
    }

    func test_fetchItemThumbnail_returnsError() {
        // given
        mock.getThumbnailResponse = Result.failure(AppError.notFound)
        let expecting = expectation(description: "fetchItemThumbnail")

        // when
        var response: AppError?
        sut.fetchItemThumbnail(from: "") { result in
            guard case let .failure(error) = result else {
                fail("expected error return")
                return
            }
            response = error
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.errorDescription).to(equal(AppError.notFound.errorDescription))
    }

    func test_fetchItemThumbnail_returnsThumbnail() {
        // given
        let expectedURI = "abc123"
        let imageData = R.image.placeholder()!.jpegData(compressionQuality: 1)!
        mock.getThumbnailResponse = Result.success(imageData)
        let expecting = expectation(description: "fetchItemThumbnail")

        // when
        var response: ViewItemResponseModel?
        sut.fetchItemThumbnail(from: expectedURI) { result in
            guard case let .success(thumbnail) = result else {
                fail("expected successful return")
                return
            }
            response = thumbnail
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.sourceURI).to(equal(expectedURI))
    }
}

extension ViewItemPageWorkerTests {
    class CloudMock: ItemPageStore {

        var getItemPageResponse: Result<ItemPageDTO, AppError> = Result.failure(AppError.notFound)
        var getThumbnailResponse: Result<Data, AppError> = Result.failure(AppError.notFound)
        var getDetailImageResponse: Result<Data, AppError> = Result.failure(AppError.notFound)

        func get(_ itemId: String, completed: @escaping (Result<ItemPageDTO, AppError>) -> Void) {
            completed(getItemPageResponse)
        }

        func getThumbnail(from itemURI: String, completed: @escaping (Result<Data, AppError>) -> Void) {
            completed(getThumbnailResponse)
        }

        func getDetailImage(from itemURI: String, completed: @escaping (Result<Data, AppError>) -> Void) {
            completed(getDetailImageResponse)
        }


    }
}
