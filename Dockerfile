# Укажите базовый образ
FROM node:14

# Установите рабочую директорию
WORKDIR /app

# Скопируйте package.json и package-lock.json
COPY package*.json ./

# Установите зависимости
RUN npm install --verbose

# Скопируйте остальные файлы приложения
COPY . .

# Укажите команду для запуска приложения
CMD ["npm", "start"]
