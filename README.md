# laravel-fullstack-docker
A modern full-stack boilerplate for building Laravel web applications with Docker.  
Includes PHP, Node.js, MySQL, and NGINX, all containerized for rapid local development.

## Requirements
- Docker and Docker Compose installed on your machine.

## Features
- MySQL server
- Nginx web server
- PHP 8.4
- Node.js 20
## Installation
- Clone the repository
```bash 
chmod +x ./initialize.sh
./initialize.sh
```
Note: Do not use http:// when defining the local domain. 

- Navigate to the infrastructure directory:
```bash
cd infrastructure
```
- Start the Docker containers:
```bash
docker-compose up --build
```

## Folder Structure
- backend: Contains the Laravel application.
- frontend: Contains the Frontend application.
- infrastructure: Contains the Docker configuration files.
