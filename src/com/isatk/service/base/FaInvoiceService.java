package com.isatk.service.base;

import java.util.List;
import java.util.Map;

import com.isatk.core.exception.SysException;
import com.isatk.model.dto.FaInvoice;
import com.isatk.model.dto.SysUser;

public interface FaInvoiceService extends BasicStandard<FaInvoice,FaInvoice> {

	int updateByIds(String ids);

	List<Map> findExcelDateByIds(String ids);

	FaInvoice findCountFaInvoice(FaInvoice fa);

	void deleteOneRecord(Long dbid, SysUser su) throws SysException;

	void addOneForDel(Long dbid) throws SysException;
	
	List<FaInvoice> countNum(FaInvoice fa);
}
