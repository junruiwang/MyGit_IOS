package com.jje.mobile.carnival.model;

public class HotelCity {

    //城市名称
    private String cityName;
    //城市拼音
    private String pinyin;
    //维度
    private float latitude;
    //经度
    private float longitude;

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getPinyin() {
        return pinyin;
    }

    public void setPinyin(String pinyin) {
        this.pinyin = pinyin;
    }

    public float getLatitude() {
        return latitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    public float getLongitude() {
        return longitude;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }

    @Override
    public String toString() {
        return "HotelCity{" +
                "cityName='" + cityName + '\'' +
                ", pinyin='" + pinyin + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                '}';
    }
}
