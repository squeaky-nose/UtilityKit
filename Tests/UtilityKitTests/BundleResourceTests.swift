import Testing
import Foundation
@testable import UtilityKit

struct BundleResourceTests {

    @Test func initWithResourceNameAndExtensionSetsProperties() {
        let resource = BundleResource(bundle: .module, resourceName: "sample", resourceExtension: "json")

        #expect(resource.resourceName == "sample")
        #expect(resource.resourceExtension == "json")
        #expect(resource.bundle === Bundle.module)
    }

    @Test func initDefaultsToMainBundle() {
        let resource = BundleResource(resourceName: "sample", resourceExtension: "json")

        #expect(resource.bundle === Bundle.main)
    }

    @Test func initWithFilenameParsesNameAndExtension() {
        let resource = BundleResource(bundle: .module, "sample.json")

        #expect(resource.resourceName == "sample")
        #expect(resource.resourceExtension == "json")
    }

    @Test func initWithFilenameContainingPathUsesLastComponent() {
        let resource = BundleResource(bundle: .module, "some/nested/path/sample.json")

        #expect(resource.resourceName == "sample")
        #expect(resource.resourceExtension == "json")
    }

    @Test func initWithFilenameContainingMultipleDotsKeepsLastExtensionOnly() {
        let resource = BundleResource(bundle: .module, "sample.backup.json")

        #expect(resource.resourceName == "sample.backup")
        #expect(resource.resourceExtension == "json")
    }

    @Test func descriptionContainsResourceDetails() {
        let resource = BundleResource(bundle: .module, resourceName: "sample", resourceExtension: "json")

        let description = resource.description
        #expect(description.contains("sample"))
        #expect(description.contains("json"))
    }

    @Test func urlResolvesForExistingResource() {
        let resource = BundleResource(bundle: .module, resourceName: "sample", resourceExtension: "json")

        #expect(resource.url != nil)
    }

    @Test func urlIsNilForMissingResource() {
        let resource = BundleResource(bundle: .module, resourceName: "does-not-exist", resourceExtension: "json")

        #expect(resource.url == nil)
    }

    @Test func dataReturnsContentsOfExistingResource() throws {
        let resource = BundleResource(bundle: .module, resourceName: "sample", resourceExtension: "json")

        let data = try #require(resource.data)
        let expected = try Data(contentsOf: #require(resource.url))
        #expect(data == expected)
    }

    @Test func dataIsNilForMissingResource() {
        let resource = BundleResource(bundle: .module, resourceName: "does-not-exist", resourceExtension: "json")

        #expect(resource.data == nil)
    }
}
