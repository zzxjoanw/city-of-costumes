<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Webmarks::Login</title>
    <link rel="stylesheet" href="coc.css" />
	<link rel="icon" type="image/gif" href="favicon.gif" /> <!-- firefox, opera -->
    <link rel="SHORTCUT ICON" href="favicon.gif"/> <!-- ie -->
</head>

<cfparam name="userName" default="Guest">
<cfparam name="isLoggedIn" default="false">

<cfif #isLoggedIn# is "true">
	<cfset menuText = "[ Logout | Add New Costume | View My Costumes | Search ]">
<cfelse>
	<cfset menuText = "[ Register | <a href='main.cfm?action=login'>Login</a> | Add New Costume | Search ]">
</cfif>

<body>
	<div id="userInfo">
    	<span class="left"><cfoutput>Welcome, #userName#!</cfoutput></span>
        <span class="right"><cfoutput>#menuText#</cfoutput></span>
    </div>
    <div id="costumeFrame"></div>
</body>
</html>