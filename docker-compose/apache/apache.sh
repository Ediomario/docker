docker run -d -p 8080:80 --name my-php-app --restart=always -v /mnt/apache/html:/var/www/html php:8.4-apache
