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
