FROM nginx:latest

# Copy the configuration files
RUN mkdir -p /etc/nginx/sites-available

COPY blue.conf /etc/nginx/sites-available/blue.conf
COPY green.conf /etc/nginx/sites-available/green.conf

# Copy the init script
COPY init.sh /init.sh
RUN chmod +x /init.sh

CMD ["/init.sh"]
