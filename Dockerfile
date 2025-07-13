FROM php:8.4-cli

RUN apt-get update && apt-get install -y unzip git curl protobuf-compiler supervisor && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install sockets

WORKDIR /app

# Download and extract RR binary safely in /tmp, then move to /usr/local/bin
RUN mkdir -p /tmp/roadrunner
RUN curl -L https://github.com/roadrunner-server/roadrunner/releases/download/v2025.1.2/roadrunner-2025.1.2-linux-amd64.tar.gz \
    | tar -xz -C /tmp/roadrunner --strip-components=1
RUN mv /tmp/roadrunner/rr /usr/local/bin/rr
RUN chmod +x /usr/local/bin/rr
RUN rm -rf /tmp/roadrunner

# Download and extract RR binary safely in /tmp, then move to /usr/local/bin
RUN mkdir -p /tmp/protoc-gen-php-grpc
RUN curl -L https://github.com/spiral-modules/php-grpc/releases/download/v1.6.0/protoc-gen-php-grpc-1.6.0-linux-amd64.tar.gz \
    | tar -xz -C /tmp/protoc-gen-php-grpc --strip-components=1
RUN mv /tmp/protoc-gen-php-grpc/protoc-gen-php-grpc /usr/local/bin/protoc-gen-php-grpc
RUN chmod +x /usr/local/bin/protoc-gen-php-grpc
RUN rm -rf /tmp/protoc-gen-php-grpc

# Either download precompiled grpc and protobuf extensions
RUN mkdir -p /tmp/php-extensions
RUN curl -L https://github.com/rxcod9/laravel-grpc-microservice/releases/download/v1.0.0/php.8.4-cli-grpc.so.tar.gz \
    | tar -xz -C /tmp/php-extensions
RUN curl -L https://github.com/rxcod9/laravel-grpc-microservice/releases/download/v1.0.0/php.8.4-cli-protobuf.so.tar.gz \
    | tar -xz -C /tmp/php-extensions
RUN cp /tmp/php-extensions/*.so $(php -r 'echo ini_get("extension_dir");')
RUN rm -rf /tmp/php-extensions
RUN ini_dir=$(php -i | grep '^Scan this dir for additional .ini files' | awk -F'=> ' '{print $2}' | xargs) && \
    echo "extension=grpc.so" > "$ini_dir/99-grpc.ini" && \
    echo "extension=protobuf.so" > "$ini_dir/99-protobuf.ini"

# OR You can install through pecl which takes really long for grpc
# RUN pecl install grpc protobuf
# RUN docker-php-ext-enable grpc protobuf

# RUN curl -Ls https://github.com/spiral/php-grpc/releases/download/v1.3.3/protoc-gen-php-grpc.phar -o /usr/local/bin/protoc-gen-php-grpc && \
#     chmod +x /usr/local/bin/protoc-gen-php-grpc

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# COPY . .
# RUN composer install

CMD ["rr", "serve", "-c", ".rr.yaml"]
