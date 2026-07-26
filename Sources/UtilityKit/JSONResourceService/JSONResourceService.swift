//
//  JSONResourceService.swift
//  UtilityKit
//
//  Created by Sushant Verma on 12/4/2026.
//

import Foundation

/// Decodes a bundled JSON resource into a value of `T`, once, at construction.
///
/// `JSONResourceService` reads and decodes eagerly in its initializer: on
/// success, ``content`` holds the decoded value and ``error`` is `nil`; on
/// failure, ``content`` is `nil` and ``error`` describes why.
///
/// ```swift
/// let resource = BundleResource(bundle: .main, "config.json")
/// let service = JSONResourceService<Config>(resource)
///
/// if let config = service.content {
///     // use config
/// } else {
///     print(service.error ?? "unknown error")
/// }
/// ```
public final class JSONResourceService<T: Decodable & Sendable>: Sendable {
    private let logger = AutoLogger.unifiedLogger()

    /// The decoded value, or `nil` if reading or decoding the resource failed.
    public let content: T?
    /// The reason `content` is `nil`, or `nil` if decoding succeeded.
    public let error: JSONResourceServiceError?

    /// Reads and decodes `bundleResource` immediately.
    /// - Parameters:
    ///   - bundleResource: The JSON resource to load.
    ///   - decoder: The decoder to use. Defaults to a plain `JSONDecoder()`;
    ///     pass a configured instance to customize e.g. key or date decoding strategy.
    public init(_ bundleResource: BundleResource, decoder: JSONDecoder = JSONDecoder()) {
        guard let data = bundleResource.data else {
            logger.error("❌ \(bundleResource) cant be read.")
            content = nil
            error = .resourceUnavailable(bundleResource)
            return
        }

        do {
            content = try decoder.decode(T.self, from: data)
            error = nil
        } catch {
            logger.error("❌ \(bundleResource) cant be decoded. Error: \(error)")
            content = nil
            self.error = .decodingFailed(resource: bundleResource, underlying: error)
        }
    }
}

