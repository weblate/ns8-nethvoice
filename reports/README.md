# Reports NS8

- [Reports NS8](#reports-ns8)
  - [File Summary](#file-summary)
  - [Build process](#build-process)
  - [Runtime Environment](#runtime-environment)

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

## Runtime Environment
NS8 provides to the containers the necessary configurations to run, divided by container here's a rundown:
 - `api`
   - file - `~/.config/state/report/api-config.json`: contains all the configuration needed for reports to run, this configurations gets generated every `configure-module`. For more info please refer to the [main repo](https://github.com/nethesis/nethvoice-report).
   - env - `REPORTS_INTERNATIONAL_PREFIX`: due to being reluctant to change a standard file used by reports to configure, this variable is provided to the container allowing migration of tables at start.
 - `ui`
   - file - `~/.config/state/report/ui-config.json`: configures env variables for ui application, for more info refer to [project repo](https://github.com/nethesis/nethvoice-report/blob/master/ui/public/config/config.production.js).
   - env - `APP_HOST`: due to lack of healthcheck from api, this host is used to TCP check if it's on before starting.
   - env - `APP_PORT`: same thing, but for the port of the service.
