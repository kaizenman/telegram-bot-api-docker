# Використовуємо базовий образ Alpine Linux
FROM alpine:latest

# Встановлюємо необхідні пакети та залежності
RUN apk update && apk upgrade && apk add --no-cache \
  alpine-sdk \
  linux-headers \
  git \
  zlib-dev \
  openssl-dev \
  gperf \
  cmake

# Клонуємо репозиторій telegram-bot-api
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git /app/telegram-bot-api

# Переходимо до директорії проекту, створюємо build-директорію, збираємо та встановлюємо
WORKDIR /app/telegram-bot-api
RUN rm -rf build && mkdir build && cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
  cmake --build . --target install

# Очищаємо зайві файли після збірки
RUN rm -rf /app

# Відкриваємо порт для HTTP-запитів
EXPOSE 8082

# Вказуємо команду за замовчуванням
CMD ["sh", "-c", "telegram-bot-api --api-id=${TELEGRAM_API_ID} --api-hash=${TELEGRAM_API_HASH} --local --http-port=8082 --http-ip-address=0.0.0.0"]
