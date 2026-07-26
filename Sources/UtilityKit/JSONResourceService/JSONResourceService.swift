//
//  JSONResourceService.swift
//  UtilityKit
//
//  Created by Sushant Verma on 12/4/2026.
//

import Foundation

public final class JSONResourceService<T: Decodable & Sendable>: Sendable {
    private let logger = AutoLogger.unifiedLogger()

    public let content: T?
    public let error: JSONResourceServiceError?

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

