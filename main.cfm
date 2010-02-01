<cfparam name="title" default="City of Costumes::Home">
<cfparam name="message" default="">

<cfparam name="url.action" default="">

<cfparam name="session.userName" default="Guest">
<cfparam name="session.isLoggedIn" default="false">
<cfparam name="session.css" default="hero">

<cfparam name="form.userGlobal" default="">
<cfparam name="form.bttnRegSubmit" default="">
<cfparam name="form.bttnLoginSubmit" default="">
<cfparam name="form.bttnNewSubmit" default="">
<cfparam name="form.bttnNewSubmitAnon" default="">

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

<cfif #form.bttnNewSubmit# eq "Submit"> <!--- Costume form submitted by a logged-in user --->
	<cfif #session.isLoggedIn# eq "true">
        <cffile action = "upload" fileField = "costumeFile" destination = "costumes/" nameConflict = "error" accept = "application/octet-stream">
        <cfoutput>ext: #cffile.serverFileExt#</cfoutput>
		<cfquery name="qAddCostume" datasource="cocdata">
        	INSERT INTO tblCostume
    	</cfquery>
    </cfif>
<cfelseif #form.bttnNewSubmitAnon# eq "Submit"> <!--- Costume form submitted by a non-logged-in user --->
	<cfquery name="qAddCostumeAnon" datasource="cocdata">
    </cfquery>
</cfif>

<!--- set the menu --->
<cfif #session.isLoggedIn# eq "true">
	<cfset menuText = "[ <a href='main.cfm?action=logout'>Logout</a> | <a href='main.cfm?action=new'>Add New Costume</a> | View My Costumes | Search | Change Style ]">
<cfelse>
	<cfset menuText = "[ <a href='main.cfm?action=register'>Register</a> | <a href='main.cfm?action=login'>Login</a> | 
						<a href='main.cfm?action=new'>Add New Costume</a> | Search ]">
</cfif>

<!--- set the title --->
<cfswitch expression="#url.action#">
   	<cfcase value="login">
		<cfset #title# = "City of Costumes::Login">
    </cfcase>
    <cfcase value="register">
       	<cfset #title# = "City of Costumes::Register">
    </cfcase>
    <cfcase value="new">
       	<cfset #title# = "City of Costumes::Add New Costume">
    </cfcase>
    <cfcase value="search">
       	<cfset #title# = "City of Costumes::Search">
    </cfcase>
    <cfcase value="style">
       	<cfset #title# = "City of Costumes::Change Style">
    </cfcase>
</cfswitch>





<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
    	<title>#title#</title>
        <link rel="stylesheet" href="coc.css" /><!-- formatty stuff -->
    	<link rel="stylesheet" href="#session.css#.css" /><!-- theme -->
	</cfoutput>
	<link rel="icon" type="image/gif" href="favicon.gif" /> <!-- firefox, opera -->
    <link rel="SHORTCUT ICON" href="favicon.gif"/> <!-- ie -->
</head>

<body>
	<div id="userInfo">
    	<span class="left"><cfoutput>Welcome, #session.userName#!</cfoutput></span>
        <span class="right"><cfoutput>#menuText#</cfoutput></span>
    </div>
    <div id="contentFrame">
	    <cfswitch expression="#url.action#">
        
<!--- login section --->
    		<cfcase value="login"> <!--- url.action = login --->
            	<cfif #form.bttnLoginSubmit# eq ""> <!--- login form --->
	            	<cfform name="" action="main.cfm?action=login" method="post">
    	            	<table>
        	            	<tr><td>Account Name:</td><td><cfinput type="text" name="userGlobal" value="@"></td></tr>
            	            <tr><td>Password:</td><td><cfinput type="text" name="userPassword"></td></tr>
                	        <tr><td colspan="3"><cfinput type="submit" value="Submit" name="bttnLoginSubmit"></td></tr>
                    	</table>
	                </cfform>
                </cfif>
	        </cfcase>
<!--- end login section --->

<!--- registration section --->
    	    <cfcase value="register"> <!--- url.action = register --->
            	<cfif #form.bttnRegSubmit# eq ""> <!--- reg form --->
					<cfform name="" action="main.cfm?action=register" method="post">
                    	<table>
                        	<tr><td>Account Name:</td><td><cfinput type="text" name="userGlobal" value="@"></td><td> This should match your in-game global.</td></tr>
                        	<tr><td>Email:</td><td><cfinput type="text" name="userEmail"></td></tr>
                        	<tr><td>Password:</td><td><cfinput type="text" name="userPassword"></td></tr>
                        	<tr><td colspan="3"><cfinput type="submit" value="Submit" name="bttnRegSubmit"></td></tr>
                        </table>
					</cfform>
                <cfelse> <!--- form submitted --->
					<cfoutput>#message#</cfoutput>
                </cfif>
	        </cfcase>
<!--- end registration section --->

<!--- new costume section --->
            <cfcase value="new">
            	<cfif #form.bttnNewSubmit# eq "" OR #form.bttnNewSubmitAnon# eq "">
					<cfform name="" action="main.cfm?action=new" method="post" enctype="multipart/form-data">
    	   	           	<table border="0">
                        	<tr><td>Upload Costume File:</td><td><input type="file" name="costumeFile" value="" />
        	   	          	<tr><td>Gender</td><td><input type="radio" name="gender" value="male" /> Male <input type="radio" name="gender" value="female" /> Female <input type="radio" name="gender" value="huge" /> Huge </td></tr>
            	   	        <tr><td>Costume Name</td><td><input type="text" name="costumeName" value="" /></td></tr>
                	   		<tr><td valign="top">Description</td><td><textarea name="costumeDescription" rows="5" cols="50"></textarea></td></tr>
		            		<cfif #session.isLoggedIn# eq "true"> <!--- is user logged in? --->
								<tr><td colspan="2" align="center"><input type="submit" value="Submit" name="bttnNewSubmit" /></td></tr>
                	        <cfelse>
            	               	<tr><td colspan="2" align="center"><input type="submit" value="Submit" name="bttnNewSubmitAnon" /></td></tr>
        	                </cfif>
    	               	</table>
	                </cfform>
                </cfif>
	        </cfcase>
<!--- end new costume section --->

            <cfcase value="search">
	        </cfcase>

            <cfcase value="style">
            </cfcase>

<!--- logout section --->
			<cfcase value="logout">
            	<cfset session.userName = "">
                <cfset session.isLoggedIn = "false">
            </cfcase>
<!--- end logout section --->

            <cfdefaultcase>
            	<!-- show a random costume -->
            </cfdefaultcase>
    	</cfswitch>
    </div>
</body>
</html>