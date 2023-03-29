# Reports NS8

- [Reports NS8](#reports-ns8)
  - [File Summary](#file-summary)
  - [Build process](#build-process)

## File Summary
- `Containerfile` has the build process for both `api` and `ui`.
- `api-entrypoint.sh` is the main entrypoint for api image, is used to check the liveness of DB and Redis before starting the main process. Then uses `migration.sql.tmpl` to apply latest changes to database.
- `ui-entrypoint.sh` entrypoint for ui, waits for backend to be online, then starts the nginx server.
- `migrations.sql.tmpl` list of migrations to be run at startup by `api-entrypoint`.

## Build process
Build is handled by a single containerfile to allow reuse of common layers between images, `buildah` is used to run the process, the following command are currently used by `../build-images.sh` to build:
 - `api`:

    ```bash
    buildah build --force-rm --layers --jobs "$(nproc)" --target api-production --tag "ghcr.io/nethesis/nethvoice-reports-api:latest"
    ```

 - `ui`:

    ```bash
    buildah build --force-rm --layers --jobs "$(nproc)" --target ui-production --tag "ghcr.io/nethesis/nethvoice-reports-ui:latest"
    ```
