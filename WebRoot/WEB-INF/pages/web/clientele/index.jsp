<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>鄂西快运欢迎您</title>
<script type="text/javascript">
	if("${res}"){
		alert("${res}");
	}
	
	function deleteClientele(userId){
		if(confirm("确定要删除此客户吗？")){
			window.location.href="${appPath }/clientele/delClientele.mo?id="+userId;
		}
	}
	
	function expHTML(){
		window.open("${appPath }/clientele/expClientReport.html?type=html");
	}
	function expPDF(){
		window.open("${appPath }/clientele/expClientReport.html?type=pdf");
	}
	function expWORD(){
		window.open("${appPath }/clientele/expClientReport.html?type=word");
	}
</script>
<jsp:include page="/WEB-INF/pages/common/head.jsp"></jsp:include>
</head>
<body data-menu="2">
<jsp:include page="/WEB-INF/pages/common/menu.jsp"></jsp:include>
 <div class="container" >
       	<ol class="breadcrumb main" >
		  <li><a href="#"><i class="fa fa-truck"></i> 鄂西快运</a></li>
		  <li  class="active">客户管理</li>
		</ol>
     	<form class="form-inline" id="pagerForm" action="${appPath}/clientele/index.html" method="post">
     	<input type="hidden" name="pageNum" value="1">
     		<div class="well">     		 
			  <div class="form-group">
			    <label for="exampleLoginName">姓名：</label>
			    <input type="text" class="form-control" id="name" name="name" placeholder="客户姓名">
			  </div>
			  <div class="form-group">
			    <label for="exampleInputPassword3">电话：</label>
			    <input type="text" class="form-control" id="phone" name="phone" placeholder="客户电话">
			  </div>
			  <div class="form-group">
			    <label for="exampleFaRange">发货方：</label>
			    <select class="form-control" id="isFa" name="isFa">
			    	<optgroup>
			      		<option value="">全部</option>
			      		<option value="1">是</option>
			      		<option value="0">否</option>
			      	</optgroup>
			     </select>
			  </div>
			  <div class="form-group">
			    <label for="exampleFaRange">收货方：</label>
			    <select class="form-control" id="isSo" name="isSo">
			    	<optgroup>
			      		<option value="">全部</option>
			      		<option value="1">是</option>
			      		<option value="0">否</option>
			      	</optgroup>
			     </select>
			  </div>
			  <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 搜 索</button>
	     	</div>
			<div class="panel panel-default">
			  <!-- Default panel contents -->
			  <div class="panel-heading"><i class="fa fa-th-list"></i> 客户信息 <div class="pull-right"><a href="${appPath }/clientele/addClientele.html" class="btn btn-success btn-xs"><i class="fa fa-user-plus"></i>添加客户</a></div></div>
			
			  <!-- Table -->
			  <table class="table table-striped table-bordered table-hover table-condensed">
			  	<thead>
				  	<tr>
				  		<th>姓名</th>
				  		<th>电话</th>
				   		<!-- <th>发货方</th>
				   		<th>收货方</th> -->
				   		<th>运单数（收/付）</th>
				   		<th>代收合计</th>
				   		<th>运费合计</th>
				   		<th>删除/编辑</th>
				   		
				   	</tr>
		   		</thead>
			   	<tbody>
			   	<c:forEach items="${page.dataList}" var="user">		   	
			   		<tr>
			   			<td>${user.name }</td>
			   			<td>${user.phone }</td>
			   			<%-- <td><c:if test="${user.isFa == 1}">是</c:if><c:if test="${user.isFa != 1}">否</c:if></td>
			   			<td><c:if test="${user.isSo == 1}">是</c:if><c:if test="${user.isSo != 1}">否</c:if></td> --%>
			   			<td></td>
			   			<td></td>
			   			<td></td>
			   			<td>
			   				<a href="${appPath }/clientele/addClientele.html?id=${user.id}" class="btn btn-success btn-xs"><i class="fa fa-pencil-square-o"></i>修改</a>
					      	<a href="#" onclick="deleteClientele(${user.id});" class="btn btn-danger btn-xs "><i class="fa fa-times"></i>删除</a>
					      	<!-- <a href="#" onclick="expHTML();">导出html</a>
					      	<a href="#" onclick="expPDF();">导出pdf</a>
					      	<a href="#" onclick="expWORD();">导出word</a> -->
					   </td>
			   		</tr>
			   	</c:forEach>
			   	</tbody>
			  </table>
			</div>
		</form>
		<hr />
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
</html>