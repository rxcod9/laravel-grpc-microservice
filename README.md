# Laravel gRPC Microservice with RoadRunner

A **minimal, production-ready Dockerized Laravel microservice** using **gRPC** and **RoadRunner**. This project enables you to **publish and receive messages** over gRPC with minimal dependencies—no full Laravel framework required. Logging is directed to Docker stdout for easy container monitoring.

---

## 🚀 Features

- PHP 8.4 CLI (alpine or debian)
- gRPC via [`spiral/roadrunner-grpc`](https://github.com/spiral/roadrunner-grpc)
- Logging with `illuminate/log` and `monolog`
- Minimal Laravel components: `support`, `log`, `config`
- `.proto`-driven code generation (Dockerized `protoc`)
- RoadRunner gRPC server & PHP worker
- Docker Compose for local development

---

## 📦 Prerequisites

- Docker & Docker Compose
- `protoc` and PHP plugins (optional if using Docker for codegen)
- `grpcurl` (optional, for testing)
- PHP 8.4 extensions: `grpc`, `protobuf`, `sockets` (included in Dockerfile)

---

## 📁 Project Structure

```
grpc-service/
├── Dockerfile
├── docker-compose.yml
├── .rr.yaml
├── protos/
│   └── messages.proto
├── src/
│   ├── MessageService.php
│   └── MessageServiceInterface.php
├── app/
│   └── Grpc/       (auto-generated from .proto)
├── bootstrap.php
├── composer.json
├── composer.lock
└── README.md
```

---

## 🏁 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/rxcod9/laravel-grpc-microservice.git
cd laravel-grpc-microservice
```

---

### 2. Generate gRPC PHP Stubs

Use Dockerized `namely/protoc-all`:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace namely/protoc-all \
  -f protos/messages.proto \
  -l php \
  -o app/Grpc
```

This generates:

- `MessageServiceInterface.php`
- `MessageServiceClient.php`
- Message request/response classes

---

### 3. Build and Start the Service

```bash
docker-compose up --build
```

This will:

- Install PHP dependencies
- Compile and install gRPC extensions
- Start the RoadRunner worker and gRPC server

---

## 🧪 Testing the gRPC Server

Example using `grpcurl`:

```bash
grpcurl -plaintext \
  -proto protos/messages.proto \
  -d '{"topic":"notifications","payload":"{\"event\":\"test\"}"}' \
  localhost:50051 messages.MessageService/SendMessage
```

Expected response:

```json
{
  "success": true,
  "message": "Message processed"
}
```

---

## 📜 Example `.proto` Definition

```proto
syntax = "proto3";

package messages;

service MessageService {
  rpc SendMessage (MessageRequest) returns (MessageResponse);
}

message MessageRequest {
  string topic = 1;
  string payload = 2;
}

message MessageResponse {
  bool success = 1;
  string message = 2;
}
```

---

## ⚙️ RoadRunner Configuration (`.rr.yaml`)

```yaml
rpc:
  listen: tcp://0.0.0.0:6001

grpc:
  listen: tcp://0.0.0.0:50051
  proto:
    - protos/messages.proto
  workers:
    command: "php bootstrap.php"
    pool:
      numWorkers: 2
```

---

## 🛠 Build Notes

- Install `grpc.so` and `protobuf.so` in Docker with `pecl install grpc protobuf`, or copy pre-built `.so` files for faster builds.
- Download the RoadRunner binary in Dockerfile:

  ```Dockerfile
  RUN curl -Ls https://github.com/roadrunner-server/roadrunner/releases/download/v2025.1.2/roadrunner-2025.1.2-linux-amd64.tar.gz \
    | tar -xz -C /usr/local/bin rr
  ```

---

## 📦 Example `composer.json`

```json
{
  "require": {
    "spiral/roadrunner-grpc": "^2.6",
    "illuminate/log": "^12.0",
    "illuminate/support": "^12.0",
    "illuminate/config": "^12.0",
    "illuminate/container": "^12.0",
    "illuminate/console": "^12.0",
    "monolog/monolog": "^3.0"
  },
  "autoload": {
    "psr-4": {
      "App\\": "app/",
      "Messages\\": "app/Grpc/Messages/",
      "GPBMetadata\\": "app/Grpc/GPBMetadata/"
    }
  }
}
```

---

## 🧼 Clean Shutdown

```bash
docker-compose down
```

---

## 📋 License

MIT

---

## 🙋 Support

For issues, bugs, or feature requests, open an issue on GitHub or contact the maintainer.

