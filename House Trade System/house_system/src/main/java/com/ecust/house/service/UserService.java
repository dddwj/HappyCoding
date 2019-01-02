package com.ecust.house.service;

import com.alibaba.fastjson.JSONObject;
import com.ecust.house.dao.UserMapper;
import com.ecust.house.model.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Slf4j
@Service
public class UserService {
//    @Autowired
//    private HttpServletRequest request;
//
//    @Autowired
//    private HttpServletResponse response;


    @Autowired
    private UserMapper userMapper;

    public JSONObject validate(String userID, String password){
        User user = userMapper.selectPasswordByUserName(userID);
        JSONObject response = new JSONObject();
        response.put("method","json");
        if(user == null){
            response.put("status","wrong");
            response.put("data","User not exists!");
        }else if(!user.getPassword().equals(password)){
            response.put("status","wrong");
            response.put("data", "Wrong Password!");
        }
        else{
            response.put("status", "ok");
            response.put("data",user.getUserName() + "；    在售房源：" + user.getOnSale() + "套；   注册日期：" + user.getRegDate());
            response.put("userName", user.getUserName());
//            System.out.println(user.toString());
        }
        return response;

    }


}
