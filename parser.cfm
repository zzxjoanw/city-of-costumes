<cftry>
	<cffile action="read" file="#form.costumeFile#" variable="cfContents">
<cfcatch><cflocation url="main.cfm"></cfcatch>
</cftry>

<cfset costumeRequirements = "">

<!--- vet rewards, highest to lowest --->
<cfif cfContents contains "!X_Arachnos_Crab_Spider_Face" OR
      cfContents contains "!Widow_Shader_Helm_NoColor" OR
	  cfContents contains "!x_mumystic_hair_nocolor" OR
	  cfContents contains "!x_wolfarmor_hair_nocolor">
	<cfset costumeRequirements &= "51 month Vet Reward OR Pre-order City of Villains<br>">
</cfif>

<cfif cfContents contains "box">
	<cfset costumeRequirements &= "39 month Vet Reward">
</cfif>

<cfif cfContents contains "freedom_phalanx" OR
	  cfContents contains "vindicators" OR
	  cfContents contains "Emblem_V_Vanguard_01" OR
	  cfContents contains "V_Arachnos_02" OR
	  cfContents contains "ppd" OR
	  cfContents contains "cage_consortium" OR
	  cfContents contains "circle_of_thorns" OR
	  cfContents contains "council">
	<cfset costumeRequirements &= "30 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "tech_sleek">
	<cfset costumeRequirements &= "27 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "!Cape_shoulder_top">
	<cfset costumeRequirements &= "21 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "Samurai" OR
	  cfContents contains "Oni">
	<cfset costumeRequirements &= "18 month Vet Reward<br>">
</cfif>

<cfif cfContents contains "Wings_Angel" OR
	  cfContents contains "Wings_Demon">
	<cfset costumeRequirements &= "15 month Vet Reward">
</cfif>

<cfif cfContents contains "Athletic" OR
		cfContents contains "!Chest_Belly_Tee_" OR
		cfContents contains "!chest_Desire" OR
		cfContents contains "Disco" OR
		cfContents contains "Hacker" OR
		cfContents contains "Shirt_Student_02" OR
		cfContents contains "kilt">
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

<cfif cfContents contains "Sinister" OR
      cfContents contains "eagle_armor">
	<cfset costumeRequirements &= "Good vs Evil<br>">
</cfif>

<cfif cfContents contains "cape_top_01">
	<cfset costumeRequirements &= "CoH Collector's Edition<br>">
</cfif>
<!--- end boxes --->

<!--- booster packs --->
<cfif cfContents contains "Doctor" OR
      cfContents contains "Goggle" OR
		 cfContents contains "Scien" OR
		cfContents contains "Rubber" OR
		cfContents contains "Lens_01">
	<cfset costumeRequirements &= "Science Booster<br>">
</cfif>

<cfif cfContents contains "Cyborg">
	<cfset costumeRequirements &= "Tech Booster<br>">
</cfif>

<cfif cfContents contains "Magic" OR
      cfContents contains "Witch" OR
		 cfContents contains "Wizard" OR
		 cfContents contains "Renegade">
	<cfset costumeRequirements &= "Magic Booster<br>">
</cfif>

<cfif cfContents contains "Warrior" OR
		  cfContents contains "Tai" OR
		  cfContents contains "Dragon" OR
		  cfContents contains "Foot" OR
		  cfContents contains "Tiger" OR
		  cfContents contains "Oni" OR
		  cfContents contains "Qin" OR
		  cfContents contains "Braided_Buns">
	<cfset costumeRequirements &= "MA Booster<br>">
</cfif>

<cfif cfContents contains "Wedding" OR
	  cfContents contains "Plus">
	<cfset costumeRequirements &= "Wedding Pack<br>">
</cfif>
<!--- end booster packs --->

<!--- invented pieces --->
<cfif cfContents contains "bat">
	<cfset costumeRequirements &= "Crafted a Bat Wings recipe<br>">
</cfif>

<cfif cfContents contains "bone">
	<cfset costumeRequirements &= "Crafted a Bone Wings recipe<br>">
</cfif>

<cfif cfContents contains "Burned">
	<cfset costumeRequirements &= "Crafted a Burned Wings recipe<br>">
</cfif>

<cfif cfContents contains "Cherub">
	<cfset costumeRequirements &= "Crafted a Cherub Wings recipe<br>">
</cfif>

<cfif cfContents contains "dragon_wings">
	<cfset costumeRequirements &= "Crafted a Dragon Wings recipe<br>">
</cfif>

<cfif cfContents contains "fairy">
	<cfset costumeRequirements &= "Crafted a Fairy Wings recipe<br>">
</cfif>

<cfif cfContents contains "insect">
	<cfset costumeRequirements &= "Crafted a Insect Wings recipe<br>">
</cfif>

<cfif cfContents contains "tech">
	<cfset costumeRequirements &= "Crafted a Piston Boots recipe<br>">
</cfif>

<cfif cfContents contains "boot_rocket">
	<cfset costumeRequirements &= "Crafted a Rocket Boots recipe<br>">
</cfif>

<cfif cfContents contains "xxx">
	<cfset costumeRequirements &= "Crafted a Winged Boots recipe<br>">
</cfif>
<!--- end invented pieces --->

<!--- in-game unlockables --->
<cfif cfContents contains "Roman">
	<cfset costumeRequirements &= "Finished the ITF">
</cfif>

<cfif cfContents contains "Vanguard">
	<cfset costumeRequirements &= "Bought with Vanguard Merits<br>">
</cfif>

<cfif cfContents contains "Heart" OR
      cfContents contains "GreekSandals">
	<cfset costumeRequirements &= "Valentine's Day event reward<br>">
</cfif>

<cfif cfContents contains "Epaulets">
	<cfset costumeRequirements &= "Earned the Task Force Commander badge<br>">
</cfif>

<cfif cfContents contains "Santa" OR
      cfContents contains "Xmas" OR
	  cfContents contains "EarMuffs">
	<cfset costumeRequirements &= "Winter Event reward<br>">
</cfif>

<cfif cfContents contains "Pumpkin">
	<cfset costumeRequirements &= "Earned the Apocalypse Survivor badge<br>">
</cfif>
<!--- end in-game unlockables --->


