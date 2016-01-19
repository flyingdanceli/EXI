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
<title>鄂西快运欢迎您</title>
<script type="text/javascript">
	if("${res}"){
		alert("${res}");
	}
	
	function deleteUser(userId){
		if(confirm("确定要删除此用户吗？")){
			window.location.href="${appPath }/sysUser/delUser.mo?id="+userId;
		}
	}
</script>
<jsp:include page="/WEB-INF/pages/common/head.jsp"></jsp:include>
</head>
<body data-menu="9">
<jsp:include page="/WEB-INF/pages/common/menu.jsp"></jsp:include>
 <div class="container" >
       	<ol class="breadcrumb main" >
		  <li><a href="#"><i class="fa fa-truck"></i> 鄂西快运</a></li>
		  <li  class="active">员工管理</li>
		</ol>
     	<form class="form-inline" id="pagerForm" action="${appPath}/sysUser/userIndex.html" method="post">
     		<div class="well">     		 
			  <div class="form-group">
			    <label for="exampleLoginName">登录帐号：</label>
			    <input type="text" class="form-control" id="loginName" name="loginName" placeholder="发货/收货人姓名">
			  </div>
			  <div class="form-group">
			    <label for="exampleInputPassword3">姓名：</label>
			    <input type="text" class="form-control" id="name" name="name" placeholder="发货/收货人电话">
			  </div>
			  <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 搜 索</button>
	     	</div>
			<div class="panel panel-default">
			  <!-- Default panel contents -->
			  <div class="panel-heading"><i class="fa fa-th-list"></i> 员工信息 <div class="pull-right"><a href="${appPath }/sysUser/addUser.html" class="btn btn-success btn-xs"><i class="fa fa-user-plus"></i> 添加员工</a></div></div>
			
			  <!-- Table -->
			  <table class="table table-striped table-bordered table-hover table-condensed">
			  	<thead>
			  	<tr>
			   		<th>登录帐号</th>
			  		<th>姓名</th>
			  		<th>发货权限</th>
			   		<th>接受权限</th>
			   		<th>录入时间</th>
			   		<th>是否禁用</th>
			   		<th>操作</th>		   				   		
			   	</tr>
			   	</thead>
			   	<tbody>
			   	<c:forEach items="${page.dataList}" var="user">		   	
			   		<tr>
			   			<td>${user.loginName }</td>
			   			<td>${user.name }</td>
			   			<td>${user.faRangeName }</td>
			   			<td>${user.soRangeName }</td>
			   			<td><fmt:formatDate value="${user.insTime }"/></td>
			   			<td><c:if test="${user.isDisable == 1}">是</c:if><c:if test="${user.isDisable != 1}">否</c:if></td>
			   			<td>
			   				<a href="${appPath }/sysUser/updateUser.html?id=${user.id}" class="btn btn-success btn-xs"><i class="fa fa-pencil-square-o"></i>修改</a>
					      	<a href="#" onclick="deleteUser(${user.id});" class="btn btn-danger btn-xs"><i class="fa fa-times"></i>删除</a>
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