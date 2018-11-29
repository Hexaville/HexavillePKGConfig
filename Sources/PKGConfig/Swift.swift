//
//  Swift.swift
//  PKGConfig
//
//  Created by Yuki Takei on 2018/11/29.
//

import Foundation

extension PKGConfig {
    public enum SwiftBuildOption {
        public enum ConfigurationType: String, Codable {
            case debug = "debug"
            case release = "release"
        }
        
        case configuration(ConfigurationType)
    }
    
    public struct SwiftBuildOptions {
        public static func configuration(_ value: SwiftBuildOption.ConfigurationType) -> SwiftBuildOption {
            return SwiftBuildOption.configuration(value)
        }
    }
    
    public struct Swift: Codable {
        public let version: String
        public let buildOptions: [SwiftBuildOption]
        
        public init(version: String, buildOptions: [SwiftBuildOption]) {
            self.version = version
            self.buildOptions = buildOptions
        }
    }
}

extension PKGConfig.SwiftBuildOption: Codable {
    enum CodingKeys: CodingKey {
        case configuration
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch true {
        case container.contains(.configuration):
            let value = try container.decode(
                PKGConfig.SwiftBuildOption.ConfigurationType.self,
                forKey: .configuration
            )
            self = .configuration(value)
        default:
            throw DecodingError.unresolvedKey
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .configuration(let value):
            try container.encode(value, forKey: .configuration)
        }
    }
}

