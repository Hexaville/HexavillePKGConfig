import Foundation

public enum DecodingError: Error {
    case unresolvedKey
}

public func configureHexaville(
    appName: String,
    executableTarget: String,
    cloudService: PKGConfig.CloudService,
    docker: PKGConfig.Docker? = nil,
    swift: PKGConfig.Swift) -> PKGConfig {
    
    return PKGConfig(
        appName: appName,
        executableTarget: executableTarget,
        cloudService: cloudService,
        docker: docker,
        swift: swift
    )
}

public struct PKGConfig: Codable {
    public let appName: String
    public let executableTarget: String
    public let cloudService: CloudService
    public let docker: Docker?
    public let swift: Swift
}
