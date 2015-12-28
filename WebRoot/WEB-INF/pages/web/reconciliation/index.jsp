<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>鄂西快运</title>
<jsp:include page="/WEB-INF/pages/common/head.jsp"></jsp:include>

</head>
<body data-menu="1">
<jsp:include page="/WEB-INF/pages/common/menu.jsp"></jsp:include>
 <div class="container" >
       	<ol class="breadcrumb main" >
		  <li><a href="#"><i class="fa fa-truck"></i> 鄂西快运</a></li>
		  <li  class="active">对账管理</li>
		</ol>
		<form class="form-inline" id="pagerForm" action="" method="post">
     	<div class="well">
				<input type="hidden" name="pageNum" value="1">
				
			  <div class="form-group">
			    <label>单号：</label>
			    <input type="text" class="form-control" name="faNo" placeholder="单号" value="${param.faNo }" size="12">
			  </div>
			  <div class="form-group">
			    <label>收货人：</label>
			    <input type="text" class="form-control" name="soName" placeholder="收货人姓名-模糊匹配" value="${param.soName }" size="17">
			  </div>
			  <div class="form-group">
			    <label>收货电话：</label>
			    <input type="text" class="form-control" name="soPhone"  placeholder="收货人电话" value="${param.soPhone }" size="12">
			  </div>&nbsp;&nbsp;&nbsp;&nbsp;
			  <div class="form-group">
			    <label>发货点</label>
			      <select class="form-control" name="faPoint" data-value="${param.faPoint }">
			      <option value="">全部</option>
			      <c:forEach var="fa" items="${fa }">
			      	<option value="${fa.id }">${fa.name }</option>
			      </c:forEach>
			      </select>
			    </div>&nbsp;&nbsp;&nbsp;&nbsp;
			    <div class="form-group">
			    <label>到货点</label>
			       <select class="form-control" name="soPoint" data-value="${param.soPoint }">
			       <option value="">全部</option>
			      	<c:forEach var="so" items="${so }">
				      	<option value="${so.id }">${so.name }</option>
				      </c:forEach>
			      </select>
			  </div>
			  <br><br>
			  <!-- 状态(0.发货中；1.已经收货；2.代收支付确认；3.代收支付完成) -->
			  <div class="form-group">
			    <label>状态：</label>
			       <select class="form-control" name="status" data-value="${param.status }">
			       		<option value="">全部</option>
			      		<option value="0">发货中</option>
			      		<option value="1">已收货</option>
			      		<option value="2">代收支付已经确认</option>
			      		<option value="3">代收支付已经完成</option>
			      </select>
			  </div>&nbsp;&nbsp;&nbsp;&nbsp;
			  <div class="form-group">
			    <select class="form-control" name="timeType" data-value="${param.timeType }">
			    	<option value="1">发货时间</option>
			    	<option value="2">收货时间</option>
			    	<option value="3">代收时间</option>
			    </select>
			       <select class="form-control" name="time" data-value="${param.time }">
			       <option value="">全部</option>
			       <c:forEach var="d" items="${dateList }">
				      	<option value="<fmt:formatDate value="${d }"  pattern="yyyy-MM-dd"></fmt:formatDate>"><fmt:formatDate value="${d }"  pattern="yyyy-MM-dd"></fmt:formatDate></option>
				   </c:forEach>
			      
			      </select>
			  </div>&nbsp;&nbsp;&nbsp;&nbsp;
			   <div class="form-group">
			    <label>付款方式：</label>
			       <select class="form-control" name="freightWay" data-value="${param.freightWay }">
			       		<option value="">全部</option>
			      		<option value="0">己付</option>
			      		<option value="1">到付</option>
			      </select>
			  </div>&nbsp;&nbsp;&nbsp;&nbsp;
			  
			  <button type="button" class="btn btn-default" id="pagesubmit"><i class="fa fa-search"></i> 搜 索</button>
     	</div>
     	</form>
     	<form action="${appPath }/reconciliation/exportExcel.html" method="post" id="listform">
		<div class="panel panel-default">
		  <!-- Default panel contents -->
		  <div class="panel-heading"><i class="fa fa-th-list"></i> 发货单 
		  	<div class="pull-right">
		  		<div class="btn-toolbar" role="toolbar" aria-label="toolbar">
		  			<div class="btn-group btn-group-xs" role="group" aria-label="group">
		  				<button type="button" id="dcgx_all" class="btn btn-success btn-xs"><i class="fa fa-file"></i> 导出（全部）</button>
		  				<button type="button" id="dcgx" class="btn btn-success btn-xs"><i class="fa fa-file-excel-o"></i> 导出（勾选）</button>
		  			</div>
		  			<div class="btn-group btn-group-xs" role="group" aria-label="group">
		  				<button type="button" id="qrzf"  class="btn btn-danger btn-xs"><i class="fa fa-circle-o"></i> 确认代收已支付（勾选）</button>
		  			</div>
		  			<div class="btn-group btn-group-xs" role="group" aria-label="group">
		  				<button type="button" id="sendsms"  class="btn btn-danger btn-xs"><i class="fa fa-envelope"></i> 发送短信（全部）</button>
		  			</div>
		  		</div>
		  		
		  		
		  		
		  	</div>
		  </div>
		
		  <!-- Table -->
		  <table class="table table-striped table-bordered table-hover" id="datalist">
		  	<thead>
		  	<tr>
		  		<th width="30px"><input type="checkbox" id="allchecked" ></th>
		  		<th>运单号/发货时间</th>
		  		<th>发货点/收货点</th>
		   		<th>发货人/电话</th>
		   		<th>收货人/电话</th>
		   		<th>运费/保险费</th>
		   		<th>代收费/手续费</th>
		   		<th>件数</th>
		   		<th>状态</th>
		   		<th>操作</th>
		   	</tr>
		   	</thead>
		   	<tbody>
		   	<c:forEach items="${page.dataList}" var="v" varStatus="s">
			   	<tr id="tr${v.id }">
			   		<td class="checktd"><input type="checkbox" name="id" value="${v.id }"></td>
			   		<td ><strong class="text-primary">${v.faNo }</strong><br /><span class="text-danger"><fmt:formatDate value="${v.faTime }"></fmt:formatDate></span></td>
			   		<td>
			   			<strong class="text-primary">${v.sysPointF.name }</strong><br>
			   			<strong class="text-danger">${v.sysPointS.name }</strong>
			   		</td>
			   		<td>${v.basClienteleF.name }<br />${v.basClienteleF.phone }</td>
			   		<td>${v.basClienteleS.name }<br />${v.basClienteleS.phone }</td>
			   		<td>
			   			<span class="text-primary">运：${v.freight }</span>&nbsp;${v.freightWay==0?"<span class=\"label label-danger\">己付</span>":"" }<br>
			   			<span class="text-danger">保：${v.countInsurance }</span>
			   		</td>
			   		<td><span class="text-danger">${v.collection }</span><br />${v.fee }</td>
			   		<td>${v.cargoNum }</td>
			   		<td>
			   			<c:if test="${v.status == 0 }"><span class="text-muted"><i class="fa fa-circle-o"></i> 发货中</span></c:if>
			   			<c:if test="${v.status == 1 }"><span class="text-info"><i class="fa fa-adjust"></i> 已收货</span></c:if>
			   			<c:if test="${v.status == 2 }"><span class="text-danger"><i class="fa fa-adjust"></i> 代收确认</span></c:if>
			   			<c:if test="${v.status == 3 }"><span class="text-success"><i class="fa fa-circle"></i> 已完成</span></c:if>
			   			<br>
			   			<time class="text-muted time"><fmt:formatDate value="${v.upTime }"></fmt:formatDate></time>
			   		</td>
			   		<td>
			   			<a href="javascript:void(0);" data-id="${v.id}" class="btn btn-danger btn-sm delete" >
							      <i class="fa fa-trash-o"></i> 删除
							</a>
						<a href="" data-id="${v.id}" class="btn btn-success btn-sm" >
							<i class="fa fa-pencil-square-o"></i> 修改
						</a>
			   		</td>
			   	</tr>
		   	</c:forEach>
		   	</tbody>
		  </table>
		</div>
		</form>
		<div class="alert alert-info" style2="font-family: Georgia ;">
			总计：${countFi.faPoint }单，
			货物共计：<strong>${countFi.cargoNum }</strong> 件，
			运费：${countFi.freight }，
			已付运费：${countFi.freightWay }，
			代收费：${countFi.collection }，
			保险费：${countFi.countInsurance }，
			手续费：${countFi.fee }，
			转运费：${countFi.soPointSubMoney }，
			其中代收费：<strong>${countFi.collectionWay }</strong> 单
		</div>
		<div class="panelBar row" >
	        <div class="pages col-md-3 pagination">
	            <span>&nbsp;每页&nbsp;</span>
	            <span class="sel">
	            ${page.pageSize }
	            </span>
	            <span>&nbsp;条，共 ${page.lastRowNum} 条</span>
	        </div>
	        <div class="pagination-box col-md-9" totalcount="${page.lastRowNum}" numperpage="20" pagenumshown="10" currentpage="${page.pageNum}">
	        	<nav class="pull-right">
				  <ul class="pagination">
				   
				  </ul>
				</nav>
	        </div>
	    </div>
    </div> <!-- /container -->
<jsp:include page="/WEB-INF/pages/common/foot.jsp"></jsp:include>
</body>
<script type="text/javascript">
$(function(){
	$("#allchecked").change(function(){
		$("#datalist td input:checkbox").prop("checked",$(this).prop("checked"));
		if($(this).prop("checked")){
			$("#datalist tbody tr").addClass("danger");
		}else{
			$("#datalist tbody tr").removeClass("danger");
		}
	});
	$("#datalist tbody tr").click(function(){
		var _checkbox = $(this).find("input:checkbox");
		_checkbox.prop("checked",!_checkbox.prop("checked"));
		if(_checkbox.prop("checked")){
			$(this).addClass("danger");
		}else{
			$(this).removeClass("danger");
		}
	});
	$(".checktd").click(function(){
		var _checkbox = $(this).find("input:checkbox");
		_checkbox.prop("checked",!_checkbox.prop("checked"));
	});
	$("#dcgx").click(function(){
		$("#listform").prop("action","${appPath }/reconciliation/exportExcel.html").submit();
	});
	$("#dcgx_all").click(function(){
		if("${page.lastRowNum}" > 10000){
			alert("导出数据过多，请导出10000条以内数据！");
			return ;
		}
		$("#pagerForm").prop("action","${appPath }/reconciliation/exportAllExcel.html").submit();
	});
	$("#pagesubmit").click(function(){
		$("#pagerForm").prop("action","${appPath }/reconciliation/index.html").submit();
	});
	$("#qrzf").click(function(){
		var fields = $("#datalist td input:checked").serializeArray();
		$.getJSON("${appPath }/reconciliation/changeStatus.ajax",fields,function(){
			alert("执行成功！");
			$("#pagerForm").submit();
		});
	});
	$(".delete").click(function(){
		if(confirm("确定删除该记录？")){
			$.getJSON("${appPath }/reconciliation/delete.ajax?id="+$(this).data("id"),function(json){
				alert("删除成功！");
				$("#tr"+json.id).remove();
				//$("#pagerForm").submit();
			});
		}
		return false;
		
	});
	$("#sendsms").click(function(){
		$("#pagerForm").prop("action","${appPath }/reconciliation/sendAllMsg.html").submit();
	});
	if("${msg}" != "")
		alert("${msg}");
});
</script>
</html>