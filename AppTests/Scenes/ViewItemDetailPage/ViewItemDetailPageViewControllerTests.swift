//
//  ViewItemDetailPageViewControllerTests.swift
//  App
//
//  Created by Schön, Ralph on 20.06.19.
//  Copyright (c) 2019 Schön, Ralph. All rights reserved.
//

@testable import App
import XCTest
import Nimble

class ViewItemDetailPageViewControllerTests: XCTestCase {
    var sut: ViewItemDetailPageViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        sut = R.storyboard.viewItemDetailPage.viewItemDetailPageViewController()!
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    func test_showDetailImage() {
        // given
        let image = R.image.placeholder()
        loadView()

        // when
        sut.showDetailImage(ViewItemDetailPageViewModel(image: image))

        // then
        expect(self.sut.imageView.image).to(equal(image))
    }
}
