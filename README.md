# Gaming Linux From Scratch (GLFS)

Gaming Linux From Scratch er en bok som dekker hvordan man installerer 
pakker som Steam og Wine etter Linux From Scratch boken.

# Hvor kan du lese

Gå til (https://lfs.freding.no/glfs/index.html) og begynne å bla gjennom boken!

Boken er under rullende utgivelse på nett.

Det finnes også [Releases](https://github.com/glfs-book/glfs/releases) som du
kan lastes ned. Alle inneholder både SysV og Systemd utgavene av 
boken, chunked HTML.

# Installasjon

Hvordan konverterer jeg disse XML-filene til HTML selv? Du må ha installert programvare 
som håndterer disse konverteringene. Les `INSTALL.md`-filen for å 
finne ut hvilke programmer du må installere og hvor du kan få instruksjoner 
for å installere programvaren.

Etter det kan du bygge HTML koden med en enkel `make` kommando.
Du kan endre revisjonen, f.eks. systemd vs. sysv, ved å legge til `REV=<rev>` til
`make` kommandoen. `<rev>` kan være:
- `sysv` (standard)
- `systemd`

Eksempel: `make REV=systemd`.

Standardmålet (sysv) bygger HTML koden i `~/public_html/glfs`,
mens for systemd ville det være i `~/public_html/glfs-systemd`.

Som standard vil hver pakke og seksjon være sin egen side, og deretter koble 
alt sammen for en smidig opplevelse.

Du kan angi en sti til GLFS temaer ved å kjøre `make THEME_PATH=<path>`.
Standardinnstillingen er `stylesheets/lfs-xsl`. Du finner mer på
https://github.com/glfs-book/lfs-themes.

Det mørke temaet er også standard, men du kan bytte tema ved å 
kjøre `make THEME=<theme>`. `<theme>` kan være lik:
- `light`
- `dark`

Merk at hvis du setter `THEME_PATH`,  kan du sette `THEME` til mer enn
bare det som er tilgjengelige alternativer vist ovenfor, men bare de tilgjengelige temaene
som er i den banen.

Standardverdier kan endres i en fil som ikke spores (`local.mk`) ved å deklarere
variabler som finnes i `Makefile` i `local.mk`, slik som `REV` og `THEME`.
Denne filen må opprettes manuelt.
