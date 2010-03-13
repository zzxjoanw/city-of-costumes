<cffile action="read" file="#form.costumeFile#" variable="cfContents">

<!--- vet rewards, highest to lowest --->
<cfif cfContents contains "!X_Arachnos_Crab_Spider_Face"
     		  OR contains "!Widow_Shader_Helm_NoColor"
			  OR contains "!x_mumystic_hair_nocolor"
			  OR contains "!x_wolfarmor_hair_nocolor">
	<cfset costumeRequirements &= "51 month Vet Reward OR Pre-order City of Villains<br>">
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

<cfif cfContents contains "Magic"
			  OR contains "Witch"
			  OR contains "Wizard"
			  OR contains "Renegade">
	<cfset costumeRequirements &= "Magic Booster<br>">
</cfif>

<cfif cfContents contains "Warrior"
			  OR contains "Tai"
			  OR contains "Dragon"
			  OR contains "Foot"
			  OR contains "Tiger"
			  OR contains "Oni"
			  OR contains "Qin"
			  OR contains "Braided_Buns">
	<cfset costumeRequirements &= "MA Booster<br>">
</cfif>

<cfif cfContents contains "Wedding"
			  OR contains "Plus">
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

<cfif cfContents contains "Heart" OR contains "GreekSandals">
	<cfset costumeRequirements &= "Valentine's Day event reward<br>">
</cfif>

<cfif cfContents contains "Epaulets">
	<cfset costumeRequirements &= "Earned the Task Force Commander badge<br>">
</cfif>

<cfif cfContents contains "Santa" OR contains "Xmas" OR contains "EarMuffs">
	<cfset costumeRequirements &= "Winter Event reward<br>">
</cfif>

<cfif cfContents contains "Pumpkin">
	<cfset costumeRequirements &= "Earned the Apocalypse Survivor badge<br>">
</cfif>
<!--- end in-game unlockables --->


