Cloud Configuration server provider, based on Spring Cloud, intended to deliver configuration values for each uService.
You are able to provide encryption to your secrets with this server as one of its main features.

#### Building Docker Image
Configuration server docker image is composed by a customised base image which contains the ability of creating a
the JKS encryption key for you to encrypt sensitive configuration.

To build the docker image which is gonna be your actual configuration server you will need to follow the steps below:
1) Go to `docker-base` directory and execute the following command with your values.

```
docker build -t dev-it:configuration-server-<environment-name-you-want-to-build> \
    --build-arg alias=<your-alias> \
    --build-arg keystorename=<your-keystorename> \
    --build-arg storepass=<your-password> \
    --build-arg validity=<amount-of-days> .
```
This will generate a base docker image for your server.

2) After doing that replace on you configuration files for the values you entered before

```
encrypt:
  key-store:
    location: classpath:<your-keystorename>.jks
    password: <your-password>
    alias: <your-alias>
    secret: <your-password>
```

3) After that, you will need to build the actual server using `mvn clean install` command. Default environment to build is `dev`, but you could
override it by calling

```
mvn clean install -Ddocker.environment=<environment-you-want-to-build>
```

This will produce consuming the corresponding `docker-<environment-you-want-to-build>` folder. So if you are going to create a new environment you must create a new
`docker-<new-env>` folder with the `Dockerfile` like this:

```
FROM dev-it:configuration-server-<new-env>:latest
ADD *.jar app.jar
RUN touch /app.jar
RUN jar uf app.jar *.jks
EXPOSE 8888
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

#### Encrypt values
It is enough to do a `curl` command like this one:

```
curl --user "user:password" localhost:8888/encrypt -d 'Hello DevIt!'
```

As spring security as been included into the pom you will need to provide the following properties or env variables (the later more recommended to prevent publish server credentials):

```
security:
    user:
        name: user
        password: password
```
Whenever is desirable to disable security just add this to the `application.yml` file `security.basic.enable: false`. Having
this set, `curl` command it is:

```
curl localhost:8888/encrypt -d 'Hello DevIt!'
```

The value retrieved for that is: `AQAXXhy05MYZn35gFAF160dJ+3R19z13AI//vnuFMmHo19g9djy3jm4zJpkrBKmAQMjp37xFsBIyo9j1YxbC9BwfYOxCPbjN7Wc4kEOEsTSLX2ht/eB1AMKPpjZ5rrDoRjsN3sr2y/xE0C0Jo7xf7ftYneyyHE98sInftGwsWBZq+wH1qp9VW93c+Wlf9FjktDsLSXfDcnoxb6kKWAB7RKoTp5TlzoHc6NJtZlHbsyGmyIf98vOzz9wTUoVQCNvoWo083+Q9kfI2f340nw5eu0kHwCi1gr0S3jBo43IGVf9wIOn+Ni46wTmas4GdfHlSdK810WBwCEOADx5ezv8SCMWhJuqTszmUNwrZvwIYMfASREUit+xoq98pcdpWKGVz2ls=`

Now, having said that, if you want to decrypt it just need to:

```
curl --user "uservice:password" localhost:8888/decrypt -d 'AQAXXhy05MYZn35gFAF160dJ+3R19z13AI//vnuFMmHo19g9djy3jm4zJpkrBKmAQMjp37xFsBIyo9j1YxbC9BwfYOxCPbjN7Wc4kEOEsTSLX2ht/eB1AMKPpjZ5rrDoRjsN3sr2y/xE0C0Jo7xf7ftYneyyHE98sInftGwsWBZq+wH1qp9VW93c+Wlf9FjktDsLSXfDcnoxb6kKWAB7RKoTp5TlzoHc6NJtZlHbsyGmyIf98vOzz9wTUoVQCNvoWo083+Q9kfI2f340nw5eu0kHwCi1gr0S3jBo43IGVf9wIOn+Ni46wTmas4GdfHlSdK810WBwCEOADx5ezv8SCMWhJuqTszmUNwrZvwIYMfASREUit+xoq98pcdpWKGVz2ls='
```