FROM public.ecr.aws/aws-observability/aws-otel-collector:v0.43.2

LABEL org.opencontainers.image.source = https://github.com/base2Services/build-containers;

COPY --chmod=777 ecs_sd_targets.yaml /etc/ecs_sd_targets.yaml
COPY --chmod=777 cat /bin/cat