package com.kh.suje;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.kh.suje.dao")
public class SujeApplication {

	public static void main(String[] args) {
		SpringApplication.run(SujeApplication.class, args);
	}

}
