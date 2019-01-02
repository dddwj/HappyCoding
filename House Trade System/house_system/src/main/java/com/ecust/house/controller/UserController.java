package com.ecust.house.controller;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecust.house.model.User;
import com.ecust.house.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


@RestController
@RequestMapping("/user")
//@CrossOrigin(origins = "http://localhost:8080") //支持跨域POST/GET请求。若不使用这句话，那请求必须是JSONP格式。 // 或者添加拦截器处理。
public class UserController {

    private Map<String, User> sessionTable = new HashMap<>();

    @Autowired
    private HttpServletRequest request;

    @Autowired
    private HttpServletResponse response;

    private static Cookie cookie;

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login"/* ,produces="application/json;charset=UTF-8"*/)
    public String login(/* HttpServletRequest request, HttpServletResponse response, */@RequestBody JSONObject jsonParam) {
        String userID = jsonParam.getString("userID");
        String password = jsonParam.getString("password");

        JSONObject response_data = userService.validate(userID, password);
        HttpSession session = request.getSession();

        if(response_data.get("status") == "ok"){

            String sessionId = session.getId();
            System.out.println(sessionId);
            session.setAttribute("userName", response_data.get("userName"));

            cookie = new Cookie("JSESSIONID",sessionId);
            response.addCookie(cookie);

            cookie = new Cookie("userID", userID);
            cookie.setPath("/");
            response.addCookie(cookie);
//            System.out.println(session.getId());
//            System.out.println(cookie.getValue());
//            System.out.println(cookie.getPath());
//            System.out.println(cookie.getDomain());
//            System.out.println(cookie.getName());

        }
        return response_data.toJSONString();
    }
}
