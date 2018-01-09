package com.devit.configuration;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class DevitConfigurationServerApplication {

	public static void main(String[] args) throws Exception {
		SpringApplication.run(DevitConfigurationServerApplication.class, args);
	}

}
