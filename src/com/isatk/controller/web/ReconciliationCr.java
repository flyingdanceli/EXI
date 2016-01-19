package com.isatk.controller.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.util.JRLoader;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.druid.pool.DruidDataSource;
import com.isatk.controller.base.BaseController;
import com.isatk.ge.model.bean.PageBean;
import com.isatk.ge.utils.code.SNPool;
import com.isatk.model.dto.AjaxMessage;
import com.isatk.model.dto.BasClientele;
import com.isatk.model.dto.CargoDetails;
import com.isatk.model.dto.FaInvoice;
import com.isatk.model.dto.SysPoint;
import com.isatk.model.dto.SysUser;
import com.isatk.service.base.BankNameService;
import com.isatk.service.base.BasClienteleService;
import com.isatk.service.base.FaInvoiceService;
import com.isatk.service.base.SysPointService;
import com.isatk.util.HttpUtils;
import com.isatk.util.TimeFormatTemplate;
@Controller
@RequestMapping("/reconciliation")
public class ReconciliationCr extends BaseController{
	@Autowired
	private FaInvoiceService faInvoiceService;
	@Autowired
	private SysPointService sysPointService;
	@Autowired
	private BankNameService bankNameService;
	@Autowired
	BasClienteleService clienteleService;
	@RequestMapping("/index.html")
	public ModelAndView mine(HttpServletRequest request,HttpServletResponse response,PageBean<FaInvoice, FaInvoice> page,FaInvoice faInvoice ,Integer timeType,Date time){
		if(page==null){
			page = new PageBean<FaInvoice,FaInvoice>();
		}
		if("".equals(faInvoice.getSoPhone()))
			faInvoice.setSoPhone(null);
		if("".equals(faInvoice.getSoName()))
			faInvoice.setSoName(null);
		if("".equals(faInvoice.getFaNo()))
			faInvoice.setFaNo(null);
		//page.setPageSize(50);
		ModelAndView mv=new ModelAndView("web/reconciliation/index");
		List<SysPoint> fa = sysPointService.findList(1, 0);
		List<SysPoint> so = sysPointService.findList(0, 1);
		if(timeType !=null && timeType == 1){
			faInvoice.setFaTime(time);
		}else if(timeType !=null && timeType == 2){
			faInvoice.setSoTime(time);
		}else if(timeType !=null && timeType == 3){
			faInvoice.setCollectionTime(time);
		}
		faInvoice.setOrderString(" ins_time desc ");
		page.setParameterEntity(faInvoice);
		page.setHasEnable(1);
		page = faInvoiceService.findListData(page);
		List<Date> dateList =  new ArrayList();
		for(int i=0 ; i>-120; i--){
			dateList.add(TimeFormatTemplate.getOffsetDateBegin(i));
		}
		
		FaInvoice countFi = faInvoiceService.findCountFaInvoice(faInvoice);
		mv.addObject("countFi", countFi);
		mv.addObject("dateList", dateList);
		mv.addObject("page", page);
		mv.addObject("fa", fa);
		mv.addObject("so", so);
		mv.addObject("timeType", timeType);
		mv.addObject(_USER, request.getSession().getAttribute(_USER));
		return mv;
	}
	
	@RequestMapping("/doEdit.html")
	public ModelAndView doEdit(HttpServletRequest request,HttpServletResponse response,FaInvoice faInvoice ,String[] name ,String[] num,Integer[] insurance,
			String faPhone,String soPhone,
			String faName,String soName,
			String faBankCode,String soBankCode,
			String faCardNo,String soCardNo
			){
		Date date = new Date();
		ModelAndView mv=new ModelAndView("redirect:/invoice/mine.html");

		faInvoice.setUpTime(date);
		Integer collection = faInvoice.getCollection();
		if(collection!=null&&collection!=0){
			if(collection<3000){
				faInvoice.setFee(3);
			}else if(3000<=collection&&collection<6000){
				faInvoice.setFee( 5 );
			}else if(6000<=collection&&collection<10000){
				faInvoice.setFee( 10 );
			}else if(10000<=collection&&collection<13000){
				faInvoice.setFee( 13 );
			}else if(13000<=collection && collection<16000){
				faInvoice.setFee( 16 );
			}else if(16000<=collection && collection<20000){
				faInvoice.setFee( 20 );
			}else if(20000<=collection && collection<23000){
				faInvoice.setFee(23  );
			}else if(23000<collection && collection<26000){
				faInvoice.setFee( 26 );
			}else if(26000<=collection){
				faInvoice.setFee( 30 );
			}
			
		}else{
			faInvoice.setFee(0);
		}
		int j =0;
		int k = 0;
		List<CargoDetails> cds = new ArrayList<CargoDetails>();
		if(name != null){
			for(int i=0;i<name.length;i++){
				if(StringUtils.isNotBlank(name[i])){
					CargoDetails cd = new CargoDetails();
					cd.setId(SNPool.createInstance().getNextID());
					cd.setName(name[i]);
					cd.setInsurance(insurance[i]==null?0:insurance[i]);
					cd.setNum(StringUtils.isBlank(num[i])?"1":num[i]);
					cd.setFaId(faInvoice.getId());
					cds.add(cd);
					j=j+cd.getInsurance();
					k+= Integer.valueOf(cd.getNum());
				}
			}
		}
		faInvoice.setStatus(0);
		faInvoice.setCountInsurance(j);
		faInvoice.setCargoNum(k);
		faInvoice.setCargoDetailsSet(cds);
		faInvoice.setBankCode(faBankCode);
		faInvoice.setCardNo(faCardNo);//卡号
		BasClientele basClienteleF = new BasClientele();
		basClienteleF.setPhone(faPhone);
		basClienteleF.setName(faName);
		basClienteleF.setCardNo(faCardNo);
		basClienteleF.setBankCode(faBankCode);
		BasClientele basClienteleS = new BasClientele();
		basClienteleS.setPhone(soPhone);
		basClienteleS.setName(soName);
		faInvoice.setBasClienteleF(basClienteleF);
		faInvoice.setBasClienteleS(basClienteleS);
		faInvoiceService.addOneRecord(faInvoice);
		return mv;
	}
	
	@RequestMapping("/exportExcel.html")
	public ModelAndView exportExcel(HttpServletRequest request,HttpServletResponse response,Long[] id) throws SQLException{
//		Map<String,Object> params = new HashMap();
		String ids = "";
		for(Long i:id){
			ids+=i+",";
		}
		if(ids.length()>0){
			ids = ids.substring(0, ids.length()-1);
		}
//		params.put("ids", ids);
//		ApplicationContext ct=new ClassPathXmlApplicationContext("applicationContext.xml");
//		DruidDataSource datasource=(DruidDataSource)ct.getBean("dataSource");
//		Connection con=datasource.getConnection();
		//exportExcel(request, response, con, params);
		exportExcel(request, response,ids);
		return null;
	}
	
	public void exportExcel(HttpServletRequest request, HttpServletResponse response,String ids){
		ServletContext servletContext = request.getServletContext();
        File templeFile=new File(servletContext.getRealPath("/excel/ABCTemple.xls"));
        HSSFWorkbook workbook =null;
        try {
			workbook = new HSSFWorkbook(new FileInputStream(templeFile));
			HSSFSheet sheet = workbook.getSheetAt(0);
			List<Map> list = faInvoiceService.findExcelDateByIds(ids);
			for(int i=0;i< list.size();i++){
				HSSFRow row = sheet.createRow(i+1);
				row.createCell(0).setCellValue(String.valueOf(list.get(i).get("faNo")));
				row.createCell(1).setCellValue(String.valueOf(list.get(i).get("bankCode")));
				row.createCell(2).setCellValue(String.valueOf(list.get(i).get("cardNo")));
				row.createCell(3).setCellValue(String.valueOf(list.get(i).get("faNmae")));
				Integer collection = (Integer) (list.get(i).get("collection")==null?0:list.get(i).get("collection"));
				Integer fee = (Integer) (list.get(i).get("fee")==null?0:list.get(i).get("fee"));
				Double d = (double) (collection - fee);
				row.createCell(4,Cell.CELL_TYPE_NUMERIC).setCellValue(d);
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
            response.setHeader("Content-Disposition", "attachment;filename="+TimeFormatTemplate.getNumberDate()+".xls");
            response.setContentType("application/vnd_ms-excel");
            workbook.write(response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
            	response.getOutputStream().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	}
	@RequestMapping("/exportAllExcel.html")
	public ModelAndView exportAllExcel(HttpServletRequest request,HttpServletResponse response,PageBean<FaInvoice, FaInvoice> page,FaInvoice faInvoice ,Integer timeType,Date time){
		ServletContext servletContext = request.getServletContext();
        File templeFile=new File(servletContext.getRealPath("/excel/ABCTemple.xls"));
        HSSFWorkbook workbook =null;
        try {
			workbook = new HSSFWorkbook(new FileInputStream(templeFile));
			HSSFSheet sheet = workbook.getSheetAt(0);
			List<FaInvoice> list = allFaInvoice(page,faInvoice,timeType,time);
			int r=1;
			for(int i=0;i< list.size();i++){
				Integer collection = (Integer) (list.get(i).getCollection()==null?0:list.get(i).getCollection());
				Integer fee = (Integer) (list.get(i).getFee()==null?0:list.get(i).getFee());
				Double d = (double) (collection - fee);
				if(d==0d || list.get(i).getBankCode()==null || list.get(i).getBankCode().equals("")){
					continue;
				}
				HSSFRow row = sheet.createRow(r);
				row.createCell(0).setCellValue(String.valueOf(list.get(i).getFaNo()));
				row.createCell(1).setCellValue(String.valueOf(list.get(i).getBankCode()));
				row.createCell(2).setCellValue(String.valueOf(list.get(i).getCardNo()));
				row.createCell(3).setCellValue(String.valueOf(list.get(i).getFaName()));
				row.createCell(4,Cell.CELL_TYPE_NUMERIC).setCellValue(d);
				r++;
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
            response.setHeader("Content-Disposition", "attachment;filename="+TimeFormatTemplate.getNumberDate()+".xls");
            response.setContentType("application/vnd_ms-excel");
            workbook.write(response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
            	response.getOutputStream().close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
	}
	/**
	 * 根据条件，对所有客户发送到账短信
	 * @param request
	 * @param response
	 * @param page
	 * @param faInvoice
	 * @param timeType
	 * @param time
	 * @return
	 */
	@RequestMapping("/sendAllMsg.html")
	@ResponseBody
	private ModelAndView sendAllMsg(HttpServletRequest request,HttpServletResponse response,PageBean<FaInvoice, FaInvoice> page,FaInvoice faInvoice ,Integer timeType,Date time){
		List<FaInvoice> list = allFaInvoice(page,faInvoice,timeType,time);
		String mobilecontent = "";
		int i =0;
		for(FaInvoice fi:list){
			String fp = fi.getFaPhone();
			if(fp!=null && fp.length()==11 && fi.getCollection() !=null && fi.getCollection()>0 ){
				int money = fi.getCollection()-fi.getFee();
				mobilecontent += fp+"|,|尊敬的“"+fi.getFaName()+"”，您单号"+fi.getFaNo()+"的代收货款("+money+"元)已打款，请等待银行到账【鄂西快运】|;|";
				i++;
			}
		}
		if(mobilecontent.length()>0){
			mobilecontent = mobilecontent.substring(0, mobilecontent.length()-3);
		}
		System.out.println(mobilecontent);
		HttpUtils hp =  new HttpUtils();
		hp.addPaprm("username", "向小宝");//%E5%90%91%E5%B0%8F%E5%AE%9D    向小宝
		hp.addPaprm("userpwd", "888888");
		hp.addPaprm("mobilecontent", mobilecontent);
		String s = hp.send("http://123.56.85.26:6666/smsService/ptpSendService");
		page.setPageNum(1);
		page.setPageSize(20);
		ModelAndView mv = mine(request,response,page,faInvoice,timeType,time);
		mv.addObject("msg", "成功发送短信"+i+"条！");
		return mv;
	}
	/**
	 * 查询所有数据
	 * @param page
	 * @param faInvoice
	 * @param timeType
	 * @param time
	 * @return
	 */
	private List<FaInvoice> allFaInvoice(PageBean<FaInvoice, FaInvoice> page,FaInvoice faInvoice ,Integer timeType,Date time){
		if(page==null){
			page = new PageBean<FaInvoice,FaInvoice>();
		}
		if("".equals(faInvoice.getSoPhone()))
			faInvoice.setSoPhone(null);
		if("".equals(faInvoice.getSoName()))
			faInvoice.setSoName(null);
		if("".equals(faInvoice.getFaNo()))
			faInvoice.setFaNo(null);
		page.setPageSize(99999999);
		page.setPageNum(1);
		if(timeType !=null && timeType == 1){
			faInvoice.setFaTime(time);
		}else if(timeType !=null && timeType == 2){
			faInvoice.setSoTime(time);
		}else if(timeType !=null && timeType == 3){
			faInvoice.setCollectionTime(time);
		}
		faInvoice.setOrderString(" ins_time desc ");
		page.setParameterEntity(faInvoice);
		page.setHasEnable(1);
		page = faInvoiceService.findListData(page);
		return page.getDataList();
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
            File jasperFile=new File(servletContext.getRealPath("/reports/excel_clientele2.jasper"));
            JasperReport jasperReport =(JasperReport)JRLoader.loadObject(jasperFile);
           
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, params, conn);
            JRXlsExporter exporter=new JRXlsExporter();
            exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
            exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, response.getOutputStream());
            exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.FALSE);
            exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
        
            response.setHeader("Content-Disposition", "attachment;filename="+TimeFormatTemplate.getThisTimeTxt()+".xls");
            response.setContentType("application/vnd_ms-excel");
            exporter.exportReport();
        } catch (JRException e) {
            e.printStackTrace();
        } catch (IOException e){
            e.printStackTrace();
        } 
    }
   
	public List<BasClientele> findClientele(String key,Integer maxLength){
		List<BasClientele> list = clienteleService.findRecordByKey(key);
		return list;
	}
	@RequestMapping("/changeStatus.ajax")
	@ResponseBody
	public AjaxMessage changeStatus(HttpServletRequest request,HttpServletResponse response,Long[] id) throws SQLException{
		String ids = "";
		Date date = new Date();
		for(Long i:id){
			FaInvoice fi = new FaInvoice();
			fi.setId(i);
			fi.setStatus(3);
			fi.setUpTime(date);
			fi.setCollectionTime(date);
			faInvoiceService.updateOneRecord(fi);
		}
		/*if(ids.length()>0){
			ids = ids.substring(0, ids.length()-1);
			faInvoiceService.updateByIds(ids);
		}*/
		
		AjaxMessage  am =  new AjaxMessage();
		return am;
	}
	@RequestMapping("/delete.ajax")
	@ResponseBody
	public AjaxMessage delete(HttpServletRequest request,HttpServletResponse response,Long id){
		SysUser su = (SysUser) request.getSession().getAttribute(_USER);
		faInvoiceService.deleteOneRecord(id,su);
		AjaxMessage  am =  new AjaxMessage();
		am.setId(id);
		return am;
	}
}
