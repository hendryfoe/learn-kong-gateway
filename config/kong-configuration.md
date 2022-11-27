```sh
docker build --no-cache -t kong-deno-apps .

docker network create kong-net

docker run -d --name kong-database \
  --network=kong-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kongpass" \
  postgres:15.1-bullseye

# postgres:9.6.24-alpine

# OSS
docker run --rm --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_PASSWORD=kongpass" \
  kong:3.0.1 kong migrations bootstrap

# OSS
docker run -d --name kong-gateway \
  --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_USER=kong" \
  -e "KONG_PG_PASSWORD=kongpass" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 127.0.0.1:8001:8001 \
  -p 127.0.0.1:8444:8444 \
  kong:3.0.1


# Enterprise
docker run --rm --network=kong-net \
  --platform=linux/x86_64 \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_PASSWORD=kongpass" \
  -e "KONG_PASSWORD=test" \
  kong/kong-gateway:3.0.1.0 kong migrations bootstrap

# Enterprise
export KONG_LICENSE_DATA='{"license":{"payload":{"admin_seats":"10","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2022-07-20","license_expiration_date":"2024-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'

docker run -d --name kong-gateway \
  --platform=linux/x86_64 \
  --network=kong-net \
  -v ./tmp:/tmp \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_USER=kong" \
  -e "KONG_PG_PASSWORD=kongpass" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
  -e KONG_LICENSE_DATA \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong/kong-gateway:3.0.1.0
```

# Adding Load Balancer

### Create upstream
```sh
curl -X POST http://localhost:8001/upstreams \
  --data name='app-one-upstream'
```

### Attach Upstream to `target` services
```sh
curl -X POST http://localhost:8001/upstreams/app-one-upstream/targets \
  --data target='host.docker.internal:3001'
curl -X POST http://localhost:8001/upstreams/app-one-upstream/targets \
  --data target='host.docker.internal:3011'
```

### Update Service host to Load Balancer upstream
```sh
curl -X PATCH http://localhost:8001/services/app-one \
  --data host='app-one-upstream''
```