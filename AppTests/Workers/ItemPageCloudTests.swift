import XCTest
@testable import App
import Nimble
import OHHTTPStubs

class ItemPageCloudTests: XCTestCase {

    var sut: ItemPageCloud!
    let baseURL = "m.mobile.de"
    let imageURL = "i.ebayimg.com"

    override func setUp() {
        super.setUp()
        sut = ItemPageCloud()
    }

    override func tearDown() {
        sut = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func test_getItemPage_withSuccessfulResponse() {
        // given
        let expectedResponse = ItemPageDTO(images: [ItemImageDTO(uri: "i.ebayimg.com/00/s/MTA2NlgxNjAw/z/iUAAAOSwMolc9NdI/$"),
                                                    ItemImageDTO(uri: "i.ebayimg.com/00/s/MTA2NlgxNjAw/z/GuMAAOSwyvlc9NdU/$")])
        let expecting = expectation(description: "getItemPage")
        stub(condition: isHost(baseURL)) { _ in
            let data = Data.resource(for: "get_item_page_200", withExtension: "json")
            return OHHTTPStubsResponse(jsonObject: data.toJson(), statusCode: 200, headers: nil)
        }

        // when
        var response: ItemPageDTO?
        sut.get("") { result in
            guard case let .success(itemPage) = result else {
                fail("expected successful return")
                return
            }
            response = itemPage
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response).to(equal(expectedResponse))
    }

    func test_getItemPage_returnsNoImages() {
        // given
        let expecting = expectation(description: "getItemPage")
        stub(condition: isHost(baseURL)) { _ in
            let data = Data.resource(for: "get_item_page_parsing", withExtension: "json")
            return OHHTTPStubsResponse(jsonObject: data.toJson(), statusCode: 200, headers: nil)
        }

        // when
        var response: AppError?
        sut.get("") { result in
            guard case let .failure(error) = result else {
                fail("expected error return")
                return
            }
            response = error
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.errorDescription).to(equal(AppError.jsonParsingError(NSError()).errorDescription))
    }

    func test_getItemPage_withServerResponseError() {
        // given
        let error = NSError(domain: "NSURLErrorDomain", code: NSURLErrorBadURL, userInfo: nil)
        let expecting = expectation(description: "getItemPage")
        stub(condition: isHost(baseURL)) { _ in
            return OHHTTPStubsResponse(error: error)
        }

        // when
        var response: AppError?
        sut.get("") { result in
            guard case let .failure(error) = result else {
                fail("expected error return")
                return
            }
            response = error
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.errorDescription).to(equal(AppError.networkError(error).errorDescription))
    }

    func test_getThumbnail_withNetworkConnectionError() {
        // given
        let error = NSError(domain: "NSURLErrorDomain", code: NSURLErrorNetworkConnectionLost, userInfo: nil)
        let expecting = expectation(description: "getThumbnail")
        stub(condition: isHost(imageURL)) { _ in
            return OHHTTPStubsResponse(error: error)
        }

        // when
        var response: AppError?
        sut.getThumbnail(from: imageURL + "/") { result in
            guard case let .failure(error) = result else {
                fail("expected error return")
                return
            }
            response = error
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.errorDescription).to(equal(AppError.networkError(error).errorDescription))
    }

    func test_getDetailImage_withServerResponseError() {
        // given
        let error = NSError(domain: "NSURLErrorDomain", code: NSURLErrorCannotFindHost, userInfo: nil)
        let expecting = expectation(description: "getDetailImage")
        stub(condition: isHost(imageURL)) { _ in
            return OHHTTPStubsResponse(error: error)
        }

        // when
        var response: AppError?
        sut.getDetailImage(from: imageURL + "/") { result in
            guard case let .failure(error) = result else {
                fail("expected error return")
                return
            }
            response = error
            expecting.fulfill()
        }

        // then
        waitForExpectations(timeout: 3.0)
        expect(response?.errorDescription).to(equal(AppError.networkError(error).errorDescription))
    }
}
