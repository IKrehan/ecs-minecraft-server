FROM alpine AS Builder
WORKDIR /app

RUN apk --no-cache add curl zip

RUN curl -L https://mediafilez.forgecdn.net/files/4648/557/Prominence_II_FABRIC_Server_Pack_v0.5.zip -o server-data.zip
RUN unzip server-data.zip 
RUN rm -f server-data.zip
COPY . .

FROM eclipse-temurin:17-jdk-jammy AS Runner
WORKDIR /app

COPY --from=Builder app ./
RUN echo "eula=true" >>eula.txt

CMD ["bash", "start.sh"]
EXPOSE 25565
