package com.kh.suje.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        // 브라우저에서 /upload/파일명 으로 요청하면
        // 실제 컴퓨터의 c:/upload/ 폴더에서 이미지를 찾게 연결
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///c:/upload/");
                // .addResourceLocations("file:///c:/upload/");
                // .addResourceLocations("file:///Users/kkt/Desktop/KKT/Spring_boot/upload");
    }
}
