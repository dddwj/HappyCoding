package com.ecust.house.controller;

import com.ecust.house.controller.Msg;
import lombok.Data;

@Data
public class ReturnResult<T> {

    private int code;
    private String msg;
    private T data;

    public ReturnResult(Msg msg) {
        this(msg, null);
    }

    public ReturnResult(Msg msg, T t) {
        this.code = msg.getCode();
        this.msg = msg.getMsg();
        this.data = t;
    }

    public ReturnResult(int code, String message) {
        this.code = code;
        this.msg = message;
    }
}