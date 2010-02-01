<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<cfquery name="qViewUsers" datasource="cocdata">
	SELECT * FROM tblUsers;
</cfquery>
<body>
	<table>
    	<tr><td>ID</td><td>Global</td><td>Email</td><td>Pass</td></tr>
		<cfoutput query="qViewUsers">
        <tr><td>#qViewUsers.userID#</td><td>#qViewUsers.userGlobal#</td><td>#qViewUsers.userEmail#</td><td>#qViewUsers.userPassword#</td></tr>
        </cfoutput>
    </table>
</body>
</html>