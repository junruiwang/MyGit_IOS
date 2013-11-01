package com.jje.mobile.carnival;

import com.jje.mobile.carnival.model.CarnivalForm;
import com.jje.mobile.carnival.remote.CarnivalControllerProxy;
import com.jje.mobile.util.AesUtil;
import com.jje.mobile.util.BaseForm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = "/carnival")
public class CarnivalController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CarnivalController.class);

    @Value(value = "${static.resource.url}")
    private String staticUrl;

    @Autowired
    private CarnivalControllerProxy carnivalControllerProxy;

    @RequestMapping(value = "/activityPage", method = {RequestMethod.POST, RequestMethod.GET})
    public String activityPage(HttpServletRequest request) {
        try {
            CarnivalForm carnivalForm = new CarnivalForm();
            carnivalForm.setUserId("0");
            carnivalForm.setSign(AesUtil.generateSignByUserId("0"));
            carnivalForm.setCarnivalId("10010");
            carnivalForm.setCarnivalName("hello");
            carnivalControllerProxy.getHotelCityListByAll(carnivalForm);
            request.setAttribute("staticPath",staticUrl);
            return "/carnival/activityPage";
        } catch (Exception ex) {
            LOGGER.error("跳转活动页面发生错误", ex);
            return null;
        }
    }
}
