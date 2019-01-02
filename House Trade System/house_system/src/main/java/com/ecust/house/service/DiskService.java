package com.ecust.house.service;

import com.ecust.house.dao.HouseMapper;
import com.ecust.house.model.Disk;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DiskService {
    @Autowired
    private HouseMapper houseMapper;

    public List<Disk> selectDiskById(long DiskId){
        return houseMapper.selectDiskById(DiskId);
    }
}
