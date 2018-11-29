//
//  Docker.swift
//  PKGConfig
//
//  Created by Yuki Takei on 2018/11/29.
//

import Foundation

extension PKGConfig {
    public enum DockerBuildOption {
        case nocache(Bool)
    }
    
    public struct DockerBuildOptions {
        public static func nocache(_ value: Bool) -> DockerBuildOption {
            return DockerBuildOption.nocache(value)
        }
    }
    
    public struct Docker: Codable {
        public let buildOptions: [DockerBuildOption]
    }
}

extension PKGConfig.DockerBuildOption: Codable {
    enum CodingKeys: CodingKey {
        case nocache
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch true {
        case container.contains(.nocache):
            self = .nocache(try container.decode(Bool.self, forKey: .nocache))
        default:
            throw DecodingError.unresolvedKey
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .nocache(let nocache):
            try container.encode(nocache, forKey: .nocache)
        }
    }
}
