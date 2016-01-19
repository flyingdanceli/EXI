package com.isatk.controller.web;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.isatk.ge.model.bean.PageBean;
import com.isatk.model.dto.FaInvoice;
import com.isatk.service.base.FaInvoiceService;

@Controller
@RequestMapping("/report")
public class ReportCr {
	@Autowired
	private FaInvoiceService faInvoiceService;
	
	@RequestMapping("/index.html")
	public ModelAndView index(HttpServletRequest request,HttpServletResponse response){
		ModelAndView mv=new ModelAndView("web/report/index");
		return mv;
	}
	
	@RequestMapping("/all.ajax")
	@ResponseBody
	public List all(HttpServletRequest request,HttpServletResponse response,FaInvoice faInvoice ){
		List<FaInvoice>  list = faInvoiceService.countNum(faInvoice);
		return list;
	}
}
