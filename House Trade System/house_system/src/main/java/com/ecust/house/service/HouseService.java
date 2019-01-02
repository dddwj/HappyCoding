package com.ecust.house.service;

import com.ecust.house.dao.HouseMapper;
import com.ecust.house.model.Disk;
import com.ecust.house.model.House;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class HouseService {
    @Autowired
    private HouseMapper houseMapper;

    public House selectById(long houseId){
        return houseMapper.selectHouseById(houseId);
    }

    public List<House> selectByXiaoqu(String xiaoqu){
        return houseMapper.selectHouseByXiaoqu(xiaoqu);
    }

    public LinkedList<Integer> insertHouses(List<LinkedHashMap<String,String>> houses){
        LinkedList<Integer> ids = new LinkedList<>();
        for(LinkedHashMap<String, String> row : houses){
            House h = new House();
            h.setSalerName(row.get("userID"));
            h.setAddress(row.get("address"));
            h.setDiskName(row.get("diskName"));
            h.setTotal(Float.valueOf(row.get("total")));
            h.setDirection(row.get("direction"));
            h.setAcreage(Float.valueOf(row.get("acreage")));
            System.out.println(row);
//            int DiskID = 1000000;
            Integer DiskID = Integer.valueOf(row.get("diskID"));
            houseMapper.insertHouse(h.getAddress(),h.getSalerName(),h.getAcreage(),h.getTotal(),h.getDirection(),DiskID);
            Integer id = houseMapper.selectPriKeyForInsert();
            ids.add(id);
            h.setId(id);
        }
        return ids;
    }

    public String selectDiskIDByName(String DiskName){
        Integer res = houseMapper.selectDiskIDByName(DiskName);
        if (res == null)
            return "Not Found!";
        else
            return "" + res;
    }

    public List<House> selectHousesByUserID(Integer userID){
        List<House> houses = houseMapper.selectHousesByUserID(userID);
        for(House h : houses){
            if(h.getIsForSale().equals("0")){
                h.setIsForSale("已下架，不在售");
            }
            else
                h.setIsForSale("在售");
        }
        return houses;
    }

    public boolean takedownHouse(Integer userID, Integer houseID){
        return houseMapper.updateHouseSaleStatus(userID, houseID, 0);
    }

    public boolean putonHouse(Integer userID, Integer houseID){
        return houseMapper.updateHouseSaleStatus(userID, houseID, 1);
    }

    public boolean deleteHouse(Integer houseID){
        return  houseMapper.deleteHouseByID(houseID);
    }

    public boolean updateHouse(House h){
        return houseMapper.updateHouseByID(h.getSalerName(), h.getId(), h.getAddress(),
                h.getDiskName(),h.getAcreage(),h.getDirection(), h.getTotal());
    }
}
