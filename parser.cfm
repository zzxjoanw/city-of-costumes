<cffile action="read" file="#form.costumeFile#" variable="cfContents">

<!--- vet rewards, highest to lowest --->
<cfif cfContents contains "!X_Arachnos_Crab_Spider_Face"
     		  OR contains "!Widow_Shader_Helm_NoColor"
			  OR contains "!x_mumystic_hair_nocolor"
			  OR contains "!x_wolfarmor_hair_nocolor">
	<cfset costumeRequirements &= "51 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "box">
	<cfset costumeRequirements &= "39 month Vet Reward">
</cfif>

<cfif cfContents contains "freedom_phalanx"
			  OR contains "vindicators"
			  OR contains "vanguard"  <!--- how to differentiate from the merit-bought pieces? --->
			  OR contains "V_Arachnos_02"
			  OR contains "ppd"
			  OR contains "cage_consortium"
			  OR contains "circle_of_thorns"
			  OR contains "council">
	<cfset costumeRequirements &= "30 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "tech_sleek">
	<cfset costumeRequirements &= "27 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "!Cape_shoulder_top">
	<cfset costumeRequirements &= "21 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "Samurai"
			  OR contains "Oni">
	<cfset costumeRequirements &= "18 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "Wings_Angel"
			  OR contains "Wings_Demon">
	<cfset costume Requirements &= "15 month Vet Reward">
</cfif>

<cfif cfContents contains "Athletic"
			  OR contains "!Chest_Belly_Tee_"
			  OR contains "!chest_Desire"
			  OR contains "Disco"
			  OR contains "Hacker"
			  OR contains "Shirt_Student_02"
			  OR contains "kilt">
	<cfset costumeRequirements &= "9 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "_greek_">
	<cfset costumeRequirements &= "6 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "Trenchcoat">
	<cfset costumeRequirements &= "3 month Vet Reward<br>">
</cfif>
<!--- end vet rewards --->

<!--- boxes --->
<cfif cfContents contains "Valkyrie">
	<cfset costumeRequirements &= "Mac Pack<br>">
</cfif>

<cfif cfContents contains "Sinister"
			  OR contains "eagle_armor">
	<cfset costumeRequirements &= "Good vs Evil<br>">
</cfif>

<cfif cfContents contains "cape_top_01">
	<cfset costumeRequirements &= "CoH Collector's Edition<br>">
</cfif>
<!--- end boxes --->

<!--- booster packs --->
<cfif cfContents contains "Doctor"
			  OR contains "Goggle"
			  OR contains "Scien"
			  OR contains "Rubber"
			  OR contains "Lens_01">
	<cfset costumeRequirements &= "Science Booster<br>">
</cfif>

<cfif cfContents contains "Cyborg">
	<cfset costumeRequirements &= "Tech Booster<br>">
</cfif>


<!--- end booster packs --->


<!--- in-game unlockables --->
<cfif cfContents contains "Roman">
	<cfset costumeRequirements &= "Finished the ITF">
</cfif>

<cfif cfContents contains "Vanguard">
	<cfset costumeRequirements &= "Bought with Vanguard Merits<br>">
</cfif>

<cfif cfContents contains "Heart" OR contains "GreekSandals">
	<cfset costumeRequirements &= "Valentine's Day event reward<br>">
</cfif>