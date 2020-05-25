//
//  ViewItemPageDataSourceTests.swift
//  AppTests
//
//  Created by Schön, Ralph on 21.06.19.
//  Copyright © 2019 Schön, Ralph. All rights reserved.
//

import XCTest
@testable import App
import Nimble

class ViewItemPageDataSourceTests: XCTestCase {

    var sut: ViewItemPageDataSource!
    var collectionView: UICollectionView!
    let layout = UICollectionViewLayout()
    let indexPath = IndexPath(row: 0, section: 0)

    override func setUp() {
        super.setUp()
        sut = ViewItemPageDataSource()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), collectionViewLayout: layout)
        collectionView.register(R.nib.itemCell)
    }

    override func tearDown() {
        sut.dataStore = nil
        sut = nil
        super.tearDown()
    }

    func test_numberOfSections() {
        // given
        let section = ViewItemPageSection(rows: [ViewItemPageRow(sourceURI: "testURI")])
        let itemPage = ViewItemPageViewModel(sections: [section])
        sut.dataStore = itemPage


        // when
        let result = sut.numberOfSections(in: collectionView)

        // then
        expect(result).to(equal(itemPage.sections.count))
    }

    func test_numberOfItemsInSection_forEmptySection() {
        // when
        let result = sut.collectionView(collectionView, numberOfItemsInSection: 0)

        // then
        expect(result).to(equal(0))
    }

    func test_numberOfItemsInSection() {
        // given
        let section = ViewItemPageSection(rows: [ViewItemPageRow(sourceURI: "testURI"),
            ViewItemPageRow(sourceURI: "testURI")])
        let itemPage = ViewItemPageViewModel(sections: [section])
        sut.dataStore = itemPage

        // when
        let result = sut.collectionView(collectionView, numberOfItemsInSection: 0)

        // then
        expect(result).to(equal(section.rows.count))
    }

    func test_cellForItemAtIndexPath_withEmptyDataSource_returnsEmptyItemCell() {
        // given
        sut.dataStore = nil

        // when
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)

        // then
        expect((cell as? ItemCell)?.imageView.image).to(beNil())
    }

    func test_cellForItemAtIndexPath_failedWithPlaceholder() {
        // given
        let section = ViewItemPageSection(rows: [ViewItemPageRow(sourceURI: "testURI", state: .failed)])
        let itemPage = ViewItemPageViewModel(sections: [section])

        sut.dataStore = itemPage

        // when
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)

        // then
        expect((cell as? ItemCell)?.imageView.image).to(equal(R.image.placeholder()))
    }

    func test_cellForItemAtIndexPath_newItem_callsDelegate() {
        // given
        let spy = DelegateSpy()
        sut.delegate = spy

        let section = ViewItemPageSection(rows: [ViewItemPageRow(sourceURI: "testURI", state: .new)])
        let itemPage = ViewItemPageViewModel(sections: [section])
        sut.dataStore = itemPage

        // when
        _ = sut.collectionView(collectionView, cellForItemAt: indexPath)

        // then
        expect(spy.didCallGetItemThumbnail).to(equal(1))
    }

    func test_cellForItemAtIndexPath_downloaded_returnsSameCell() {
        // given
        let section = ViewItemPageSection(rows: [ViewItemPageRow(sourceURI: "testURI", state: .downloaded)])
        let itemPage = ViewItemPageViewModel(sections: [section])
        sut.dataStore = itemPage

        // when
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)

        // then
        expect((cell as? ItemCell)?.imageView.image).to(equal(R.image.placeholder()))
    }
}

extension ViewItemPageDataSourceTests {
    class DelegateSpy: ViewItemPageCollectionDelegate {
        var didCallGetItemThumbnail = 0
        
        func getItemThumbnail(with details: ViewItemRequestModel) {
            didCallGetItemThumbnail += 1
        }
    }
}
