//
//  JsonResourceService.swift
//  UtilityKit
//
//  Created by Sushant Verma on 12/4/2026.
//

import Foundation

public class JsonResourceService<T: Decodable> {
    let logger = AutoLogger.unifiedLogger()

    public var content: T?

    public init(_ bundleResource: BundleResource, decoder: JSONDecoder = JSONDecoder()) {
        content = read(bundleResource, withDecoder: decoder)
    }

    func read(_ bundleResource: BundleResource, withDecoder decoder: JSONDecoder) -> T? {
        guard let data = bundleResource.data else {
            logger.error("❌ \(bundleResource) cant be read.")
            return nil
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.error("❌ \(bundleResource) cant be decoded. Error: \(error)")

            return nil
        }
    }
}

