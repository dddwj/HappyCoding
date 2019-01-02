package com.ecust.house.model;

import lombok.Data;

import java.sql.Date;

@Data
public class User {
    private int userID;
    private String userName;
    private String phoneNumber;
    private int onSale;
    private Date regDate;
    private String password;

    @Override
    public String toString() {
        return this.getUserID() + ", " + this.getUserName() + ", OnSale:" + this.getOnSale();
    }
}
