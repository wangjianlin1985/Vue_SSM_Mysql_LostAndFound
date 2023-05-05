package com.chengxusheji.po;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.JSONException;
import org.json.JSONObject;
import com.client.utils.JsonUtils;
import com.client.utils.SessionConsts;
import com.fasterxml.jackson.annotation.JsonIgnore;

public class Area {
    /*学院id*/
    private Integer areaId;
    public Integer getAreaId(){
        return areaId;
    }
    public void setAreaId(Integer areaId){
        this.areaId = areaId;
    }

    /*学院名称*/
    @NotEmpty(message="学院名称不能为空")
    private String areaName;
    public String getAreaName() {
        return areaName;
    }
    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    @JsonIgnore
    public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonArea=new JSONObject(); 
		jsonArea.accumulate("areaId", this.getAreaId());
		jsonArea.accumulate("areaName", this.getAreaName());
		return jsonArea;
    }

    @Override
	public String toString() {
		return JsonUtils.toJson(this);
	}
}