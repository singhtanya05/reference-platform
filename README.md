# Reference Platform API

This is a production-like Spring Boot REST API used as the workload for the Reference Platform GitOps and DevOps demonstrations.

It provides a simple Product API with database persistence, migrations, and observability endpoints.

## Features
- **Java 21** & **Spring Boot 3**
- **PostgreSQL** integration with Spring Data JPA
- **Flyway** for database migrations
- **Actuator** and **Prometheus** metrics endpoints
- Containerized via a multi-stage **Dockerfile**

## Local Setup

### Prerequisites
- Java 21
- Docker (optional, to run PostgreSQL locally)

### 1. Database Setup
You can run a PostgreSQL instance locally using Docker:
```bash
docker run --name ref-platform-db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=reference_platform -p 5432:5432 -d postgres:15
```

### 2. Run the Application
The application is configured to connect to `localhost:5432` by default. You can override these variables if necessary:
```bash
export DB_URL=jdbc:postgresql://localhost:5432/reference_platform
export DB_USER=postgres
export DB_PASSWORD=postgres
```
Run the application using the Maven wrapper:
```bash
./mvnw spring-boot:run
```

## Running Tests
To run all unit tests and verify the application context loads successfully:
```bash
./mvnw test
```

## Docker

### Build the Image
```bash
docker build -t reference-platform-api:latest .
```

### Run the Container
(Assuming your database is accessible from the container)
```bash
docker run -p 8080:8080 \
  -e DB_URL=jdbc:postgresql://host.docker.internal:5432/reference_platform \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  reference-platform-api:latest
```

## Endpoints

### Application API
- `GET /api/v1/products` - List all products
- `GET /api/v1/products/{id}` - Get a product by ID
- `POST /api/v1/products` - Create a new product
- `PUT /api/v1/products/{id}` - Update a product
- `DELETE /api/v1/products/{id}` - Delete a product

### Observability
- `GET /actuator/health` - Application health
- `GET /actuator/prometheus` - Prometheus metrics
