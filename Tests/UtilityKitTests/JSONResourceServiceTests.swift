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

struct JSONResourceServiceTests {

    @Test func decodesValidJsonIntoContent() {
        let resource = BundleResource(bundle: .module, resourceName: "sample", resourceExtension: "json")

        let service = JSONResourceService<SampleModel>(resource)

        #expect(service.content == SampleModel(name: "UtilityKit", count: 3))
        #expect(service.error == nil)
    }

    @Test func contentIsNilWhenResourceIsMissing() {
        let resource = BundleResource(bundle: .module, resourceName: "does-not-exist", resourceExtension: "json")

        let service = JSONResourceService<SampleModel>(resource)

        #expect(service.content == nil)
    }

    @Test func errorIsResourceUnavailableWhenResourceIsMissing() {
        let resource = BundleResource(bundle: .module, resourceName: "does-not-exist", resourceExtension: "json")

        let service = JSONResourceService<SampleModel>(resource)

        guard case .resourceUnavailable(let reportedResource) = service.error else {
            Issue.record("Expected .resourceUnavailable, got \(String(describing: service.error))")
            return
        }
        #expect(reportedResource.resourceName == "does-not-exist")
    }

    @Test func contentIsNilWhenJsonIsMalformed() {
        let resource = BundleResource(bundle: .module, resourceName: "malformed", resourceExtension: "json")

        let service = JSONResourceService<SampleModel>(resource)

        #expect(service.content == nil)
    }

    @Test func errorIsDecodingFailedWhenJsonIsMalformed() {
        let resource = BundleResource(bundle: .module, resourceName: "malformed", resourceExtension: "json")

        let service = JSONResourceService<SampleModel>(resource)

        guard case .decodingFailed(let reportedResource, let underlying) = service.error else {
            Issue.record("Expected .decodingFailed, got \(String(describing: service.error))")
            return
        }
        #expect(reportedResource.resourceName == "malformed")
        #expect(underlying is DecodingError)
    }

    @Test func usesProvidedDecoderConfiguration() {
        let resource = BundleResource(bundle: .module, resourceName: "snake_case", resourceExtension: "json")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let service = JSONResourceService<SnakeCaseModel>(resource, decoder: decoder)

        #expect(service.content == SnakeCaseModel(itemName: "Widget", itemCount: 5))
        #expect(service.error == nil)
    }

    @Test func contentIsNilWhenDecoderDoesNotMatchKeys() {
        let resource = BundleResource(bundle: .module, resourceName: "snake_case", resourceExtension: "json")

        let service = JSONResourceService<SnakeCaseModel>(resource)

        #expect(service.content == nil)
        #expect(service.error != nil)
    }
}
