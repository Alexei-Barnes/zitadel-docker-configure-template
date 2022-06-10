FROM ghcr.io/zitadel/zitadel:configured-latest-amd64
COPY auth-ca.crt /.zitadel/auth-ca.crt
COPY config.yaml /.zitadel/config.yaml
COPY steps.yaml /.zitadel/steps.yaml
COPY --from=tarampampam/curl:7.78.0 /bin/curl /bin/curl
