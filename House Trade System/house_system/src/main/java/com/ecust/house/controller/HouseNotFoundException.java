package com.ecust.house.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class HouseNotFoundException extends RuntimeException {
    public HouseNotFoundException(long houseId) {
        super("Couldn't find house '" + houseId + "'.");
    }
}
