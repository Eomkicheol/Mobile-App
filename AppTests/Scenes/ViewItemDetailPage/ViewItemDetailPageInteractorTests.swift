//
//  ViewItemDetailPageInteractorTests.swift
//  App
//
//  Created by Schön, Ralph on 20.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemDetailPageInteractorTests: XCTestCase {
    var sut: ViewItemDetailPageInteractor!
    let spy = PresenterSpy()
    let mock = WorkerMock()
    
    override func setUp() {
        super.setUp()
        sut = ViewItemDetailPageInteractor()
        sut.presenter = spy
        sut.worker = mock
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_getItemImage_returnsError() {
        // given
        mock.response = Result.failure(.notFound)

        // when
        sut.getItemImage()

        // then
        expect(self.spy.didCallDetailFailed).to(equal(1))
        expect(self.spy.didCallDetailImage).to(equal(0))
    }

    func test_getItemImage_returnsData() {
        // given
        mock.response = Result.success(Data())

        // when
        sut.getItemImage()

        // then
        expect(self.spy.didCallDetailImage).to(equal(1))
        expect(self.spy.didCallDetailFailed).to(equal(0))
    }
}

extension ViewItemDetailPageInteractorTests {
    class PresenterSpy: ViewItemDetailPagePresentationLogic {

        var didCallDetailImage = 0
        var didCallDetailFailed = 0

        func presentDetailImage(_ imageData: Data) {
            didCallDetailImage += 1
        }

        func presentDetailFailed(with error: AppError) {
            didCallDetailFailed += 1
        }
    }

    class WorkerMock: ViewItemDetailPageWorker {
        var response: Result<Data, AppError> = Result.failure(.notFound)

        override func fetchDetailImage(form uri: String, completed: @escaping (Result<Data, AppError>) -> Void) {
            completed(response)
        }
    }
}
