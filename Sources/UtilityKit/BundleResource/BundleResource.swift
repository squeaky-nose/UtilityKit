//
//  BundleResource.swift
//  UtilityKit
//
//  Created by Sushant Verma on 12/4/2026.
//

import Foundation

/// A reference to a named resource file within a `Bundle`.
///
/// `BundleResource` locates a file by name and extension inside a bundle, and
/// provides convenience access to its `URL` and raw `Data` without throwing —
/// both simply return `nil` when the resource can't be found or read.
public struct BundleResource: CustomStringConvertible, @unchecked Sendable {
    /// The bundle the resource is expected to live in.
    public let bundle: Bundle
    /// The resource's filename, without its extension.
    public let resourceName: String
    /// The resource's file extension, without the leading dot.
    public let resourceExtension: String

    let logger = AutoLogger.unifiedLogger()

    /// Creates a resource reference from a separate name and extension.
    /// - Parameters:
    ///   - bundle: The bundle to search. Defaults to `Bundle.main`.
    ///   - resourceName: The resource's filename, without its extension.
    ///   - resourceExtension: The resource's file extension, without the leading dot.
    public init(bundle: Bundle = Bundle.main, resourceName: String, resourceExtension: String) {
        self.bundle = bundle
        self.resourceName = resourceName
        self.resourceExtension = resourceExtension
    }

    /// Creates a resource reference by parsing a filename into a name and extension.
    /// - Parameters:
    ///   - bundle: The bundle to search. Defaults to `Bundle.main`.
    ///   - filename: A filename such as `"config.json"`. Only the last path
    ///     component and extension are used, so a path like `"a/b/config.json"`
    ///     resolves the same as `"config.json"`.
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

    /// The resource's location in `bundle`, or `nil` if it can't be found.
    public var url: URL? {
        bundle.url(forResource: resourceName, withExtension: resourceExtension)
    }

    /// The resource's raw contents, or `nil` if it can't be found or read.
    ///
    /// Failures are logged via `os.Logger` rather than thrown; use
    /// ``JSONResourceService`` if you need to distinguish failure reasons.
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
