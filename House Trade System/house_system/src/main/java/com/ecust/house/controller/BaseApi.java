package com.ecust.house.controller;

public class BaseApi {

    <T> ReturnResult<T> createSuccessReturn() {
        return new ReturnResult(Msg.SUCCESS, null);
    }

    <T> ReturnResult<T> createSuccessReturn(T t) {
        return new ReturnResult(Msg.SUCCESS, t);
    }

    ReturnResult createErrorReturn(Msg msg) {
        return new ReturnResult(msg);
    }
}