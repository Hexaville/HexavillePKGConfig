import XCTest
@testable import PKGConfig

final class PKGConfigTests: XCTestCase {
    let testAWSConfig = PKGConfig.CloudService.AWS(
        credential: PKGConfig.CloudService.AWS.Credential(
            accessKeyId: "accessKeyId",
            secretAccessKey: "secretAccessKey"
        ),
        region: "us-east-1",
        lambda: PKGConfig.CloudService.AWS.Lambda(
            s3Bucket: "myBucket",
            role: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
            timeout: 29,
            vpc: PKGConfig.CloudService.AWS.VPC(
                subnetIds: ["xxxxxxxxxxxxxxxxxx"],
                securityGroupIds: ["xxxxxxxxxxxxxxxxxx"]
            )
        )
    )
    
    var testFullPKGConfig: PKGConfig {
        return PKGConfig(
            appName: "test",
            executableTarget: "test",
            cloudService: .aws(testAWSConfig),
            docker: PKGConfig.Docker(
                buildOptions: [
                    PKGConfig.DockerBuildOptions.nocache(false)
                ]
            ),
            swift: PKGConfig.Swift(
                version: "4.2",
                buildOptions: [
                    PKGConfig.SwiftBuildOptions.configuration(.debug)
                ]
            )
        )
    }
    
    func testEncode() {
        let jsonString = try! testFullPKGConfig.encodeToJSONUTF8String()

let exepected = """
{"cloudService":{"aws":{"region":"us-east-1","lambda":{"s3Bucket":"myBucket","vpc":{"securityGroupIds":["xxxxxxxxxxxxxxxxxx"],"subnetIds":["xxxxxxxxxxxxxxxxxx"]},"memory":256,"role":"xxxxxxxxxxxxxxxxxxxxxxxxxx","timeout":29},"credential":{"accessKeyId":"accessKeyId","secretAccessKey":"secretAccessKey"}}},"appName":"test","executableTarget":"test","docker":{"buildOptions":[{"nocache":false}]},"swift":{"version":"4.2","buildOptions":[{"configuration":"debug"}]}}
"""
        XCTAssertEqual(jsonString, exepected)
    }
    
    func testDecode() {
        let jsonString = try! testFullPKGConfig.encodeToJSONUTF8String()
        
        let decodedPkgConfig = try! PKGConfig.decode(fromJSONString: jsonString)
        
        switch decodedPkgConfig.cloudService {
        case .aws(let aws):
            XCTAssertEqual(aws.credential!.accessKeyId, testAWSConfig.credential!.accessKeyId)
            XCTAssertEqual(aws.credential!.secretAccessKey, testAWSConfig.credential!.secretAccessKey)
            XCTAssertEqual(aws.lambda.vpc!.subnetIds, testAWSConfig.lambda.vpc!.subnetIds)
        }
        
        if case .nocache(let value) = decodedPkgConfig.docker!.buildOptions[0] {
            XCTAssertEqual(value, false)
        } else {
            XCTFail()
        }
        
        if case .configuration(let value) = decodedPkgConfig.swift.buildOptions[0] {
            XCTAssertEqual(value, .debug)
        } else {
            XCTFail()
        }
    }

    static var allTests = [
        ("testEncode", testEncode),
        ("testDecode", testDecode),
    ]
}
