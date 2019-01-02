package com.ecust.house.dao;

import com.ecust.house.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UserMapper {
    @Select("select userID, userName, phoneNumber, onSale, regDate, password from User where userID=#{userID}")
    User selectPasswordByUserName(@Param("userID") String userID);
}
