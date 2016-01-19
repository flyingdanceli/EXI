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
<link href="${appPath }/resources/bootstrap-datetimepicker-master/build/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
<script type="text/javascript" src="${appPath }/resources/moment/moment.min.js"></script>
<script type="text/javascript" src="${appPath }/resources/moment/zh-cn.js"></script>
<script type="text/javascript" src="${appPath }/resources/bootstrap-datetimepicker-master/build/js/bootstrap-datetimepicker.min.js"></script>
</head>
<body data-menu="0">
<jsp:include page="/WEB-INF/pages/common/menu.jsp"></jsp:include>

 <div class="container" >
       	<ol class="breadcrumb main" >
		  <li><a href="#"><i class="fa fa-truck"></i> 鄂西快运</a></li>
		  <li  class="active">发货单</li>
		</ol>

		<form class="form-inline" id="pagerForm" action="${appPath}/invoice/mine.html" method="post">
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
			  </div>
			  <div class="form-group">
			    <label>发货点</label>
			      <select class="form-control" name="faPoint" data-value="${param.faPoint }">
			      <option value="">全部</option>
			      <c:forEach var="fa" items="${fa }">
			      	<option value="${fa.id }">${fa.name }</option>
			      </c:forEach>
			      </select>
			    </div>
			    <div class="form-group">
			    <label>到货点</label>
			       <select class="form-control" name="soPoint" data-value="${param.soPoint }">
			       <option value="">全部</option>
			      	<c:forEach var="so" items="${so }">
				      	<option value="${so.id }">${so.name }</option>
				      </c:forEach>
			      </select>
			      &nbsp;
			      <select class="form-control" name="soPointSubName" id="soPointSubName" data-value="${param.soPointSubName }">
		      		<option value=""></option>
		      		<option value="恩施">恩施</option>
		      		<option value="利川">利川</option>
		      		<option value="来风">来风</option>
		      		<option value="鹤峰">鹤峰</option>
		      		<option value="宣恩">宣恩</option>
		      		<option value="咸丰">咸丰</option>
		      		<option value="巴东">巴东</option>
		      		<option value="建始">建始</option>
		      		<option value="野三关">野三关</option>
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
			    
			     <div class='col-sm-5'>
			     <select class="form-control" name="timeType" data-value="${param.timeType }">
			    	<option value="1">发货时间</option>
			    	<option value="2">收货时间</option>
			    	<option value="3">代收时间</option>
			    </select>
			    </div>
			    <div class='col-sm-7'>
            		<input type='text' class="form-control" id='time' name="time" value="${param.time }" size="11" />
        		</div>
			   
			  </div>&nbsp;&nbsp;&nbsp;&nbsp;
			  <div class="form-group">
			    <label>付款方式：</label>
			       <select class="form-control" name="freightWay" data-value="${param.freightWay }">
			       		<option value="">全部</option>
			      		<option value="0">己付</option>
			      		<option value="1">到付</option>
			      </select>
			  </div>&nbsp;&nbsp;&nbsp;&nbsp;
			  <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 搜 索</button>
			
     	</div>
		<div class="panel panel-default">
		  <!-- Default panel contents -->
		  <div class="panel-heading"><i class="fa fa-th-list"></i> 我的发货单 <div class="pull-right"><a href="${appPath }/invoice/add.html" class="btn btn-success btn-xs"><i class="fa fa-plus"></i> 添加</a></div></div>
		
		  <!-- Table -->
		  <table class="table table-striped table-bordered table-hover ">
		  	<thead>
		  	<tr>
		  		<th>运单号/发货时间</th>
		  		<th>发货点/收货点</th>
		   		<th>发货人/电话</th>
		   		<th>收货人/电话</th>
		   		<th>运费/保险费</th>
		   		<th>代收费/手续费</th>
		   		<th>件数</th>
		   		<th>状态</th>
		   		
		   		<th width="200px" style="width:200px;">操作</th>
		   	</tr>
		   	</thead>
		   	<tbody>
		   	<c:forEach items="${page.dataList}" var="v" varStatus="s">
			   	<tr id="tr${v.id }">
			   		<td ><strong class="text-primary">${v.faNo }</strong><br /><span class="text-danger"><fmt:formatDate value="${v.faTime }"></fmt:formatDate></span></td>
			   		<td>
			   			<strong class="text-primary">${v.sysPointF.name }</strong><br>
			   			<strong class="text-danger">${v.sysPointS.name } ${v.soPointSubName }</strong>
			   		</td>
			   		<td>
			   			<span class="text-primary">${v.basClienteleF.name }</span><br />
			   			<span class="text-danger">${v.basClienteleF.phone }</span>
			   		</td>
			   		<td>
			   			<span class="text-primary">${v.basClienteleS.name }</span><br />
			   			<span class="text-danger">${v.basClienteleS.phone }</span>
			   		</td>
			   		<td>
			   			<span class="text-primary">运：${v.freight }</span>&nbsp;${v.freightWay==0?"<span class=\"label label-danger pull-right\">己付</span>":"" }<br>
			   			<span class="text-danger">保：${v.countInsurance }</span>
			   		</td>
			   		<td><span class="text-primary">${v.collection }</span><br />${v.fee }</td>
			   		<td>${v.cargoNum }</td>
			   		<td>
			   			<c:if test="${v.status == 0 }"><span class="text-muted"><i class="fa fa-circle-o"></i> 发货中</span></c:if>
			   			<c:if test="${v.status == 1 }"><span class="text-success"><i class="fa fa-adjust"></i> 已收货</span></c:if>
			   			<c:if test="${v.status == 2 }"><span class="text-danger"><i class="fa fa-adjust"></i> 代收确认</span></c:if>
			   			<c:if test="${v.status == 3 }"><span class="text-success"><i class="fa fa-circle"></i> 已完成</span></c:if>
			   			<br>
			   			<time class="text-muted time"><fmt:formatDate value="${v.upTime }"></fmt:formatDate></time>
			   		</td>
			   		<td>
			   			<div class="btn-group btn-group-sm" style="width:200px;">
				   			<a href="${appPath }/print/printPdf.html?invoiceId=${v.id}"  target="print${v.id}" class="btn btn-info" ><i class="fa fa-file-pdf-o"></i> 票据</a>
							<a href="iprint://115.28.180.62/print/printReport.html?invoiceId=${v.id }&jasper=bill&view=false" class="btn btn-info" ><i class="fa fa-ticket"></i> 标签</a>
						
							<c:if test="${user.faRange==v.faPoint  && v.status ==0}">
								<a href="javascript:void(0);" data-id="${v.id}" class="btn btn-danger btn-xs delete" >
							      <i class="fa fa-trash-o"></i> 删除
								</a>
							</c:if>
				   			<c:if test="${user.soRange==v.soPoint && v.status ==0 }">
					   			<div class="btn-group btn-group-sm" role="group">
								    <button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
								      <i class="fa fa-check"></i> 收货
								      <span class="caret"></span>
								    </button>
								    <ul class="dropdown-menu" role="menu">
								      <li><a href="${appPath}/invoice/status.html?status=1&&id=${v.id}"> 货已收到</a></li>
								    </ul>
								  </div>
							</c:if>
				   			<c:if test="${user.faRange==v.faPoint && v.status ==1 }">
				   			<div class="btn-group btn-group-sm" role="group">
				   				<button type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
							      <i class="fa fa-jpy"></i> 支付代收款
							      <span class="caret"></span>
							    </button>
							    <ul class="dropdown-menu" role="menu">
							      <li><a href="${appPath}/invoice/status.html?status=2&&id=${v.id}"> 确认代收钱款已支付</a></li>
							    </ul>
							  </div>
				   			</c:if>
				   			<!-- <a href="${appPath }/print/ptint.html?invoiceId=${v.id}" target="print${v.id}" class="btn btn-default" >
							      <i class="fa fa-print"></i> 打印
							</a> -->
							
						</div>
						
						
						<!-- Split button 
						<div class="btn-group btn-group-sm">
							<a href="${appPath }/print/printPdf.html?invoiceId=${v.id}"  target="print${v.id}" class="btn btn-danger" ><i class="fa fa-file-pdf-o"></i> PDF打印</a>
						  	
						  <button type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">&nbsp;
						    <span class="caret"></span>
						    <span class="sr-only">Toggle Dropdown</span>
						  </button>
						  <ul class="dropdown-menu">
						  	
						  	<li><a href="iprint://115.28.180.62/print/printReport.html?invoiceId=${v.id }&view=false" ><i class="fa fa-print"></i> 直接打印</a></li>
						  	<li><a href="iprint://115.28.180.62/print/printReport.html?invoiceId=${v.id }&view=true" ><i class="fa fa-files-o"></i> 打印预览</a></li>
						  	
						  	<li><a href="iprint://115.28.180.62/print/printReport.html?invoiceId=${v.id }&jasper=bill&view=false" ><i class="fa fa-ticket"></i> 打印标签</a></li>
						    
						  </ul>
						</div>
						-->
			   		</td>
			   	</tr>
		   	</c:forEach>
		   	</tbody>
		  </table>
		</div>
		<div class="alert alert-info" style2="font-family: Georgia ;">
			<!-- 总计：${countFi.freightWay }单，
			合计运费：${countFi.freight }，
			已付运费：${countFi.freightWay }，
			合计代收费：${countFi.collection }，
			合计保险费：${countFi.countInsurance }，
			合计手续费：${countFi.fee }，
			合计转运费：${countFi.soPointSubMoney }，
			货物共计：<strong>${countFi.cargoNum }</strong> 件，
			其中代收费：<strong>${countFi.collectionWay }</strong> 单 -->
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
		</form>
    </div> <!-- /container -->
<jsp:include page="/WEB-INF/pages/common/foot.jsp"></jsp:include>
<script type="text/javascript">
     $(function () {
         $('#time').datetimepicker({
         	format:"YYYY-MM-DD",
         	useCurrent:false,
         	locale:"zh-cn",
         	showClear:true,
         	showTodayButton:true,
         	showClose:true,
         	tooltips: {
         	    today: '今天',
         	    clear: '清除',
         	    close: '关闭',
         	    selectMonth: '选择月份',
         	    prevMonth: '上一月',
         	    nextMonth: '下一月',
         	    selectYear: '选择年',
         	    prevYear: '上一年',
         	    nextYear: '下一年',
         	    selectDecade: 'Select Decade',
         	    prevDecade: 'Previous Decade',
         	    nextDecade: 'Next Decade',
         	    prevCentury: 'Previous Century',
         	    nextCentury: 'Next Century'
         	}
         });
         $(".delete").click(function(){
     		if(confirm("确定删除该记录？")){
     			$.getJSON("${appPath }/invoice/delete.ajax?id="+$(this).data("id"),function(json){
     				alert("删除成功！");
     				$("#tr"+json.id).remove();
     				//$("#pagerForm").submit();
     			});
     		}
     		return false;
     		
     	});
     });
 </script>
</body>
</html>