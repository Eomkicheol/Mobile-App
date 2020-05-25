import Foundation

extension Data {
    static func resource(for name: String, withExtension: String) -> Data {
        let url = Bundle(for: ItemPageCloudTests.self).url(forResource: name, withExtension: withExtension)!
        // swiftlint:disable:next force_try
        return try! Data(contentsOf: url)
    }

    func toJson() -> Any {
        // swiftlint:disable:next force_try
        let json = try! JSONSerialization.jsonObject(with: self, options: .mutableLeaves)
        return json
    }
}
