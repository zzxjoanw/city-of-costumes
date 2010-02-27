<cffile action="read" file="c:\program files\city of heroes\costumes\justice.costume" variable="jcfContents">
<cffile action="read" file="c:\program files\city of heroes\costumes\Julia Novak.costume" variable="jncfContents">

<cfif jcfContents contains "eagle_armor">a1<cfelse>a2</cfif>
<cfif jncfContents contains "eagle_armor">b1<cfelse>b2</cfif> 

<!-- should output a1b2 -->