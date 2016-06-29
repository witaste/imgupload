<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta content="telephone=no" name="format-detection" />
<meta
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no"
	name="viewport" id="viewport" />
<title>上传图片</title>
<script type="text/javascript" src="resources/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="resources/jquery/plugins/rotate/jquery.rotate.js"></script>
<script type="text/javascript" src="resources/jquery/plugins/jquery-file-upload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="resources/jquery/plugins/jquery-file-upload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="resources/jquery/plugins/jquery-file-upload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="resources/jquery/plugins/magnific-popup/jquery.magnific-popup.min.js"></script>
<link rel="stylesheet" href="resources/jquery/plugins/magnific-popup/magnific-popup.css">
<link rel="stylesheet" href="resources/weui/weui.min.css">
<style type="text/css">
/* 拉幕层 */
.weui_uploader_progress {
	position: absolute;
	z-index: 100;
	line-height: 79px;
	color: #FFFFFF;
	height: 79px;
	width: 79px;
	text-align: center;
	background-color: rgba(0, 0, 0, .5);
}

.weui_uploader_image {
	float: left;
	width: 79px;
	height: 79px;
}

.weui_cell:before {
	left: 0 !important;
}
}
</style>
<script type="text/javascript">
	var cnt = 0;
	var currentDegree = 0;
	$(function() {
		$('#fileupload').fileupload(
				{
					dataType : 'json',
					add : function(e, data) {
						cnt++ ;
						data.context = {};
						data.context.progress_id = 'progress_' + cnt + '_' + e.timeStamp;
						data.context.img_id = 'img_' + cnt + '_' + e.timeStamp;
						//加载本地图片 
						var reader = new FileReader();
						reader.onload = function(e) {
							$('<img/>')
									.attr('src', e.target.result)
									.attr('id',data.context.img_id)
									.addClass("weui_uploader_image")
									.appendTo($("#weui_uploader_files"))
									.wrap('<li class="weui_uploader_file"></li>')
									.after('<div id="' + data.context.progress_id + '" class="weui_uploader_status_content weui_uploader_progress">0%</div>')
									.load(function() {
										$(this).magnificPopup({
											items: {src: this.src}
											,closeMarkup:'<button type="button" class="mfp-close" style="width:30px;position:fixed;right:20px;top:0px;">&#215;</button>'
											,type: 'image' 
											,closeOnBgClick:false
											,midClick:true
											,showCloseBtn:true
											,enableEscapeKey:false
											,image:{titleSrc:function(item){
												var html = '';
												html += '<button onclick="deleteCurrent(\''+data.context.img_id+'\')" style="position:fixed;right:160px;top:12px;z-index:1047;">删除</button>&nbsp;';
												html += '<button onclick="animateCurrent(\'-\')" style="position:fixed;right:100px;top:12px;z-index:1047;">左旋</button>&nbsp;';
												html += '<button onclick="animateCurrent(\'+\')" style="position:fixed;right:60px;top:12px;z-index:1047;">右旋</button>&nbsp;';
												return html;
												}
											},
											callbacks:{
												open:function(){
// 													$(".mfp-img:eq(0)").animate({rotate:90});
												},
												close:function(){
													currentDegree = 0;
												}
											}
										});// popup options end 
										data.submit();
									});// img onload end

						};// reader on load end
						reader.readAsDataURL(data.files[0]);
					},
					done : function(e, data) {
						var pDiv = $("#" + data.context.progress_id);
						if(data.textStatus == 'success'){
							pDiv.text('100%');
							pDiv.empty();
						}else{
							pDiv.html('<i class="weui_icon_warn"></i>');
						}
					},
					fail:function(e, data){
						var pDiv = $("#" + data.context.progress_id);
						pDiv.text('100%');
						pDiv.empty();
					},
					progress : function(e, data) {
						var progress = parseInt(data.loaded / data.total * 100, 10);
						var pDiv = $("#" + data.context.progress_id);
						pDiv.css("height",79 - 0.79 * progress);
						if(progress != 100){
							pDiv.text(progress + '%');
						}
					}
				});
		

	});
	function deleteCurrent(imgId){
		$('.mfp-close').click();
		$('#' + imgId).parent().remove();
	}
	function animateCurrent(operation){
		currentDegree = eval(currentDegree + operation + '90');
		$(".mfp-img:eq(0)").animate({rotate:currentDegree});
		if(currentDegree == 360 || currentDegree == -360){
			currentDegree = 0;
		}
	}
	    
</script>
<body>
	<h2>Hello World!</h2>
	<div class="weui_cell">
		<div class="weui_cell_bd weui_cell_primary">
			<div class="weui_uploader">
				<div class="weui_uploader_hd weui_cell">
					<div class="weui_cell_bd weui_cell_primary">图片上传</div>
				</div>
				<div class="weui_uploader_bd">
					<ul class="weui_uploader_files" id="weui_uploader_files">
					<!-- 图片列表 s t a r t -->
					<!-- 图片列表 e n d     -->
					</ul>
					<div class="weui_uploader_input_wrp">
						<input id="fileupload" name="files[]" data-url="upload" class="weui_uploader_input" type="file" accept="image/jpg,image/jpeg,image/png,image/gif" multiple="multiple">
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
