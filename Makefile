include .env
export 

postgres_up:
	docker-compose up -d kinotower-postgres

postgres_down:
	docker-compose down kinotower-postgres

migrate-create:
	docker compose -f docker-compose.yml run --rm kinotower-postgres-migrate create -ext sql -dir /migrations $(name)

migrate-up:
	docker compose -f docker-compose.yml run --rm kinotower-postgres-migrate -path=/migrations/ -database "postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@kinotower-postgres:5432/$(POSTGRES_DB)?sslmode=disable" up

migrate-down:
	docker compose -f docker-compose.yml run --rm kinotower-postgres-migrate -path=/migrations/ -database "postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@kinotower-postgres:5432/$(POSTGRES_DB)?sslmode=disable" down -all