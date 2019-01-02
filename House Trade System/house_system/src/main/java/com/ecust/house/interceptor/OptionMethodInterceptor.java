package com.ecust.house.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class OptionMethodInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
    // 使用这样一个拦截器是为了解决ajax异步的跨域问题。必须对option请求返回"Access-Control-Allow-Credentials"="true"。
    // 同时，这个拦截器可以设置跨域的域名。在Controller中用注解@Origin同样可以实现。

        httpServletResponse.setHeader("Access-Control-Allow-Origin", "http://localhost:8080");

        httpServletResponse.setHeader("Access-Control-Allow-Headers", "Content-Type,Content-Length, Authorization, Accept,X-Requested-With");

        httpServletResponse.setHeader("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");

        httpServletResponse.setHeader("Access-Control-Allow-Credentials","true");
//        httpServletResponse.setHeader("X-Powered-By","Jetty");


        String method= httpServletRequest.getMethod();
        System.out.println("************************************");
        System.out.println("Request method: " + method);
        System.out.println("Request URL:" + httpServletRequest.getRequestURL());
        if (method.equals("OPTIONS")){
//            System.out.println("OPTIONS METHOD!");
            httpServletResponse.setStatus(233);
            return false;   // 返回false，后续的postHandle，afterCompletion就不执行。
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
