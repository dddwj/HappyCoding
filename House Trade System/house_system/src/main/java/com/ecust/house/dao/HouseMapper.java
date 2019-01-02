package com.ecust.house.dao;

import com.ecust.house.model.Disk;
import com.ecust.house.model.House;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface HouseMapper {
    House selectHouseById(@Param("id") long id);    // 用xml文件写sql语句

    @Select("select h.houseID as id, h.houseLoc as address, h.price as total, h.acreage as acreage, d.estateName as diskName, u.userName as salerName, h.direction as direction " +
            "from House as h natural join Estate as d " +
            "inner join `User` as u on u.userID = h.salerID " +
            "where d.estateName like '%${diskName}%' and h.isForSale = 1 and h.isDeleted = 0 " +
            "order by estateID desc;")
    List<House> selectHouseByXiaoqu(@Param("diskName") String diskName);

    // 用注解写sql语句
    // 要使用注解写法，数据库的列名必须与实体类的属性名一致（可以在sql语句中设置别名），否则无法自动映射。
    // 要手动映射，必须用xml文件写sql语句。
    @Select("select NewDiskID, NewDiskName, NewDiskType, Coordinates from NewDisk where NewDiskID <= #{id} order by NewDiskID")
    List<Disk> selectDiskById(@Param("id") long id);

    @Insert("insert into House(houseLoc, salerID, isForSale, regDate, type, acreage, price, direction, estateID, isDeleted)" +
            " values(#{houseLoc},#{salerID},1,now(),'住宅',#{acreage},#{total},#{direction},#{estateID},0)")
    Boolean insertHouse(@Param("houseLoc") String address, @Param("salerID") String salerName, @Param("acreage") float acreage, @Param("total") Float total, @Param("direction") String direction, @Param("estateID") Integer estateID);

    @Select("select LAST_INSERT_ID()")
    Integer selectPriKeyForInsert();    // 使用此函数查找刚才插入的自增主键的值。

    @Select("select estateID from Estate where estateName like '${estateName}%' limit 1")
    Integer selectDiskIDByName(@Param("estateName") String estateName);

    @Update("update House set isDeleted = 1, isForSale = 0 where houseID=#{houseID}")
    Boolean deleteHouseByID(@Param("houseID") int houseID);

    @Select("select houseID as id, houseLoc as address, e.estateName as diskName, House.regDate, acreage, price as total, direction, u.userName as salerName, isForSale " +
            "from House join `User` as u on u.userID = House.salerID natural join Estate as e " +
            "where salerID=#{userID} and isDeleted = 0")
    List<House> selectHousesByUserID(@Param("userID") Integer userID);

    @Update("update House set isForSale = #{status} where houseID = #{houseID} and salerID = #{salerID} " )
    Boolean updateHouseSaleStatus(@Param("salerID") Integer userID, @Param("houseID") Integer houseID, @Param("status") Integer status);

    @Update("update House set houseLoc=#{address}, acreage=#{acreage}, direction=#{direction}, price=#{total} where houseID=#{houseID} and salerID = #{salerID} and isDeleted=0")
    Boolean updateHouseByID(@Param("salerID") String salerID, @Param("houseID") Integer houseID, @Param("address") String address,
                            @Param("diskName") String diskName, @Param("acreage") float acreage, @Param("direction") String direction,
                            @Param("total") float total);
}
