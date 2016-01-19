package com.isatk.controller.web;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRHtmlExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.util.JRLoader;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.isatk.ge.model.bean.PageBean;
import com.isatk.ge.utils.code.SNPool;
import com.isatk.model.dao.BasClienteleMapper;
import com.isatk.model.dto.BasClientele;
import com.isatk.model.dto.BasClienteleExample;
import com.isatk.service.base.BasClienteleService;

@Controller
@RequestMapping("/clientele")
public class ClienteleCr {
	@Autowired
	BasClienteleService clienteleService;
	@Autowired
	private BasClienteleMapper basClienteleMapper;
	
	@RequestMapping("/index.html")
	public ModelAndView toIndex(HttpServletRequest request,HttpServletResponse response,PageBean<BasClientele, BasClientele> page,BasClientele clientele){
		if(page==null){
			page = new PageBean<BasClientele,BasClientele>();
		}
		if(clientele !=null){
			if("".equals(clientele.getName())){
				clientele.setName(null);
			}
			if("".equals(clientele.getPhone())){
				clientele.setPhone(null);
			}
		}
		ModelAndView mv=new ModelAndView("web/clientele/index");
		page.setParameterEntity(clientele);
		page.setHasEnable(1);
		page = clienteleService.findListData(page);
		mv.addObject("page", page);
		return mv;
	}
	
	@RequestMapping("/addClientele.html")
	public ModelAndView toAddClientele(HttpServletRequest request,HttpServletResponse response,Long id){
		ModelAndView mv=new ModelAndView("web/clientele/add");
		if(id != null){
			BasClientele clientele = clienteleService.findOneRecord(id);
			mv.addObject("basClient", clientele);
		}
		return mv;
	}
	
	@RequestMapping("/saveClientele.mo")
	public ModelAndView saveClientele(BasClientele clientele){
		if(clientele.getId()!=null){
			clienteleService.updateOneRecord(clientele);
		}else{
			clientele.setId(SNPool.createInstance().getNextID());
			clienteleService.addOneRecord(clientele);
		}
		List<BasClientele> clienteleList = basClienteleMapper.selectByExample(new BasClienteleExample());
		ModelAndView mv=new ModelAndView("web/clientele/index");
		mv.addObject("clienteleList", clienteleList);
		mv.addObject("res","操作成功");		
		return mv;
	}
	
	@RequestMapping("/delClientele.mo")
	public ModelAndView deleteClientele(Long id){
		basClienteleMapper.deleteByPrimaryKey(id);
		List<BasClientele> clienteleList = basClienteleMapper.selectByExample(new BasClienteleExample());
		ModelAndView mv=new ModelAndView("web/clientele/index");
		mv.addObject("clienteleList", clienteleList);
		mv.addObject("res","操作成功");
		return mv;
	}
	
	
	@RequestMapping("/findClientele.ajax")
	@ResponseBody
	public List<BasClientele> findClientele(String key,Integer maxLength){
		List<BasClientele> list = clienteleService.findRecordByKey(key);
		return list;
	}
	
	@RequestMapping("/expClientReport.html")
	public String expClientReport(HttpServletRequest request,HttpServletResponse response,String type) throws Exception{
		ServletContext ctx = request.getServletContext();
//		File reportFile = new File(ctx.getRealPath("/reports/report_kehu.jrxml"));
//		InputStream in = ctx.getResourceAsStream("boot/dbconnection.properties");
		Map params = new HashMap();
		params.put("CLIENT_ID", 2323415404250112l);
//		Properties pro = new Properties();
//		pro.load(in);

//		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile);		
		Class.forName("org.gjt.mm.mysql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://120.25.121.97:3306/wuliu","root","cK2sGylf6aDG");
        if("html".equals(type)){
        	exportHtml(request, response, conn, params);        	
        }
		if("pdf".equals(type)){
			exportPdf(request, response, conn, params);
        }
		if("word".equals(type)){
			exportExcel(request, response, conn, params);
		}
//        JRDataSource dataSource = new JRBeanCollectionDataSource(beanCollection);  
//        //编译jrxml文件  
//        jasperReport = JasperCompileManager.compileReport("/reports/report_kehu.jrxml");  
//        //填充数据  
//        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, params, new JRBeanCollectionDataSource(beanCollection));  
//        //导出为html文件  
//        JasperExportManager.exportReportToHtmlFile(jasperPrint, "test3_beanCollectionDataSource.html");  
//        System.out.println(".........................");  
        return null;
	}

//	public void export2word() {
//		/* 1 */	 String sourceFileName=ResponseUtil.getRequest( ).getSession().getServletContext().getRealPath("/jaspers/ListIReport.jasper");
//		/* 2 */	 JasperPrint jasperPrint=JasperFillManager.fillReport(sourceFileName,    new HashMap(), getDs());	                                 System.out.println("22222222222222")	
//		/* 3 */	 JRPdfExporter pdfExporter=new JRPdfExporter();
//		/* 4 */	 ResponseUtil.getResponse( ).addHeader("Content-Disposition", "attachment;Filename="+  java.net.URLEncoder.encode(outfileName, "UTF-8")+".pdf");
//		/* 5 */	 pdfExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ResponseUtil.getResponse( ).getOutputStream());
//		/* 6 */	 pdfExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
//		/* 7 */	 JasperExportManager.exportReportToPdf(jasperPrint);
//		/* 8 */	 pdfExporter.exportReport();
//		/* 9 */	 ResponseUtil.getResponse( ).setContentType("application/pdf");
//		} catch (JRException e) {
//		e.printStackTrace();
//		}catch (Exception e) {
//		e.printStackTrace();
//		}
//		}
	/**
     * 导出为html文件
     * @param request
     * @param response
     */
    private void exportHtml(HttpServletRequest request, HttpServletResponse response,Connection conn,Map params){
         
        try {
            response.setCharacterEncoding("UTF-8");  
            ServletContext servletContext=request.getServletContext();
            //得到jasper文件
            File jasperFile=new File(servletContext.getRealPath("/reports/report_kehu.jasper"));
            JasperReport jasperReport =(JasperReport)JRLoader.loadObject(jasperFile);
           
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, params, conn);
            JRHtmlExporter exporter = new JRHtmlExporter();
             
            exporter.setParameter(JRHtmlExporterParameter.JASPER_PRINT, jasperPrint);
            exporter.setParameter(JRHtmlExporterParameter.OUTPUT_WRITER,response.getWriter());
            exporter.setParameter(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN,Boolean.FALSE);
            exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "utf-8");
            exporter.exportReport();
        } catch (JRException e) {
            e.printStackTrace();
        } catch (IOException e){
            e.printStackTrace();
        }
    }
    
    /**
     * 导出为excel文件
     * @param request
     * @param response
     */
    private void exportExcel(HttpServletRequest request, HttpServletResponse response,Connection conn,Map params){
        try {
            response.setCharacterEncoding("UTF-8");  
            ServletContext servletContext=request.getServletContext();
            //得到jasper文件
            File jasperFile=new File(servletContext.getRealPath("/reports/report_kehu.jasper"));
            JasperReport jasperReport =(JasperReport)JRLoader.loadObject(jasperFile);
           
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, params, conn);
            JRXlsExporter exporter=new JRXlsExporter();
            exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
            exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, response.getOutputStream());
            exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
            exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
 
            response.setHeader("Content-Disposition", "attachment;filename=first.xls");
            response.setContentType("application/vnd_ms-excel");
            exporter.exportReport();
        } catch (JRException e) {
            e.printStackTrace();
        } catch (IOException e){
            e.printStackTrace();
        } 
    }
    
    /**
     * 导出为pdf文件
     * @param response
     * @param conn
     */
    private void exportPdf(HttpServletRequest request, HttpServletResponse response, Connection conn,Map params) {
        try {
            ServletContext servletContext=request.getServletContext();
            //得到jasper文件
            File jasperFile=new File(servletContext.getRealPath("/reports/report_kehu.jasper"));
            JasperReport jasperReport =(JasperReport)JRLoader.loadObject(jasperFile);
           
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, params, conn);
            JRPdfExporter exporter = new JRPdfExporter();  
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
             
            response.setHeader("Content-Disposition", "attachment;filename=first.pdf");
            response.setContentType("application/pdf");
            response.setCharacterEncoding("UTF-8");  
            exporter.exportReport();
             
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
