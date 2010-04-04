<cfparam name="url.user" default="">
<cfparam name="url.action" default="">
<cfparam name="url.ID" default="0">
<cfparam name="form.bttnUserDeleteCheck" default="">
<cfparam name="form.bttnCostumeDeleteCheck" default="">
<cfparam name="session.userRights" default="">

<cfif #session.userRights# neq "admin">
	<cflocation url="main.cfm">
	<cfabort>
</cfif>

<cfquery name="qViewUsers" datasource="cocdata">
	SELECT DISTINCT userName FROM #code#_tblCostumes;
</cfquery>

<cfquery name="qViewCostumesByUser" datasource="cocdata">
	SELECT * FROM #code#_tblCostumes WHERE userName = '#url.user#';
</cfquery>

<cfquery name="qSearchByCostumeTags" datasource="cocdata">
	SELECT * FROM #code#_tblTags WHERE costumeID = #url.ID#;
</cfquery>

<cfif #form.bttnUserDeleteCheck# eq "Delete" AND #form.userDeleteCheck# eq "yes">
	<cfquery name="qDeleteUser" datasource="cocdata">
		DELETE FROM #code#_tblUsers WHERE userID = #form.userID#;
    </cfquery>
</cfif>

<cfif #form.bttnCostumeDeleteCheck# eq "Delete" AND #form.costumeDeleteCheck# eq "yes">
	<cfquery name="qDeleteCostume" datasource="cocdata">
		DELETE FROM #code#_tblCostumes WHERE costumeID = #form.costumeID#;
    </cfquery>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Admin Page</title>
    <script language="javascript">
		function stretchControl(myImage)
		{
			var width = -1, height = -1, widthPercentScale, heightPercentScale;
			getImageWidth(myImage);
			getImageHeight(myImage);
			
			if (width > 400)<!--- if width is 500 --->
	        {
    	    	widthPercentScale = 400/width; <!--- wps = 0.8 --->
        	}

			if (height > 300) <!--- if width is 400 --->
    	    {
        	   	heightPercentScale = 300/height; <!--- hps = 0.75 --->
			}
                
			if (widthPercentScale > heightPercentScale)
			{
				width = width * widthPercentScale;
				height = height * widthPercentScale;
			}
			else
			{
				width = width * heightPercentScale;
				height = height * heightPercentScale;
			}
		}
                        
    	function getImageWidth(myImage)
        {
			var x, obj;

			if (document.layers)
            {
				var img = getImage(myImage);
				width = img.width;
			}
            else
            {
				width = getElementWidth(myImage);
			}
			return 0;
		}

		function getImageHeight(myImage)
        {
			var y, obj;

			if (document.layers)
            {
				var img = getImage(myImage);
				height = img.height;
			}
            else
            {
				height = getElementHeight(myImage);
			}
			return 0;
		}
	</script>
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
                <td><a href="peppermint.cfm?action=ViewCostumesByUser&user=#qViewUsers.userName#">#qViewUsers.userName#</a></td>
                <cfif #qViewUsers.userName# neq "Guest">
	                <td>
    	            	<form name="userMaintenance" action="peppermint.cfm" method="post">
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
    <cfelseif #url.action# eq "ViewCostumesByUser">
    	<table border="1">
    		<tr>
            	<td>costume ID</td>
                <td>user Name</td>
                <td>costume File</td>
                <td>costume Gender</td>
                <td>costume Name</td>
                <td>costume ImageFile</td>
                <td>Tag Admin</td>
                <td>Delete</td>
             </tr>
			<cfoutput query="qViewCostumesByUser">
	        <tr>
            	<td>#qViewCostumesByUser.costumeID#</td>
                <td>#qViewCostumesByUser.userName#</td>
                <td><a href="#qViewCostumesByUser.costumeFile#"><img src="images/file-image.png" /></a></td>
                <td>#qViewCostumesByUser.costumeGender#</td>
                <td>#qViewCostumesByUser.costumeName#</td>
                <script language="javascript">
					stretchControl(#costumeImageFile#);
				</script>
                <td><a href="#costumeImageFile#"><img src="#costumeImageFile#" height="document.write(height);" width="document.write(width)"></a></td>
                <td><a href="peppermint.cfm?action=ViewCostumeTagsByID&ID=#qViewCostumesByUser.costumeID#">View Tags</a></td>
                <td>
                	<form name="costumeMaintenance" action="peppermint.cfm" method="post">
                    	<input type="hidden" name="costumeID" value="#qViewCostumesByUser.costumeID#" />
	                	<input type="radio" name="costumeDeleteCheck" value="yes" />Y
    	                <input type="radio" name="costumeDeleteCheck" value="no" checked="checked" />N
        	            <input type="submit" name="bttnCostumeDeleteCheck" value="Delete" />
                    </form>
                </td>
             </tr>
    	    </cfoutput>
	    </table>
    <cfelseif #url.action# eq "ViewCostumeTagsByID">
    	<form name="" action="" method="post">
        	<table>
            	<tr><td>ID</td><td>Tags</td><td>Delete?</td></tr>
		    	<cfoutput query="qSearchByCostumeTags">
	                <tr><td>#qSearchByCostumeTags#</td><td>#qSearchByCostumeTags.tagText#<br /></td><td>#qSearchByCostumeTags#</td></tr>
				</cfoutput>
            </table>
        </form>
    </cfif>
</body>
</html>