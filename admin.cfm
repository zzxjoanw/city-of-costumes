<cfparam name="url.user" default="">
<cfparam name="url.action" default="">
<cfparam name="form.bttnUserDeleteCheck" default="">
<cfparam name="form.bttnCostumeDeleteCheck" default="">
<cfparam name="session.userRights" default="">

<cfif #session.userRights# neq "admin">
	<cflocation url="main.cfm">
	<cfabort>
</cfif>

<cfquery name="qViewUsers" datasource="cocdata">
	SELECT DISTINCT userName FROM tblCostumes;
</cfquery>

<cfquery name="qViewCostumesByUser" datasource="cocdata">
	SELECT * FROM tblCostumes WHERE userName = '#url.user#';
</cfquery>

<cfif #form.bttnUserDeleteCheck# eq "Delete" AND #form.userDeleteCheck# eq "yes">
	<cfquery name="qDeleteUser" datasource="cocdata">
		DELETE FROM tblUsers WHERE userID = #form.userID#;
    </cfquery>
</cfif>

<cfif #form.bttnCostumeDeleteCheck# eq "Delete" AND #form.costumeDeleteCheck# eq "yes">
	<cfquery name="qDeleteCostume" datasource="cocdata">
		DELETE FROM tblCostumes WHERE costumeID = #form.costumeID#;
    </cfquery>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Admin Page</title>
</head>
<body>
	<cfif #url.action# eq "">
		<table>
    		<tr><td>ID</td><td>Delete</td></tr>
			<cfoutput query="qViewUsers">
            <cfif #qViewUsers.userName# eq "">
            	<cfset qViewUsers.userName = "Guest">
            </cfif>
	        <tr>
                <td><a href="admin.cfm?action=ViewCostumesByUser&user=#qViewUsers.userName#">#qViewUsers.userName#</a></td>
                <cfif #qViewUsers.userName# neq "Guest">
	                <td>
    	            	<form name="userMaintenance" action="admin.cfm" method="post">
        	            	<input type="hidden" name="userID" value="#qViewUsers.userName#" />
	        	        	<input type="radio" name="userDeleteCheck" value="yes" />Y
    	        	        <input type="radio" name="userDeleteCheck" value="no" checked="checked" />N
        	        	    <input type="submit" name="bttnUserDeleteCheck" value="Delete" />
	                    </form>
    	            </td>
                </cfif>
             </tr>
    	    </cfoutput>
	    </table>
    </cfif>
    
    <cfif #url.action# eq "ViewCostumesByUser">
    	<table border="1">
    		<tr>
            	<td>costume ID</td>
                <td>user Name</td>
                <td>costume File</td>
                <td>costume Gender</td>
                <td>costume Name</td>
                <td>costume ImageFile</td>
                <td>Delete</td>
             </tr>
			<cfoutput query="qViewCostumesByUser">
	        <tr>
            	<td>#qViewCostumesByUser.costumeID#</td>
                <td>#qViewCostumesByUser.userName#</td>
                <td><a href="#qViewCostumesByUser.costumeFile#"><img src="file-image.png" /></a></td>
                <td>#qViewCostumesByUser.costumeGender#</td>
                <td>#qViewCostumesByUser.costumeName#</td>
                <td><a href="#qViewCostumesByUser.costumeImageFile#"><img src="file-image.png" /></a></td>
                <td>
                	<form name="costumeMaintenance" action="admin.cfm" method="post">
                    	<input type="hidden" name="costumeID" value="#qViewCostumesByUser.costumeID#" />
	                	<input type="radio" name="costumeDeleteCheck" value="yes" />Y
    	                <input type="radio" name="costumeDeleteCheck" value="no" checked="checked" />N
        	            <input type="submit" name="bttnCostumeDeleteCheck" value="Delete" />
                    </form>
                </td>
             </tr>
    	    </cfoutput>
	    </table>
    </cfif>
</body>
</html>