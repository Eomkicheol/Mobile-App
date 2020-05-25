//
//  ViewItemDetailPageWorkerTests.swift
//  App
//
//  Created by Schön, Ralph on 20.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemDetailPageWorkerTests: XCTestCase {
    var sut: ViewItemDetailPageWorker!
    let stub = CloudStub()
    
    override func setUp() {
        super.setUp()
        sut = ViewItemDetailPageWorker(stub)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_getDetailImage_returnsError() {
        // given
        let expecting = expectation(description: "fetchDetailImage")

        // when
        var response: AppError?
        sut.fetchDetailImage(form: "") { result in
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
}

extension ViewItemDetailPageWorkerTests {
    class CloudStub: ItemPageStore {

        var didCallGetDetailImage = 0
        var response: Result<Data, AppError> = Result.failure(.notFound)

        func get(_ itemId: String, completed: @escaping (Result<ItemPageDTO, AppError>) -> Void) {}
        func getThumbnail(from itemURI: String, completed: @escaping (Result<Data, AppError>) -> Void) {}

        func getDetailImage(from itemURI: String, completed: @escaping (Result<Data, AppError>) -> Void) {
            completed(response)
        } 
    }
}
