package com.ecust.house.controller;


import com.ecust.house.dao.HouseMapper;
import com.ecust.house.model.Disk;
import com.ecust.house.model.House;
import com.ecust.house.service.DiskService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.ecust.house.service.HouseService;

@Slf4j
//@RestController    // 返回jsp时，不可使用这个标注。
@Controller
@RequestMapping(value = "/view")
public class JSPController {
    @Autowired
    private HouseService houseService;
    @Autowired
    private DiskService diskService;

    @RequestMapping(value = "/")
    public String index(Map<String, Object> model){
        model.put("time", new Date());
        model.put("message","index jsp");
        return "hello";
    }

    @RequestMapping(value = "/hello")
    public String hello(Map<String, Object> model){
        model.put("time", new Date());
        model.put("message","hello jsp");
        return "hello";     // 在application.yml中，配置了此字符串前缀、后缀。最终访问的是/WEB-INF/view/hello.jsp
    }
}
