package com.kh.suje.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {

    private final AdminAuthInterceptor adminAuthInterceptor;

    //관리자 페이지 권한 없으면 들어가지 못하게 막기
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(adminAuthInterceptor)
                .addPathPatterns("/admin/**");
    }

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
