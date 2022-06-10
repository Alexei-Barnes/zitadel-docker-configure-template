FROM ghcr.io/zitadel/zitadel:v2.0.0-v2-alpha.23-amd64
COPY auth-ca.crt /.zitadel/auth-ca.crt
COPY config.yaml /.zitadel/config.yaml
COPY steps.yaml /.zitadel/steps.yaml
COPY --from=tarampampam/curl:7.78.0 /bin/curl /bin/curl
