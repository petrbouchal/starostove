Data o starostech českých obcí 2015
=====
Toto repo obsahuje data o českých starostech a kód potřebný k jejich sběru a sestavení.
Výsledný dataset je [`data-output/starostove_komplet.csv`](/data-output/starostove_komplet.csv)

Data pochází z wikipedie (9. července 2016) a z open data volebních registrů ČS.

## Postup:

1. stáhnout jména starostů z wikipedie (`starostovezwiki.R`) podle [seznamu obcí](https://cs.wikipedia.org/wiki/Seznam_obcí_v_Česku) (`obcelist.r`)
2. zpracovat jména tak, aby neobsahovala tituly, poznámky atd. (`starostove_process.R`)
3. podle kodu obce spojit seznam starostů se registrem

## Popis souborů:

### Vstupní data v [`data-input`](/data-input/)


### Výstupní data v [`data-output`](/data-output/)
