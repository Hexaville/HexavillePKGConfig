# PKGConfig

package configurator for hexaville apps

## Example

```swift
PKGConfig(
    cloudService: .aws(
        PKGConfig.CloudService.AWS(
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
    ),
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
```