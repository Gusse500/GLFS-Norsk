# 1. Hvordan kan jeg bidra?
Først, vennligst les
[Linux From Scratch Editor's Manual](https://www.linuxfromscratch.org/lfs/LFS-EDITORS-GUIDE.html)
siden den inneholder noe god informasjon. Noe informasjon mangler, og noe er spesifikt for LFS.

# 2. Grunnleggende
Dette prosjektet er hovedsakelig skrevet i Docbook XML. De fleste problemene og oppdateringene 
gjelder XML-en som legges inn i den endelige teksten i den gjengitte boken. Hvis 
du ønsker å bidra på en eller annen måte, men ikke kjenner XML og/eller ikke ønsker å skrive 
noe XML, kan du legge inn problemene på
[issues](https://github.com/glfs-book/glfs/issues).

Hvis du føler deg mer kyndig, bør du gjøre deg kjent med boken, hvordan den er
skrevet, hvor viktige filer finnes, deretter foreta en oppdatering etter behov,
og legge til en PR. Denne delen krever en mer grundig forklaring og hvor den
virkelig avviker fra LFS Editor's Manual. Hvis du er en BLFS redaktør, vil redigeringen
av denne boken ikke være så annerledes. Les avsnitt 3.1.2, 3.2 og 3.3 for GLFS 
spesifikk informasjon.

# 3. For de kyndige
## 3.1. Hvor tingene befinner seg
### 3.1.1. Interne filer og mapper
Før vi begynner med hoveddelen av boken og hva folk skal lese, 
må vi dekke filene og mappene for kilden til boken som er 
mer interne, men likevel essensielle.

I roten av kildekoden finner du disse filene og mappene:
- `.github/workflows/`
- `archive/`
- `download/`
- `images/`
- `kernel-config/`
- `stylesheets/`
- `template/`
- `.gitattributes`
- `.gitignore`
- `INSTALL.md`
- `Makefile`
- `expand_date`
- `general.ent`
- `git-version.sh`
- `gnome.ent`
- `obfuscate.sh`
- `packages.ent`
- `tidy.conf`
- `xent.ent`

#### 3.1.1.1. `.github/workflows/`
Denne mappen inneholder YAML filer som brukes av Github CI-er til å gjengi
boken og legge den ut på GLFS nettstedet som ligger på Github. Den trenger sjelden
oppdatering.
#### 3.1.1.2. `archive/`
Denne mappen inneholder XML filer som ikke lenger anses som nødvendige 
eller nyttige å inkludere i boken, men som flyttes dit i tilfelle 
de må hentes tilbake eller for studiets skyld. Filer som ikke samsvarer med nye 
standarder trenger ikke å oppdateres med mindre de bringes tilbake til 
boken.
#### 3.1.1.3. `download/`
Denne mappen inneholder nedlastinger som kan være nødvendige for andre pakker, 
for eksempel oppdateringer eller skript.
#### 3.1.1.4. `images/`
Denne mappen inneholder bilder som brukes av boken, f.eks. for merknader, viktig informasjon, 
advarsel og tips-bokser, samt for favorittikonet og bildet som vises øverst 
på hjemmesiden. Trenger sjelden å oppdateres.
#### 3.1.1.5. `kernel-config/`
Denne mappen inneholder filene som trengs for å generere kjernekonfigurasjonsblokker 
som du finner på sider som krever at du endrer konfigurasjonen i 
kjernen din. Oppdater etter behov.
#### 3.1.1.6. `stylesheets/`
Denne mappen inneholder Docbook XML XSLT-stilarkene som trengs for å generere 
HTML fra XML kilden. Den inneholder også CSS filene som trengs for å gjøre 
boken penere. Trenger svært sjelden oppdatering.
#### 3.1.1.7. `template/`
Denne mappen inneholder maler som de fleste sidene i denne boken er basert på, 
hovedsakelig pakker. Den har dokumentasjon som kan hjelpe deg med å finne ut 
hva du vil og ikke vil. Den må kanskje oppdateres hvis standardene endres.
#### 3.1.1.8. `.gitattributes`
Denne filen er en standard git fil som gir attributter til samsvarende filer. 
Trenger sjelden å oppdateres.
#### 3.1.1.9. `.gitignore`
Denne filen er en standard git fil som ignorerer samsvarende filer fra å komme inn i
git historikken og treet. For eksempel ignoreres `conditional.ent` og `version.ent`
generert av `git-version.sh`, men kan finnes lokalt hvis du gjengir
boken. Trenger svært sjelden å oppdateres.
#### 3.1.1.10. `INSTALL.md`
Denne filen beskriver hvilke pakker du trenger for å kunne gjengi boken. 
Trenger sjelden å oppdateres.
#### 3.1.1.11. `Makefile`
Denne filen er Makefile som brukes av **make** for å gjengi boken. 
Trenger sjelden å oppdateres.
#### 3.1.1.12. `expand_date`
Denne filen er et Python skript som utvider datovariabelen i XML-filer,
selv om denne oppførselen har falt i unåde i GLFS, men fortsatt er sterk i
BLFS. Trenger sjelden å oppdateres.
#### 3.1.1.13. `general.ent`
Denne filen er en XML entitetsfil som inneholder viktige variabler som brukes av 
bokens XML, og inkluderer også forskjellige entitetsfiler. Denne filen må 
oppdateres ved hver stabile utgivelse.
#### 3.1.1.14. `git-version.sh`
Denne filen er et skallskript som genererer versjonen og revisjonen boken 
skal gjengis for, og sender ut teksten i henhold til `conditional.ent` og 
`version.ent`. Trenger sjelden å oppdateres.
#### 3.1.1.15. `gnome.ent`
Denne filen er en XML entitetsfil som inneholder GNOME spesifikke enheter som brukes 
av et lite utvalg XML filer. Trenger sjelden å oppdateres.
#### 3.1.1.16. `obfuscate.sh`
Denne filen er et skallskript som tilslører e-postadresser i XML og HTML 
filer. Trenger sjelden å oppdateres.
#### 3.1.1.17. `packages.ent`
Denne filen er en XML-enhetsfil som inneholder versjonsvariabler. Enkelte 
versjonsvariabler brukes av bestemte pakker, men vanligvis vil det bare 
være én variabel som brukes av en gitt pakke. For eksempel brukes &pulseaudio-version;
av Pulseaudio. Disse variablene bestemmer pakkens versjon.
Når en pakke trenger en oppdatering, må denne filen redigeres.
#### 3.1.1.18. `tidy.conf`
Denne filen er en konfigurasjonsfil som brukes av **tidy**. Trenger sjelden å 
bli oppdatert.
#### 3.1.1.19. `xent.ent`
Denne filen er en XML enhetsfil som inneholder innhold som gjentas 
gjennom hele boken. Oppdater eller legg til etter behov.

***

### 3.1.2. Bokens filer og mapper
Nå som de interne detaljene er dekket, er det på tide å dekke filene som har en
sterkere innvirkning på det endelige gjengitte produktet. Her er følgende filer og
mapper i roten av kildekoden:

- `appendices/`
- `book/`
- `introduction/`
- `qol/`
- `shareddeps/`
- `steam/`
- `wine/`
- `changelog.xml` (link to `introduction/welcome/changelog.xml`)
- `index.xml`

Noen pakker i mappene må kanskje oppdateres hver gang en versjon 
oppdateres. I motsetning til BLFS bruker ikke GLFS md5sums, SBU-er eller størrelse. Den bruker 
imidlertid lenker og pakkeversjoner. Lenkene må være korrekte, i likhet 
med instruksjonene.

#### 3.1.2.1. `appendices/`
Denne mappen inneholder XML filer som gjengis på slutten av boken. 
Trenger sjelden å oppdateres.
#### 3.1.2.2. `book/`
Denne katalogen inneholder XML filer som er gjengitt i begynnelsen av boken. 
Trenger sjelden å oppdateres.
#### 3.1.2.3. `introduction/`
Denne mappen inneholder XML filer gjengitt for introduksjonsdelen av 
boken. Inneholder `welcome/changelog.xml` som må oppdateres ofte. 
Resten av XML filene gjør det vanligvis ikke.
#### 3.1.2.4. `qol/`
Denne mappen inneholder XML filer gjengitt for QOL-delen av boken. 
Trenger sjelden å oppdateres.
#### 3.1.2.5. `shareddeps/`
Denne mappen inneholder XML filer gjengitt for delen Delte avhengigheter 
i boken. Inneholder pakker.
#### 3.1.2.6. `steam/`
Denne mappen inneholder XML filer gjengitt for Steam-delen av boken. 
Inneholder pakker.
#### 3.1.2.7. `wine/`
Denne mappen inneholder XML filer gjengitt for Wine-delen av boken. 
Inneholder pakker.
#### 3.1.2.8. `changelog.xml`
Denne symbolske lenken peker til `introduction/welcome/changelog.xml`, en XML fil som
beskriver endringer gjort i boken siden forrige utgivelse. Alle endringer bør
noteres her, og meldingen bør være lik eller nøyaktig som git commit meldingen
som beskriver commit-en. `->` bør være `->` i XML filen. For
brukeren i endringsloggoppføringen ville det blitt satt pris på om den samsvarte med
Github brukernavnet ditt. Hvis du er en BLFS/LFS redigerer, kan du også bruke referansen du
bruker for LFS/BLFS. Endringer som ikke skal ha en endringsloggoppføring er enkle
skrivefeil, grammatikkendringer, retting av gjengivelsesfeil, ordlyd osv. (små
endringer) og interne endringer (ikke medregnet endringer i `packages.ent`, disse
teller som oppdateringer som må ha en endringsloggoppføring).
#### 3.1.2.9. `index.xml`
Denne filen er en XML fil som bestemmer hvilke XML hovedfiler som skal inkluderes 
for gjengivelse. Tenk på den som hoved XML filen, eller din `int main()`, men for 
XML. Trenger sjelden å endres med mindre en ny seksjon legges til.

***

### 3.1.3. Standarder
I tillegg til å vite hvor filene er, teller også teksten i disse filene, og 
det finnes standarder å huske på.

1. Ingen tabulatorer unntatt i Makefile. Bruk mellomrom. Med mindre det er etter en setning, 
bruk to om gangen.
2. Hold tegnantallet på en gitt linje maksimalt 80 tegn, og ikke overskrid denne grensen. 
Dette hindrer XML filen i å bli stygg og utilgjengelig. Det 
finnes situasjoner der du ikke kan holde den under denne grensen, for eksempel ved bruk av lenker 
eller kodeblokker. Det er greit. Men hvis du kan unngå det, vær så snill å holde deg under 80 
tegngrensen.
3. Bruk oxford-komma (subjekt1, subjekt2 og subjekt3) i stedet for 
(subjekt1, subjekt2 og subjekt3).
4. Rediger `changelog.xml` etter behov. Se avsnitt 3.1.2.9.

## 3.2. Gjør en oppdatering
Først trenger du
[Git](https://glfs-book.github.io/glfs/shareddeps/git.html) for å klone,
trekke og pushe. Når du har installert det, må du forke dette
repositoriet til Github kontoen din. Når du har forket det, må du
klone forkingen:
```Bash
git clone https://github.com/<username>/glfs
```
Nå som du har klonet repoet, kan du gjøre endringer i standardgrenen
`trunk`, eller du kan lage en til:
```Bash
git checkout --track origin -b <branch_name>
```
Gjør nå en redigering slik du synes passer. Hvis det ikke er en redigering i en intern fil som
ikke er `packages.ent` eller retting av en enkel skrivefeil, lag en endringsloggoppføring (se
avsnitt 3.1.2.9). Når du har gjort en, kopier teksten du lagde, formater
teksten du kopierte til ren tekst som ikke blir rotet til i en git commit
melding, og utfør deretter en testrendering. Se om renderingen ser fin ut, om den ble gjengitt.

Etterpå, gjør en `git status` for å se at du redigerte de riktige filene, ikke har laget
noen nye som ikke burde vært laget, og `git add` deretter disse filene.
Etterpå, gjør
```Bash
git commit -m "<copied_text>" -m "<optional_message>"
```
Nå gjør:
```Bash
git push origin <branch_name>
```

## 3.3. Making a PR
Now over on Github on your repo, make a Pull/Merge Request that merges into
`glfs-book:trunk`. Hvis det er en konflikt, gjenta avsnitt 3.2 for å fikse disse 
konfliktene før du foretar PR/MR. Hvis alt ser bra ut, send det inn.

Det kan være behov for endringer. Dette er greit og rutinemessig. Gjenta avsnitt 
3.2 etter behov, så vil Github automatisk hente inn de nye endringene i 
PR-en. Skyll og gjenta til PR-en er slått sammen.

Etter det, klapp deg selv på skulderen, siden du nå er en GLFS bidragsyter.
