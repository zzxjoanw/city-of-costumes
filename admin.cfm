<cfparam name="url.user" default="">
<cfparam name="url.action" default="">

<cfif #session.userRights# neq "admin">
	<cflocation url="main.cfm">
	<cfabort>
</cfif>

<cfquery name="qViewUsers" datasource="cocdata">
	SELECT * FROM tblUsers;
</cfquery>

<cfquery name="qViewCostumesByUser" datasource="cocdata">
	SELECT * FROM tblCostumes WHERE userName = '#url.user#';
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>
<body>
	<cfif #url.action# eq "">
		<table>
    		<tr><td>ID</td><td>Global</td><td>Email</td><td>Pass</td><td>Delete</td></tr>
			<cfoutput query="qViewUsers">
	        <tr>
            	<td>#qViewUsers.userID#</td>
                <td><a href="admin.cfm?action=ViewCostumesByUser&user=#qViewUsers.userGlobal#">#qViewUsers.userGlobal#</a></td>
                <td>#qViewUsers.userEmail#</td><td>#qViewUsers.userPassword#</td>
                <td>
                	<form name="" action="" method="">
	                	<input type="radio" name="deleteCheck" value="yes" />Y
    	                <input type="radio" name="deleteCheck" value="no" checked="checked" />N
        	            <input type="submit" name="bttnDeleteCheck" value="Delete" />
                    </form>
                </td>
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
                	<form name="" action="" method="">
	                	<input type="radio" name="deleteCheck" value="yes" />Y
    	                <input type="radio" name="deleteCheck" value="no" checked="checked" />N
        	            <input type="submit" name="bttnDeleteCheck" value="Delete" />
                    </form>
                </td>
             </tr>
    	    </cfoutput>
	    </table>
    </cfif>
</body>
</html>