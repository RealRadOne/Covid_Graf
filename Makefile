include .env

PSQL = PGPASSWORD=$(POSTGRES_PASSWORD) \
	docker exec -i $(POSTGRES_CONTAINER) \
	psql -h $(POSTGRES_HOST) -p 5432 -U $(POSTGRES_USER)

help:
	@head -18 Makefile

postgres-console:
	PGPASSWORD=$(POSTGRES_PASSWORD) \
	docker exec -it $(POSTGRES_CONTAINER) \
	psql -h $(POSTGRES_HOST) -p 5432 -U $(POSTGRES_USER) -d $(POSTGRES_DBNAME)

postgres-create-db:
	$(PSQL) -c "CREATE DATABASE $(POSTGRES_DBNAME)"

postgres-init-schema:
	cat schema.sql | $(PSQL) -d $(POSTGRES_DBNAME)

postgres-copy-data:
	cat data/reference.csv | $(PSQL) -d $(POSTGRES_DBNAME) \
	-c "COPY public.countries_ref FROM STDIN CSV HEADER"

	cat data/us_confirmed.csv | $(PSQL) -d $(POSTGRES_DBNAME) \
	-c "COPY public.us_confirmed FROM STDIN CSV HEADER"

	cat data/countries-aggregated.csv | $(PSQL) -d $(POSTGRES_DBNAME) \
	-c "COPY public.countries_aggregated FROM STDIN CSV HEADER"

postgres-delete-tables:
	cat delete_tables.sql | $(PSQL) -d $(POSTGRES_DBNAME)

