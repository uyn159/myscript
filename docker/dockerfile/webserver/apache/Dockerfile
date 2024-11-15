# the official Apache HTTP Server image from the Docker Hub
FROM httpd:2.4

# Copy your website files into the container
COPY ./public-html/ /usr/local/apache2/htdocs/

# Copy the SSL certificates
COPY ./key/fullchain2.pem /usr/local/apache2/conf/fullchain2.pem
COPY ./key/privkey2.pem /usr/local/apache2/conf/privkey2.pem

# Copy custom Apache configuration file
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
EXPOSE 80
EXPOSE 443