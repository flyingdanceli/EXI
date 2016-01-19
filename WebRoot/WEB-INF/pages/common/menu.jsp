<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
   <!-- Fixed navbar -->
    <nav class="navbar navbar-default navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/">鄂西快运</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li class=""><a href="${appPath }/invoice/mine.html"><i class="fa fa-file"></i> 发货单</a></li>
            <c:if test="${sessionScope.user.id eq 0 }">
            	<li><a href="${appPath }/reconciliation/index.html"><i class="fa fa-retweet"></i> 对账管理</a></li>
            
 
            
            <li><a href="${appPath }/clientele/index.html"><i class="fa fa-users"></i> 客户管理</a></li>
            <li><a href="${appPath }/car/index.html"><i class="fa fa-truck"></i> 车辆管理</a></li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-pie-chart"></i> 统计 <span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu">
              	<li><a href="${appPath }/report/index.html">整体统计</a></li>
                <li><a href="#">月度统计</a></li>
                <li><a href="#">年度统计</a></li>
                <li class="divider"></li>
                <li class="dropdown-header">数据导出</li>
                <li><a href="#">银行对账数据</a></li>
              </ul>
            </li>
            <li class="dropdown">
            	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-server"></i> 系统管理 <span class="caret"></span></a>
	            <ul class="dropdown-menu" role="menu">
	            	<li><a href="${appPath }/sysUser/userIndex.html"><i class="fa fa-user"></i> 员工管理</a></li>
	            	<li><a href="http://www.60dx.com" target="_blank"><i class="fa fa-envelope"></i> 短信管理</a></li>
	            </ul>
            </li>
            </c:if> 
          </ul>
          <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><i class="fa fa-user-secret"></i> ${sessionScope.user.name } <span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu">
                <li><a href="${appPath }/sysUser/toChangePassword.html"><i class="fa fa-key"></i> 修改密码</a></li>
                <li><a href="${appPath}/">退出</a></li>
              </ul>
            </li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
