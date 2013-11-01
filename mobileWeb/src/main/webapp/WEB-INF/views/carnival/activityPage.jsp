<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    pageContext.setAttribute("basePath",basePath);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动页面</title>
    <style type="text/css">
    <!--
    *{ padding:0; margin:0;}
    ul,li{ list-style:none; padding:0; margin:0;}
    fl{ float:left;}
    body{ font: Arial, Helvetica, sans-serif; font-size:40px; font-family:microsoft yahei,Tahoma,Arial; width:1000px; height:100%; background-color:#930006;}
    .clear{ clear:both; font-size:0; line-height:0;}
    -->
    </style>
    <%--<script type="text/javascript">
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-39572739-8', 'jinjiang.com');
        ga('send', {
            'hitType': 'pageview',
            'page': '/carnival/activityPage',
            'title': '双十一活动页'
        });

    </script>--%>
    </head>
    <script type="text/javascript">
        function showActivityPage(){
            if (!canSelect)return;
            document.getElementById("divContent").style.visibility="hidden";
            document.getElementById("divButton").style.visibility="hidden";
            var userAgent = "${userAgent}";
            if (userAgent == 'ios') {
                window.location = "pageToDetail?segue=activity_toShake_sugue";
            } else if (userAgent == 'android') {
                window.location = "pageToDetail?segue=activity_toShake_sugue";
            }
        }
        function showRulePage(){
            /*ga('send', {
                'hitType': 'event',
                'eventCategory': 'button',
                'eventAction': 'click',
                'eventLabel': '查看活动规则'
            });*/
            canSelect = false;
            document.getElementById("maskView").style.visibility="visible";
            showHdgz();
        }

        function hideRulePage(){
            document.getElementById("maskView").style.visibility="hidden";
            canSelect = true;
            hideHdgz();
        }

        var showInterval;
        var canSelect = true;

        function showHdgz()
        {
            showInterval = setInterval("hdgzDown()",5);
        }

        function hdgzDown()
        {
            var o = document.getElementById("divRule");
            var top  = parseInt(o.style.top);
            top+=10;
            if (top >= 10) clearInterval(showInterval);
            top = top+"px";
            document.getElementById("divRule").style.top = top ;
        }

        function hideHdgz()
        {
            showInterval = setInterval("hdgzUp()",5);
        }

        function hdgzUp()
        {
            var o = document.getElementById("divRule");
            var top  = parseInt(o.style.top);
            top-=10;
            if (top <= -820) clearInterval(showInterval);
            top = top+"px";
            document.getElementById("divRule").style.top = top ;
        }

        </script>

<body>

    <div style="top:0px; left:0px; right:0px; height:100%; width:100%; position:absolute; background:url(${staticPath}/mresource/carnival/bg_1.jpg) repeat-x; z-index:0;">
        <div id="divContent" style="top:0px; margin:0 auto; left:0px; right:0px; height:800px; width:640px; position:absolute; background:url(${staticPath}/mresource/carnival/jnh_1.png) no-repeat; z-index:1;">
            <a onclick="showRulePage();" style="position:absolute; right:50px; top:720px; width:220px; height:60px; cursor:pointer;"></a>
        </div>
        <div  id="divButton">
            <a onclick="showActivityPage();" style="margin:0 auto; position:absolute; left:80px; right:80px; bottom:20px; width:480px; height:86px; background:url(${staticPath}/mresource/carnival/jnh_btn_1.png) no-repeat; cursor:pointer;"></a>
        </div>
    </div>

 <!---活动规则--->
    <div id="divRule" style="margin:0 auto; top:-820px; left:0px; right:0px; height:820px; width:640px; position:absolute; background:url(${staticPath}/mresource/carnival/hdgz.png) no-repeat; z-index:1;">
       <a onclick="hideRulePage();" style="margin:0 auto; position:absolute; left:569px; right:80px; bottom:753px; width:48px; height:50px; background:url(${staticPath}/mresource/carnival/close.png) no-repeat; cursor:pointer;">
       </a>
       <div href="" style=" position:absolute; right:48px; top:40px; width:540px; height:550px; cursor:pointer; font-size:20px; color:#333; text-decoration:none; line-height:34px; overflow-x:hidden;">
           <p style="font-size:24px; font-weight:bold; color:#F60;">嘉年华活动详情
           <ul style="margin-top:5px;"><a style="color:#F60">活动日期：</a>
               <li style="padding-left:20px;">2013年8月20日-10月31日</li>
           </ul>
           <ul><a style="color:#F60">活动方式：</a>
               <li>1、摇手机抽大奖（每日最多中奖一次，活动日期：2013年8月20日-9月30日）</li>
               <li> 2、秋季酒店88折，12%现金反馈大惊喜</li>
               <li style="padding-left:32px; font-size:18px;">活动期间预定并在线支付成功的且入住时间为2013年11月15日23:59前，可以参与88折返现12%活动。</li>
           </ul>
           <ul><a style="font-size:20px; color:#F60">返现细则：</a>
               <li>1、活动期间，预订除百时快捷外，在线支付的酒店都可以享受12%返现,使用优惠券订单不再进行返现；</li>
               <li>2、 返现金额按在线支付订单中实际完成入住的那部分金额的12%返回到用户账户；</li>
               <li>3、返现金额将在用户消费成功后即check out之后（入住时间在2013年11月15日23:59之前）45日内返还12%的返现金额到支付账户内。</li>
           </ul>
           </p>

           <ul style="margin-top:15px;"><a style="font-size:24px; font-weight:bold; color:#F60">多重惊喜</a>
               <li>1、现金立减：支付宝用户在APP内下单且通过APP内支付宝在线支付满150元立减10元，活动期间每个用户最多只可享受2次立减优惠，余额宝支付不支持立减活动；</li>
               <li>2、狂赚积分：锦江旅行家会员预订酒店并成功消费，享双倍积分，享会员最高可享7倍积分；</li>
               <li>3、会员特权：享会员预订锦江之星酒店享9折优惠；</li>
               <li>4、神秘“抽奖币”：官网下载“锦江旅行家App”, 完成注册，每日登陆，会员升级，购买享卡，会员激活，成功订酒店均有神秘抽奖币相送，可到锦江旅行家官网（www.jinjiang.com）查询抽奖币并参加抽奖活动，“0元游欧洲”等你拿哦！</li>
           </ul>

           <ul style="margin-top:15px;"><a style="font-size:24px; font-weight:bold; color:#F60;">奖品设置：</a>
               <li style=" color:#F60;">一等奖：iPhone5  2台</li>
               <li style=" color:#F60;">二等奖：TrackMan32L登山徒背包 20个</li>
               <li style="color:#F60;">三等奖：奔腾剃须刀100个</li>
               <li style="color:#F60;">其他奖品：精装笔记本300本，军刀洗漱包200个，精美8GU盘200个，面值100元E卡通 100张  还有500W的优惠券大放送哦！</li>
               <li style=" margin-top:5px;">奖品发放时间：将于活动结束后30日内发放</li>
               <li style=" margin-top:5px;">奖品配送：此次抽奖的实物奖品由锦江旅行家统一配送</li>
               <li style=" margin-top:5px;">配送区域：覆盖全国（除新疆、西藏及港澳台地区，同时请您确保您的地址在快递可送达地区，超出快递配送范围，也不能寄送礼品）</li>
           </ul>

           <ul style="margin-top:15px;"><a style="font-size:24px; font-weight:bold; color:#F60">特殊说明：</a>
               <li>参加88折现金反馈活动，在线支付时不能使用优惠券。</li>
               <li>摇奖的优惠券有效期：<a style="color:#F60;">2013年11月1日---2014年2月20日</a></li>
               <li>用户发票按照实际入住金额开具</li>
               <li>客服电话：1010-1666</li>
               <li style="margin-top:10px;"><a style="color:#ff0000; font-size:16px; margin-top:10px;">*此次活动最终解释权归锦江旅行家所有</a></li>
           </ul>

       </div>
    </div>
    <p id = "maskView" style="visibility:hidden; margin:0 auto; top:0px; left:0px; right:0px; position:absolute;width:100%; height:100%; background:#000 repeat; opacity:.4; z-index:0;"></p>

</body>
</html>
 <!---安卓调用--->
<script type=text/javascript>
function onJsAndroid(){
	document.body.style.zoom=1.5;
}
</script>