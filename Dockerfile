FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
RUN microdnf install -y httpd && microdnf clean all
COPY index.html /var/www/html/
EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
