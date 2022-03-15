import Foundation

public protocol SafeConfigurationType {
    static var configuration: SafeDecoder.Configuration { get }
}

public struct SafeDecoder {
    
    public struct Configuration {
        var defaults: [ObjectIdentifier : Any] = [:]
        
        public mutating func register<T>(_ type: T.Type, value: T) {
            defaults[ObjectIdentifier(type)] = value
        }
        
        public subscript<T>(_ key: T.Type) -> T? {
            defaults[ObjectIdentifier(key)] as? T
        }
        
        static public var `default`: Configuration = .init(defaults: [
            ObjectIdentifier(Bool.self) : false,
            ObjectIdentifier(Int.self) : 0,
            ObjectIdentifier(Int8.self) : 0,
            ObjectIdentifier(Int16.self) : 0,
            ObjectIdentifier(Int32.self) : 0,
            ObjectIdentifier(Int64.self) : 0,
            ObjectIdentifier(UInt.self) : 0,
            ObjectIdentifier(UInt8.self) : 0,
            ObjectIdentifier(UInt16.self) : 0,
            ObjectIdentifier(UInt32.self) : 0,
            ObjectIdentifier(UInt64.self) : 0,
            ObjectIdentifier(Float.self) : 0,
            ObjectIdentifier(Double.self) : 0,
            ObjectIdentifier(String.self) : ""
        ])
    }
    
    let decoder: JSONDecoder
    
    
    public init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    /// Decode
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        try decoder.decode(DefaultContainer<T>.self, from: data).base
    }
    
    /// support configurable decode
    public func decode<T, C>(_ type: T.Type, _ c: C.Type, from data: Data) throws -> T where T : Decodable, C : SafeConfigurationType {
        try decoder.decode(Container<T, C>.self, from: data).base
    }
}

public struct DefaultContainer<T: Decodable>: Decodable {
    public let base: T
    
    public init(from decoder: Decoder) throws {
        if let decoder = decoder as? _SafeDecoder {
            base = try decoder.singleValueContainer().decode(T.self)
        }else {
            base = try T(from: _SafeDecoder(decoder: decoder, configuration: .default))
        }
    }
}

public struct Container<T: Decodable, C: SafeConfigurationType>: Decodable {
    public let base: T
    
    public init(from decoder: Decoder) throws {
        if let decoder = decoder as? _SafeDecoder {
            base = try decoder.singleValueContainer().decode(T.self)
        }else {
            base = try T(from: _SafeDecoder(decoder: decoder, configuration: C.configuration))
        }
    }
}

struct _SafeDecoder: Decoder {
    
    let decoder: Decoder
    
    let configuration: SafeDecoder.Configuration
    
    var codingPath: [CodingKey] {
        decoder.codingPath
    }
    
    var userInfo: [CodingUserInfoKey : Any] {
        decoder.userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer(SafeKeyedDecodingContainer(container: try decoder.container(keyedBy: type), configuration: configuration))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        SafeUnkeyedDecodingContainer(container: try decoder.unkeyedContainer(), configuration: configuration)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        try SafeSingleValueDecodingContainer(decoder: self)
    }
}

struct SafeSingleValueDecodingContainer: SingleValueDecodingContainer {
    
    let configuration: SafeDecoder.Configuration
    
    let _decoder: Decoder
    
    let container: SingleValueDecodingContainer
    
    init(decoder: _SafeDecoder) throws  {
        self._decoder = decoder.decoder
        self.container = try _decoder.singleValueContainer()
        self.configuration = decoder.configuration
    }
    
    var codingPath: [CodingKey] {
        container.codingPath
    }
    
    func decodeNil() -> Bool {
        container.decodeNil()
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: String.Type) throws -> String {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        do {
            return try T(from: _SafeDecoder(decoder: _decoder, configuration: configuration))
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
}

struct SafeUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    
    let configuration: SafeDecoder.Configuration
    
    var container: UnkeyedDecodingContainer
    
    init(container: UnkeyedDecodingContainer, configuration: SafeDecoder.Configuration) {
        self.container = container
        self.configuration = configuration
    }
    
    var codingPath: [CodingKey] {
        container.codingPath
    }
    
    var count: Int? {
        container.count
    }
    
    var isAtEnd: Bool {
        container.isAtEnd
    }
    
    var currentIndex: Int {
        container.currentIndex
    }
    
    mutating func decodeNil() throws -> Bool {
        try container.decodeNil()
    }
    

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        do {
            return try container.decode(type)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        do {
            return try T(from: _SafeDecoder(decoder: try superDecoder(), configuration: configuration))
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        KeyedDecodingContainer(SafeKeyedDecodingContainer(container: try container.nestedContainer(keyedBy: type), configuration: configuration))
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        SafeUnkeyedDecodingContainer(container: try container.nestedUnkeyedContainer(), configuration: configuration)
    }
    
    mutating func superDecoder() throws -> Decoder {
        try container.superDecoder()
    }
}

struct SafeKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    
    let configuration: SafeDecoder.Configuration
    
    let container: KeyedDecodingContainer<Key>
    
    init(container: KeyedDecodingContainer<Key>, configuration: SafeDecoder.Configuration) {
        self.container = container
        self.configuration = configuration
    }
    
    var codingPath: [CodingKey] {
        container.codingPath
    }
    
    var allKeys: [Key] {
        container.allKeys
    }
    
    func contains(_ key: Key) -> Bool {
        container.contains(key)
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        try container.decodeNil(forKey: key)
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        do {
            return try container.decode(type, forKey: key)
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        do {
            return try T(from: _SafeDecoder(decoder: try superDecoder(forKey: key), configuration: configuration))
        } catch {
            if let value = configuration[type] {
                return value
            }
            throw error
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        KeyedDecodingContainer(SafeKeyedDecodingContainer<NestedKey>(container: try container.nestedContainer(keyedBy: type, forKey: key), configuration: configuration))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        SafeUnkeyedDecodingContainer(container: try container.nestedUnkeyedContainer(forKey: key), configuration: configuration)
    }
    
    func superDecoder() throws -> Decoder {
        try container.superDecoder()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        try container.superDecoder(forKey: key)
    }
}
