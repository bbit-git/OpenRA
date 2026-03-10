## player.yaml
options-tech-level =
    .low = Nizka
    .medium = Stredni
    .no-powers = Bez superschopnosti
    .unrestricted = Bez omezeni

checkbox-automatic-concrete =
    .label = Automatický beton
    .description = Pod budovami se automaticky pokládají betonové základy

notification-insufficient-funds = Nedostatek prostredku.
notification-new-construction-options = Nove moznosti vystavby.
notification-cannot-deploy-here = Zde nelze rozvinout.
notification-low-power = Nizky vykon.
notification-base-under-attack = Zakladna pod utokem.
notification-ally-under-attack = Nas spojenec je pod utokem.
notification-harvester-under-attack = Harvester je pod utokem.
notification-silos-needed = Jsou potreba sila.
notification-no-room-for-new-unit = Není místo pro novou jednotku.
notification-cannot-build-here = Zde nelze stavět.
notification-one-of-our-buildings-has-been-captured = Jedna z našich budov byla obsazena.

## world.yaml
notification-game-saved = Hra ulozena.

dropdown-map-worms =
    .label = Červi
    .description = Červi se potulují po mapě a požírají nepřipravené síly

options-starting-units =
    .mcv-only = Pouze MCV
    .light-support = Lehka podpora
    .heavy-support = Tezka podpora
    .carryall = MCV + Transportér

resource-spice = Koření

faction-random =
    .name = Libovolna
    .description = Nahodna House
    A random house is chosen at the start of the game

faction-atreides =
    .name = Atreides
    .description =
        Rod Atreides
        Ušlechtilí Atreides z vodního světa Caladan
        spoléhají na svou mobilitu a přesné údery.
        Jejich pokročilá technika jim umožňuje nasazovat
        orcithoptery k leteckým úderům.

faction-harkonnen =
    .name = Harkonnen
    .description =
        Rod Harkonnen
        Zlí Harkonnenové se nezastaví před ničím,
        aby získali kontrolu nad kořením.
        Jejich brutální síla a těžké zbraně
        jsou děsivou hrozbou na bojišti.

faction-ordos =
    .name = Ordos
    .description =
        Rod Ordos
        Z ledového světa Sigma Draconis IV jsou zákeřní
        Ordosové známí svou lstivostí a podlostí.
        Používají sabotáž a tajné operace
        k dosažení svých cílů.

faction-corrino =
    .name = Corrino

faction-mercenaries =
    .name = Žoldnéři

faction-smugglers =
    .name = Pašeráci

faction-fremen =
    .name = Fremen

map-generator-d2k = Generátor map
map-generator-clear = Čistý terén

## defaults.yaml
notification-unit-lost = Jednotka ztracena.
notification-unit-promoted = Jednotka povýšena.
notification-enemy-building-captured = Nepřátelská budova obsazena.
notification-primary-building-selected = Primarni building selected.

## aircraft.yaml
actor-carryall-reinforce =
    .name = Transportér
    .description =
        Velká okřídlená planetární loď
        Automaticky přepravuje kombajny na a z polí koření.

actor-carryall-encyclopedia = Automaticky přepravuje kombajny mezi poli koření a rafinériemi. Jsou také volány k evakuaci kombajnů, když jim hrozí nebezpečí od písečných červů.

actor-frigate-name = Fregata

actor-ornithopter =
    .name = Ornitoptéra
    .encyclopedia = Nejrychlejší letadlo na Dune, je lehce obrněné a schopné shazovat 500lb bomby na pozemní cíle. Je vyráběno pouze rodem Atreides.

actor-ornithopter-husk-name = Ornitoptéra
actor-carryall-husk-name = Transportér (troska)
actor-carryall-huskvtol-name = Transportér (troska)

## arrakis.yaml
notification-worm-attack = Útok červa.
notification-worm-sign = Znamení červa.

actor-spicebloom-spawnpoint-name = Místo zrodu kořenového výronu
actor-spicebloom-name = Kořenový výron
actor-sandworm-name = Písečný červ
actor-sietch-name = Fremenský sietch

## defaults.yaml
meta-vehicle-generic-name = Jednotka
meta-husk-generic-name = Zničená jednotka
meta-aircrafthusk-generic-name = Jednotka
meta-infantry-generic-name = Jednotka
meta-plane-generic-name = Jednotka
meta-building-generic-name = Budova

## husks.yaml
actor-mcv-husk-name = Mobilní stavební vozidlo (zničeno)
actor-harvester-husk-name = Sklízeč koření (zničeno)
actor-siege-tank-husk-name = Obléhací tank (zničeno)
actor-missile-tank-husk-name = Raketový tank (zničeno)
actor-sonic-tank-husk-name = Sonický tank (zničeno)
actor-devastator-husk-name = Devastator (zničeno)
actor-deviator-husk-name = Deviator (zničeno)
meta-combat-tank-husk-name = Bojový tank (zničeno)

## infantry.yaml
actor-light-inf =
    .name = Lehká pěchota
    .description =
        Pěchota pro všeobecné použití.
          Silný proti pěchotě
          Slabý proti vozidlům a dělostřelectvu
    .encyclopedia = Lehce obrněná pěchota vybavená útočnými puškami 9mm RP. Jsou efektivní proti jiné pěchotě, ale zranitelní vůči vozidlům a dělostřelectvu.

actor-engineer =
    .name = Inženýr
    .description =
        Infiltruje a obsazuje nepřátelské
        struktury.
          Silný proti budovám
          Slabý proti všemu ostatnímu
    .encyclopedia =
        Může být použit k obsazení nepřátelských budov.
        
        Inženýři jsou odolní proti protitankovým zbraním, ale zranitelní vůči střelným zbraním a výbušninám.

actor-trooper =
    .name = Voják
    .description =
        Protitanková pěchota.
          Silný proti tankům
          Slabý proti pěchotě a dělostřelectvu
    .encyclopedia = Vyzbrojeni drátově naváděnými protipancéřovými střelami jsou vojáci velmi efektivní proti těžkým vozidlům, ale méně účinní proti pěchotě.

actor-thumper =
    .name = Thumper Infantry
    .description =
        Po rozmístění přitahuje blízké červy.
          Neozbrojený
    .encyclopedia = Rozmístí hlasité úderové zařízení, které přitahuje písečné červy do oblasti.

actor-fremen =
    .name = Fremeni
    .description =
        Elitní pěchotní jednotka s útočnými puškami a raketami.
          Silný proti pěchotě a vozidlům
          Slabý proti dělostřelectvu
    .encyclopedia = Původní pouštní válečníci z Dune, vyzbrojení 10mm útočnými puškami a raketami. Jsou silní proti pěchotě i vozidlům.

actor-grenadier =
    .name = Granátník
    .description =
        Pěchota s granáty.
          Silný proti budovám a pěchotě
          Slabý proti vozidlům
    .encyclopedia = Pěchotní dělostřelecká jednotka silná proti budovám. Mají šanci explodovat při zabití, což způsobí kolaterální škody.

actor-sardaukar =
    .name = Sardaukar
    .description =
        Elitní útočná pěchota Corrino.
          Silný proti pěchotě a vozidlům
          Slabý proti dělostřelectvu
    .encyclopedia = Mocní těžcí vojáci vybavení kulometem, který je účinný proti pěchotě, a raketami účinnými proti vozidlům.

actor-mpsardaukar-description =
    Elitní útočná pěchota Harkonnenů.
      Silný proti pěchotě a vozidlům
      Slabý proti dělostřelectvu

actor-saboteur =
    .name = Sabotér
    .description =
        Zákeřná pěchota s výbušninami.
        Na omezenou dobu se stane neviditelnou.
          Silný proti budovám
          Slabý proti všemu ostatnímu
    .encyclopedia = Specializovaná vojenská jednotka rodu Ordos, schopná demolovat nepřátelské budovy. Může se dočasně stát neviditelnou.

actor-nsfremen-description =
    Elitní pěchotní jednotka s útočnými puškami a raketami.
      Silný proti pěchotě a vozidlům
      Slabý proti dělostřelectvu

## misc.yaml
actor-crate-name = Bedna
actor-mpspawn-name = (bod zahájení pro více hráčů)
actor-waypoint-name = (trasový bod pro skriptované chování)
actor-camera-name = (odhaluje oblast vlastníkovi)
actor-wormspawner-name = (místo výskytu červy)

actor-upgrade-conyard =
    .name = Vylepšení stavebního dvora
    .description =
        Odemyká další možnosti stavby:
        - Velká betonová deska
        - Raketová věž
        - Opravna

actor-upgrade-barracks =
    .name = Vylepšení kasáren
    .description =
        Odemyká další pěchotu:
        - Voják
        - Inženýr
        - Pěchota s tloučkem
        
        Vyžadováno k odemčení speciální jednotky frakce.

actor-upgrade-light =
    .name = Vylepšení lehké továrny
    .description =
        Odemyká další lehké jednotky:
        - Raketový quad
        
        Vyžadováno k odemčení speciální jednotky frakce.

actor-upgrade-heavy =
    .name = Vylepšení těžké továrny
    .description =
        Odemyká další možnosti stavby:
        - Opravna
        - Výzkumné centrum IX
        
        Odemyká další těžké jednotky:
        - Raketový tank

actor-upgrade-hightech =
    .name = Vylepšení továrny vysokých technologií
    .description = Odemyká superzbraň leteckého úderu Atreides.

actor-deathhand =
    .name = Ruka smrti
    .encyclopedia = Vyzbrojená atomovými kazetovými municemi detonuje nad svým cílem a způsobuje velké škody na rozsáhlé ploše. Má však nízkou přesnost.

## structures.yaml
notification-construction-complete = Stavba dokončena.
notification-unit-ready = Jednotka připravena.
notification-repairing = Opraviting.
notification-unit-repaired = Jednotka opravena.
notification-select-target = Zvolte cíl.
notification-missile-launch-detected = Detekováno vypuštění rakety.
notification-airstrike-ready = Letecký útok připraven.
notification-building-lost = Budova ztracena.
notification-reinforcements-have-arrived = Posily dorazily.
notification-death-hand-missile-prepping = Raketa Death Hand se připravuje.
notification-death-hand-missile-ready = Raketa Death Hand připravena.
notification-fremen-ready = Fremenové připraveni.
notification-saboteur-ready = Sabotér připraven.

meta-concrete =
    .generic-name = Stavba
    .description =
        Poskytuje pevný základ, který
        chrání před poškozením terénem.

actor-concrete-a =
    .name = Betonová deska
    .encyclopedia = Budovy nepostavené na betonové desce budou průběžně poškozovány písečnými bouřemi a povrchem pouště.

actor-concrete-b-name = Velká betonová deska

actor-construction-yard =
    .name = Stavební dvůr
    .description = Buduje stavby.
    .encyclopedia = Stavební dvůr slouží jako základ každé základny postavené na Arrakis a poskytuje přístup ke stavebním možnostem.

actor-wind-trap =
    .name = Větrná past
    .description =
        Zásobuje energií ostatní
        struktury.
    .encyclopedia = Vyrábí energii a vodu pro vaši základnu. Velké nadzemní kanály směrují proudy větru do podzemních turbín.

actor-barracks =
    .name = Kasárna
    .description = Cvičí pěchotu.
    .encyclopedia = Vyžadováno pro výrobu a výcvik lehké pěchoty, může být vylepšeno k odemčení dalších jednotek.

actor-refinery =
    .name = Rafinérie koření
    .description =
        Kombajny zde vykládají koření
        ke zpracování.
    .encyclopedia = Základ veškeré produkce koření na Dune. Kombajny přepravují vytěžené koření do rafinérie ke zpracování.

actor-silo =
    .name = Silo
    .description = Ulozits excess harvested Spice.
    .encyclopedia = Ukládejte vytěžené koření. Přebytky z rafinérií jsou rovnoměrně rozdělovány mezi všechny dostupné sila.

actor-light-factory =
    .name = Lehká továrna
    .description = Vyrábí lehká vozidla.
    .encyclopedia = Vyžadováno pro výrobu malých, lehce obrněných bojových vozidel. Může být vylepšena k odemčení dalších jednotek.

actor-heavy-factory =
    .name = Těžká továrna
    .description = Vyrábí těžká vozidla.
    .encyclopedia = Umožňuje stavbu těžkých vozidel jako jsou kombajny a bojové tanky. Může být vylepšena k odemčení dalších jednotek.

actor-outpost =
    .name = Stanoviště
    .description =
        Poskytuje radarovou mapu bojiště.
        Ke svému provozu vyžaduje energii.
        Detekuje maskované jednotky.
    .encyclopedia = Jakmile je k dispozici dostatek energie, radarová hlídka se aktivuje a poskytuje radarovou mapu bojiště.

actor-starport =
    .name = Hvězdný přístav
    .description = Místo výsadku pro rychlé posily za cenu.
    .encyclopedia = Odemyká mezigalaktický obchod s obchodním cechem CHOAM, kde lze vozidla a letadla nakoupit za variabilní ceny.

actor-wall =
    .name = Betonová zeď
    .generic-name = Budova
    .description = Zastavuje jednotky a blokuje nepřátelskou palbu.
    .encyclopedia = Nejúčinnější obranné bariéry na Dune, blokující tankovou palbu a bránící pohybu jednotek.

actor-medium-gun-turret =
    .name = Dělová věž
    .description =
        Obranná struktura. Detekuje maskované jednotky.
          Silný proti lehkým vozidlům
          Střední proti pěchotě a tankům
    .encyclopedia = Zbraň středního dosahu, která je účinná proti všem typům vozidel, zejména lehce obrněným.

actor-large-gun-turret =
    .name = Raketová věž
    .description =
        Obranná struktura. Detekuje maskované jednotky.
        Ke svému provozu vyžaduje energii.
          Silný proti vozidlům
          Slabý proti pěchotě
    .encyclopedia = Vylepšená obranná struktura s delším dosahem a vyšší kadencí palby než střední věž.

actor-repair-pad =
    .name = Opravit Pad
    .description =
        Opravuje vozidla.
        Umožňuje stavbu MCV.
    .encyclopedia =
        Opravuje jednotky za zlomek jejich výrobních nákladů.
        
        Opravna je zranitelná během oprav, protože její brány jsou otevřené.

actor-high-tech-factory =
    .name = Hi-tech továrna
    .description = Odemyká pokročilé technologie.
    .airstrikepower-name = Letecký úder
    .airstrikepower-description = Ornitoptéry bombardují cíl.
    .encyclopedia = Vyrábí vzdušné jednotky a je vyžadována ke stavbě transportérů. Rod Atreides může tuto budovu vylepšit k odemčení leteckých úderů.

actor-research-centre =
    .name = Výzkumné centrum IX
    .description = Odemyká pokročilé tanky.
    .encyclopedia = Poskytuje technologická vylepšení pro struktury i vozidla. Toto zařízení je nezbytné pro pokročilé vojenské operace.

actor-palace =
    .name = Palác
    .description = Odemyká elitní pěchotu a zbraně.
    .encyclopedia = Slouží jako velitelské centrum po postavení a nabízí další možnosti a speciální jednotky pro každý rod.
    .nukepower-name = Ruka smrti
    .nukepower-description = Vypustí atomovou střelu na zvolenou oblast.
    .produceactorpower-fremen-name = Naverbovat Fremeny
    .produceactorpower-fremen-description =
        Elitní pěchotní jednotka s útočnými puškami a raketami.
        Silný proti pěchotě a vozidlům
        Slabý proti dělostřelectvu
    .produceactorpower-saboteur-name = Naverbovat sabotéra
    .produceactorpower-saboteur-description =
        Zákeřná pěchota s výbušninami.
        Může být rozmístěna a stát se na omezenou dobu neviditelnou.
        Silný proti budovám
        Slabý proti všemu ostatnímu

## vehicles.yaml
actor-mcv =
    .name = Mobilní stavební vozidlo
    .description =
        Rozbalí se do stavebního dvora.
          Neozbrojený
    .encyclopedia = Musí být dopraven na místo, kde může být rozbalen. Po nalezení vhodného skalního útvaru se rozbalí do stavebního dvora.

actor-harvester =
    .name = Sklízeč koření
    .description =
        Sbírá koření ke zpracování.
          Neozbrojený
    .encyclopedia = Odolný proti střelám a do určité míry i výbušninám. Jsou zranitelní vůči dělostřelectvu a písečným červům.

actor-trike =
    .name = Tříkolka
    .description =
        Rychlý průzkumník.
          Silný proti pěchotě
          Slabý proti tankům
    .encyclopedia = Lehce obrněná tříkolová vozidla vyzbrojená těžkými kulomety, účinná proti pěchotě.

actor-quad =
    .name = Raketový quad
    .description =
        Raketový průzkumník.
          Silný proti vozidlům
          Slabý proti pěchotě
    .encyclopedia = Lepší než Trike v obrněnosti i palebné síle, Quad je čtyřkolové vozidlo vyzbrojené raketami.

actor-siege-tank =
    .name = Obléhací tank
    .description =
        Obléhací dělostřelectvo.
          Silný proti pěchotě a budovám
          Slabý proti tankům
    .encyclopedia = Neuvěřitelně účinný proti pěchotě a lehce obrněným vozidlům, ale má problémy proti těžkým tankům.

actor-missile-tank =
    .name = Raketový tank
    .description =
        Raketové dělostřelectvo.
          Silný proti vozidlům, budovám a letadlům
          Slabý proti pěchotě
    .encyclopedia =
        Sestřeluje letadla a je účinný proti většině cílů kromě pěchoty.
        
        Raketové tanky jsou zranitelné v boji zblízka.


actor-sonic-tank =
    .name = Sonický tank
    .description =
        Vystřeluje sonické vlny.
          Silný proti pěchotě a vozidlům
          Slabý proti dělostřelectvu
    .encyclopedia = Nejúčinnější proti pěchotě a lehce obrněným vozidlům, ale slabší proti těžkým tankům a dělostřelectvu.

actor-devastator =
    .name = Devastator
    .description =
        Supertěžký tank.
          Silný proti tankům
          Slabý proti dělostřelectvu
    .encyclopedia = Jako nejmocnější tank na Dune je Devastátor pomalý, ale vysoce účinný proti těžce obrněným cílům.

actor-raider =
    .name = Nájezdnická tříkolka
    .description =
        Vylepšený průzkumník.
          Silný proti pěchotě a lehkým vozidlům
          Slabý proti tankům
    .encyclopedia = Nájezdnické trojkolky, vylepšené rodem Ordos, mají zvýšenou palebnou sílu, rychlost a obrněnost.

actor-stealth-raider =
    .name = Maskovaná nájezdnická tříkolka
    .description =
        Neviditelná nájezdnická trojkolka.
          Silný proti pěchotě a lehkým vozidlům
          Slabý proti tankům
    .encyclopedia = Maskovaná verze nájezdníka, dobrá pro tajné útoky. Demaskuje se při střelbě nebo poškození.

actor-deviator =
    .name = Deviator
    .description =
        Vystřeluje hlavici, která mění
        příslušnost nepřátelských vozidel.
    .encyclopedia = Střílí rakety, které uvolňují silikonový oblak, dočasně měnící příslušnost nepřátelských vozidel.


meta-combat-tank-description =
    Hlavní bojový tank.
      Silný proti tankům
      Slabý proti pěchotě

actor-combat-tank-a =
    .name = Atreidský bojový tank
    .encyclopedia = Účinný proti většině vozidel, ale méně vhodný proti lehce obrněným cílům.

actor-combat-tank-h =
    .name = Harkonnenský bojový tank
    .encyclopedia = Účinný proti většině vozidel, ale méně vhodný proti lehce obrněným cílům.

actor-combat-tank-o =
    .name = Bojový tank Ordos
    .encyclopedia = Účinný proti většině vozidel, ale méně vhodný proti lehce obrněným cílům.

meta-destroyabletile =
    .generic-name = Průchod (zničitelný)
    .name = Průchod (zničitelný)

meta-destroyedtile =
    .generic-name = Průchod (opravitelný)
    .name = Průchod (opravitelný)

## ai.yaml
bot-omnius =
    .name = Omnius

bot-vidius =
    .name = Vidious

bot-gladius =
    .name = Gladius

## map-generators.yaml
label-random-map = Nahodna Map
label-clear-map-generator-option-tile = Dlaždice
label-clear-map-generator-choice-tile-sand =
    .label = Písek
label-clear-map-generator-choice-tile-concrete =
    .label = Beton
label-clear-map-generator-choice-tile-dune =
    .label = Duna
label-clear-map-generator-choice-tile-rock =
    .label = Skála
label-clear-map-generator-choice-tile-platform =
    .label = Platforma

label-d2k-map-generator-option-seed = Seed
label-d2k-map-generator-option-terrain-type = Typ terénu
label-d2k-map-generator-choice-terrain-type-rocky =
    .label = Skalnatý
label-d2k-map-generator-choice-terrain-type-rough =
    .label = Drsný
label-d2k-map-generator-choice-terrain-type-flat =
    .label = Rovný
label-d2k-map-generator-choice-terrain-type-pockets =
    .label = Kapsy
label-d2k-map-generator-option-players = Hráči

label-d2k-map-generator-option-symmetry = Symetrie
label-d2k-map-generator-choice-mirror-none =
    .label = Žádná
label-d2k-map-generator-choice-symmetry-mirror-horizontal =
    .label = Zrcadlit vodorovně
label-d2k-map-generator-choice-symmetry-mirror-vertical =
    .label = Zrcadlit svisle
label-d2k-map-generator-choice-symmetry-mirror-diagonal-tl =
    .label = Zrcadlit diagonálně (vlevo nahoře)
label-d2k-map-generator-choice-symmetry-mirror-diagonal-tr =
    .label = Zrcadlit diagonálně (vpravo nahoře)
label-d2k-map-generator-choice-symmetry-mirror-2-rotations =
    .label = 2 otočení
label-d2k-map-generator-choice-symmetry-mirror-3-rotations =
    .label = 3 otočení
label-d2k-map-generator-choice-symmetry-mirror-4-rotations =
    .label = 4 otočení
label-d2k-map-generator-choice-symmetry-mirror-5-rotations =
    .label = 5 otočení
label-d2k-map-generator-choice-symmetry-mirror-6-rotations =
    .label = 6 otočení
label-d2k-map-generator-choice-symmetry-mirror-7-rotations =
    .label = 7 otočení
label-d2k-map-generator-choice-symmetry-mirror-8-rotations =
    .label = 8 otočení

label-d2k-map-generator-option-resources = Zdroje
label-d2k-map-generator-choice-resources-none =
    .label = Žádné
label-d2k-map-generator-choice-resources-low =
    .label = Nízké
label-d2k-map-generator-choice-resources-medium =
    .label = Střední
label-d2k-map-generator-choice-resources-high =
    .label = Vysoké
label-d2k-map-generator-choice-resources-very-high =
    .label = Velmi vysoké
label-d2k-map-generator-choice-resources-full =
    .label = Plné

label-d2k-map-generator-option-worms = Červi
label-d2k-map-generator-choice-worms-none =
    .label = Žádní
label-d2k-map-generator-choice-worms-low =
    .label = Nízký počet
label-d2k-map-generator-choice-worms-medium =
    .label = Střední počet
label-d2k-map-generator-choice-worms-high =
    .label = Vysoký počet

label-d2k-map-generator-option-density = Hustota
label-d2k-map-generator-choice-density-players =
    .label = Škálovat podle hráčů
label-d2k-map-generator-choice-density-area-and-players =
    .label = Škálovat podle velikosti a hráčů
label-d2k-map-generator-choice-density-area-very-low =
    .label = Velmi nízká
label-d2k-map-generator-choice-density-area-low =
    .label = Nízká
label-d2k-map-generator-choice-density-area-medium =
    .label = Střední
label-d2k-map-generator-choice-density-area-high =
    .label = Vysoká
label-d2k-map-generator-choice-density-area-very-high =
    .label = Velmi vysoká
