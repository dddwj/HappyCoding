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
import com.alibaba.fastjson.JSONObject;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;

import com.ecust.house.service.HouseService;
import sun.awt.image.ImageWatched;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Slf4j
@RestController //使用RestController注解，只能返回字符串string，而不会根据字符串拼接成"/string.jsp"地址。
@CrossOrigin(origins = "http://localhost:63342") //支持跨域POST/GET请求。若不使用这句话，那请求必须是JSONP格式。
//@Controller
// @EnableTransactionManagement 支持sql事务的时候添加
public class HouseController {

    @Autowired
    private HttpServletResponse response;

    @Autowired
    private HttpServletRequest request;

    @Autowired
    private HouseService houseService;
    @Autowired
    private DiskService diskService;

    @RequestMapping("/")
    public String index(){
        return "index page";
    }

    @RequestMapping("/selectById/{id}")         //废弃
    public String getHouseInfoById(@PathVariable("id") long houseId) {
        return houseService.selectById(houseId).toString();
//        return "House1:" + JSON.toJSONString(h);
    }

    @RequestMapping("/selectByXiaoqu/{xiaoqu}")     // 废弃
    public List<House> getHouseInfoByXiaoqu(@PathVariable("xiaoqu") String xiaoqu){
//        return houseService.selectByXiaoqu(xiaoqu).toString();
        List<House> houses = houseService.selectByXiaoqu(xiaoqu);
        return houses;  // 自动返回JSON数据
    }

    @RequestMapping("/selectDisk/{id}")     //废弃
    public String getDiskInfoById(@PathVariable("id") long id){
        String str = "";
        List<Disk> result = diskService.selectDiskById(id);
        for(Disk each: result){
            str += each.toString();
            str += "\n";
        }
        return str;
    }

    @RequestMapping("/insertGuapai")
    @ResponseBody
    public String insertGuapai(@RequestBody JSONObject jsonParam){
        Set<Entry<String, Object>> entrySet = jsonParam.entrySet();
        List<LinkedHashMap<String, String>> Houses = new LinkedList<>();
        for(Entry<String, Object> s : entrySet){
            LinkedHashMap<String, String> row = (LinkedHashMap<String, String>)s.getValue();
            Houses.add(row);
        }
//        Cookie[] cookies = request.getCookies();
//        for(Cookie cookie : cookies){
//            if(cookie.getName().equals("userName")){
//                System.out.println(cookie.getValue());
//            }
//        }

//        HttpSession session = request.getSession(false);
//        String userName = (String)session.getAttribute("userName");
//        System.out.println(session.getId() + "------" + userName);

        LinkedList<Integer> insertedIds = houseService.insertHouses(Houses);
        JSONObject result = new JSONObject();
        result.put("msg", "ok");
        result.put("method", "json");
        result.put("data", insertedIds.toString());
        return result.toJSONString();
    }

    @RequestMapping("/selectDiskID")
    @ResponseBody
    public String selectDiskIDByName(@RequestBody JSONObject jsonParam){
        String DiskName = (String)jsonParam.get("DiskName");
        String DiskID = houseService.selectDiskIDByName(DiskName);

        JSONObject result = new JSONObject();
        result.put("msg","ok");
        result.put("method","json");
        result.put("diskID", DiskID);
        System.out.println(result.toJSONString());
        return result.toJSONString();
    }

    /*
    @RequestMapping("/deleteById")
    @ResponseBody
    public String deleteById(@RequestBody JSONObject jsonParam){
        Set<Entry<String, Object>> entrySet = jsonParam.entrySet();
        LinkedList<Integer> ids = new LinkedList<>();
        for(Entry<String, Object> s : entrySet){
            LinkedHashMap<String, Integer> row = (LinkedHashMap<String, Integer>)s.getValue();
            ids.add(row.get("id"));
        }
//        houseService.deleteById(ids);

        JSONObject result = new JSONObject();
        result.put("msg", "ok");
        result.put("method", "json");
        result.put("data",jsonParam);
        return result.toJSONString();
    }
*/

    @RequestMapping("/selectUserHouses")
    @ResponseBody
    public List<House> selectUserHouses(@RequestBody JSONObject jsonParm){
        Integer userID = Integer.valueOf((String)jsonParm.get("userID"));
        List<House> houses = houseService.selectHousesByUserID(userID);
        return houses;
//        if(houses == null){    // 目前放到前端判断：是否有挂牌的房子和数量。
//            return result.toJSONString();
//        }
//        else {
//            JSONObject houses_json = new JSONObject();
//            for (House h : houses) {
//                result.put("");
//            }
//            return result.toJSONString();
//        }
    }

    @RequestMapping("/controlHouse/{method}")
    @ResponseBody
    public String controlHouse(@RequestBody JSONObject jsonParm, @PathVariable("method") String method){
        Integer userID = Integer.valueOf(jsonParm.get("userID")+"");
        Integer houseID = Integer.valueOf(jsonParm.get("houseID")+"");
        Boolean res;
        if (method.equals("takedown"))
            res = houseService.takedownHouse(userID,houseID);
        else if (method.equals("puton"))
            res = houseService.putonHouse(userID,houseID);
        else if (method.equals("delete"))
            res = houseService.deleteHouse(houseID);
        else if (method.equals("update")) {
            House h = new House();
            h.setSalerName(userID+"");
            h.setId(houseID);
            h.setAddress((String)jsonParm.get("address"));
            h.setDiskName((String)jsonParm.get("diskName"));
            h.setAcreage(Float.valueOf((String)jsonParm.get("acreage")));
            h.setTotal(Float.valueOf((String)jsonParm.get("total")));
            h.setDirection((String)jsonParm.get("direction"));
            res = houseService.updateHouse(h);
        }
        else
            res = false;

        JSONObject result = new JSONObject();
        result.put("msg", "ok");
        result.put("method", "json");
        result.put("data",res);
        return result.toJSONString();
    }




}
