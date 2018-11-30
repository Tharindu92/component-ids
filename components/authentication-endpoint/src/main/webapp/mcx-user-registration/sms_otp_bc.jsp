<!doctype html>
<!--
/*******************************************************************************
* Copyright (c) 2016, WSO2.Telco Inc. (http://www.wso2telco.com)
*
* All Rights Reserved. WSO2.Telco Inc. licences this file to youunder the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
******************************************************************************/
-->
<%@page import="java.util.logging.Logger" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.framework.cache.*" %>
<%@ page import="org.wso2.carbon.identity.application.authentication.framework.context.*" %>
<%@ page import="com.wso2telco.identity.application.authentication.endpoint.util.DbUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.wso2telco.identity.application.authentication.endpoint.util.ReadMobileConnectConfig" %>
<%@ page import="javax.xml.parsers.ParserConfigurationException" %>
<%@ page import="org.xml.sax.SAXException" %>
<%@ page import="javax.xml.xpath.XPathExpressionException" %>
<%@ page import="javax.servlet.jsp.jstl.core.Config" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html class="site no-js lang--en" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Mobile Connect</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">

    <link rel="apple-touch-icon" href="apple-touch-icon.png">
    <script src="../mcx-user-registration/js/jquery-3.2.1.min.js" type="text/javascript"></script>
    <script src="../mcx-user-registration/js/landing.js" type="text/javascript"></script>
    <script src="../mcx-user-registration/js/tether.min.js" type="text/javascript"></script>
    <!--script src="../mcx-user-registration/js/bootstrap.min.js" type="text/javascript"></script-->
    <script src="../mcx-user-registration/js/public/js/main.js" type="text/javascript"></script>
    <script src="../mcx-user-registration/js/public/js/modal.js" type="text/javascript"></script>
    <script src="../mcx-user-registration/js/parsley.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../mcx-user-registration/mcresources/css/style.css">
    <!--link rel="stylesheet" href="../mcx-user-registration/css/bootstrap.min.css"-->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">


    <noscript>
        <!-- Fallback synchronous download, halt page rendering if load is slow  -->
        <link href="//fonts.googleapis.com/css?family=Roboto:400,300,700,400italic,300italic,700italic" rel="stylesheet"
              type="text/css">
    </noscript>
    <!-- loads fonts asyncronously preventing font loading from block page render -->
    <script>
        // Config for loading the web fonts
        var WebFontConfig = {
            google: {
                families: ['Roboto:400,300,700,400italic,300italic,700italic']
            },
            active: function () {
                // Set a cookie that the font has been downloaded and should be cached
                var d = new Date();
                d.setTime(d.getTime() + (7 * 86400000)); // plus 7 Days
                document.cookie = "cachedroboto=true; expires=" + d.toGMTString() + "; path=/";
            }
        };
    </script>
    <script src="../mcx-user-registration/mcresources/js/vendor/webfontloader.js"></script>
    <!-- Adds IE root class without breaking doctype -->
    <!--[if IE]>
    <script>document.documentElement.className = document.documentElement.className + " ie";</script>
    <![endif]-->

    <!-- load main script early asyncronously -->
    <script type="text/javascript" src="../mcx-user-registration/mcresources/js/main.js" async></script>
    <script type="text/javascript" src="../mcx-user-registration/mcresources/js/vendor/modernizr.js"></script>

    <%
	    Logger log=Logger.getLogger(this.getClass().getName());
        String sessionDataKey = request.getParameter("id");
        Boolean isRegistering = Boolean.valueOf(request.getParameter("registering"));
        String operator = "";
        boolean isSessionExpired = DbUtil.getSessionStatus(sessionDataKey);
        Map<String,String> scopeDescription = null;
        String spLogo =null;
        String spName = null;
        boolean approve_all_enable = false;

        if(!isSessionExpired){
            scopeDescription= DbUtil.getScopeDescforSession(id);
            if(scopeDescription.isEmpty()){
                isSessionExpired = true;
            }else{
                isRegistering = Boolean.valueOf(scopeDescription.get("isNewUser"));
                operator = scopeDescription.get("operator");
                spName = scopeDescription.get("spName");
                approve_all_enable = Boolean.valueOf(scopeDescription.get("approve_all_enable"));
                scopeDescription.remove("isNewUser");
                scopeDescription.remove("operator");
                scopeDescription.remove("spName");
                scopeDescription.remove("approve_all_enable");
            }
        }

        String imgPath = null;
        String termsConditionsPath = null;
        if (operator!=null && !operator.isEmpty()) {
            imgPath = "images/branding/" + operator + "_logo.png";
    %>
    <link href="css/branding/<%=operator%>-style.css" rel="stylesheet">
    <%
        }
    %>

</head>

<body class="theme--light">
    <form action="../../commonauth" method="post" id="loginForm" class="form-horizontal" data-parsley-validate
          novalidate>


            <div class="container">

            <header class="site-header">
           <div class="site-header__inner site__wrap">
        <h1 class="visuallyhidden">Mobile Connect</h1>
        <div align="center">
        <table class="site-header-brand-table" style="margin-bottom:0px;">
        <tbody><tr>
        <td width="30%">
        <a class="brand">
        <img src="../images/svg/mobile-connect.svg" alt="Mobile Connect&nbsp;Logo" width="150" class="site-header__logo">
        </a>
        </td>
        <td width="70%">
    	</td>
        </tr>
        </tbody></table>
        </div>
        </div>
    	</header>


                <div class="row">
                    <div class="span12">

                        <input type="hidden" name="sessionDataKey" id="sessionDataKey" value='<%=sessionDataKey%>'/>
                        <div class="site__root" id="content-placeholder"></div>
                        <fmt:message key="waiting-label-continue-on-device-otp-prompt" var="prompt" />

                        <!-- The handlebar template -->
                        <!--
                        <script id="results-template" type="text/x-handlebars-template"> -->
                        	<main class="site__main site__wrap section v-distribute">
                        		<header class="page__header">
                        			<h1 class="page__heading">
                        			<fmt:message key='waiting-label-continue-on-device-heading'/>
                                    </h1>

                                    <p style="font-size: 0.9em;">

                        				<%

                        					Boolean showSMSLink = false;
                        					Boolean smsotp =true;
                        				%>

                        				<fmt:message key='waiting-label-continue-on-device-intro-otp-sms'/>

                                    </p>
                        		</header>

                        		<div class="page__illustration v-grow v-align-content">
                        			<div>

                        				<div class="timer-spinner-wrap">
                        					<div class="timer-spinner">
                        						<div class="pie spinner"></div>
                        						<div class="pie filler"></div>
                        						<div class="mask"></div>
                        					</div>
                        					<img src="../images/svg/phone-pin.svg" width="52" height="85">
                        				</div>
                        			</div>
                        		</div>
                        		<div class="error-copy space--bottom hide" id="timeout-warning">
                        			{{continue-on-device-timeout}}
                        		</div>

                                    <div id="otperror" class="parsley-errors-list filled" style="text-align: center;display: none">
                                    </div>
                                    <div>
                                        <ul class="form-fields">
                                            <li>
                                                <input  id="smsotp" type="text" onkeyup="this.value=this.value.replace(/[^\d]/,'')"  onselectstart="return false" onpaste="return false;" onCopy="return false" onCut="return false" onDrag="return false" onDrop="return false" autocomplete=off placeholder='<%=pageContext.getAttribute("prompt") %>'
                                                          onkeypress="return event.keyCode != 13;"/>
                                            </li>
                                            <li>
                                                <button id="smsotpsubmit" type="button" onclick="sendsiSMSOTP('<%=sessionDataKey%>');"  class="btn btn--outline btn--large btn--full" >
                                                    <fmt:message key='common-button-misc-submit'/>
                                                </button>
                                            </li>
                                        </ul>
                                    </div>

                        		<a onclick="handleTermination(true);" class="btn btn--outline btn--full btn--large">
                        			<fmt:message key='common-button-misc-cancel'/>
                        		</a>
                        		<div>
                                    <p class="page-footer-message"><fmt:message key='waiting-label-continue-on-device-success-before-timeout-phase1'/><br><fmt:message key='waiting-label-continue-on-device-success-before-timeout-phase2'/></p>
                                </div>
                        	</main>
                        <!--</script>-->
                        <script src="../js/sha256.js"></script>
                        <script type="text/javascript">
                        	var error_messages = {
                        	  invalid: '<fmt:message key="waiting-label-continue-on-device-otp-invalid"/>',
                        	  mismatch: '<fmt:message key="waiting-label-continue-on-device-otp-mismatch"/>',
                        	  error_process: '<fmt:message key="waiting-label-continue-on-device-otp-error-process"/>'
                        	 };
                        </script>
                        <script src="../mcx-user-registration/js/waiting/existing-user/waiting.js"></script>

                    </div>
                </div>

            </div>
    </form>

</body>

</html>
