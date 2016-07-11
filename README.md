Data o starostech českých obcí a měst 2016
=====

Toto repo obsahuje data o českých starostech a kód potřebný k jejich sběru a sestavení.
Výsledný dataset je [`data-output/starostove_komplet.csv`](/data-output/starostove_komplet.csv)

Data pochází z wikipedie (9. července 2016) a z [open data registrů ČS k volbám do zastupitelstev obcí 2014](http://volby.cz/opendata/kv2014/kv2014_opendata.htm) - konkrétně registr zastupitelů a volebních stran.

## Postup:

1. stáhnout jména starostů z wikipedie ([/starostovezwiki.R](/starostove_process.R)) podle [seznamu obcí](https://cs.wikipedia.org/wiki/Seznam_obcí_v_Česku). Skript scrapuje tabulku atributů obce na pravé straně wiki stránky
2. zpracovat jména tak, aby neobsahovala tituly, poznámky a šla použít ke spojení s registry ([starostove_process.R](/starostove_process.R))
3. podle kódu obce spojit seznam starostů se registrem zastupitelů a následně strany s registrem volebních stran

## Popis souborů:

### Vstupní data v [`data-input`](/data-input/)

[`starostovezwiki.csv`](data-input/kvros.xlsx): registr volebních stran
[`starostovezwiki.csv`](data-input/kvrk.xlsx): registr zastupitelů

Dokumentace k oběma souborům je v adresáři [data-input/dokumentace](data-input/dokumentace) v PDF a XML souborech stažených z open data webu ČSÚ.

### Výstupní data v [`data-output`](/data-output/)

[`starostovezwiki.csv`](data-output/starostovezwiki.csv): hrubá data, jak vyšla ze skriptu pro stahování jmen z wikipedie.

- nazev: název obce
- kodobcelau: kód okresu obce
- kodobce: kód obce
- kraj: název a kód kraje
- okres: název a kód okresu
- starosta: jméno starosty

[`starostove_komplet.csv`](data-output/starostovezwiki.csv): hlavní výstupní dataset
[`starostove_komplet.xlsx`](data-output/starostovezwiki.xlsx): to stejné v xlsx

Soubor obsahuje propojená data o starostech, obcích a jejich stranách. Vznikl vyhledáním jména každého starosty podle jména a kódu obce v registru obcí a připojením dat z tohoto registru a následným obohacením o data z registru volebních stran.

Soubor obsahuje
- sloupce ze souboru [`starostovezwiki.csv`](data-output/starostovezwiki.csv)
- jméno a příjmení starosty, tak jak je vydoloval skript výše
- na ně napojené sloupce z dvou registrů, s výjimkou sloupců, přes které se data spojovala: name1 (původně `JMENO` v registru zastupitelů), surname (původně `PRIJMENI` v registru zastupitelů), kodobce (původně `KODZASTUP` v registru zastupitelů).
- sloupce z obou registrů jsou popsané v codebooks těchto dvou registrů - ty jsou uložené v adresáři [`data-input/`]()

## Caveat emptor

- data na wikipedii nemusí být aktuální
- 44 obcí má dva zastupitele se stejným jménem, takže není jasné, kdo z nich je starosta. Ve finálním souboru jsou tyto obce uvedeny dvakrát. P5i troše snahy by měl pravý starosta jít rozklíčovat podle titulu, věku, strany, pořadí na kandidátce, označení "ml."/"st." atd.
- v datech nejsou městské části a obvody. Analogickým postupem by ale měly jít stáhnout z wiki a následně spojit s registrem zastupitelstev (též v datech ČSÚ).
- data obsahují vojenské újezdy a jejich přednosty.
- skript obsahuje kód provádějící několik manuálních oprav pro několik případů, kde výchozí text políčka "starosta" byla natolik zmatený, že nemělo smysl psát pro něj psát obecný algoritmus. Na to je potřeba dát pozor při případné replikaci na jiných datech/v jiném období atd.
- v datech nejsou ostatní zastupitelé - ti jsou ale v registru
- registry ČSÚ dostupné v běžné tabulkové formě v balíku open dat neobsahují nezvolené kandidáty. Jejich data by bylo třeba posbírat skrz de facto API ČSÚ k volbám, dostupné ve formátu XML na stránce volebních opendat.
