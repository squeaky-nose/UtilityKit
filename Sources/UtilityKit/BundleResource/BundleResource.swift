//
//  BundleResource.swift
//  UtilityKit
//
//  Created by Sushant Verma on 12/4/2026.
//

import Foundation

public struct BundleResource: CustomStringConvertible, @unchecked Sendable {
    public let bundle: Bundle
    public let resourceName: String
    public let resourceExtension: String

    let logger = AutoLogger.unifiedLogger()

    public init(bundle: Bundle = Bundle.main, resourceName: String, resourceExtension: String) {
        self.bundle = bundle
        self.resourceName = resourceName
        self.resourceExtension = resourceExtension
    }

    public init(bundle: Bundle = .main, _ filename: String) {
        let url = URL(fileURLWithPath: filename)

        self.init(
            bundle: bundle,
            resourceName: url.deletingPathExtension().lastPathComponent,
            resourceExtension: url.pathExtension
        )
    }

    public var description: String {
        "BundleResource(bundle: \(bundle.bundleIdentifier ?? "<unknown>"), resourceName: \(resourceName), resourceExtension: \(resourceExtension))"
    }

    public var url: URL? {
        bundle.url(forResource: resourceName, withExtension: resourceExtension)
    }

    public var data: Data? {
        guard let url,
            let data = try? Data(contentsOf: url)
        else {
            logger.error("❌ \(self) cant be read.")
            return nil
        }
        return data
    }
}
