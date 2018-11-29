import Foundation

public enum DecodingError: Error {
    case unresolvedKey
}

private var sharedHexavillePKGConfig: PKGConfig?

public func hexavillePKGConfig() -> PKGConfig? {
    return sharedHexavillePKGConfig
}

public func hexaville(
    cloudService: PKGConfig.CloudService,
    docker: PKGConfig.Docker? = nil,
    swift: PKGConfig.Swift) {

    sharedHexavillePKGConfig = PKGConfig(
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

extension PKGConfig {
    public enum CloudService {
        public struct AWS: Codable {
            public struct Credential: Codable {
                public let accessKeyId: String
                public let secretAccessKey: String
            }

            public struct Lambda: Codable {
                public let s3Bucket: String
                public let role: String?
                public let timeout: UInt
                public let vpc: VPC?

                public init(
                    s3Bucket: String,
                    role: String? = nil,
                    timeout: UInt = 10,
                    vpc: VPC? = nil) {
                    self.s3Bucket = s3Bucket
                    self.role = role
                    self.timeout = timeout
                    self.vpc = vpc
                }
            }

            public struct VPC: Codable {
                public let subnetIds: [String]
                public let securityGroupIds: [String]
            }

            public let credential: Credential?

            public let region: String?

            public let lambda: Lambda

            public init(
                credential: Credential? = nil,
                region: String? = nil,
                lambda: Lambda) {
                self.credential = credential
                self.region = region
                self.lambda = lambda
            }
        }

        case aws(AWS)
    }
}

extension PKGConfig.CloudService: Codable {
    enum CodingKeys: CodingKey {
        case aws
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let aws = try container.decode(PKGConfig.CloudService.AWS.self, forKey: .aws)
        self = .aws(aws)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .aws(let aws):
            try container.encode(aws, forKey: .aws)
        }
    }
}


extension PKGConfig {
    public func encodeToJSONUTF8String() throws -> String {
        return try String(data: JSONEncoder().encode(self), encoding: .utf8) ?? "{}"
    }
    
    public static func decode(fromJSONString jsonString: String) throws -> PKGConfig {
        return try JSONDecoder().decode(
            PKGConfig.self, from: jsonString.data(using: .utf8) ?? Data()
        )
    }
}
