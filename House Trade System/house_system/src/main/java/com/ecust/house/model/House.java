package com.ecust.house.model;

import lombok.Data;

import java.io.Serializable;
import java.sql.Date;

@Data
public class House implements Serializable {
    private int id = 0;
    private String address;
    private float total;
    private String diskName;
    private String salerName;
    private String direction;
    private float acreage;
    private Date regDate;
    private String isForSale; //销售状态：在售、不在售、已删除、已成交

    @Override
    public String toString(){
        return "房源信息："+getId()+","+getAddress()+","+getTotal()+","+getDiskName();
    }
}
