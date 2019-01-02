package com.ecust.house.model;

import lombok.Data;

@Data
public class Disk {
    private long NewDiskID;
    private String NewDiskName;
    private String Coordinates;
    private String NewDiskType;

    @Override
    public String toString(){
        return getNewDiskID()+","+getNewDiskName()+","+getNewDiskType()+","+getCoordinates()+";\n";
    }
}
