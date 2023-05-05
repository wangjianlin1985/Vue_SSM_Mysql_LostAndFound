package com.client.controller;

import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.ui.Model;

import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;

import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import org.springframework.web.bind.annotation.ModelAttribute;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.chengxusheji.po.Praise;
import com.chengxusheji.po.LostFound;
import com.chengxusheji.service.PraiseService;
import com.client.service.AuthService;
import com.client.utils.JsonResult;
import com.client.utils.JsonResultBuilder;
import com.client.utils.ReturnCode;

@RestController
@RequestMapping("/api/praise") 
public class ApiPraiseController {
	@Resource PraiseService praiseService;
	@Resource AuthService authService;

	@InitBinder("lostFoundObj")
	public void initBinderlostFoundObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("lostFoundObj.");
	}
	@InitBinder("praise")
	public void initBinderPraise(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("praise.");
	}

	/*客户端ajax方式添加表扬信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public JsonResult add(@Validated Praise praise, BindingResult br, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		//通过accessToken获取到用户信息 
		String userName = authService.getUserName(request);
		if(userName == null) return JsonResultBuilder.error(ReturnCode.TOKEN_VALID_ERROR);
		if (br.hasErrors()) //验证输入参数
			return JsonResultBuilder.error(ReturnCode.INPUT_PARAM_ERROR);
        praiseService.addPraise(praise); //添加到数据库
        return JsonResultBuilder.ok();
	}

	/*客户端ajax更新表扬信息*/
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public JsonResult update(@Validated Praise praise, BindingResult br, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		//通过accessToken获取到用户信息 
		String userName = authService.getUserName(request);
		if(userName == null) return JsonResultBuilder.error(ReturnCode.TOKEN_VALID_ERROR);
		if (br.hasErrors())  //验证输入参数
			return JsonResultBuilder.error(ReturnCode.INPUT_PARAM_ERROR); 
        praiseService.updatePraise(praise);  //更新记录到数据库
        return JsonResultBuilder.ok(praiseService.getPraise(praise.getPraiseId()));
	}

	/*ajax方式显示获取表扬详细信息*/
	@RequestMapping(value="/get/{praiseId}",method=RequestMethod.POST)
	public JsonResult getPraise(@PathVariable int praiseId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键praiseId获取Praise对象*/
        Praise praise = praiseService.getPraise(praiseId); 
        return JsonResultBuilder.ok(praise);
	}

	/*ajax方式删除表扬记录*/
	@RequestMapping(value="/delete/{praiseId}",method=RequestMethod.POST)
	public JsonResult deletePraise(@PathVariable int praiseId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
		//通过accessToken获取到用户信息 
		String userName = authService.getUserName(request);
		if(userName == null) return JsonResultBuilder.error(ReturnCode.TOKEN_VALID_ERROR);
		try {
			praiseService.deletePraise(praiseId);
			return JsonResultBuilder.ok();
		} catch (Exception ex) {
			return JsonResultBuilder.error(ReturnCode.FOREIGN_KEY_CONSTRAINT_ERROR);
		}
	}

	//客户端查询表扬信息
	@RequestMapping(value="/list",method=RequestMethod.POST)
	public JsonResult list(@ModelAttribute("lostFoundObj") LostFound lostFoundObj,String title,String addTime,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if (title == null) title = "";
		if (addTime == null) addTime = "";
		if(rows != 0)praiseService.setRows(rows);
		List<Praise> praiseList = praiseService.queryPraise(lostFoundObj, title, addTime, page);
	    /*计算总的页数和总的记录数*/
	    praiseService.queryTotalPageAndRecordNumber(lostFoundObj, title, addTime);
	    /*获取到总的页码数目*/
	    int totalPage = praiseService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = praiseService.getRecordNumber();
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap.put("totalPage", totalPage);
	    resultMap.put("list", praiseList);
	    return JsonResultBuilder.ok(resultMap);
	}

	//客户端ajax获取所有表扬
	@RequestMapping(value="/listAll",method=RequestMethod.POST)
	public JsonResult listAll() throws Exception{
		List<Praise> praiseList = praiseService.queryAllPraise(); 
		return JsonResultBuilder.ok(praiseList);
	}
}

