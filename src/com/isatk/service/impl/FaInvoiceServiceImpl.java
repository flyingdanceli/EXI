package com.isatk.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.isatk.core.exception.SysException;
import com.isatk.ge.model.bean.PageBean;
import com.isatk.ge.utils.code.SNPool;
import com.isatk.model.dao.BasClienteleMapper;
import com.isatk.model.dao.CargoDetailsMapper;
import com.isatk.model.dao.FaInvoiceDelMapper;
import com.isatk.model.dao.FaInvoiceMapper;
import com.isatk.model.dto.BasClientele;
import com.isatk.model.dto.CargoDetails;
import com.isatk.model.dto.FaInvoice;
import com.isatk.model.dto.FaInvoiceDel;
import com.isatk.model.dto.FaInvoiceExample;
import com.isatk.model.dto.SysUser;
import com.isatk.service.base.BasClienteleService;
import com.isatk.service.base.FaInvoiceService;
@Component
public class FaInvoiceServiceImpl implements FaInvoiceService {
	@Autowired
	private FaInvoiceMapper faInvoiceMapper;
	@Autowired
	private CargoDetailsMapper cargoDetailsMapper;
	@Autowired
	private BasClienteleMapper basClienteleMapper;
	@Autowired
	private BasClienteleService basClienteleService;
	@Autowired
	private FaInvoiceDelMapper faInvoiceDelMapper;
	@Override
	public FaInvoice findOneRecord(String dbid) throws SysException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public FaInvoice findOneRecord(Long dbid) throws SysException {
		return faInvoiceMapper.selectByPrimaryKey(dbid);
	}

	@Override
	public FaInvoice findOneRecord(FaInvoice dto) throws SysException {
		return findOneRecord(dto.getId());
	}

	@Override
	public PageBean<FaInvoice, FaInvoice> findListData(
			PageBean<FaInvoice, FaInvoice> page) throws SysException {
		page.setPage(page.createPage());
		FaInvoice dto=page.getParameterEntity();
		dto.setPage(page.createPage());
		page.putLastRowNum(faInvoiceMapper.countDetail(dto));
		List<FaInvoice> list=faInvoiceMapper.selectDetail(dto);
		page.setDataList(list);
		return page;
	}

	@Override
	public void deleteOneRecord(FaInvoice dto) throws SysException {
		deleteOneRecord(dto.getId());
	}

	@Override
	public void deleteOneRecord(String dbid) throws SysException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteOneRecord(Long dbid,SysUser su) throws SysException {
		FaInvoice fi = faInvoiceMapper.selectByPrimaryKey(dbid);
		FaInvoiceDel fid= new FaInvoiceDel();
		BeanUtils.copyProperties(fi, fid);
		fid.setDelDate(new Date());
		fid.setDelUserId(su.getId());
		fid.setDelUserName(su.getName());
		faInvoiceDelMapper.insert(fid);
		faInvoiceMapper.deleteByPrimaryKey(dbid);
	}
	@Override
	public void deleteOneRecord(Long dbid) throws SysException {
		faInvoiceMapper.deleteByPrimaryKey(dbid);
	}
	@Override
	public void addOneForDel(Long dbid) throws SysException {
		FaInvoiceDel fid = faInvoiceDelMapper.selectByPrimaryKey(dbid);
		FaInvoice fi = new FaInvoice();
		BeanUtils.copyProperties(fid, fi);
		faInvoiceMapper.insert(fi);
		faInvoiceDelMapper.deleteByPrimaryKey(dbid);
	}

	@Override
	public void addOneRecord(FaInvoice dto) throws SysException {
		Date date = new Date();
		if(dto.getSoPoint()!=8){
			dto.setSoPointSubMoney(0);
			dto.setSoPointSubName("");
		}
		if(dto.getCargoDetailsSet()!=null){
			for(CargoDetails cd:dto.getCargoDetailsSet()){
				cargoDetailsMapper.insertSelective(cd);
			}
		}
		
		BasClientele basClienteleF = dto.getBasClienteleF();
		BasClientele basClienteleS =  dto.getBasClienteleS();
		BasClientele baf = basClienteleService.findOneRecordByPhone(basClienteleF.getPhone());
		if(baf==null){
			basClienteleF.setId(SNPool.createInstance().getNextID());
			basClienteleF.setIsFa(1);
			basClienteleF.setIsSo(0);
			basClienteleF.setRegTime(date);
			basClienteleService.addOneRecord(basClienteleF);
			dto.setFaClientele(basClienteleF.getId());
		}else{
			baf.setIsFa(1);
			baf.setBankCode(basClienteleF.getBankCode());
			baf.setBankName(basClienteleF.getBankName());
			baf.setCardNo(basClienteleF.getCardNo());
			baf.setName(basClienteleF.getName());
			basClienteleService.updateOneRecord(baf);
			dto.setFaClientele(baf.getId());
		}
		BasClientele bas = basClienteleService.findOneRecordByPhone(basClienteleS.getPhone());
		if(bas==null){
			basClienteleS.setId(SNPool.createInstance().getNextID());
			basClienteleS.setIsFa(1);
			basClienteleS.setIsSo(0);
			basClienteleS.setRegTime(date);
			basClienteleService.addOneRecord(basClienteleS);
			dto.setSoClientele(basClienteleS.getId());
		}else{
			bas.setIsFa(1);
			/*bas.setBankCode(basClienteleS.getBankCode());
			bas.setBankName(basClienteleS.getBankName());
			bas.setCardNo(basClienteleS.getCardNo());*/
			bas.setName(basClienteleS.getName());
			basClienteleService.updateOneRecord(bas);
			dto.setSoClientele(bas.getId());
		}
		faInvoiceMapper.insertSelective(dto);
	}

	@Override
	public void updateOneRecord(FaInvoice dto) throws SysException {
		faInvoiceMapper.updateByPrimaryKeySelective(dto);
	}

	@Override
	public Long findMaxID() throws SysException {
		// TODO Auto-generated method stub
		FaInvoiceExample example = new FaInvoiceExample();
		return null;
	}
	@Override
	public int updateByIds(String ids){
		return faInvoiceMapper.updateByIds(ids);
	}
	@Override
	public List<Map> findExcelDateByIds(String ids){
		return faInvoiceMapper.selectExcelDateByIds(ids);
	}
	@Override
	public FaInvoice findCountFaInvoice(FaInvoice fa){
		return faInvoiceMapper.countDetail2(fa);
	}
	@Override
	public List<FaInvoice> countNum(FaInvoice fa){
		return faInvoiceMapper.countNum(fa);
	}
	
}
