FROM dev-it:configuration-server-dev
ADD *.jar app.jar
RUN touch /app.jar
RUN jar uf app.jar /BOOT-INF/classes/default-key.jks
EXPOSE 8888
ARG debugConfig
ENV DEBUG_CONFIG $debugConfig
ENTRYPOINT ["/start.sh"]