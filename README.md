# UtilityKit

[![Tests](https://github.com/squeaky-nose/UtilityKit/actions/workflows/tests.yml/badge.svg)](https://github.com/squeaky-nose/UtilityKit/actions/workflows/tests.yml)
[![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)](Package.swift)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A small Swift package of utilities for working with bundled resources — locating them, reading their raw data, and decoding them as JSON.

## Requirements

- Swift 6.2+
- iOS 15+ / macOS 13+ / tvOS 15+ / watchOS 8+

## Installation

### Swift Package Manager

Add UtilityKit as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/squeaky-nose/UtilityKit.git", from: "1.0.0")
]
```

Or add it via Xcode: **File → Add Package Dependencies…** and enter the repository URL.

## Usage

### BundleResource

Locate a resource in a bundle and read its raw data:

```swift
import UtilityKit

let resource = BundleResource(bundle: .main, resourceName: "config", resourceExtension: "json")

resource.url   // URL? — location of the resource, if it exists
resource.data  // Data? — raw contents of the resource, if it can be read
```

You can also describe a resource by filename:

```swift
let resource = BundleResource(bundle: .main, "config.json")
```

### JSONResourceService

Decode a bundled JSON resource into a `Decodable & Sendable` type:

```swift
import UtilityKit

struct Config: Decodable, Sendable {
    let name: String
    let count: Int
}

let resource = BundleResource(bundle: .main, "config.json")
let service = JSONResourceService<Config>(resource)

service.content // Config? — decoded value, or nil if reading/decoding failed
service.error   // JSONResourceServiceError? — the reason, if it failed
```

`T` must be `Sendable` because `JSONResourceService` itself is `Sendable` — it's a `final class` with only immutable (`let`) stored properties, so instances can be safely shared across threads/tasks as long as the decoded content can be too.

`error` is `nil` on success, or one of:

```swift
public enum JSONResourceServiceError: Error {
    case resourceUnavailable(BundleResource)
    case decodingFailed(resource: BundleResource, underlying: Error)
}
```

A custom `JSONDecoder` can be supplied, e.g. to configure a key decoding strategy:

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

let service = JSONResourceService<Config>(resource, decoder: decoder)
```

## Testing

Tests are written with [Swift Testing](https://developer.apple.com/documentation/testing) and run via:

```bash
swift test
```

Every push and pull request runs the suite in [GitHub Actions](.github/workflows/tests.yml).

## License

UtilityKit is available under the MIT license. See [LICENSE](LICENSE) for details.
