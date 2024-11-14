# Используем официальный образ Node.js как базовый
FROM node:16

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем весь код в контейнер
COPY . .

# Указываем порт, который будет использоваться контейнером
EXPOSE 3000

# Запуск приложения
CMD ["npm", "start"]
