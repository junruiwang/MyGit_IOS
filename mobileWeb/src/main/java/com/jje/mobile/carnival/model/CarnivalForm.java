package com.jje.mobile.carnival.model;

import com.jje.mobile.util.BaseForm;

public class CarnivalForm extends BaseForm{

    private String carnivalId;

    private String carnivalName;

    public String getCarnivalId() {
        return carnivalId;
    }

    public void setCarnivalId(String carnivalId) {
        this.carnivalId = carnivalId;
    }

    public String getCarnivalName() {
        return carnivalName;
    }

    public void setCarnivalName(String carnivalName) {
        this.carnivalName = carnivalName;
    }
}
