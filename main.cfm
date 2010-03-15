<!---
to do:
	now:
		get tags working
		bring parser.cfm up to date for i16
		ensure that the filename checker is working properly (see line 156)
		disallow direct navigation to parser.cfm
	someday:
		add forums
--->



<!--- variable defs --->
<cfparam name="title" default="City of Costumes::Home">
<cfparam name="message" default="">
<cfparam name="rootDir" default="c:/coldfusion8/wwwroot/portfolio_site/city-of-costumes">

<cfparam name="url.action" default="">

<cfparam name="session.userName" default="Guest">
<cfparam name="session.isLoggedIn" default="false">
<cfparam name="session.css" default="hero">
<cfparam name="session.userRights" default="">

<cfparam name="form.userGlobal" default="">
<cfparam name="form.costumeGender" default="">
<cfparam name="form.costumeImageFile" default="">
<cfparam name="form.costumeTags" default="">
<cfparam name="form.searchByName" default="">

<cfparam name="form.bttnRegSubmit" default="">
<cfparam name="form.bttnLoginSubmit" default="">
<cfparam name="form.bttnNewSubmit" default="">
<cfparam name="form.bttnNewSubmitAnon" default="">
<cfparam name="form.bttnSubmitSearch" default="">

<cfset rootDir = GetBaseTemplatePath() />
<cfset costumeFileDest = rootDir & ExpandPath('/costumefiles')>
<cfset costumeImageFileDest = rootDir & ExpandPath('/costumeimagefiles')>

<!--- login form submitted --->
<cfif #form.bttnLoginSubmit# eq "Submit">
	<cfquery name="qLogin" datasource="cocdata">
    	SELECT * FROM tblUsers WHERE userGlobal = '#form.userGlobal#';
    </cfquery>
    <cfif #qLogin.userPassword# eq #form.userPassword#>
    	<cfset session.userName = #qLogin.userGlobal#>
        <cfset session.isLoggedIn = "true">
        <cfset session.userRights = #qLogin.userRights#>
        <cflocation url="main.cfm">
	</cfif>
</cfif>

<!--- Reg form submitted --->
<cfif #form.bttnRegSubmit# eq "Submit"> 
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

<!--- Search by Name query --->
<cfquery name="qSearchByCostumeName" datasource="cocdata">
	SELECT * FROM tblCostumes WHERE costumeName = '#form.searchByName#';
</cfquery>

<!--- View My Costumes query --->
<cfquery name="qViewMyCostumes" datasource="cocdata">
	SELECT * FROM tblCostumes WHERE userName = '#session.userName#';
</cfquery>

<!--- Add a New Costume While Logged In --->
<cfif #form.bttnNewSubmit# eq "Submit">
	<cfset message = "">
	<cfif #form.costumeFile# eq "" OR #form.costumeImageFile# eq "" OR #form.costumeGender# eq "" OR #form.costumeName# eq "" OR #form.costumeDescription# eq "">
        <cfset form.bttnNewSubmit = "">
    </cfif>
    
	<cfif #session.isLoggedIn# eq "true">
    	<cfset form.costumeFile = REreplace(form.costumeFile,"\{\}\<\>\:\;\(\)\[\]","")>
        <!--- characters to remove: {}<>:;()[]  --->
											
		<cftry>
	        <cffile action="upload" fileField="costumeFile" destination="#ExpandPath('costumefiles')#" nameConflict="overwrite" accept="application/octet-stream">
	        <cfcatch><cfset message &= "Costume file upload failed<br />"></cfcatch>
        </cftry>
        <cfif #cffile.serverExt# neq "costume">
	    	<cfset fullPath = #ExpandPath('costumefiles')# & #cffile.serverFileName# & #cffile.serverFileExt#>
    		<cffile action="delete" file="#fullPath#">
	    </cfif>

        <cftry>
        	<cffile action="upload"
            		filefield="costumeImageFile"
                    destination="#ExpandPath('costumeimagefiles')#"
                    nameconflict="makeunique"
            		accept="image/jpeg,image/jpg,image/tga,image/x-tga,image/targa,image/x-targa">
            <cfcatch><cfset message &= "Image upload failed<br />"></cfcatch>
        </cftry>
        <cfif #cffile.serverExt# neq "jpg" AND #cffile.serverExt# neq "jpeg" AND #cffile.serverExt# neq "tga">
    		<cfset fullPath = #ExpandPath('costumeimagefiles')# & #cffile.serverFileName# & #cffile.serverFileExt#>
    		<cffile action="delete" file="#fullPath#">
	    </cfif>
		
        <cfif form.costumeGender eq "">
        	<cfset message &= "no gender<br>">
        </cfif>
        <cfif form.costumeName eq "">
        	<cfset message &= "no name<br>">
        </cfif>
        <cfif form.costumeDescription eq "">
        	<cfset message &= "no desc<br>">
        </cfif>
        
        <cfinclude template="parser.cfm"> <!--- separate file for easier maintenance --->

    	<cftransaction>
           	<cftry>
				<cfquery name="qAddCostume" datasource="cocdata">
			    	INSERT INTO tblCostumes (userName, costumeFile, costumeImageFile, costumeGender, costumeName, costumeDescription, costumeRequirements)
   				    VALUES ('#session.userName#','#form.costumeFile#','#costumeImageFile#','#form.costumeGender#','#form.costumeName#','#form.costumeDescription#','#costumeRequirements#')
    			</cfquery>
		    	<cfcatch><cfset message &= "One or more fields were not filled out.<br>"></cfcatch>
			</cftry>
            
            <cfquery name="qGetLastRecordID" datasource="cocdata">
            	SELECT @@IDENTITY AS newID; <!--- returns the last inserted primary key value --->
            </cfquery>
            
            <cfif #form.costumeTags# neq ""> <!--- add tags to db --->
				<cfset costumeTagsArray = ListToArray(form.costumeTags)>
                <cfloop index="i" from="1" to="#ArrayLen(costumeTagsArray)#">
	    			<cfquery name="qAddTag" datasource="cocdata">
  		    			INSERT INTO tblTags (costumeID, tagText)
	    	    	    VALUES ('#qGetLastRecordID.newID#','#costumeTagsArray[i]#')
    			    </cfquery>
                </cfloop>
            </cfif>
       	</cftransaction>
    </cfif>

<!--- Add a New Costume Anonymously --->
<cfelseif #form.bttnNewSubmitAnon# eq "Submit">
	<cfset message = "">
   	<cfif #form.costumeFile# eq "" OR #form.costumeImageFile# eq "" OR #form.costumeGender# eq "" OR #form.costumeName# eq "" OR #form.costumeDescription# eq "">
        <cfset form.bttnNewSubmitAnon = "">
    </cfif>

  	<cfset form.costumeFile = REreplace(form.costumeFile,"\{\}\<\>\:\;\(\)\[\]","")> <!--- will this keep checking until all characters are removed? --->
    <!--- characters to remove: {}<>:;()[]  --->
    <!--- a windows file cannot contain :<> --->
   
	<cftry>
        <cffile action="upload" fileField="costumeFile" destination="#ExpandPath('costumefiles')#" nameConflict="overwrite" accept="application/octet-stream">
        <cfcatch><cfset message &= "Costume file upload failed<br />"></cfcatch>
    </cftry>
    <cfif #cffile.serverFileExt# neq "costume">
    	<cfset fullPath = #ExpandPath('costumefiles\')# & #cffile.serverFileName# & "." & #cffile.serverFileExt#>
    	<cffile action="delete" file="#fullPath#">
    </cfif>
        
    <cftry>
       	<cffile action="upload"
           		filefield="costumeImageFile"
                destination="#ExpandPath('costumeimagefiles')#"
                nameconflict="makeunique"
          		accept="image/jpeg,image/jpg,image/tga,image/x-tga,image/targa,image/x-targa">
        <cfcatch><cfset message &= "Image upload failed<br />"></cfcatch>
    </cftry>
    <cfif #cffile.serverFileExt# neq "jpg" AND #cffile.serverFileExt# neq "jpeg" AND #cffile.serverFileExt# neq "tga">
  		<cfset fullPath = #ExpandPath('costumeimagefiles')# & #cffile.serverFileName# & #cffile.serverFileExt#>
   		<cffile action="delete" file="#fullPath#">
    </cfif>

    <cfif form.costumeGender eq "">
       	<cfset message &= "no gender<br>">
    </cfif>
    <cfif form.costumeName eq "">
       	<cfset message &= "no name<br>">
    </cfif>
    <cfif form.costumeDescription eq "">
       	<cfset message &= "no desc<br>">
    </cfif>
    
    <cfinclude template="parser.cfm"> <!--- separate file for easier maintenance --->

	<cftransaction>
		<cftry>
			<cfquery name="qAddCostumeAnon" datasource="cocdata">
	    		INSERT INTO tblCostumes (userName, costumeFile, costumeGender, costumeName, costumeDescription, costumeRequirements)
	   		    VALUES ('#session.userName#','#form.costumeFile#','#form.costumeGender#','#form.costumeName#','#form.costumeDescription#','#costumeRequirements#')
    		</cfquery>
			<cfcatch>One or more fields were not filled out.</cfcatch>
    	</cftry>
    	
    	<cfquery name="qGetLastRecordID" datasource="cocdata">
    		SELECT @@IDENTITY AS newID; <!--- returns the last inserted primary key value --->
	    </cfquery>

        <cfif #form.costumeTags# neq ""> <!--- add tags to db --->
			<cfset costumeTagsArray = ListToArray(form.costumeTags)>
            <cfloop index="i" from="1" to="#ArrayLen(costumeTagsArray)#">
             	<cfquery name="qAddTag" datasource="cocdata">
  	    			INSERT INTO tblTags (costumeID, tagText)
	   	    	    VALUES ('#qGetLastRecordID.newID#','#costumeTagsArray[i]#');
    		    </cfquery>
            </cfloop>
        </cfif>
    </cftransaction>
</cfif>

<!--- set the menu --->
<cfif #session.isLoggedIn# eq "true">
	<cfif #session.userRights# eq "admin">
    	<cfset menuText = "[ <a href='main.cfm?action=logout'>Logout</a> | <a href='main.cfm?action=new'>Add New Costume</a> | <a href='main.cfm?action=view'>View My Costumes</a> | <a href='main.cfm?action=search'>Search</a> | <a href='admin.cfm'>Admin</a>]">
     <cfelse>
		<cfset menuText = "[ <a href='main.cfm?action=logout'>Logout</a> | <a href='main.cfm?action=new'>Add New Costume</a> | <a href='main.cfm?action=view'>View My Costumes</a> | <a href='main.cfm?action=search'>Search</a> ]">
	</cfif>        
<cfelse>
	<cfset menuText = "[ <a href='main.cfm?action=register'>Register</a> | <a href='main.cfm?action=login'>Login</a> | <a href='main.cfm?action=new'>Add New Costume</a> | <a href='main.cfm?action=search'>Search</a> ]">
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

<!--- display a random costume --->
<cfquery datasource="cocdata" name="qGetRandomCostume">
	SELECT costumeID FROM tblCostumes;
</cfquery>
                
<cfif qGetRandomCostume.recordCount>
	<cfset showNum = 1>
	<cfset itemList = "">
					
	<cfloop from="1" to="#qGetRandomCostume.recordCount#" index="i">
		<cfset itemList = ListAppend(itemList, i)>
	</cfloop>
					
	<cfset randomItems = "">
	<cfset itemCount = listLen(itemList)>
					
	<cfloop from="1" to="#itemCount#" index="i">
		<cfset random = ListGetAt(itemList, RandRange(1, itemCount))>
		<cfset randomItems = ListAppend(randomItems, random)>
		<cfset itemList = ListDeleteAt(itemList, ListFind(itemList, random))>
		<cfset itemCount = ListLen(itemList)>
	</cfloop>
					
	<cfloop from="1" to="#showNum#" index="i">
		<cfset randCostumeNum = #qGetRandomCostume.costumeID[ListGetAt(randomItems, i)]#>
	</cfloop>
                    
	<cfquery datasource="cocdata" name="qGetRandomCostumeByID">
		SELECT * FROM tblCostumes WHERE costumeID = #randCostumeNum#;
	</cfquery>
</cfif>

<!--- clientside output --->
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<cfoutput>
    	<title>#title#</title>
        <link rel="stylesheet" href="coc.css" /><!-- formatty stuff -->
    	<!---<link rel="stylesheet" href="#session.css#.css" /><!-- theme --> --->
	</cfoutput>
	<link rel="icon" type="image/gif" href="favicon.gif" /> <!-- firefox, opera -->
    <link rel="SHORTCUT ICON" href="favicon.gif"/> <!-- ie -->
</head>

<body>
	<div id="userInfo">
    	<cfif #session.userName# eq "">
        	<span class="left"><cfoutput>Welcome, Guest!</cfoutput></span>
        <cfelse>
	    	<span class="left"><cfoutput>Welcome, #session.userName#!</cfoutput></span>
        </cfif>
        <span class="right"><cfoutput>#menuText#</cfoutput></span>
    </div>
    <div id="contentFrame">
	    <cfswitch expression="#url.action#">
        
<!--- login section --->
    		<cfcase value="login"> <!--- url.action = login --->
            	<cfif #form.bttnLoginSubmit# eq ""> <!--- login form --->
	            	<cfform name="" action="main.cfm?action=login" method="post">
    	            	<table>
        	            	<tr><td>Account Name:</td><td><cfinput type="text" name="userGlobal" value=""></td></tr>
            	            <tr><td>Password:</td><td><cfinput type="password" name="userPassword" value=""></td></tr>
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
            	<cfoutput>#message#</cfoutput>
            	<cfif #form.bttnNewSubmit# eq "" OR #form.bttnNewSubmitAnon# eq "">
					<cfform name="" action="main.cfm?action=new" method="post" enctype="multipart/form-data">
    	   	           	<table border="0">
                        	<tr><td>Upload Costume File:</td><td><input type="file" name="costumeFile" value="" />
                            <tr><td>Upload Screenshot:</td><td><input type="file" name="costumeImageFile" value="">
        	   	          	<tr>
                            	<td>Gender</td>
                                <td>
                                	<input type="radio" name="costumeGender" value="male" /> Male
                                	<input type="radio" name="costumeGender" value="female" checked /> Female
                                    <input type="radio" name="costumeGender" value="huge" /> Huge
                                </td>
                            </tr>
            	   	        <tr><td>Costume Name</td><td><input type="text" name="costumeName" value="test" /></td></tr>
                	   		<tr><td valign="top">Description</td><td><textarea name="costumeDescription" rows="5" cols="50">test</textarea></td></tr>
                            <tr><td valign="top">Tags (separated by commas)</td><td><input type="text" name="costumeTags" size="50"></td></tr>
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

<!--- search section--->
            <cfcase value="search">
            	<cfif bttnSubmitSearch eq "">
                	<br>
                	<fieldset >
	            	<cfform name="" action="main.cfm?action=search" method="post">
		            	Search by:<br>
    		            Costume Name:<input type="text" name="searchByName"><br>
        		        Tag: <input type="text" name="searchTag" size="20" maxlength="20"><input type="submit" value="Submit" name="bttnSubmitSearch">
	                </cfform>
                    </fieldset>
                <cfelse>
                	<table>
                    	<tr><td>ID</td><td>Username</td><td>file</td><td>Gender</td><td>Reqs</td><td>Name</td><td>Image</td></tr>
                	<cfoutput query="qSearchByCostumeName">
                    	<tr>
                        	<td>#costumeID#</td><td>#userName#</td>
                            <td><a href="#costumeFile#"><img src="file-image.PNG"></a></td>
                            <td>#costumeGender#</td><td>#costumeRequirements#</td>
                            <td>#costumeName#</td><td>IMage</td>
                        </tr>
                    </cfoutput>
	                </table>
                </cfif>
	        </cfcase>

            <cfcase value="style">
            </cfcase>
<!--- end search section --->

<!--- logout section --->
			<cfcase value="logout">
            	<cfset session.userName = "">
                <cfset session.isLoggedIn = "false">
                <cflocation url="main.cfm">
            </cfcase>
<!--- end logout section --->

<!--- view my costumes --->
			<cfcase value="view">
                	<table>
                    	<tr><td>ID</td><td>Username</td><td>file</td><td>Gender</td><td>Reqs</td><td>Name</td><td>Image</td></tr>
	                	<cfoutput query="qViewMyCostumes">
    	                	<tr><td>#costumeID#</td><td>#userName#</td><td><a href="#costumeFile#">link</a></td><td>#costumeGender#</td><td>#costumeRequirements#</td><td>#costumeName#</td><td><img src="#costumeImageFile#" /></td></tr>
        	            </cfoutput>
	                </table>
            </cfcase>
<!--- end of view section --->

<!--- start page -- display a random costume --->
            <cfdefaultcase>
                <cfoutput>
                   	ID: #qGetRandomCostumeByID.costumeID#<br>
                    Name: #qGetRandomCostumeByID.costumeName#<br />
                    Gender: #qGetRandomCostumeByID.costumeGender#<br>
                    Image:<img src="#qGetRandomCostumeByID.costumeImageFile#"><br>
                    File:<a href="#qGetRandomCostumeByID.costumeFile#"><img src="file-image.PNG" /></a><br>
                    Reqs:#qGetRandomCostumeByID.costumeRequirements#<br>
                </cfoutput>
            </cfdefaultcase>
    	</cfswitch>
<!--- end start page section --->        
    </div>
</body>
</html>
