<cfparam name="title" default="City of Costumes::Home">
<cfparam name="message" default="">

<cfparam name="url.action" default="">

<cfparam name="session.userName" default="Guest"> 
<cfparam name="session.isLoggedIn" default="false">
<cfparam name="session.css" default="hero">

<cfparam name="form.userGlobal" default="">
<cfparam name="form.bttnRegSubmit" default="">
<cfparam name="form.bttnLoginSubmit" default="">

<cfif #form.bttnLoginSubmit# eq "Submit"> <!--- login form submitted --->
	<cfquery name="qLogin" datasource="cocdata">
    	SELECT * FROM tblUsers WHERE userGlobal = '#form.userGlobal#';
    </cfquery>
    <cfif #qLogin.userPassword# eq #form.userPassword#>
    	<cfset session.userName = #qLogin.userGlobal#>
        <cfset session.isLoggedIn = "true">
	</cfif>
</cfif>

<cfif #form.bttnRegSubmit# eq "Submit"> <!--- Reg form submitted --->
	<cfquery name="qUserCheck" datasource="cocdata">
		SELECT userGlobal FROM tblUsers WHERE userGlobal = '#form.userGlobal#';
	</cfquery>
	<cfif #qUserCheck.recordCount# eq 0>
		<cfquery name="qAddUser" datasource="cocdata">
			INSERT INTO tblUsers (userGlobal, userEmail, userPassword, userStyle)
			VALUES ('#form.userGlobal#', '#form.userEmail#', '#form.userPassword#', 'Hero');
		</cfquery>
		<cfset message = "add user to dbase">
	<cfelse>
		<cfset message = "user already exists">
	</cfif>
</cfif>

<!--- set the menu --->
<cfif #session.isLoggedIn# eq "true">
	<cfset menuText = "[ <a href='main.cfm?action=logout'>Logout</a> | <a href='add.cfm'>Add New Costume</a> | View My Costumes | Search | Change Style ]">
<cfelse>
	<cfset menuText = "[ <a href='main.cfm?action=register'>Register</a> | <a href='main.cfm?action=login'>Login</a> | 
						<a href='main.cfm?action=new'>Add New Costume</a> | Search ]">
</cfif>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
    	<title>City of Costumes::Add New Costume</title>
    	<link rel="stylesheet" href="#session.css#.css" />
	</cfoutput>
	<link rel="icon" type="image/gif" href="favicon.gif" /> <!-- firefox, opera -->
    <link rel="SHORTCUT ICON" href="favicon.gif"/> <!-- ie -->
</head>

<body>
	<div id="userInfo">
    	<span class="left"><cfoutput>Welcome, #session.userName#!</cfoutput></span>
        <span class="right"><cfoutput>#menuText#</cfoutput></span>
    </div>
</body>
</html>