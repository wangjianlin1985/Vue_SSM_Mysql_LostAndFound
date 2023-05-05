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
import com.chengxusheji.po.Claim;
import com.chengxusheji.po.LostFound;
import com.chengxusheji.service.ClaimService;
import com.client.service.AuthService;
import com.client.utils.JsonResult;
import com.client.utils.JsonResultBuilder;
import com.client.utils.ReturnCode;

@RestController
@RequestMapping("/api/claim") 
public class ApiClaimController {
	@Resource ClaimService claimService;
	@Resource AuthService authService;

	@InitBinder("lostFoundObj")
	public void initBinderlostFoundObj(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("lostFoundObj.");
	}
	@InitBinder("claim")
	public void initBinderClaim(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("claim.");
	}

	/*客户端ajax方式添加认领信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public JsonResult add(@Validated Claim claim, BindingResult br, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		//通过accessToken获取到用户信息 
		String userName = authService.getUserName(request);
		if(userName == null) return JsonResultBuilder.error(ReturnCode.TOKEN_VALID_ERROR);
		if (br.hasErrors()) //验证输入参数
			return JsonResultBuilder.error(ReturnCode.INPUT_PARAM_ERROR);
        claimService.addClaim(claim); //添加到数据库
        return JsonResultBuilder.ok();
	}

	/*客户端ajax更新认领信息*/
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public JsonResult update(@Validated Claim claim, BindingResult br, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		//通过accessToken获取到用户信息 
		String userName = authService.getUserName(request);
		if(userName == null) return JsonResultBuilder.error(ReturnCode.TOKEN_VALID_ERROR);
		if (br.hasErrors())  //验证输入参数
			return JsonResultBuilder.error(ReturnCode.INPUT_PARAM_ERROR); 
        claimService.updateClaim(claim);  //更新记录到数据库
        return JsonResultBuilder.ok(claimService.getClaim(claim.getClaimId()));
	}

	/*ajax方式显示获取认领详细信息*/
	@RequestMapping(value="/get/{claimId}",method=RequestMethod.POST)
	public JsonResult getClaim(@PathVariable int claimId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键claimId获取Claim对象*/
        Claim claim = claimService.getClaim(claimId); 
        return JsonResultBuilder.ok(claim);
	}

	/*ajax方式删除认领记录*/
	@RequestMapping(value="/delete/{claimId}",method=RequestMethod.POST)
	public JsonResult deleteClaim(@PathVariable int claimId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
		//通过accessToken获取到用户信息 
		String userName = authService.getUserName(request);
		if(userName == null) return JsonResultBuilder.error(ReturnCode.TOKEN_VALID_ERROR);
		try {
			claimService.deleteClaim(claimId);
			return JsonResultBuilder.ok();
		} catch (Exception ex) {
			return JsonResultBuilder.error(ReturnCode.FOREIGN_KEY_CONSTRAINT_ERROR);
		}
	}

	//客户端查询认领信息
	@RequestMapping(value="/list",method=RequestMethod.POST)
	public JsonResult list(@ModelAttribute("lostFoundObj") LostFound lostFoundObj,String personName,String claimTime,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if (personName == null) personName = "";
		if (claimTime == null) claimTime = "";
		if(rows != 0)claimService.setRows(rows);
		List<Claim> claimList = claimService.queryClaim(lostFoundObj, personName, claimTime, page);
	    /*计算总的页数和总的记录数*/
	    claimService.queryTotalPageAndRecordNumber(lostFoundObj, personName, claimTime);
	    /*获取到总的页码数目*/
	    int totalPage = claimService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = claimService.getRecordNumber();
	    HashMap<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap.put("totalPage", totalPage);
	    resultMap.put("list", claimList);
	    return JsonResultBuilder.ok(resultMap);
	}

	//客户端ajax获取所有认领
	@RequestMapping(value="/listAll",method=RequestMethod.POST)
	public JsonResult listAll() throws Exception{
		List<Claim> claimList = claimService.queryAllClaim(); 
		return JsonResultBuilder.ok(claimList);
	}
}

