package com.ecust.house.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class Product implements Serializable {
    private static final long serialVersionUID = 1435515995276255188L;
    private long id;
    private String name;
    private long price;

}
