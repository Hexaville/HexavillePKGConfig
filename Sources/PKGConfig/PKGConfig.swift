import Foundation

public enum DecodingError: Error {
    case unresolvedKey
}

public func configureHexaville(
    cloudService: PKGConfig.CloudService,
    docker: PKGConfig.Docker? = nil,
    swift: PKGConfig.Swift) -> PKGConfig {
    
    return PKGConfig(
        cloudService: cloudService,
        docker: docker,
        swift: swift
    )
}

public struct PKGConfig: Codable {
    public let cloudService: CloudService
    public let docker: Docker?
    public let swift: Swift
}
