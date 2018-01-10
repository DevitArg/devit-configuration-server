Cloud Configuration server provider, based on Spring Cloud, intended to deliver configuration values for each uService.
You are able to provide encryption to your secrets with this server as one of its main features.

#### Building Docker Image
You will note within `pom.xml` file the following properties:

```
<properties>
    ...
    <jks.alias>default</jks.alias>
    <jks.keystorename>keystore</jks.keystorename>
    <jks.storepass>password</jks.storepass>
    <jks.validity>365</jks.validity>
</properties>
```
These are the default values which your jks key for encryption will be created with.
Spring properties are:

```
encrypt:
  key-store:
    location: classpath:keystore.jks
    password: password
    alias: default
    secret: password
```

If you want to override them, you will need to provide a JKS' parameters to build it at maven `install` phase.
E.g:
```
mvn clean install -Djks.alias=newAlias \
    -Djks.keystorename=newKeystoreName \
    -Djks.storepass=newStorepass \
    -Djks.validity=365
```
If you manually override the defaults, you will need to change the spring properties as well:
```
encrypt:
  key-store:
    location: classpath:newKeystoreName.jks
    password: newStorepass
    alias: newAlias
    secret: newStorepass
```
(Properties located within `application.yml` file)*[]: 

If you need to checkout the base project what I drafted before including its logic within the current one, this is the project:
[devit-configuration-server-docker](https://github.com/DevitArg/devit-configuration-server-docker)

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