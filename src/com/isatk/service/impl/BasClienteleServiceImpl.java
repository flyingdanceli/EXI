package com.isatk.service.impl;

import java.util.List;

import org.apache.commons.lang3.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.isatk.core.exception.SysException;
import com.isatk.ge.model.bean.Page;
import com.isatk.ge.model.bean.PageBean;
import com.isatk.model.dao.BasClienteleMapper;
import com.isatk.model.dto.BasClientele;
import com.isatk.model.dto.BasClienteleExample;
import com.isatk.model.dto.FaInvoice;
import com.isatk.service.base.BasClienteleService;
@Component
public class BasClienteleServiceImpl implements BasClienteleService {
	@Autowired
	private BasClienteleMapper basClienteleMapper;
	@Override
	public BasClientele findOneRecord(String dbid) throws SysException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BasClientele findOneRecord(Long dbid) throws SysException {
		return basClienteleMapper.selectByPrimaryKey(dbid);
	}

	@Override
	public BasClientele findOneRecord(BasClientele dto) throws SysException {
		return findOneRecord(dto.getId());
	}

	@Override
	public PageBean<BasClientele, BasClientele> findListData(
			PageBean<BasClientele, BasClientele> page) throws SysException {
		page.setPage(page.createPage());
		BasClientele dto=page.getParameterEntity();
		dto.setPage(page.createPage());
		page.putLastRowNum(basClienteleMapper.countByCondiction(dto));
		List<BasClientele> list=basClienteleMapper.selectListByCondiction(dto);
		page.setDataList(list);
		return page;
	}

	@Override
	public void deleteOneRecord(BasClientele dto) throws SysException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteOneRecord(String dbid) throws SysException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteOneRecord(Long dbid) throws SysException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addOneRecord(BasClientele dto) throws SysException {
		basClienteleMapper.insertSelective(dto);
	}

	@Override
	public void updateOneRecord(BasClientele dto) throws SysException {
		basClienteleMapper.updateByPrimaryKeySelective(dto);
	}

	@Override
	public Long findMaxID() throws SysException {
		// TODO Auto-generated method stub
		BasClienteleExample example = new BasClienteleExample();
		return null;
	}
	@Override
	public List<BasClientele> findRecordByKey(String key){
		BasClienteleExample example = new BasClienteleExample();
		if(NumberUtils.isNumber(key.replaceAll(" ", ""))){
			example.createCriteria().andPhoneLike(key.replaceAll(" ", "%")+"%");
		}else{
			example.createCriteria().andNameLike(key.replaceAll(" ", "%")+"%");
		}
		Page page = new Page();
		page.setBegin(0);
		page.setEnd(20);
		page.setLength(20);
		example.setPage(page);
		return basClienteleMapper.selectByExample(example);
		
	}
	@Override
	public BasClientele findOneRecordByPhone(String phone){
		BasClienteleExample example = new BasClienteleExample();
		example.createCriteria().andPhoneEqualTo(phone);
		List<BasClientele> list = basClienteleMapper.selectByExample(example);
		if(list.size()==0){
			return null;
		}
		return list.get(0);
	}
}
