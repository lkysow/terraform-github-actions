FROM hashicorp/terraform:0.11.8

# todo: add labels

RUN apk --no-cache add jq

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]