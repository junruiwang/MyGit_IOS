package com.jje.mobile.util;


import java.io.Serializable;

public class BaseForm implements Serializable {

    private String clientAgent = "HTML5";

    private String userId = "0";

    private String sign;

    public String getClientAgent() {
        return clientAgent;
    }

    public void setClientAgent(String clientAgent) {
        this.clientAgent = clientAgent;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    @Override
    public String toString() {
        return "BaseForm{" +
                "clientAgent='" + clientAgent + '\'' +
                "userId='" + userId + '\'' +
                ", sign='" + sign + '\'' +
                '}';
    }
}
