import Testing
import Foundation
@testable import UtilityKit

private struct SampleModel: Decodable, Equatable {
    let name: String
    let count: Int
}

private struct SnakeCaseModel: Decodable, Equatable {
    let itemName: String
    let itemCount: Int
}

struct JsonResourceServiceTests {

    @Test func decodesValidJsonIntoContent() {
        let resource = BundleResource(bundle: .module, resourceName: "sample", resourceExtension: "json")

        let service = JsonResourceService<SampleModel>(resource)

        #expect(service.content == SampleModel(name: "UtilityKit", count: 3))
    }

    @Test func contentIsNilWhenResourceIsMissing() {
        let resource = BundleResource(bundle: .module, resourceName: "does-not-exist", resourceExtension: "json")

        let service = JsonResourceService<SampleModel>(resource)

        #expect(service.content == nil)
    }

    @Test func contentIsNilWhenJsonIsMalformed() {
        let resource = BundleResource(bundle: .module, resourceName: "malformed", resourceExtension: "json")

        let service = JsonResourceService<SampleModel>(resource)

        #expect(service.content == nil)
    }

    @Test func usesProvidedDecoderConfiguration() {
        let resource = BundleResource(bundle: .module, resourceName: "snake_case", resourceExtension: "json")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let service = JsonResourceService<SnakeCaseModel>(resource, decoder: decoder)

        #expect(service.content == SnakeCaseModel(itemName: "Widget", itemCount: 5))
    }

    @Test func contentIsNilWhenDecoderDoesNotMatchKeys() {
        let resource = BundleResource(bundle: .module, resourceName: "snake_case", resourceExtension: "json")

        let service = JsonResourceService<SnakeCaseModel>(resource)

        #expect(service.content == nil)
    }
}
