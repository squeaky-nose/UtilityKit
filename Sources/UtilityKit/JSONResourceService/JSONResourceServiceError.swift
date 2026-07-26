//
//  JSONResourceServiceError.swift
//  UtilityKit
//
//  Created by Sushant Verma on 26/7/2026.
//


public enum JSONResourceServiceError: Error, CustomStringConvertible {
    case resourceUnavailable(BundleResource)
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
