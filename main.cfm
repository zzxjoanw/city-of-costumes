<!---
to do:
	now:
		bring parser.cfm up to date for i16
		(no new pieces in i17)
		ensure that the filename checker is working properly (see line 156)
		add a tag cloud to the search page
		make image uploads optional
		add default image
	from VT:
		WORKS DONE add description to start page so people know what they're looking at
		WORKS DONE add a search-by-user function for regular users
		WORKS DONE registration section: add a password confirmation field
		WORKS DONE add a list of valid image formats
		WORKS DONE search function should work on partial strings
		DONE prevent image stretching
	someday:
		implement css style selection
		add forums
--->

<!--- variable defs --->
<cfparam name="title" default="City of Costumes::Home">
<cfparam name="message" default=""> <!--- various error messages --->
<cfparam name="output" default=""> <!--- testing stuff --->

	<!--- image scaling --->
    <cfparam name="width" default="">
    <cfparam name="height" default="">
	<cfparam name="widthPercentScale" default="">
	<cfparam name="heightPercentScale" default="">
    
<cfparam name="url.action" default="">

<cfparam name="session.userGlobal" default="Guest">
<cfparam name="session.isLoggedIn" default="false">
<cfparam name="session.css" default="hero">
<cfparam name="session.userRights" default="">

<cfparam name="form.userGlobal" default="">
<cfparam name="form.costumeImageFile" default="">
<cfparam name="form.costumeTags" default=""> <!--- new costume form (both): comma-delimited tag list --->
<cfparam name="form.searchByName" default=""> <!--- costume search form: costume name --->
<cfparam name="form.searchByTag" default=""> <!--- costume search form: tag --->
<cfparam name="form.searchByUser" default=""> <!--- costume search form: user --->

<cfparam name="form.bttnRegSubmit" default=""> <!--- user registration --->
<cfparam name="form.bttnLoginSubmit" default=""> <!--- user login --->
<cfparam name="form.bttnNewSubmit" default=""> <!--- new costume form (reg'd user): add new costume --->
<cfparam name="form.bttnNewSubmitAnon" default=""> <!--- new costume form (anon user): add new costume --->
<cfparam name="form.bttnSubmitSearchByName" default=""> <!--- costume search form: search by name --->
<cfparam name="form.bttnSubmitSearchByTag" default=""> <!--- costume search form: search by tag --->
<cfparam name="form.bttnSubmitSearchByUser" default=""> <!--- costume search form: search by user --->

<cfset costumeFileDest = ExpandPath('./costumefiles')>
<cfset costumeImageDest = ExpandPath('./costumeimages')>

<!--- set the menu --->
<cfif #session.isLoggedIn# eq "true">
	<cfif #session.userRights# eq "admin">
    	<cfset menuText = "[ <a href='main.cfm?action=logout'>Logout</a> | <a href='main.cfm?action=new'>Add New Costume</a> | <a href='main.cfm?action=view'>View My Costumes</a> | <a href='main.cfm?action=search'>Search</a> | <a href='peppermint.cfm'>Admin</a>]">
	<cfelse>
		<cfset menuText = "[ <a href='main.cfm?action=logout'>Logout</a> | <a href='main.cfm?action=new'>Add New Costume</a> | <a href='main.cfm?action=view'>View My Costumes</a> | <a href='main.cfm?action=search'>Search</a> ]">
	</cfif>
<cfelse>
	<cfset menuText = "[ <a href='main.cfm?action=register'>Register</a> | <a href='main.cfm?action=login'>Login</a> | <a href='main.cfm?action=new'>Add New Costume</a> | <a href='main.cfm?action=search'>Search</a> ]">
</cfif>

<!--- login form submitted --->
<cfif #form.bttnLoginSubmit# eq "Submit">
	<cfquery name="qLogin" datasource="cocdata">
    	SELECT * FROM #code#_tblUsers WHERE userGlobal = '#form.userGlobal#';
    </cfquery>
    <cfif #qLogin.userPassword# eq #form.userPassword#>
    	<cfset session.userGlobal = #qLogin.userGlobal#>
        <cfset session.isLoggedIn = "true">
        <cfset session.userRights = #qLogin.userRights#>
        <cflocation url="main.cfm">
	</cfif>
</cfif>

<!--- Reg form submitted --->
<cfif #form.bttnRegSubmit# eq "Submit">
   	<cfif #form.userPassword# neq #form.userPasswordConfirm#>
       	<cfset message = "Passwords do not match">
        <cfabort>
    </cfif>
	<cfquery name="qUserCheck" datasource="cocdata">
		SELECT userGlobal FROM #code#_tblUsers WHERE userGlobal = '#form.userGlobal#';
	</cfquery>
	<cfif #qUserCheck.recordCount# eq 0>
		<cfquery name="qAddUser" datasource="cocdata">
			INSERT INTO #code#_tblUsers (userGlobal, userEmail, userPassword, userStyle)
			VALUES ('#form.userGlobal#', '#form.userEmail#', '#form.userPassword#', 'Hero');
		</cfquery>
	<cfelse>
		<cfset message = "That username is already in use.">
	</cfif>
</cfif>

<!--- Search by Name query --->
<cfquery name="qSearchByCostumeName" datasource="cocdata">
	SELECT * FROM #code#_tblCostumes WHERE costumeName LIKE '%#form.searchByName#%';
</cfquery>

<!--- Search by Tags query --->
<cfquery name="qSearchByCostumeTags" datasource="cocdata">
	SELECT * FROM #code#_tblCostumes WHERE costumeID IN (SELECT costumeID FROM #code#_tblTags WHERE tagText = '#form.searchByTag#');
</cfquery>

<!--- Search by User query --->
<cfquery name="qSearchByUser" datasource="cocdata">
	SELECT * FROM #code#_tblCostumes WHERE userName LIKE '%#form.searchByUser#%';
</cfquery>

<!--- View My Costumes query --->
<cfquery name="qViewMyCostumes" datasource="cocdata">
	SELECT * FROM #code#_tblCostumes WHERE userName = '#session.userGlobal#';
</cfquery>

<!--- Add a New Costume --->
<cfif #form.bttnNewSubmit# eq "Submit" OR #form.bttnNewSubmitAnon# eq "Submit">
	<cfset message = "">

   	<cfif #form.costumeFile# eq "" OR #form.costumeImageFile# eq "" OR #form.costumeName# eq "" OR #form.costumeDescription# eq "">
        <cfset form.bttnNewSubmitAnon = "">
		<cfset form.bttnNewSubmit = "">
        <cflocation url="main.cfm">
        <cfabort>
	</cfif>

	<cfset #form.costumeFile# = REReplace(#form.costumeFile#,"[^[:alpha:][:digit:]._-]","","ALL")> <!--- the ^ searches for any characters other than those listed --->
	<cfset #form.costumeTags# = REReplace(#form.costumeTags#,"[^[:alpha:][:digit:]._-,]","","ALL")> <!--- ALL finds every instance of the specified search string --->
	<cfset #form.costumeImageFile# = REReplace(#form.costumeImageFile#,"[^[:alpha:][:digit:]._-]","","ALL")>

    <cffile action="upload" fileField="costumeFile" destination="#costumeFileDest#" nameConflict="makeunique">
    <cfset costumeFilenameFull = "#cffile.serverFileName#.#serverFileExt#">
    <cfset costumeFilename = "#cffile.serverFileName#">
    
    <cfif #cffile.serverFileExt# neq "costume">
    	<cffile action="delete" file="#costumeFileDest#/#cffile.serverFile#">
        That is not a costume file.
        <cfabort>
    </cfif>

   	<cffile action="upload" filefield="costumeImageFile" destination="#costumeImageDest#" nameconflict="makeunique" accept="image/*">
    <cfset cffile.serverFileExt = LCase(cffile.serverFileExt)>
   	<cfif #cffile.serverFileExt# neq "jpg" AND #cffile.serverFileExt# neq "jpeg" AND #cffile.serverFileExt# neq "tga" AND #cffile.serverFileExt# neq "gif">
		<cffile action="delete" file="#costumeImageDest#/#cffile.serverFile#">
        That is not an image file.
        <cfabort>
    </cfif>
    
    <cffile action="rename" source="#costumeImageDest#/#cffile.serverFile#" destination="#costumeImageDest#/#costumeFilename#.#cffile.serverFileExt#">
    <cfset imageFile = "#costumeFilename#.#cffile.serverFileExt#">

    <cfif #form.costumeName# eq "">
   	   	<cfset message &= "no name<br>">
    </cfif>
   	<cfif form.costumeDescription eq "">
   		<cfset message &= "no desc<br>">
    </cfif>

    <cfinclude template="parser.cfm"> <!--- separate file for easier maintenance --->

	<cftransaction>
		<cfquery name="qAddCostume" datasource="cocdata">
		    INSERT INTO #code#_tblCostumes (userName, costumeFile, costumeImageFile, costumeGender, costumeName, costumeDescription, costumeRequirements)
			VALUES ('#session.userGlobal#','./costumeFiles/#costumeFilenameFull#','./costumeImages/#imageFile#','#costumeGender#','##form.costumeName##','#form.costumeDescription#','#costumeRequirements#')
   		</cfquery>

	    <cfquery name="qGetLastRecordID" datasource="cocdata">
    	   	SELECT @@IDENTITY AS newID; <!--- returns the last inserted primary key value --->
        </cfquery>

	    <cfif #form.costumeTags# neq ""> <!--- add tags to db --->
			<cfset costumeTagsArray = ListToArray(#form.costumeTags#)>
            <cfloop index="i" from="1" to="#ArrayLen(costumeTagsArray)#">
           	 	<cfquery name="qAddTag" datasource="cocdata">
  	    			INSERT INTO #code#_tblTags (costumeID, tagText)
	   	   	    	VALUES ('#qGetLastRecordID.newID#','#costumeTagsArray[i]#');
	     		</cfquery>
    	    </cfloop>
        </cfif>
	</cftransaction>
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
    <cfcase value="view">
    	<cfset #title# = "City of Costumes::View My Costumes">
    </cfcase>
</cfswitch>
<!--- end Title Section --->

<!--- display a random costume --->
<cfquery datasource="cocdata" name="qGetRandomCostume">
	SELECT costumeID FROM #code#_tblCostumes;
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
		SELECT * FROM #code#_tblCostumes WHERE costumeID = #randCostumeNum#;
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
    	<span class="desc"><span class="descMain">The Spandex Closet:</span> <span class="descSub">Online City of... Costume File Storage and Sharing</span></span>
        <span class="welcome"><cfoutput>Welcome, #session.userGlobal#!</cfoutput></span>
   	  	<span class="menu"><cfoutput>#menuText#</cfoutput></span>
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
                        	<tr><td>Password:</td><td><cfinput type="password" id="userPassword" name="userPassword"> Case sensitive</td></tr>
                            <tr><td>Confirm Password:</td><td><cfinput type="password" id="userPasswordConfirm" name="userPasswordConfirm"> Case sensitive</td></tr>
                        	<tr><td colspan="3"><cfinput type="submit" value="Submit" name="bttnRegSubmit" id="bttnRegSubmit"></td></tr>
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
                        	<tr><td>Upload Costume File:</td><td><input type="file" name="costumeFile" value="" /></td></tr>
                            <tr><td>Upload Screenshot:</td><td><input type="file" name="costumeImageFile" value=""> Screenshots must be of type jpg/tga/gif.</td></tr>
            	   	        <tr><td>Costume Name</td><td><input type="text" name="costumeName" value="" /></td></tr>
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
            	<cfif form.bttnSubmitSearchByName eq "" AND form.bttnSubmitSearchByTag eq "" AND form.bttnSubmitSearchByUser eq "">
                	<br>
                	<fieldset>
		            	<cfform name="" action="main.cfm?action=search" method="post">
			            	Search by:<br>
    			            Costume Name:<input type="text" name="searchByName"><input type="submit" value="Submit" name="bttnSubmitSearchByName"><br>
        			        Tag: <input type="text" name="searchByTag" size="20" maxlength="20"><input type="submit" value="Submit" name="bttnSubmitSearchByTag"><br>
                	        User Name:<input type="text" name="searchByUser"><input type="submit" value="Submit" name="bttnSubmitSearchByUser">
	                	</cfform>
                    </fieldset>
                <cfelse>
                	<cfif form.bttnSubmitSearchByName eq "Submit">
                    	<cfset sourceImage = #qSearchByCostumeName.costumeImageFile#>
                        <cfset sourceFile = #qSearchByCostumeName.costumeFile#>
                        <cfset queryName = "qSearchByCostumeName">
                    <cfelseif form.bttnSubmitSearchByTag eq "Submit">
                    	<cfset sourceImage = #qSearchByTags.costumeImageFile#>
                        <cfset sourceFile = #qSearchByTags.costumeFile#>
                        <cfset queryName = "qSearchByTags">
                    <cfelse>
                    	<cfset sourceImage = #qSearchByUser.costumeImageFile#>
                        <cfset sourceFile = #qSearchByUser.costumeFile#>
                        <cfset queryName = "qSearchByUser">
                    </cfif>
                    
					<cfimage action="info" source="#sourceImage#" structname="imageInfo">
       	            <cfset width = #imageInfo.width#>
           	        <cfset height = #imageInfo.height#>
                    
	            	<cfif width gt 400><!--- if width is 500 --->
               			<cfset widthPercentScale = 400/#width#> <!--- wps = 0.8 --->
            		</cfif>

				    <cfif height gt 300> <!--- if width is 400 --->
       			    	<cfset heightPercentScale = 300/#height#> <!--- hps = 0.75 --->
		        	</cfif>
                
		            <cfif widthPercentScale gt heightPercentScale>
	           			<cfset width = #width# * #widthPercentScale#>
       					<cfset height = #height# * #widthPercentScale#>
       				<cfelse>
       		       		<cfset width = #width# * #heightPercentScale#>
		               	<cfset height = #height# * #heightPercentScale#>
		            </cfif>

                	<table width="100%">
   	                	<tr><td>ID</td><td>Username</td><td>file</td><td>Gender</td><td>Reqs</td><td>Name</td><td>Image</td></tr>
       	        		<cfoutput query="#queryName#">
        	        	<tr>
               	        	<td>#costumeID#</td><td>#userName#</td>
                   	        <td><a href="#sourceFile#"><img src="images/file-image.PNG"></a></td>
                       	    <td>#costumeGender#</td>
                            <td><b>Costume Requirements:</b><br>#costumeRequirements#</td>
                           	<td>#costumeName#</td>
                            <td><a href="#sourceImage#"><img src="#sourceImage#" height="#height#" width="#width#"></a></td>
   	                    </tr>
       	            	</cfoutput>
        	        </table>
                </cfif>
	        </cfcase>
<!--- end search section --->

<!--- style selection section --->
            <cfcase value="style">
            </cfcase>
<!--- end style selection section --->

<!--- logout section --->
			<cfcase value="logout">
            	<cfset session.userGlobal = "">
                <cfset session.isLoggedIn = "false">
                <cflocation url="main.cfm">
            </cfcase>
<!--- end logout section --->

<!--- view my costumes --->
			<cfcase value="view">
               	<cfoutput query="qViewMyCostumes">
                	<cfimage action="info" source="#qViewMyCostumes.costumeImageFile#" structname="imageInfo">
                    <cfset width = #imageInfo.width#>
                    <cfset height = #imageInfo.height#>
                    
	            	<cfif width gt 400><!--- if width is 500 --->
                		<cfset widthPercentScale = 400/#width#> <!--- wps = 0.8 --->
	            	</cfif>
				    <cfif height gt 300> <!--- if width is 400 --->
        		    	<cfset heightPercentScale = 300/#height#> <!--- hps = 0.75 --->
		        	</cfif>
                
		            <cfif widthPercentScale gt heightPercentScale>
		           		<cfset width = #width# * #widthPercentScale#>
        				<cfset height = #height# * #widthPercentScale#>
        				<cfelse>
        	       		<cfset width = #width# * #heightPercentScale#>
		               	<cfset height = #height# * #heightPercentScale#>
		            </cfif>
                   	<table style="border:1px black solid;">
                       	<tr><td colspan="5"><img src="#costumeImageFile#" width="400" height="300"/></td></tr>
   	                	<tr>
                        	<td>#costumeName#</td>
                            <td>#costumeGender#</td>
                            <td>#costumeRequirements#</td>
                            <td><a href="#costumeFile#"><img src="images/file-image.PNG" height="#height#" width="#width#"></a></td>
                        </tr>
					</table>
   	            </cfoutput>
            </cfcase>
<!--- end of view section --->

<!--- start page -- display a random costume --->
            <cfdefaultcase>
                <cfoutput>
                    <cfimage action="info" source="#qViewMyCostumes.costumeImageFile#" structname="imageInfo">
                    <cfset width = #imageInfo.width#>
                    <cfset height = #imageInfo.height#>
                    
	            	<cfif width gt 400><!--- if width is 500 --->
                		<cfset widthPercentScale = 400/#width#> <!--- wps = 0.8 --->
	            	</cfif>
				    <cfif height gt 300> <!--- if width is 400 --->
        		    	<cfset heightPercentScale = 300/#height#> <!--- hps = 0.75 --->
		        	</cfif>
                
		            <cfif widthPercentScale gt heightPercentScale>
		           		<cfset width = #width# * #widthPercentScale#>
        				<cfset height = #height# * #widthPercentScale#>
        				<cfelse>
        	       		<cfset width = #width# * #heightPercentScale#>
		               	<cfset height = #height# * #heightPercentScale#>
		            </cfif>
                	<table>
                    	<tr><td><img src="#qGetRandomCostumeByID.costumeImageFile#" width="#width#" height="#height#"></td></tr>
                        <tr>
                        	<td>Name: #qGetRandomCostumeByID.costumeName#</td>
	                        <td><a href="#qGetRandomCostumeByID.costumeFile#"><img src="images/file-image.PNG" /></a></td>
                        </tr>
						<tr><td>#qGetRandomCostumeByID.costumeRequirements#</tr>
                    </table>
                </cfoutput>
            </cfdefaultcase>
<!--- end start page section --->             
    	</cfswitch>
       
    </div>
</body>
</html>
