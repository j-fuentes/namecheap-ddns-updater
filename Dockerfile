FROM bitnami/minideb:latest

RUN install_packages dnsutils curl ca-certificates
ADD update.sh /update.sh

ENTRYPOINT ["/update.sh"]
CMD ""
