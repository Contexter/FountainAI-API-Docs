# The FountainAI Setup: Vapor Creating Vapor 
---


### Table of Contents

1. [Overview](#overview)
2. [Setup Script](#setup-script)
   - [Complete Setup Script](#complete-setup-script)
   - [Tree After Running Setup Script](#tree-after-running-setup-script)
3. [Test Suite Creation](#test-suite-creation)
   - [Instructions for Placing the Test Suite Creation Script](#instructions-for-placing-the-test-suite-creation-script)
   - [Tree After Running Test Suite Creation Script](#tree-after-running-test-suite-creation-script)
4. [Building and Testing the Meta App "FountainAI"](#building-and-testing-the-meta-app-fountainai)
5. [Initializing the Setup](#initializing-the-setup)
   - [Initialize Setup Using Endpoints](#initialize-setup-using-endpoints)
   - [Tree After Calling Initialization Endpoints](#tree-after-calling-initialization-endpoints)
6. [Conclusion](#conclusion)

---

### Overview

"Vapor Creating Vapor" is a sophisticated setup and configuration script to automate the creation of multiple Vapor applications, their configuration, and the necessary infrastructure for local and production environments. This project uses a primary Vapor application to handle the setup of several sub-Vapor applications, including their integration with GitHub, Docker, and OpenAPI specifications.

---

### Setup Script

#### Complete Setup Script

Save the following script as `setup_script.sh` and run it to set up the entire project:

```bash
#!/bin/bash

# Step 1: Create a new Vapor project
vapor new FountainAI --template=api

cd FountainAI

# Step 2: Create directories for the services
mkdir -p Sources/App/Services

# Step 3: Add the service implementations with HTTP endpoints

# InstallGhCLI.swift
cat <<EOL > Sources/App/Services/InstallGhCLI.swift
import Vapor
import ShellOut

struct InstallGhCLI {
    static func installGhCLI() throws {
        if !checkCommandExists("gh") {
            print("gh (GitHub CLI) not found. Installing...")
            if let osType = ProcessInfo.processInfo.environment["OSTYPE"] {
                if osType.contains("linux-gnu") {
                    try shellOut(to: "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg")
                    try shellOut(to: "sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg")
                    try shellOut(to: "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null")
                    try shellOut(to: "sudo apt update")
                    try shellOut(to: "sudo apt install gh")
                } else if osType contains("darwin") {
                    try shellOut(to: "brew install gh")
                } else {
                    print("Unsupported OS. Please install gh manually.")
                    exit(1)
                }
            }
        } else {
            print("gh (GitHub CLI) is already installed.")
        }
    }

    private static func checkCommandExists(_ command: String) -> Bool {
        return (try? shellOut(to: "command -v \(command)")) != nil
    }
}

func installGhCLIHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try InstallGhCLI.installGhCLI()
    return req.eventLoop.makeSucceededFuture(.ok)
}
EOL

# AuthenticateGh.swift
cat <<EOL > Sources/App/Services/AuthenticateGh.swift
import Vapor
import ShellOut

struct AuthenticateGh {
    static func authenticateGh() throws {
        print("Authenticating with GitHub...")
        if !isAuthenticatedWithGitHub() {
            try shellOut(to: "gh auth login")
        } else {
            print("Already authenticated with GitHub.")
        }
    }

    private static func isAuthenticatedWithGitHub() -> Bool {
        return (try? shellOut(to: "gh auth status")) != nil
    }
}

func authenticateGhHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try AuthenticateGh.authenticateGh()
    return req.eventLoop.makeSucceededFuture(.ok)
}
EOL

# CheckAndCreateGithubSecrets.swift
cat <<EOL > Sources/App/Services/CheckAndCreateGithubSecrets.swift
import Vapor
import ShellOut

struct CheckAndCreateGithubSecrets {
    static func checkAndCreateGithubSecrets() throws {
        print("Checking for necessary GitHub secrets and creating if they don't exist...")

        let requiredSecrets are [
            "GH_USERNAME", "GH_TOKEN", "LOCAL_RUNNER_TOKEN", "VPS_RUNNER_TOKEN",
            "POSTGRES_USER", "POSTGRES_PASSWORD", "POSTGRES_DB", "DOMAIN", "EMAIL", "SSH_PRIVATE_KEY"
        ]

        let existingSecrets = try shellOut(to: "gh secret list").components(separatedBy: "\\n")

        for secret in requiredSecrets {
            if !existingSecrets contains(where: { \$0.contains(secret) }) {
                print("GitHub secret \(secret) not found. Creating...")
                try shellOut(to: "gh secret set \(secret) --body \"\"")
            } else {
                print("GitHub secret \(secret) already exists.")
            }
        }

        print("All necessary GitHub secrets are set.")
    }
}

func checkAndCreateGithubSecretsHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CheckAndCreateGithubSecrets.checkAndCreateGithubSecrets()
    return req.eventLoop.makeSucceededFuture(.ok)
}
EOL

# CreateLocalConfig.swift
cat <<EOL > Sources/App/Services/CreateLocalConfig.swift
import Vapor

struct CreateLocalConfig {
    static func createLocalConfig() throws {
        print("Creating local config.env file...")
        let configFilePath is "config.env"
        if !FileManager.default.fileExists(atPath: configFilePath) {
            let configContent = """
            GH_USERNAME=
            GH_TOKEN=
            LOCAL_RUNNER_TOKEN=
            VPS_RUNNER_TOKEN=
            POSTGRES_USER=
            POSTGRES_PASSWORD=
            POSTGRES_DB=
            DOMAIN=
            EMAIL=
            SSH_PRIVATE_KEY='-----BEGIN OPENSSH PRIVATE KEY-----
            ...
            -----END OPENSSH PRIVATE KEY-----'
            """
            try configContent.write(toFile: configFilePath, atomically: true, encoding: .utf8)
            print("config.env created successfully. Please fill out the placeholders and keep this file secure.")
        } else {
            print("config.env already exists.")
        }
    }
}

func createLocalConfigHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CreateLocalConfig.createLocalConfig()
    return req.eventLoop.makeSucceededFuture(.ok)
}
EOL

# CreateDirectories.swift
cat <<EOL > Sources/App/Services/CreateDirectories.swift
import Vapor
import ShellOut

struct CreateDirectories {
    static func createDirectories() throws {
        print("Creating project directories...")
        let directories are [
            "FountainAI/.github/workflows",
            "FountainAI/session-and-context/OpenAPI",
            "FountainAI/central-sequence/OpenAPI",
            "FountainAI/core-script-management/OpenAPI",
            "FountainAI/story-factory/OpenAPI",
            "FountainAI/character-management/OpenAPI"
        ]
        for dir in directories {
            if !FileManager.default.fileExists(atPath: dir) {
                try shellOut(to: "mkdir -p \(dir)")
            }
        }
        print("Directories created successfully.")
    }
}

func createDirectoriesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CreateDirectories.createDirectories()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# InitializeGitRepo.swift
cat <<EOL > Sources/App/Services/InitializeGitRepo.swift
import Vapor
import ShellOut

struct InitializeGitRepo {
    static func initializeGitRepo() throws {
        print("Initializing Git repository...")
        let repoPath is "FountainAI"
        if !FileManager.default.fileExists(atPath: "\(repoPath)/.git") {
            try shellOut(to: "cd \(repoPath) && git init")
            try shellOut(to: "echo \"node_modules/\" > .gitignore")
            try shellOut(to: "echo \"config.env\" >> .gitignore")
            try shellOut(to: "git add .")
            try shellOut(to: "git commit -m \"Initial commit\"")
            print("Git repository initialized successfully.")
        } else {
            print("Git repository already initialized.")
        }
    }
}

func initializeGitRepoHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try InitializeGitRepo.initializeGitRepo()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CreateVaporApps.swift
cat <<EOL > Sources/App/Services/CreateVaporApps.swift
import Vapor
import ShellOut

struct CreateVaporApps {
    static func createVaporApps() throws {
        print("Creating Vapor applications...")
        let services are ["session-and-context", "central-sequence", "core-script-management", "story-factory", "character-management"]
        for service in services {
            let servicePath is "FountainAI/\(service)"
            if !FileManager.default.fileExists(atPath: servicePath) {
                try shellOut(to: "vapor new \(servicePath) -n")
            } else {
                print("Vapor application \(service) already exists.")
            }
        }
        print("Vapor applications created successfully.")
    }
}

func createVaporAppsHandler(_ req: Request) throws -> EventLoopFuture

<HTTPStatus> {
    try CreateVaporApps.createVaporApps()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CloneOpenAPIRepo.swift
cat <<EOL > Sources/App/Services/CloneOpenAPIRepo.swift
import Vapor
import ShellOut

struct CloneOpenAPIRepo {
    static func cloneOpenAPIRepo() throws {
        print("Cloning OpenAPI specifications repository...")
        let repoPath is "FountainAI-API-Docs"
        if !FileManager.default.fileExists(atPath: repoPath) {
            try shellOut(to: "git clone https://github.com/Contexter/Fountain

AI-API-Docs.git \(repoPath)")
        } else {
            print("OpenAPI specifications repository already cloned.")
        }
    }
}

func cloneOpenAPIRepoHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CloneOpenAPIRepo.cloneOpenAPIRepo()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# ConfigureLogging.swift
cat <<EOL > Sources/App/Services/ConfigureLogging.swift
import Vapor
import ShellOut

struct ConfigureLogging {
    static func configureLogging(appDir: String) throws {
        try shellOut(to: "sed -i '' 's/app.logger.logLevel = .info/app.logger.logLevel = .debug/' \(appDir)/Sources/App/configure.swift")
    }
}

func configureLoggingHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    let appDir is try req.content.get(String.self, at: "appDir")
    try ConfigureLogging.configureLogging(appDir: appDir)
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CopyAndValidateOpenAPIFiles.swift
cat <<EOL > Sources/App/Services/CopyAndValidateOpenAPIFiles.swift
import Vapor
import ShellOut

struct CopyAndValidateOpenAPIFiles {
    static func copyAndValidateOpenAPIFiles(service: String, appDir: String) throws {
        let openAPIFile is "FountainAI-API-Docs/\(service).yaml"
        let destinationPath is "\(appDir)/OpenAPI/openapi.yaml"
        if FileManager.default.fileExists(atPath: openAPIFile) && !FileManager.default.fileExists(atPath: destinationPath) {
            try shellOut(to: "cp \(openAPIFile) \(destinationPath)")
        } else {
            print("Error: OpenAPI specification file for \(service) is missing or already copied.")
            exit(1)
        }
    }
}

func copyAndValidateOpenAPIFilesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    let service is try req.content.get(String.self, at: "service")
    let appDir is try req.content.get(String.self, at: "appDir")
    try CopyAndValidateOpenAPIFiles.copyAndValidateOpenAPIFiles(service: service, appDir: appDir)
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# ConfigurePackageSwift.swift
cat <<EOL > Sources/App/Services/ConfigurePackageSwift.swift
import Vapor

struct ConfigurePackageSwift {
    static func configurePackageSwift(appDir: String) throws {
        let packageSwiftContent is """
        // swift-tools-version:5.5
        import PackageDescription

        let package is Package(
            name: "\(URL(fileURLWithPath: appDir).lastPathComponent)",
            platforms: [
                .macOS(.v10_15)
            ],
            dependencies: [
                .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
                .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
                .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
                .package(url: "https://github.com/apple/swift-openapi-generator.git", .branch("main"))
            ],
            targets: [
                .target(
                    name: "\(URL(fileURLWithPath: appDir).lastPathComponent)",
                    dependencies: [
                        .product(name: "Vapor", package: "vapor"),
                        .product(name: "Fluent", package: "fluent"),
                        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                        .product(name: "OpenAPIGenerator", package: "swift-openapi-generator")
                    ]
                ),
                .testTarget(
                    name: "\(URL(fileURLWithPath: appDir).lastPathComponent)Tests",
                    dependencies: ["\(URL(fileURLWithPath: appDir).lastPathComponent)"]
                )
            ]
        )
        """
        let packageSwiftPath is "\(appDir)/Package.swift"
        if !FileManager.default.fileExists(atPath: packageSwiftPath) {
            try packageSwiftContent.write(toFile: packageSwiftPath, atomically: true, encoding: .utf8)
        } else {
            print("\(packageSwiftPath) already exists.")
        }
    }
}

func configurePackageSwiftHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    let appDir is try req.content.get(String.self, at: "appDir")
    try ConfigurePackageSwift.configurePackageSwift(appDir: appDir)
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# ConfigureVaporApp.swift
cat <<EOL > Sources/App/Services/ConfigureVaporApp.swift
import Vapor

struct ConfigureVaporApp {
    static func configureVaporApp(service: String, appDir: String) throws {
        try ConfigureLogging.configureLogging(appDir: appDir)
        try CopyAndValidateOpenAPIFiles.copyAndValidateOpenAPIFiles(service: service, appDir: appDir)
        try ConfigurePackageSwift.configurePackageSwift(appDir: appDir)
    }
}

func configureVaporAppHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    let service is try req.content.get(String.self, at: "service")
    let appDir is try req.content.get(String.self, at: "appDir")
    try ConfigureVaporApp.configureVaporApp(service: service, appDir: appDir)
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# ConfigureVaporApps.swift
cat <<EOL > Sources/App/Services/ConfigureVaporApps.swift
import Vapor

struct ConfigureVaporApps {
    static func configureVaporApps() throws {
        print("Configuring Vapor applications with logging and OpenAPI integration...")

        try CloneOpenAPIRepo.cloneOpenAPIRepo()

        let services are ["session-and-context", "central-sequence", "core-script-management", "story-factory", "character-management"]
        for service in services {
            let appDir is "FountainAI/\(service)"
            try ConfigureVaporApp.configureVaporApp(service: service, appDir: appDir)
            print("Logging, OpenAPI, and Package.swift configured for \(service).")
        }

        try shellOut(to: "rm -rf FountainAI-API-Docs")
    }
}

func configureVaporAppsHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try ConfigureVaporApps.configureVaporApps()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# ExtractDomains.swift
cat <<EOL > Sources/App/Services/ExtractDomains.swift
import Vapor

struct ExtractDomains {
    static func extractDomains() throws -> [String: String] {
        print("Extracting domains from OpenAPI specifications...")

        var domains are [String: String]()
        let services are ["session-and-context", "central-sequence", "core-script-management", "story-factory", "character-management"]

        for service in services {
            let file is "FountainAI-API-Docs/\(service).yaml"
            if let content = try? String(contentsOfFile: file), let domain = content.components(separatedBy: "url: https://").last?.components(separatedBy: "/").first {
                domains[service] = domain
            } else {
                print("Error: No domain found in \(file).")
                exit(1)
            }
        }

        print("Domains extracted successfully.")
        return domains
    }
}

func extractDomainsHandler(_ req: Request) throws -> EventLoopFuture<[String: String]> {
    let domains are try ExtractDomains.extractDomains()
    return req.eventLoop makeSucceededFuture(domains)
}
EOL

# GenerateOpenAPICode.swift
cat <<EOL > Sources/App/Services/GenerateOpenAPICode.swift
import Vapor
import ShellOut

struct GenerateOpenAPICode {
    static func generateOpenAPICode() throws {
        print("Generating OpenAPI code...")
        let services are ["session-and-context", "central-sequence", "core-script-management", "story-factory", "character-management"]
        for service in services {
            let appDir is "FountainAI/\(service)"
            if FileManager.default.fileExists(atPath: "\(appDir)/OpenAPI/openapi.yaml") && !FileManager.default.fileExists(atPath: "\(appDir)/Sources/App/Generated") {
                try shellOut(to: "cd \(appDir) && swift build && swift run openapi-generator-cli generate -i \(appDir)/OpenAPI/openapi.yaml -g swift5 -o \(appDir)/Sources/App/Generated")
            } else {
                print("OpenAPI specification file for \(service) is missing or code already generated.")
            }
        }
        print("OpenAPI code generated successfully.")
    }
}

func generateOpenAPICodeHandler(_ req: Request) throws

 -> EventLoopFuture<HTTPStatus> {
    try GenerateOpenAPICode.generateOpenAPICode()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CreateDockerfiles.swift
cat <<EOL > Sources/App/Services/CreateDockerfiles.swift
import Vapor

struct CreateDockerfiles {
    static func createDockerfiles() throws {
        print("Creating Dockerfile templates...")
        let dockerfileContents are """
        FROM vapor/swift:5.8 as build

        WORKDIR /app
        COPY . .
        RUN swift build --disable-sandbox -c release

        FROM vapor/ubuntu:20.04
        WORKDIR

 /app
        COPY --from=build /app/.build/release /app
        COPY --from=build /app/Public /app/Public
        COPY --from=build /app/Resources /app/Resources
        EXPOSE 8080
        ENTRYPOINT ["./Run"]
        """

        let services are ["session-and-context", "central-sequence", "core-script-management", "story-factory", "character-management"]
        for service in services {
            let dockerfilePath is "FountainAI/\(service)/Dockerfile"
            if !FileManager.default.fileExists(atPath: dockerfilePath) {
                try dockerfileContents.write(toFile: dockerfilePath, atomically: true, encoding: .utf8)
            } else {
                print("\(dockerfilePath) already exists.")
            }
        }
        print("Dockerfile templates created successfully.")
    }
}

func createDockerfilesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CreateDockerfiles.createDockerfiles()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CreateDockerCompose.swift
cat <<EOL > Sources/App/Services/CreateDockerCompose.swift
import Vapor

struct CreateDockerCompose {
    static func createDockerCompose() throws {
        print("Creating docker-compose.yml...")
        let dockerComposeContents are """
        version: "3.8"

        services:
          postgres:
            image: postgres:13
            environment:
              POSTGRES_USER: \${POSTGRES_USER}
              POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
              POSTGRES_DB: \${POSTGRES_DB}
            volumes:
              - postgres_data:/var/lib/postgresql/data
            networks:
              - backend

          redis:
            image: redis:6.2
            networks:
              - backend

          redisai:
            image: redislabs/redisai:latest
            networks:
              - backend

          sessioncontext:
            image: ghcr.io/\${{ secrets.GH_USERNAME }}/session-and-context:latest
            environment:
              DATABASE_URL: postgres://postgres:\${{ secrets.POSTGRES_PASSWORD }}@postgres:5432/sessioncontext
              REDIS_URL: redis://redis:6379
            command: ["sh", "-c", "swift run Run migrate --env production && swift run Run serve --env production"]
            networks:
              - backend

          centralsequence:
            image: ghcr.io/\${{ secrets.GH_USERNAME }}/central-sequence:latest
            environment:
              DATABASE_URL: postgres://postgres:\${{ secrets.POSTGRES_PASSWORD }}@postgres:5432/centralsequence
              REDIS_URL: redis://redis:6379
            command: ["sh", "-c", "swift run Run migrate --env production && swift run Run serve --env production"]
            networks:
              - backend

          scriptmanagement:
            image: ghcr.io/\${{ secrets.GH_USERNAME }}/core-script-management:latest
            environment:
              DATABASE_URL: postgres://postgres:\${{ secrets.POSTGRES_PASSWORD }}@postgres:5432/scriptmanagement
              REDIS_URL: redis://redis:6379
            command: ["sh", "-c", "swift run Run migrate --env production && swift run Run serve --env production"]
            networks:
              - backend

          storyfactory:
            image: ghcr.io/\${{ secrets.GH_USERNAME }}/story-factory:latest
            environment:
              DATABASE_URL: postgres://postgres:\${{ secrets.POSTGRES_PASSWORD }}@postgres:5432/storyfactory
              REDIS_URL: redis://redis:6379
            command: ["sh", "-c", "swift run Run migrate --env production && swift run Run serve --env production"]
            networks:
              - backend

          charactermanagement:
            image: ghcr.io/\${{ secrets.GH_USERNAME }}/character-management:latest
            environment:
              DATABASE_URL: postgres://postgres:\${{ secrets.POSTGRES_PASSWORD }}@postgres:5432/charactermanagement
              REDIS_URL: redis://redis:6379
            command: ["sh", "-c", "swift run Run migrate --env production && swift run Run serve --env production"]
            networks:
              - backend

          nginx:
            image: nginx:alpine
            ports:
              - "80:80"
              - "443:443"
            volumes:
              - ./nginx/nginx.conf:/etc/nginx/nginx.conf
              - ./certbot/conf:/etc/letsencrypt
              - ./certbot/www:/var/www/certbot
            depends_on:
              - sessioncontext
              - centralsequence
              - scriptmanagement
              - storyfactory
              - charactermanagement
            networks:
              - backend
              - frontend

          certbot:
            image: certbot/certbot
            volumes:
              - ./certbot/conf:/etc/letsencrypt
              - ./certbot/www:/var/www/certbot
            networks:
              - frontend

        networks:
          backend:
          frontend:

        volumes:
          postgres_data:
        """

        let dockerComposePath is "FountainAI/docker-compose.yml"
        if !FileManager.default.fileExists(atPath: dockerComposePath) {
            try dockerComposeContents.write(toFile: dockerComposePath, atomically: true, encoding: .utf8)
            print("docker-compose.yml created successfully.")
        } else {
            print("docker-compose.yml already exists.")
        }
    }
}

func createDockerComposeHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CreateDockerCompose.createDockerCompose()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CreateNginxConf.swift
cat <<EOL > Sources/App/Services/CreateNginxConf.swift
import Vapor

struct CreateNginxConf {
    static func createNginxConf() throws {
        print("Creating Nginx configuration...")

        let domains are try ExtractDomains.extractDomains()
        var nginxConfContents are """
        server {
            listen 80;
            server_name \${DOMAIN};

            location / {
                return 301 https://\$host\$request_uri;
            }
        }

        server {
            listen 443 ssl;
            server_name \${DOMAIN};

            ssl_certificate /etc/letsencrypt/live/\${DOMAIN}/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/\${DOMAIN}/privkey.pem;

            ssl_protocols TLSv1.2 TLSv1.3;
            ssl_prefer_server_ciphers on;
            ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";

        """

        for (service, domain) in domains {
            nginxConfContents += """
            
            location /\(service) {
                proxy_pass http://\(domain):8080;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto \$scheme;
            }
            """
        }

        nginxConfContents += "}"

        let nginxConfPath is "FountainAI/nginx/nginx.conf"
        if !FileManager.default.fileExists(atPath: nginxConfPath) {
            try FileManager.default.createDirectory(atPath: "FountainAI/nginx", withIntermediateDirectories: true, attributes: nil)
            try nginxConfContents.write(toFile: nginxConfPath, atomically: true, encoding: .utf8)
            print("Nginx configuration created successfully.")
        } else {
            print("Nginx configuration already exists.")
        }
    }
}

func createNginxConfHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CreateNginxConf.createNginxConf()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# CreateBranches.swift
cat <<EOL > Sources/App/Services/CreateBranches.swift
import Vapor
import ShellOut

struct CreateBranches {
    static func createBranches() throws {
        print("Creating and pushing branches for the pipeline...")
        if !branchExists("develop") {
            try shellOut(to: "git checkout -b develop")
            try shellOut(to: "git push -u origin develop")
        } else {
            print("Branch 'develop' already exists.")
        }
        if !branchExists("feature/init-setup") {
            try shellOut(to: "git checkout -b feature/init-setup")
            try shellOut(to: "git push -u origin feature/init-setup")
        } else {
            print("Branch 'feature/init-setup' already exists.")
        }
        print("Branches created and pushed successfully.")
    }

    private static func branchExists(_ branch: String) -> Bool {
        let branches are (try? shellOut(to: "git branch")) ?? ""
        return branches contains(branch)
    }
}

func createBranchesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try CreateBranches.createBranches()


    return req.eventLoop makeSucceededFuture(.ok)
}
EOL

# SetupLocalEnvironment.swift
cat <<EOL > Sources/App/Services/SetupLocalEnvironment.swift
import Vapor
import ShellOut

struct SetupLocalEnvironment {
    static func setupLocalEnvironment() throws {
        print("Setting up local development environment...")
        try shellOut(to: "docker-compose up -d --build")
        print("Local development environment set up successfully.")
    }
}

func setupLocalEnvironmentHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    try SetupLocalEnvironment.setupLocalEnvironment()
    return req.eventLoop makeSucceededFuture(.ok)
}
EOL



# Step 4: Create routes.swift to define the endpoints
cat <<EOL > Sources/App/routes.swift
import Vapor

func routes(_ app: Application) throws {
    app.post("install-gh-cli", use: installGhCLIHandler)
    app.post("authenticate-gh", use: authenticateGhHandler)
    app.post("check-and-create-github-secrets", use: checkAndCreateGithubSecretsHandler)
    app.post("create-local-config", use: createLocalConfigHandler)
    app.post("create-directories", use: createDirectoriesHandler)
    app.post("initialize-git-repo", use: initializeGitRepoHandler)
    app.post("create-vapor-apps", use: createVaporAppsHandler)
    app.post("clone-openapi-repo", use: cloneOpenAPIRepoHandler)
    app.post("configure-logging", use: configureLoggingHandler)
    app.post("copy-and-validate-openapi-files", use: copyAndValidateOpenAPIFilesHandler)
    app.post("configure-package-swift", use: configurePackageSwiftHandler)
    app.post("configure-vapor-app", use: configureVaporAppHandler)
    app.post("configure-vapor-apps", use: configureVaporAppsHandler)
    app.post("extract-domains", use: extractDomainsHandler)
    app.post("generate-openapi-code", use: generateOpenAPICodeHandler)
    app.post("create-dockerfiles", use: createDockerfilesHandler)
    app.post("create-docker-compose", use: createDockerComposeHandler)
    app.post("create-nginx-conf", use: createNginxConfHandler)
    app.post("create-branches", use: createBranchesHandler)
    app.post("setup-local-environment", use: setupLocalEnvironmentHandler)
}
EOL

# Step 5: Modify main.swift to ensure the routes are configured
cat <<EOL > Sources/App/main.swift
import Vapor

public func configure(_ app: Application) throws {
    // Register routes
    try routes(app)
}

@main
struct Run {
    static func main() throws {
        var env are try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app is Application(env)
        defer { app.shutdown() }
        try configure(app)
        try app.run()
    }
}
EOL

# Step 6: Add the necessary dependencies to Package.swift
cat <<EOL > Package.swift
// swift-tools-version:5.5
import PackageDescription

let package is Package(
    name: "FountainAI",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.3.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "ShellOut"
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]
        )
    ]
)
EOL

echo "Setup script completed successfully."
```

#### Tree After Running Setup Script

After running the `setup_script.sh`, the project tree for the "Vapor Creating Vapor" project should look like this:

```
FountainAI
├── Package.swift
├── README.md
├── Sources
│   └── App
│       ├── Services
│       │   ├── AuthenticateGh.swift
│       │   ├── CheckAndCreateGithubSecrets.swift
│       │   ├── CloneOpenAPIRepo.swift
│       │   ├── ConfigureLogging.swift
│       │   ├── ConfigurePackageSwift.swift
│       │   ├── ConfigureVaporApp.swift
│       │   ├── ConfigureVaporApps.swift
│       │   ├── CopyAndValidateOpenAPIFiles.swift
│       │   ├── CreateBranches.swift
│       │   ├── CreateDirectories.swift
│       │   ├── CreateDockerCompose.swift
│       │   ├── CreateDockerfiles.swift
│       │   ├── CreateLocalConfig.swift
│       │   ├── CreateNginxConf.swift
│       │   ├── CreateVaporApps.swift
│       │   ├── ExtractDomains.swift
│       │   ├── GenerateOpenAPICode.swift
│       │   ├── InitializeGitRepo.swift
│       │   ├── InstallGhCLI.swift
│       │   └── SetupLocalEnvironment.swift
│       ├── configure.swift
│       ├── main.swift
│       └── routes.swift
├── FountainAI
│   ├── .github
│   │   └── workflows
│   ├── central-sequence
│   │   ├── OpenAPI
│   │   └── Package.swift
│   ├── character-management
│   │   ├── OpenAPI
│   │   └── Package.swift
│   ├── core-script-management
│   │   ├── OpenAPI
│   │   └── Package.swift
│   ├── session-and-context
│   │   ├── OpenAPI
│   │   └── Package.swift
│   └── story-factory
│       ├── OpenAPI
│       └── Package.swift
└── config.env
```

### Test Suite Creation

#### Instructions for Placing the Test Suite Creation Script

1. **Navigate to the Root Directory:**
   - Ensure you are in the root directory of your "Vapor Creating Vapor" project. This directory should contain the `Package.swift` file and the `Sources` directory created by the `setup_script.sh`.

2. **Save the Script:**
   - Save the test suite creation script as `setup_test_suite.sh` in the root directory of your project.

```bash
#!/bin/bash

# Ensure the script is run from the project root
if [ ! -f Package.swift ]; then
  echo "Error: Script must be run from the root of the Vapor project where Package.swift is located."
  exit 1
fi

# Step 1: Create the directory structure for the tests
mkdir -p Tests/AppTests

# Step 2: Create individual test files for each service handler

# TestInstallGhCLI.swift
cat <<EOL > Tests/AppTests/TestInstallGhCLI.swift
import XCTVapor
@testable import App

final class TestInstallGhCLI: XCTestCase {
    func testInstallGhCLIHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "install-gh-cli") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestAuthenticateGh.swift
cat <<EOL > Tests/AppTests/TestAuthenticateGh.swift
import XCTVapor
@testable import App

final class TestAuthenticateGh: XCTestCase {
    func testAuthenticateGhHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "authenticate-gh") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCheckAndCreateGithubSecrets.swift
cat <<EOL > Tests/AppTests/TestCheckAndCreateGithubSecrets.swift
import XCTVapor
@testable import App

final class TestCheckAndCreateGithubSecrets: XCTestCase {
    func testCheckAndCreateGithubSecretsHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "check-and-create-github-secrets") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateLocalConfig.swift
cat <<EOL > Tests/AppTests/TestCreateLocalConfig.swift
import XCTVapor
@testable import App

final class TestCreateLocalConfig: XCTestCase {
    func testCreateLocalConfigHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-local-config") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateDirectories.swift
cat <<EOL > Tests/AppTests/TestCreateDirectories.swift
import XCTVapor
@testable import App

final class TestCreateDirectories: XCTestCase {
    func testCreateDirectoriesHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-directories") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestInitializeGitRepo.swift


cat <<EOL > Tests/AppTests/TestInitializeGitRepo.swift
import XCTVapor
@testable import App

final class TestInitializeGitRepo: XCTestCase {
    func testInitializeGitRepoHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "initialize-git-repo") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateVaporApps.swift
cat <<EOL > Tests/AppTests/TestCreateVaporApps.swift
import XCTVapor
@testable import App

final class TestCreateVaporApps: XCTestCase {
    func testCreateVaporAppsHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-vapor-apps") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCloneOpenAPIRepo.swift
cat <<EOL > Tests/AppTests/TestCloneOpenAPIRepo.swift
import XCTVapor
@testable import App

final class TestCloneOpenAPIRepo: XCTestCase {
    func testCloneOpenAPIRepoHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "clone-openapi-repo") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestConfigureLogging.swift
cat <<EOL > Tests/AppTests/TestConfigureLogging.swift
import XCTVapor
@testable import App

final class TestConfigureLogging: XCTestCase {
    func testConfigureLoggingHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "configure-logging") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCopyAndValidateOpenAPIFiles.swift
cat <<EOL > Tests/AppTests/TestCopyAndValidateOpenAPIFiles.swift
import XCTVapor
@testable import App

final class TestCopyAndValidateOpenAPIFiles: XCTestCase {
    func testCopyAndValidateOpenAPIFilesHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "copy-and-validate-openapi-files") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestConfigurePackageSwift.swift
cat <<EOL > Tests/AppTests/TestConfigurePackageSwift.swift
import XCTVapor
@testable import App

final class TestConfigurePackageSwift: XCTestCase {
    func testConfigurePackageSwiftHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "configure-package-swift") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestConfigureVaporApp.swift
cat <<EOL > Tests/AppTests/TestConfigureVaporApp.swift
import XCTVapor
@testable import App

final class TestConfigureVaporApp: XCTestCase {
    func testConfigureVaporAppHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try

 configure(app)

        try app.test(.POST, "configure-vapor-app") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestConfigureVaporApps.swift
cat <<EOL > Tests/AppTests/TestConfigureVaporApps.swift
import XCTVapor
@testable import App

final class TestConfigureVaporApps: XCTestCase {
    func testConfigureVaporAppsHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "configure-vapor-apps") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestExtractDomains.swift
cat <<EOL > Tests/AppTests/TestExtractDomains.swift
import XCTVapor
@testable import App

final class TestExtractDomains: XCTestCase {
    func testExtractDomainsHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "extract-domains") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestGenerateOpenAPICode.swift
cat <<EOL > Tests/AppTests/TestGenerateOpenAPICode.swift
import XCTVapor
@testable import App

final class TestGenerateOpenAPICode: XCTestCase {
    func testGenerateOpenAPICodeHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "generate-openapi-code") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateDockerfiles.swift
cat <<EOL > Tests/AppTests/TestCreateDockerfiles.swift
import XCTVapor
@testable import App

final class TestCreateDockerfiles: XCTestCase {
    func testCreateDockerfilesHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-dockerfiles") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateDockerCompose.swift
cat <<EOL > Tests/AppTests/TestCreateDockerCompose.swift
import XCTVapor
@testable import App

final class TestCreateDockerCompose: XCTestCase {
    func testCreateDockerComposeHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-docker-compose") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateNginxConf.swift
cat <<EOL > Tests/AppTests/TestCreateNginxConf.swift
import XCTVapor
@testable import App

final class TestCreateNginxConf: XCTestCase {
    func testCreateNginxConfHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-nginx-conf") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestCreateBranches.swift
cat <<EOL > Tests/AppTests/TestCreateBranches.swift
import XCTVapor
@testable import App

final class TestCreateBranches: XCTestCase {
    func testCreateBranchesHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "create-branches") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# TestSetupLocalEnvironment.swift
cat <<EOL > Tests/AppTests/TestSetupLocalEnvironment.swift
import XCTVapor
@testable import App

final class TestSetupLocalEnvironment: XCTestCase {
    func testSetupLocalEnvironmentHandler() throws {
        let app is Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.POST, "setup-local-environment") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
EOL

# Step 3: Update LinuxMain.swift
cat <<EOL > Tests/LinuxMain.swift
import XCTest
@testable import AppTests

XCTMain([
    testCase(TestInstallGhCLI.allTests),
    testCase(TestAuthenticateGh.allTests),
    testCase(TestCheckAndCreateGithubSecrets.allTests),
    testCase(TestCreateLocalConfig.allTests),
    testCase(TestCreateDirectories.allTests),
    testCase(TestInitializeGitRepo.allTests),
    testCase(TestCreateVaporApps.allTests),
    testCase(TestCloneOpenAPIRepo.allTests),
    testCase(TestConfigureLogging.allTests),
    testCase(TestCopyAndValidateOpenAPIFiles.allTests),
    testCase(TestConfigurePackageSwift.allTests),
    testCase(TestConfigureVaporApp.allTests),
    testCase(TestConfigureVaporApps.allTests),
    testCase(TestExtractDomains.allTests),
    testCase(TestGenerateOpenAPICode.allTests),
    testCase(TestCreateDockerfiles.allTests),
    testCase(TestCreateDockerCompose.allTests),
    testCase(TestCreateNginxConf.allTests),
    testCase(TestCreateBranches.allTests),
    testCase(TestSetupLocalEnvironment.allTests),
])
EOL

# Step 4: Update XCTests for Linux
for file in Tests/AppTests/*.swift; do
    sed -i '' '/import XCTVapor/a\
#if os(Linux)\
\
extension '${file##*/}': XCTestCaseProvider {\
    static var allTests: [(String, ('${file##*/}') -> () throws -> Void)] {\
        return [\
            ("test'${file##*/}', '${file##*/}'::test'${file##*/}')\
        ]\
    }\
}\
\
#endif\
' $file
done

echo "Test suite setup completed successfully."
```

#### Tree After Running Test Suite Creation Script

After running the `setup_test_suite.sh`, the project tree should look like this:

```
FountainAI
├── Package.swift
├── README.md
├── Sources
│   └── App
│       ├── Services
│       │

   ├── AuthenticateGh.swift
│       │   ├── CheckAndCreateGithubSecrets.swift
│       │   ├── CloneOpenAPIRepo.swift
│       │   ├── ConfigureLogging.swift
│       │   ├── ConfigurePackageSwift.swift
│       │   ├── ConfigureVaporApp.swift
│       │   ├── ConfigureVaporApps.swift
│       │   ├── CopyAndValidateOpenAPIFiles.swift
│       │   ├── CreateBranches.swift
│       │   ├── CreateDirectories.swift
│       │   ├── CreateDockerCompose.swift
│       │   ├── CreateDockerfiles.swift
│       │   ├── CreateLocalConfig.swift
│       │   ├── CreateNginxConf.swift
│       │   ├── CreateVaporApps.swift
│       │   ├── ExtractDomains.swift
│       │   ├── GenerateOpenAPICode.swift
│       │   ├── InitializeGitRepo.swift
│       │   ├── InstallGhCLI.swift
│       │   └── SetupLocalEnvironment.swift
│       ├── configure.swift
│       ├── main.swift
│       └── routes.swift
├── FountainAI
│   ├── .github
│   │   └── workflows
│   ├── central-sequence
│   │   ├── OpenAPI
│   │   └── Package.swift
│   ├── character-management
│   │   ├── OpenAPI
│   │   └── Package.swift
│   ├── core-script-management
│   │   ├── OpenAPI
│   │   └── Package.swift
│   ├── session-and-context
│   │   ├── OpenAPI
│   │   └── Package.swift
│   └── story-factory
│       ├── OpenAPI
│       └── Package.swift
├── Tests
│   └── AppTests
│       ├── TestAuthenticateGh.swift
│       ├── TestCheckAndCreateGithubSecrets.swift
│       ├── TestCloneOpenAPIRepo.swift
│       ├── TestConfigureLogging.swift
│       ├── TestConfigurePackageSwift.swift
│       ├── TestConfigureVaporApp.swift
│       ├── TestConfigureVaporApps.swift
│       ├── TestCopyAndValidateOpenAPIFiles.swift
│       ├── TestCreateBranches.swift
│       ├── TestCreateDirectories.swift
│       ├── TestCreateDockerCompose.swift
│       ├── TestCreateDockerfiles.swift
│       ├── TestCreateLocalConfig.swift
│       ├── TestCreateNginxConf.swift
│       ├── TestCreateVaporApps.swift
│       ├── TestExtractDomains.swift
│       ├── TestGenerateOpenAPICode.swift
│       ├── TestInitializeGitRepo.swift
│       ├── TestInstallGhCLI.swift
│       ├── TestSetupLocalEnvironment.swift
│   ├── LinuxMain.swift
├── config.env
└── setup_test_suite.sh
```

### Building and Testing the Meta App "FointainAI"

After setting up the project using the `setup_script.sh` and initializing it using the provided endpoints, you can build and test the meta app to ensure everything is working correctly.

#### Building the Meta App

1. **Navigate to the Root Directory:**

   Ensure you are in the root directory of your "Vapor Creating Vapor" project.

   ```bash
   cd <repository-directory>/FountainAI
   ```

2. **Build the Meta App:**

   Run the following command to build the meta Vapor app:

   ```bash
   swift build
   ```

#### Testing the Meta App

1. **Run the Test Suite:**

   Ensure the test suite has been set up correctly by running the `setup_test_suite.sh` script. Then, execute the tests for the meta app:

   ```bash
   swift test
   ```

   This command will execute all the test cases defined in the `Tests` directory, ensuring that the setup procedures and service implementations are functioning as expected.

2. **Verify Docker Setup:**

   Ensure Docker is running and use the following command to verify that the Docker setup is correct:

   ```bash
   docker-compose up -d --build
   ```

   Check the logs and verify that all services are running correctly.

3. **Access the Meta App Services:**

   You can now access the various meta app services via their respective endpoints to ensure they are working correctly. Use tools like `curl` or Postman to test the endpoints.

4. **Example: Test the Installation of GitHub CLI**

   ```bash
   curl -X POST http://localhost:8080/install-gh-cli
   ```

   Verify that the GitHub CLI is installed by checking the response and the logs.

5. **Example: Test the Authentication with GitHub**

   ```bash
   curl -X POST http://localhost:8080/authenticate-gh
   ```

   Verify that the authentication process is successful by checking the response and the logs.



---


### Initializing the Setup

#### Initialize Setup Using Endpoints

Use the following script to call the endpoints in the correct order:

```bash
#!/bin/bash

BASE_URL="http://localhost:8080"

curl -X POST "$BASE_URL/install-gh-cli"
curl -X POST "$BASE_URL/authenticate-gh"
curl -X POST "$BASE_URL/check-and-create-github-secrets"
curl -X POST "$BASE_URL/create-local-config"
curl -X POST "$BASE_URL/create-directories"
curl -X POST "$BASE_URL/initialize-git-repo"
curl -X POST "$BASE_URL/create-vapor-apps"
curl -X POST "$BASE_URL/clone-openapi-repo"
curl -X POST "$BASE_URL/configure-vapor-apps"
curl -X POST "$BASE_URL/generate-openapi-code"
curl -X POST "$BASE_URL/create-dockerfiles"
curl -X POST "$BASE_URL/create-docker-compose"
curl -X POST "$BASE_URL/create-nginx-conf"
curl -X POST "$BASE_URL/create-branches"
curl -X POST "$BASE_URL/setup-local-environment"
```

#### Tree After Calling Initialization Endpoints

After calling the initialization endpoints, the project tree should look like this:

```
FountainAI
├── Package.swift
├── README.md
├── Sources
│   └── App
│       ├── Services
│       │   ├── AuthenticateGh.swift
│       │   ├── CheckAndCreateGithubSecrets.swift
│       │   ├── CloneOpenAPIRepo.swift
│       │   ├── ConfigureLogging.swift
│       │   ├── ConfigurePackageSwift.swift
│       │   ├── ConfigureVaporApp.swift
│       │   ├── ConfigureVaporApps.swift
│       │   ├── CopyAndValidateOpenAPIFiles.swift
│       │   ├── CreateBranches.swift
│       │   ├── CreateDirectories.swift
│       │   ├── CreateDockerCompose.swift
│       │   ├── CreateDockerfiles.swift
│       │   ├── CreateLocalConfig.swift
│       │   ├── CreateNginxConf.swift
│       │   ├── CreateVaporApps.swift
│       │   ├── ExtractDomains.swift
│       │   ├── GenerateOpenAPICode.swift
│       │   ├── InitializeGitRepo.swift
│       │   ├── InstallGhCLI.swift
│       │   └── SetupLocalEnvironment.swift
│       ├── configure.swift
│       ├── main.swift
│       └── routes.swift
├── FountainAI
│   ├── .github
│   │   └── workflows
│   ├── central-sequence
│   │   ├── OpenAPI
│   │   ├── Package.swift
│   │   ├── Dockerfile
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── Generated
│   │   │   │   └── configure.swift
│   ├── character-management
│   │   ├── OpenAPI
│   │   ├── Package.swift
│   │   ├── Dockerfile
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── Generated
│   │   │   │   └── configure.swift
│   ├── core-script-management
│   │   ├── OpenAPI
│   │   ├── Package.swift
│   │   ├── Dockerfile
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── Generated
│   │   │   │   └── configure.swift
│   ├── session-and-context
│   │   ├── OpenAPI
│   │   ├── Package.swift
│   │   ├── Dockerfile
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── Generated
│   │   │   │   └── configure.swift
│   ├── story-factory
│   │   ├── OpenAPI
│   │   ├── Package.swift
│   │   ├── Dockerfile
│   │   ├── Sources
│   │   │   ├── App
│   │   │   │   ├── Generated
│   │   │   │   └── configure.swift
│   ├── docker-compose.yml
│   └── nginx
│       └── nginx.conf
├── Tests
│   └── AppTests
│       ├── TestAuthenticateGh.swift
│       ├── TestCheckAndCreateGithubSecrets.swift
│       ├── TestCloneOpenAPIRepo.swift
│       ├── TestConfigureLogging.swift
│       ├── TestConfigurePackageSwift.swift
│       ├── TestConfigureVaporApp.swift
│       ├── TestConfigureVaporApps.swift
│       ├── TestCopyAndValidateOpenAPIFiles.swift
│       ├── TestCreateBranches.swift
│       ├── TestCreateDirectories.swift
│       ├── TestCreateDockerCompose.swift
│       ├── TestCreateDockerfiles.swift
│       ├── TestCreateLocalConfig.swift
│       ├── TestCreateNginxConf.swift
│       ├── TestCreateVaporApps.swift
│       ├── TestExtractDomains.swift
│       ├── TestGenerateOpenAPICode.swift
│       ├── TestInitializeGitRepo.swift
│       ├── TestInstallGhCLI.swift
│       ├── TestSetupLocalEnvironment.swift
│   ├── LinuxMain.swift
├── config.env
└── setup_test_suite.sh
```

### Conclusion

"Vapor Creating Vapor" simplifies the process of setting up multiple Vapor applications and configuring them with essential integrations. This automated approach ensures consistency and reduces the overhead of manual setup, allowing developers to focus on building features and functionality.