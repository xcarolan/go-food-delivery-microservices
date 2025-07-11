data "external_schema" "gorm" {
  program = [
    "atlas-provider-gorm",
    "load",
    "--path", "./internal/products/models",
    "--dialect", "postgres",
  ]
}
env "gorm" {
  src = data.external_schema.gorm.url
  dev = "postgres://postgres:postgres@localhost:5432/catalogs_write_service?sslmode=disable"
  migration {
    dir = "file://db/migrations/atlas"
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}
env "go-migrate" {
  src = "file://db/migrations/go-migrate/schema.sql"
  dev = "postgres://postgres:postgres@localhost:5432/catalogs_write_service?sslmode=disable"
  migration {
    dir    = "file://db/migrations/go-migrate"
    format = golang-migrate
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}
