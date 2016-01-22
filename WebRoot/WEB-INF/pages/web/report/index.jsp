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
<script src="${appPath }/resources/highcharts-4.2.1/js/highcharts.js"></script>
</head>
<body data-menu="5">
<jsp:include page="/WEB-INF/pages/common/menu.jsp"></jsp:include>
 <div class="container" >
       	<ol class="breadcrumb main" >
		  <li><a href="#"><i class="fa fa-truck"></i> 鄂西快运</a></li>
		  <li><a href="#"> 统计</a></li>
		  <li  class="active">整体统计</li>
		</ol>
	<div class="panel panel-default">
	  <div class="panel-body">
	    <div id="map-con"></div>
	  </div>
	</div>
	<div class="panel panel-default">
	  <div class="panel-body">
	  	<div id="map-cargoNum"></div>
	  </div>
	</div>
	<div class="panel panel-default">
	  <div class="panel-body">
	  	<div id="map-collection"></div>
	  </div>
	</div>
	
	
    </div> <!-- /container -->
<jsp:include page="/WEB-INF/pages/common/foot.jsp"></jsp:include>
</body>
<script type="text/javascript">
$(function () {
	Highcharts.setOptions({
	    lang:{
	       contextButtonTitle:"图表导出菜单",
	       decimalPoint:".",
	       downloadJPEG:"下载JPEG图片",
	       downloadPDF:"下载PDF文件",
	       downloadPNG:"下载PNG文件",
	       downloadSVG:"下载SVG文件",
	       drillUpText:"返回 {series.name}",
	       loading:"加载中",
	       months:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
	       noData:"没有数据",
	       numericSymbols: [ "千" , "兆" , "G" , "T" , "P" , "E"],
	       printChart:"打印图表",
	       resetZoom:"恢复缩放",
	       resetZoomTitle:"恢复图表",
	       shortMonths: [ "1月" , "2月" , "3月" , "4月" , "5月" , "6月" , "7月" , "8月" , "9月" , "10月" , "11月" , "12月"],
	       thousandsSep:",",
	       weekdays: ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六","星期天"]
	    }
	});
	$.getJSON("${appPath}/report/all.ajax",function(json){
		var con = new Array();
		var cargoNum = new Array();
		var collection =  new Array();
		$.each(json,function(){
			con.push(toNum(this.con));
			cargoNum.push(toNum(this.cargoNum));
			collection.push(toNum(this.collection/10000));
			
		});
		console.log(con);
		loadMap("map-con","发货单数","2015年09月28日至今（发货单数）",con);
		loadMap("map-cargoNum","发货件数","2015年09月28日至今（发货件数）",cargoNum);
		loadMap("map-collection","代收费用（万元）","2015年09月28日至今（代收费用）",collection);
	});
	function toNum(str){
		if(!str ||str == null || str == undefined)
			return 0;
		return parseFloat(str)
	}
	function loadMap(id,name,title,data){
		$('#'+id).highcharts({
		        chart: {
		            zoomType: 'x',
		            spacingRight: 20
		        },
		        title: {
		            text: title
		        },
		        subtitle: {
		            text: document.ontouchstart === undefined ?
		                '单击并拖动，查看详细信息' :
		                '两指捏住图放大'
		        },
		        xAxis: {
		            type: 'datetime',
		           	maxZoom: 14 * 24 * 3600000, // fourteen days
		            dateTimeLabelFormats: {
		            	day: '%b%e日'
		            },
		            title: {
		                text: null
		            }
		        },
		        yAxis: {
		            title: {
		                text: name
		            }
		        },
		        tooltip: {
		            shared: true
		        },
		        legend: {
		            enabled: false
		        },
		        plotOptions: {
		            area: {
		                fillColor: {
		                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
		                    stops: [
		                        [0, Highcharts.getOptions().colors[0]],
		                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
		                    ]
		                },
		                lineWidth: 1,
		                marker: {
		                    enabled: false
		                },
		                shadow: false,
		                states: {
		                    hover: {
		                        lineWidth: 1
		                    }
		                },
		                threshold: null
		            }
		        },
		       series: [{
		            type: 'area',
		            name: '',
		            pointInterval: 24 * 3600 * 1000,
		            pointStart: Date.UTC(2015, 08, 28),
		            data: data
		        }]
		    });
		
	}
});
</script>
</html>