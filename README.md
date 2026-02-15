<div align="center">
  <img src="https://github.com/glfs-book/glfs/blob/trunk/images/glfs-logo.png?raw=true" width="25%">
  <h1>GLFS</h1>
</div>

<h2 align="center">
Gaming Linux From Scratch
</h2>

Denne boken dekker installasjon av grafikkdrivere, Steam, Wine og mer etter en 
Linux From Scratch installasjon.

## Hvor kan du lese den

Gå til https://lfs.freding.no/glfs/view/systemd/index.html eller
https://lfs.freding.no/glfs/ og begynne å bla gjennom boken!

Du finner flere nettkopier på https://linuxfromscratch.org/glfs/view/.

Det finnes også [releases](https://github.com/glfs-book/glfs/releases) 
tilgjengelig for nedlasting.

## Installasjon

Hvordan konverterer jeg disse XML filene til HTML selv? Du må ha installert 
programvare som håndterer disse konverteringene. Vennligst les
[INSTALL.md](./INSTALL.md) for å finne ut hvilke programmer du må installere og 
hvor du kan få instruksjoner for å installere programvaren.

Du kan deretter bygge HTML koden med en enkel `make` kommando.

Du kan bytte tema ved å sende `THEME=<theme>` til `make` kommandoen.
`<theme>` kan være lik:
- `dynamic` (standard)
- `dark`
- `light`
- hvilket som helst tema i `THEME_PATH`

**Eksempel:**
```Bash
make THEME=dark
```

Du kan angi temabanen ved å sende `THEME_PATH=<path>` til `make` kommandoen.
Standard er `stylesheets/lfs-xsl`. Flere temaer er tilgjengelige på
https://github.com/glfs-book/lfs-themes.

**Eksempel:**
```Bash
make THEME_PATH=../lfs-themes/themes THEME=whitepink
```

Som standard, `RENDERTMP`, som er en midlertidig mappe opprettet av
`mktemp -d`, vil bli fjernet etter at hver fil er konvertert til et nytt format 
(f.eks. HTML, wget-list, dumpede kommandoer osv.). Hvis du trenger å beholde 
mappen, send `AUTO_CLEAN=0` til `make` kommandoen.

**Eksempel:**
```Bash
make RENDERTMP=~/tmp AUTO_CLEAN=0
```

> [!MERK]
> Andre variabler finnes. For en mer omfattende liste over dem, kjør `make help`,
> og for en fullstendig liste, se Makefile.

Standardverdiene for variablene i Makefile kan endres ved å deklarere dem i 
`local.mk`. For eksempel, hvis `local.mk` inneholder `REV=systemd` og
`THEME=light`, kalle `make` uten argumenter vil bygge systemd revisjonen med 
light temaet. `local.mk` spores ikke og må opprettes manuelt.

Standardmålet gjengis som delt HTML i `~/public_html/glfs`.
