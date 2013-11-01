package com.jje.mobile.carnival.remote;


import com.jje.mobile.carnival.model.CarnivalForm;
import com.jje.mobile.carnival.model.HotelCity;
import com.jje.mobile.util.BaseForm;
import com.jje.mobile.util.HttpRequester;
import com.jje.mobile.util.HttpResponser;
import com.jje.mobile.util.MapGenerateHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class CarnivalControllerProxy {

    @Autowired
    private HttpRequester request;

    @Value("${gateway.url}")
    private String gatewayUrl;

    private static Logger logger = LoggerFactory.getLogger(CarnivalControllerProxy.class);

    public List<HotelCity> getHotelCityListByAll(CarnivalForm carnivalForm) {
        try {
            HttpResponser responser = request.sendPost(gatewayUrl + "/city/list",MapGenerateHelper.prepareObjectToMap(carnivalForm));
            System.out.println(responser.getContent());
        } catch (Exception ex) {
            logger.error("查询酒店城市列表异常", ex);
        }
        return null;
    }

}
