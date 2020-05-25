//
//  ViewItemDetailPagePresenterTests.swift
//  App
//
//  Created by Schön, Ralph on 20.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemDetailPagePresenterTests: XCTestCase {
    var sut: ViewItemDetailPagePresenter!
    let spy = DisplaySpy()

    override func setUp() {
        super.setUp()
        sut = ViewItemDetailPagePresenter()
        sut.viewController = spy
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_presentDetailImage_callsShowDetailImage() {
        // given
        let imageData = R.image.placeholder()!.jpegData(compressionQuality: 1)!

        // when
        sut.presentDetailImage(imageData)

        // then
        expect(self.spy.didCallShowDetailImage).toEventually(equal(1))
        expect(self.spy.didCallShowDetailFailure).toEventually(equal(0))
        expect(self.spy.responseViewModel?.image).toEventuallyNot(beNil())
    }

    func test_presentDetailFailed_callsShowDetailFailure() {
        // given
        let error = AppError.notFound
        let expectedResponse = error.errorTitle + error.errorDescription!

        // when
        sut.presentDetailFailed(with: error)

        // then
        expect(self.spy.didCallShowDetailFailure).toEventually(equal(1))
        expect(self.spy.didCallShowDetailImage).toEventually(equal(0))
        expect(self.spy.responseErrorTitleDescription).toEventually(equal(expectedResponse))
    }
}

extension ViewItemDetailPagePresenterTests {
    class DisplaySpy: ViewItemDetailPageDisplayLogic {
        var didCallShowDetailImage = 0
        var didCallShowDetailFailure = 0

        var responseViewModel: ViewItemDetailPageViewModel?
        var responseErrorTitleDescription: String?

        func showDetailImage(_ viewModel: ViewItemDetailPageViewModel) {
            didCallShowDetailImage += 1
            responseViewModel = viewModel
        }

        func showDetailFailure(_ title: String, errorDescription: String) {
            didCallShowDetailFailure += 1
            responseErrorTitleDescription = title + errorDescription
        }
    }
}
