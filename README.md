# 🛒 Microservices Demo - E-Commerce Platform

A complete microservices-based e-commerce platform demonstrating Docker best practices for production deployments.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              NGINX                                      │
│                         (Load Balancer)                                 │
│                           Port 80                                       │
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
├── scripts/
│   ├── dev.sh            # Development setup script
│   └── stop.sh           # Stop all services
├── docker-compose.yml    # Docker Compose configuration
└── README.md
```

##  Quick Start

### Using the Dev Script (Recommended)

```bash
# Make the scripts executable (first time only)
chmod +x scripts/*.sh

# Run the development setup
./scripts/dev.sh

# Stop all services
./scripts/stop.sh
```

The `dev.sh` script will:
1. Verify Docker and Docker Compose are running
2. Check all required files exist
3. Build and start all services
4. Run health checks on all containers

The `stop.sh` script will:
1. Verify Docker and Docker Compose are running
2. Check if any project containers are running
3. Show which services will be stopped and ask for confirmation
4. Stop and remove all containers and networks
5. Verify shutdown was successful

### Manual Start

```bash
# Start all services
docker compose up -d --build

# View logs
docker compose logs -f

# Stop all services
docker compose down
```

### Access the Application

- Frontend: http://localhost
- API Endpoints: http://localhost/api/users, /api/products, /api/orders

## 🔌 API Endpoints

### Via Nginx (http://localhost)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Frontend |
| GET | `/api/users` | List users |
| POST | `/api/users` | Create user |
| GET | `/api/products` | List products |
| POST | `/api/products` | Create product |
| GET | `/api/orders` | List orders |
| POST | `/api/orders` | Create order |

## 🧪 Testing the Services

```bash
# List users
curl http://localhost/api/users

# Create a user
curl -X POST http://localhost/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# List products
curl http://localhost/api/products

# Create a product
curl -X POST http://localhost/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "price": 999.99, "stock": 50}'

# List orders
curl http://localhost/api/orders

# Create an order
curl -X POST http://localhost/api/orders \
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
| `USER_SERVICE_URL` | http://user-service:3001 | User service URL |
| `PRODUCT_SERVICE_URL` | http://product-service:3002 | Product service URL |
| `ORDER_SERVICE_URL` | http://order-service:3003 | Order service URL |

### Services
| Variable | Default | Description |
|----------|---------|-------------|
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
