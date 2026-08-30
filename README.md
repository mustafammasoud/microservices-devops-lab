# 🛒 Microservices Demo - E-Commerce Platform

A complete microservices-based e-commerce platform demonstrating Docker best practices for production deployments.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              NGINX                                      │
│                         (Load Balancer)                                 │
│                           Port 80/443                                   │
└─────────────────────────────┬───────────────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────────────┐
│                          API Gateway                                    │
│                          Port 3000                                      │
│                    (Request Routing)                                    │
└───────────┬─────────────────┼─────────────────┬─────────────────────────┘
            │                 │                 │
┌───────────▼───────┐ ┌───────▼───────┐ ┌───────▼───────┐
│   User Service    │ │Product Service│ │ Order Service │
│    Port 3001      │ │   Port 3002   │ │   Port 3003   │
└─────────┬─────────┘ └───────┬───────┘ └───────┬───────┘
          │                   │                 │
          ▼                   ▼                 ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│   PostgreSQL    │ │   PostgreSQL    │ │   PostgreSQL    │
│   (users_db)    │ │  (products_db)  │ │   (orders_db)   │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

## 📁 Project Structure

```
microservices-demo/
├── api-gateway/          # Central API gateway
├── user-service/         # User management
├── product-service/      # Product catalog
├── order-service/        # Order processing
├── frontend/             # Web frontend
├── nginx/                # Load balancer config
├── docker-compose.yml    # Development setup
├── docker-compose.prod.yml # Production setup
└── README.md
```

##  Quick Start

### Development Mode

```bash
# Start all services
docker compose up -d --build

# View logs
docker compose logs -f

# Access the application
# Frontend: http://localhost
# API Gateway: http://localhost:3000
# API Docs: http://localhost:3000/health

# Stop all services
docker compose down
```

### Production Mode

```bash
# Start with production configuration
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Scale services
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --scale product-service=3
```

## 🔌 API Endpoints

### API Gateway (http://localhost:3000)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/api/users` | List users |
| POST | `/api/users` | Create user |
| GET | `/api/products` | List products |
| POST | `/api/products` | Create product |
| GET | `/api/orders` | List orders |
| POST | `/api/orders` | Create order |

## 🧪 Testing the Services

```bash
# Health check
curl http://localhost:3000/health

# Create a user
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# Create a product
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "price": 999.99, "stock": 50}'

# List products
curl http://localhost:3000/api/products

# Create an order
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{"userId": 1, "productId": 1, "quantity": 2}'
```

## 🐳 Docker Images

Each service has its own optimized Dockerfile with:
- Multi-stage builds
- Non-root user
- Health checks
- Minimal base images

## 🔧 Environment Variables

### API Gateway
| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 3000 | Server port |
| `USER_SERVICE_URL` | http://user-service:3001 | User service URL |
| `PRODUCT_SERVICE_URL` | http://product-service:3002 | Product service URL |
| `ORDER_SERVICE_URL` | http://order-service:3003 | Order service URL |

### Services
| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | varies | Server port |
| `DATABASE_URL` | - | PostgreSQL connection string |

## 📊 Monitoring

The production setup includes:
- Health check endpoints for all services
- Container resource limits
- Restart policies
- Centralized logging

## 🎓 Learning Objectives

This demo teaches:
1. Microservices architecture patterns
2. Service-to-service communication
3. API Gateway pattern
4. Database per service pattern
5. Docker networking
6. Docker Compose for orchestration
7. Production deployment best practices
8. Health checks and monitoring
