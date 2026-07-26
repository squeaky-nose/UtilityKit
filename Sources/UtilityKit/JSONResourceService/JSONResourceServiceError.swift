//
//  JSONResourceServiceError.swift
//  UtilityKit
//
//  Created by Sushant Verma on 26/7/2026.
//


/// The reason a ``JSONResourceService`` failed to produce a decoded value.
public enum JSONResourceServiceError: Error, CustomStringConvertible {
    /// The resource's `URL`/`Data` couldn't be resolved — see ``BundleResource/data``.
    case resourceUnavailable(BundleResource)
    /// The resource's data was read successfully, but the `JSONDecoder` failed
    /// to decode it into the requested type.
    /// - Parameters:
    ///   - resource: The resource that failed to decode.
    ///   - underlying: The error thrown by the decoder.
    case decodingFailed(resource: BundleResource, underlying: Error)

    public var description: String {
        switch self {
        case .resourceUnavailable(let resource):
            return "\(resource) could not be read."
        case .decodingFailed(let resource, let underlying):
            return "\(resource) could not be decoded: \(underlying)"
        }
    }
}
