import Foundation

enum AppError: Error {
    case networkError(_ error: Error)
    case notFound
    case jsonParsingError(_ error: Error)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch  self {
        case .networkError(let error as NSError):
            return networkErrorDescription(error)
        case .notFound:
            return R.string.localized.errorNotFound()
        case .jsonParsingError:
            return R.string.localized.errorUnknown()
        }
    }

    var errorTitle: String {
        switch self {
        case .networkError(let error as NSError):
            return networkErrorTitle(error)
        case .notFound, .jsonParsingError:
            return R.string.localized.errorTitleUnknown()
        }
    }

    private func networkErrorTitle(_ error: NSError) -> String {
        switch error.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            return R.string.localized.errorTitleNoInternetConnection()
        default:
            return R.string.localized.errorTitleUnknown()
        }
    }

    private func networkErrorDescription(_ error: NSError) -> String {
        switch error.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            return R.string.localized.errorNoInternetConnection()
        default:
            return R.string.localized.errorUnknown()
        }
    }
}
