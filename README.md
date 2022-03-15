# SafeDecoder

`SafeDecoder` is a swift package that set defaults when Codable fails to decode a field.
`SafeDecoder` supports configurable default values, See SafeDecoder.Configuration.

## Installation

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) is Apple's decentralized dependency manager to integrate libraries to your Swift projects. It is now fully integrated with Xcode 11

To integrate `SafeDecoder` into your project using SPM, specify it in your `Package.swift` file:

```swift
let package = Package(
    …
    dependencies: [
        .package(url: "git@github.com:GodL/SafeDecoder.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "YourTarget", dependencies: ["SafeDecoder", …])
        …
    ]
)
```

## Usage

### normal
```swift
let model: Data1 = try SafeDecoder().decode(Data1.self, from: try encode(testData))

```

### custom
```swift
struct CustomConfiguration: SafeConfigurationType {
    static var configuration: SafeDecoder.Configuration {
        var configuration: SafeDecoder.Configuration = .default
        configuration.register([Data1.Epidemic].self, value: [.init(title: "aaa", num: 20, routeUri: "test://url")])
        return configuration
    }
}
let model: Data1 = try SafeDecoder().decode(Data1.self, CustomConfiguration.self, from: try encode(testData))
```

## Author

GodL, 547188371@qq.com. Github [GodL](https://github.com/GodL)

*I am happy to answer any questions you may have. Just create a [new issue](https://github.com/GodL/SafeDecoder/issues/new).*
