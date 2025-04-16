FROM public.ecr.aws/aws-observability/aws-otel-collector:v0.43.2

LABEL org.opencontainers.image.source = https://github.com/base2Services/build-containers;

COPY --chmod=777 ecs_sd_targets.yaml /etc/ecs_sd_targets.yaml

# Debug tools
COPY --chmod=777 cat /bin/cat
COPY --chmod=777 gurl /bin/gurl 
# See https://github.com/ericbsantana/gurl
