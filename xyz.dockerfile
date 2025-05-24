# Building the React frontend
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build



# Build the Java backend
FROM eclipse-temurin:17-jdk AS backend-builder

WORKDIR /app/backend

COPY backend/ ./
RUN ./mvnw clean package -DskipTests



# Building the final image
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY --from=backend-builder /app/backend/target/*.jar app.jar

COPY --from=frontend-builder /app/frontend/build ./public

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]