package com.ecust.house.interceptor;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class InterceptorConfigurerAdapter extends WebMvcConfigurerAdapter {
    /**
     * 该方法用于注册拦截器
     * 可注册多个拦截器，多个拦截器组成一个拦截器链
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // addPathPatterns 添加路径
        // excludePathPatterns 排除路径
//        registry.addInterceptor(new OptionMethodInterceptor()).addPathPatterns("/*.*");
//        super.addInterceptors(registry);

        InterceptorRegistration registration = registry.addInterceptor(new OptionMethodInterceptor());
        //配置拦截路径
        registration.addPathPatterns("/**");
        //配置不拦截的路径
        registration.excludePathPatterns("/**.html");

    }
}
