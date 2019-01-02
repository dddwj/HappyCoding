package com.ecust.house.dao;

import com.ecust.house.model.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ProductMapper {
    Product select(@Param("id") long id);
    void update(Product product);
}
