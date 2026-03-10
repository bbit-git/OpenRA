## player.yaml
options-tech-level =
    .low = Nízka
    .medium = Stredná
    .no-powers = Bez superschopností
    .unrestricted = Bez obmedzení

checkbox-automatic-concrete =
    .label = Automatický betón
    .description = Betónové základy sa automaticky kladú pod budovy

notification-insufficient-funds = Nedostatok prostriedkov.
notification-new-construction-options = Nové možnosti výstavby.
notification-cannot-deploy-here = Tu nie je možné rozvinúť.
notification-low-power = Nízky výkon.
notification-base-under-attack = Základňa je pod útokom.
notification-ally-under-attack = Náš spojenec je pod útokom.
notification-harvester-under-attack = Harvester je pod útokom.
notification-silos-needed = Sú potrebné silá.
notification-no-room-for-new-unit = Nie je miesto pre novú jednotku.
notification-cannot-build-here = Tu sa nedá stavať.
notification-one-of-our-buildings-has-been-captured = Jedna z našich budov bola obsadená.

## world.yaml
notification-game-saved = Hra uložená.

dropdown-map-worms =
    .label = Červy
    .description = Červy blúdia po mape a požierajú nepripravené sily

options-starting-units =
    .mcv-only = Len MCV
    .light-support = Ľahká podpora
    .heavy-support = Ťažká podpora
    .carryall = MCV + Transportér

resource-spice = Korenie

faction-random =
    .name = Ľubovoľná
    .description = Náhodný rod
    Náhodný rod sa vyberie na začiatku hry

faction-atreides =
    .name = Atreidi
    .description =
        Rod Atreides
        Urodzení Atreidovci z vodného sveta Caladan,
        sa spoliehajú na svoje ornitoptéry, aby si zaistili vzdušnú prevahu.
        Uzavreli spojenectvo s Fremenmi, obávanými
        domorodými bojovníkmi Duny, ktorí sa v boji dokážu pohybovať nepozorovane.
        
        Variácie frakcie:
            - Bojové tanky sú vyvážené z hľadiska rýchlosti a odolnosti
        
        Špeciálne jednotky:
            - Grenadier
            - Fremen
            - Sonic Tank
        
        Superzbraň:
            - Letecký útok

faction-harkonnen =
    .name = Harkonnenovia
    .description =
        Rod Harkonnen
        Zlomyseľní Harkonnenovci sa nezastavia pred ničím, aby získali kontrolu nad korením.
        Na dosiahnutie svojich cieľov sa spoliehajú na hrubú silu a atómové zbrane:
        bohatstvo a zničenie rodu Atreides.
        
        Variácie frakcie:
            - Bojové tanky sú odolnejšie, ale pohybujú sa pomalšie
        
        Špeciálne jednotky:
            - Sardaukar
            - Devastator
        
        Superzbraň:
            - Raketa Death Hand

faction-ordos =
    .name = Ordovia
    .description =
        Rod Ordos
        Z ľadového sveta Sigma Draconis IV sú zákerní Ordos známi
        svojím bohatstvom, chamtivosťou a zradnosťou. Často sa spoliehajú na žoldnierov, sabotáže
        a zakázané ixianske technológie, aby získali prevahu.
        
        Variácie frakcie:
            - Triky sú nahradené nájazdníckymi trikmi
            - Bojové tanky sú rýchlejšie, ale menej odolné
        
        Špeciálne jednotky:
            - Raider Trike
            - Stealth Raider Trike
            - Saboteur
            - Deviator

faction-corrino =
    .name = Corrino

faction-mercenaries =
    .name = Žoldnieri

faction-smugglers =
    .name = Pašeráci

faction-fremen =
    .name = Fremeni

map-generator-d2k = Generátor máp
map-generator-clear = Čistý terén

## defaults.yaml
notification-unit-lost = Jednotka stratená.
notification-unit-promoted = Jednotka povýšená.
notification-enemy-building-captured = Nepriateľská budova obsadená.
notification-primary-building-selected = Primárna budova vybraná.

## aircraft.yaml
actor-carryall-reinforce =
    .name = Transportér
    .description =
        Veľká okrídlená loď viazaná na planétu.
        Automaticky prenáša harvestery na korenisté polia a späť.
        Na rozkaz dopraví vozidlá na opravárenské plošiny.

actor-carryall-encyclopedia =
    Automaticky prepravuje harvestery medzi korenistými poľami a rafinériami. Na rozkaz môže zdvihnúť aj jednotky a dopraviť ich na opravárenskú plošinu.

    Carryall je ľahko obrnené transportné lietadlo. Je zraniteľné voči raketám a zasiahnu ho iba protilietadlové zbrane.

actor-frigate-name = Fregata

actor-ornithopter =
    .name = Ornitoptéra
    .encyclopedia = Najrýchlejšie lietadlo na Dune, ľahko obrnené a schopné zhadzovať 500-librové bomby. Je veľmi účinné proti pechote a ľahko obrneným cieľom, pričom dokáže poškodiť aj iné typy panciera.

actor-ornithopter-husk-name = Ornitoptéra
actor-carryall-husk-name = Transportér
actor-carryall-huskvtol-name = Transportér

## arrakis.yaml
notification-worm-attack = Útok červa.
notification-worm-sign = Znamenie červa.

actor-spicebloom-spawnpoint-name = Miesto zrodu korenistého kvetu
actor-spicebloom-name = Korenistý kvet
actor-sandworm-name = Piesočný červ
actor-sietch-name = Síč Fremenov

## defaults.yaml
meta-vehicle-generic-name = Jednotka
meta-husk-generic-name = Zničená jednotka
meta-aircrafthusk-generic-name = Jednotka
meta-infantry-generic-name = Jednotka
meta-plane-generic-name = Jednotka
meta-building-generic-name = Budova

## husks.yaml
actor-mcv-husk-name = Mobilné stavebné vozidlo (zničené)
actor-harvester-husk-name = Koreninový harvester (zničený)
actor-siege-tank-husk-name = Obliehací tank (zničený)
actor-missile-tank-husk-name = Raketový tank (zničený)
actor-sonic-tank-husk-name = Sonický tank (zničený)
actor-devastator-husk-name = Devastator (zničený)
actor-deviator-husk-name = Deviator (zničený)
meta-combat-tank-husk-name = Bojový tank (zničený)

## infantry.yaml
actor-light-inf =
    .name = Ľahká pechota
    .description =
    Viacúčelová pechota.
      Silná proti pechote
      Slabá proti vozidlám a delostrelectvu
    .encyclopedia =
    Ľahko obrnení peší vojaci vyzbrojení útočnými puškami RP kalibru 9 mm. Sú účinní proti pechote a ľahko obrneným vozidlám.

    Ľahká pechota je odolná voči raketám a zbraniam veľkého kalibru, no veľmi zraniteľná voči výbušninám, ohňu a ručným zbraniam.

    Summary:

        - Polomer výbuchu: malý
        - Dohľad: veľmi malý
        - Silná proti ľahkej pechote, trooperom, raketovým tankom a Deviatoru
        - Slabá proti bojovým tankom, obliehacím tankom, granátnikom, trikom a sonickým tankom

actor-engineer =
    .name = Inžinier
    .description =
        Infiltruje a obsadzuje nepriateľské
        budovy.
          Silný proti budovám
          Slabý proti všetkému
          Opravuje poškodené útesy
    .encyclopedia =
        Dá sa použiť na obsadzovanie nepriateľských budov.
        
        Inžinieri sú odolní voči protitankovým zbraniam, ale veľmi zraniteľní voči výbušninám, ohňu a ručným zbraniam.
        
        Inžinier môže znovu aktivovať zničený vrak do sotva funkčného stavu. To umožní poslať vrak na najbližšiu opravárenskú plošinu na úplnú opravu.

actor-trooper =
    .name = Vojak
    .description =
        Protitanková pechota.
          Silná proti tankom
          Slabá proti pechote a delostrelectvu
    .encyclopedia =
        Trooperi sú vyzbrojení drôtom navádzanými priebojnými raketami a sú veľmi účinní proti vozidlám a budovám, no proti pechote si vedú horšie.
        
        Trooperi sú odolní voči protitankovým zbraniam, ale veľmi zraniteľní voči výbušninám, ohňu a strelným zbraniam.
        
        Summary:
        
            - Polomer výbuchu: stredný
            - Dohľad: malý
            - Silná proti bojovým tankom, raketovým tankom, Quadom, Trikom, Deviatoru, budovám a obrane
            - Slabá proti obliehacím tankom, ľahkej pechote, granátnikom a sonickým tankom

actor-thumper =
    .name = Pechota Thumper
    .description =
    Po rozvinutí priťahuje blízkych červov.
      Neozbrojená
    .encyclopedia =
    Rozvinie hlasné udieracie zariadenie, ktoré pritiahne do oblasti piesočné červy.

actor-fremen =
    .name = Fremeni
    .description =
        Elitná pechotná jednotka s útočnými puškami a raketami.
          Silná proti pechote a vozidlám
          Slabá proti delostrelectvu
          Špeciálna schopnosť: neviditeľnosť
    .encyclopedia =
        Pôvodní púštni bojovníci z Duny vyzbrojení 10 mm útočnými puškami a raketami. Ich palebná sila je rovnako účinná proti pechote aj vozidlám.
        
        Jednotky Fremen sú veľmi zraniteľné voči výbušninám a strelným zbraniam.
        
        Summary:
        
            - Polomer výbuchu: stredný
            - Dohľad: malý
            - Silná proti Quadom, Trikom, raketovým tankom, bojovým tankom, Devastatoru, budovám a obrane
            - Slabá proti obliehacím tankom, ľahkej pechote, granátnikom a sonickým tankom

actor-grenadier =
    .name = Grenadír
    .description =
        Pechota s granátmi.
          Silná proti budovám a pechote
          Slabá proti vozidlám
    .encyclopedia =
        Pechotná delostrelecká jednotka silná proti budovám. Pri smrti môže vybuchnúť, preto by sa nemala zoskupovať.
        
        Summary:
        
            - Polomer výbuchu: veľký
            - Dohľad: malý
            - Silná proti ľahkej pechote, Trikom, raketovým tankom, bojovým tankom, budovám a obrane
            - Slabá proti obliehacím tankom, bojovým tankom, sonickým tankom a Devastatoru

actor-sardaukar =
    .name = Sardaukar
    .description =
        Elitná útočná pechota rodu Corrino.
          Silná proti pechote a vozidlám
          Slabá proti delostrelectvu
    .encyclopedia =
        Mocní ťažkí vojaci vyzbrojení guľometom účinným proti pechote a raketometom na ničenie vozidiel. Po rozdrvení jednotka vybuchne a poškodí vozidlo nad sebou.
        
        Summary:
        
            - Polomer výbuchu: veľký
            - Dohľad: malý
            - Silná proti Trikom, Quadom, raketovým tankom, bojovým tankom, budovám a obrane
            - Slabá proti obliehacím tankom, sonickým tankom, granátnikom a rozdrveniu tankom

actor-mpsardaukar-description =
    Elitná útočná pechota Harkonnenov.
      Silná proti pechote a vozidlám
      Slabá proti delostrelectvu

actor-saboteur =
    .name = Sabotér
    .description =
        Zákerná pechota s výbušninami.
        Na obmedzený čas sa stáva neviditeľnou.
          Silná proti budovám
          Slabá proti všetkému
          Špeciálna schopnosť: ničí budovy
    .encyclopedia =
        Špecializovaná vojenská jednotka rodu Ordos schopná po vstupe zničiť nepriateľské budovy a vozidlá, no sama pritom zahynie vo výbuchu. Môže aktivovať sebazničenie a poškodiť blízke nepriateľské jednotky.
        
        Sabotér je odolný voči protitankovým zbraniam, ale veľmi zraniteľný voči výbušninám, ohňu a strelným zbraniam.

actor-nsfremen-description =
    Elitná pechotná jednotka s útočnými puškami a raketami.
      Silná proti pechote a vozidlám
      Slabá proti delostrelectvu

## misc.yaml
actor-crate-name = Bedňa
actor-mpspawn-name = (štartovací bod pre multiplayer)
actor-waypoint-name = (bod trasy pre skriptované správanie)
actor-camera-name = (odhaľuje oblasť vlastníkovi)
actor-wormspawner-name = (miesto zrodu červa)

actor-upgrade-conyard =
    .name = Vylepšenie stavebného dvora
    .description =
    Odomyká ďalšie stavebné možnosti:
    - Veľká betónová doska
    - Raketová veža

actor-upgrade-barracks =
    .name = Vylepšenie kasární
    .description =
    Odomyká ďalšiu pechotu:
    - Trooper
    - Engineer
    - Thumper Infantry

    Potrebné na odomknutie frakčných jednotiek pechoty:
    - Atreides: Grenadier
    - Harkonnen: Sardaukar

actor-upgrade-light =
    .name = Vylepšenie ľahkej továrne
    .description =
    Odomyká ďalšie ľahké jednotky:
    - Missile Quad

    Potrebné na odomknutie frakčnej ľahkej jednotky:
    - Ordos: Stealth Raider Trike

actor-upgrade-heavy =
    .name = Vylepšenie ťažkej továrne
    .description =
    Odomyká ďalšie stavebné možnosti:
    - Repair Pad
    - IX Research Center

    Odomyká ďalšie ťažké jednotky:
    - Siege Tank
    - Missile Tank
    - MCV

actor-upgrade-hightech =
    .name = Vylepšenie továrne High Tech
    .description =
    Odomyká superzbraň Atreidovcov: letecký útok.

actor-deathhand =
    .name = Ruka smrti
    .encyclopedia = Vyzbrojená atómovou kazetovou muníciou detonuje nad cieľom a spôsobuje veľké poškodenie v širokej oblasti.

## structures.yaml
notification-construction-complete = Výstavba dokončená.
notification-unit-ready = Jednotka pripravená.
notification-repairing = Opravy.
notification-unit-repaired = Jednotka oprávená.
notification-select-target = Vyberte cieľ.
notification-missile-launch-detected = Zistené odpálenie strely.
notification-airstrike-ready = Letecký útok pripravený.
notification-building-lost = Budova stratená.
notification-reinforcements-have-arrived = Posily dorazili.
notification-death-hand-missile-prepping = Raketa Death Hand sa pripravuje.
notification-death-hand-missile-ready = Raketa Death Hand pripravená.
notification-fremen-ready = Fremen pripravení.
notification-saboteur-ready = Sabotér pripravený.

meta-concrete =
    .generic-name = Budova
    .description =
    Poskytuje pevný základ, ktorý
    chráni pred poškodením terénom.

actor-concrete-a =
    .name = Betónová doska
    .encyclopedia =
    Budovy nepostavené na betónovej doske budú priebežne poškodzované drsným púštnym prostredím Duny. Hoci sú opravy možné, umiestnenie stavieb na betón zabraňuje trvalému opotrebovaniu.

    Betón je zraniteľný voči väčšine zbraní a po poškodení sa nedá opraviť.

actor-concrete-b-name = Veľká betónová doska

actor-construction-yard =
    .name = Stavebný dvor
    .description = Produkuje budovy.
    .encyclopedia =
    Stavebný dvor je základom každej základne na Arrakise, produkuje malé množstvo energie a umožňuje stavbu nových budov. Chráňte túto budovu! Je rozhodujúca pre úspech vašej základne.

    Stavebné dvory sú pomerne odolné, no v rôznej miere zraniteľné voči všetkým zbraniam.

actor-wind-trap =
    .name = Veterný lapač
    .description =
        Dodáva energiu ostatným
        budovám.
    .encyclopedia =
        Vyrába energiu a vodu pre vašu základňu. Veľké nadzemné potrubia vedú veterné prúdy do masívnych turbín pod zemou, ktoré poháňajú generátory energie a extraktory vlhkosti.
        
        Wind Trapy sú zraniteľné voči väčšine zbraní.

actor-barracks =
    .name = Kasárne
    .description = Vycvičí pechotu.
    .encyclopedia =
        Potrebné na výrobu a výcvik ľahkej pechoty, v neskorších misiách sa dajú vylepšiť na výcvik pokročilej pechoty.
        
        Kasárne sú zraniteľné voči väčšine zbraní.

actor-refinery =
    .name = Korenie Refinery
    .description =
    Harvesters unload Korenie here
    for processing.
    .encyclopedia =
    The basis of all Korenie production on Dune. Harvesters transport mined Korenie to the Refinery where it is converted into credits. Refined Korenie is automatically distributed to Silos and Refineries for storage. Each refinery can store Korenie. A Korenie Harvester is delivered by Carryall once a Refinery is built.

    Refineries are vulnerable to most weapons.

actor-silo =
    .name = Silo
    .description = Uložiťs excess harvested Korenie.
    .encyclopedia =
        Store mined Korenie. Any surplus from Refineries is evenly distributed among all available Silos. If storage capacity is exceeded, excess Korenie is lost. Destroyed or captured Silos redistribute their contents, provided there is sufficient space.
        
        The Korenie Silo is vulnerable to most weapons.

actor-light-factory =
    .name = Ľahká továreň
    .description = Vyrába ľahké vozidlá.
    .encyclopedia =
        Vyžaduje sa na výrobu malých, ľahko opancierovaných bojových vozidiel. V neskorších misiách ju možno vylepšiť na výrobu pokročilejších ľahkých vozidiel.
        
        Ľahká továreň je zraniteľná väčšinou zbraní.

actor-heavy-factory =
    .name = Ťažká továreň
    .description = Vyrába ťažké vozidlá.
    .encyclopedia =
        Umožňuje konštrukciu ťažkých vozidiel, ako sú zberače a bojové tanky. Pomocou vylepšení odomyká pokročilé vozidlá, hoci niektoré môžu vyžadovať dodatočné budovy.
        
        Ťažká továreň je zraniteľná väčšinou zbraní.

actor-outpost =
    .name = Predsunutá hliadka
    .description =
        Poskytuje radarovú mapu bojiska.
        Vyžaduje energiu na prevádzku.
        Deteguje neviditeľné jednotky.
    .encyclopedia =
        Akonáhle je k dispozícii dostatok energie, radarová hliadka sa aktivuje a poskytne radarovú mapu.
        
        Radarová hliadka je zraniteľná väčšinou zbraní.

actor-starport =
    .name = Hviezdny prístav
    .description = Zóna výsadku pre rýchle posily, za poplatok.
    .encyclopedia =
        Odomyká medzigalaktický obchod s Cechom obchodníkov CHOAM, kde je možné zakúpiť vozidlá a letecké jednotky za rôzne ceny. Toto zariadenie je nevyhnutné na získavanie jednotiek od Cechu.
        
        Aj s ťažkým pancierom je hviezdny prístav zraniteľný väčšinou zbraní.

actor-wall =
    .name = Betónový múr
    .generic-name = Budova
    .description = Zastavuje jednotky a blokuje nepriateľskú streľbu.
    .encyclopedia =
        Najúčinnejšie obranné bariéry na Dune, ktoré blokujú paľbu tankov a bránia pohybu jednotiek.
        
        Múry môžu byť poškodené len výbušnými zbraňami, raketami a granátmi. Podobne ako betónové dosky ich po poškodení nie je možné opraviť.

actor-medium-gun-turret =
    .name = Delová veža
    .description =
        Obranná budova. Deteguje neviditeľné jednotky.
          Silná proti ľahkým vozidlám
          Stredná proti pechote
          Slabá proti tankom a lietadlám
    .encyclopedia =
        Zbraň stredného dosahu, ktorá je účinná proti všetkým typom vozidiel, najmä proti tým ťažko opancierovaným. Automaticky strieľa na akúkoľvek nepriateľskú jednotku vo svojom dosahu a na prevádzku vyžaduje energiu.
        
        Delová veža je odolná voči ručným zbraniam a výbušným zbraniam, ale zraniteľná voči raketám a ťažkým výbušninám.

actor-large-gun-turret =
    .name = Raketová veža
    .description =
        Obranná budova. Deteguje neviditeľné jednotky.
        Vyžaduje energiu na prevádzku.
          Silná proti tankom, lietadlám, pohyblivým cieľom
          Slabá proti pechote
    .encyclopedia =
        Vylepšená obranná budova s dlhším dosahom a vyššou rýchlosťou streľby ako delová veža. Jej pokročilý zameriavací systém vyžaduje energiu na prevádzku.
        
        Raketová veža je odolná voči strelným zbraniam a výbušným zbraniam, ale zraniteľná voči raketám a delám veľkého kalibru.

actor-repair-pad =
    .name = Opraviť Pad
    .description =
        Opravuje vozidlá.
        Umožňuje stavbu MCV.
    .encyclopedia =
        Opravuje jednotky za zlomok ich výrobných nákladov.
        
        Opravárenská plocha je zraniteľná väčšinou zbraní.

actor-high-tech-factory =
    .name = High-tech továreň
    .description = Odomyká pokročilé technológie.
    .airstrikepower-name = Nálet
    .airstrikepower-description = Ornitoptéry bombardujú cieľ.
    .encyclopedia =
        Produces airborne units, and is required to build Carryalls. Rod Atreides can upgrade this facility to build Ornithopters for air strikes in later missions.
        
        The High Tech Factory is vulnerable to most weapons.

actor-research-centre =
    .name = Výskumné centrum IX
    .description = Odomyká pokročilé tanky.
    .encyclopedia =
        Poskytuje technologické vylepšenia pre budovy aj vozidlá. Toto zariadenie je potrebné na vývoj pokročilých špeciálnych zbraní a prototypov.
        
        Výskumné centrum IX je zraniteľné väčšinou zbraní.

actor-palace =
    .name = Palác
    .description = Odomyká elitnú pechotu a zbrane.
    .encyclopedia =
        Po vybudovaní slúži ako veliteľské centrum a ponúka ďalšie možnosti a špeciálne zbrane.
        
        Aj s ťažkým pancierom je palác zraniteľný väčšinou zbraní.
    .nukepower-name = Ruka smrti
    .nukepower-description = Vystrelí atómovú raketu na cieľové miesto.
    .produceactorpower-fremen-name = Naverbovať Fremenov
    .produceactorpower-fremen-description =
        Elitná pechotná jednotka s útočnými puškami a raketami.
        Silná proti pechote a vozidlám
        Slabá proti artilérii
        Špeciálna schopnosť: Neviditeľnosť
    .produceactorpower-saboteur-name = Naverbujte sabotéra
    .produceactorpower-saboteur-description =
        Záludná pechota s výbušninami.
        Môže byť nasadený tak, aby sa na obmedzený čas stal neviditeľným.
          Silné vs budovy
          Slabosť vs všetko
          Špeciálna schopnosť: Ničí budovy

## vehicles.yaml
actor-mcv =
    .name = Mobilné konštrukčné vozidlo (MCV)
    .description =
        Rozloží sa na stavebný dvor.
          Neozbrojené
    .encyclopedia =
        Musí byť dovezené do oblasti, kde sa môže rozložiť. Po nájdení vhodného skalnatého povrchu sa môže MCV transformovať na stavebný dvor.
        
        MCV sú odolné voči guľkám a ľahkým výbušninám. Sú zraniteľné voči raketám a delám veľkého kalibru.

actor-harvester =
    .name = Korenie Harvester
    .description =
        Collects Korenie for processing.
          Unarmed
    .encyclopedia =
        Odolné voči guľkám a do určitej miery aj voči silným výbušninám. Sú zraniteľné voči raketám a delám veľkého kalibru.
        
        Zberač je súčasťou rafinérie.

actor-trike =
    .name = Trojkolka
    .description =
        Rýchly prieskumník.
          Silná proti pechote
          Slabá proti tankom
    .encyclopedia =
        Ľahko opancierované trojkolesové vozidlá vyzbrojené ťažkými guľometmi, účinné proti pechote a ľahko opancierovaným vozidlám.
        
        Trojkolky sú zraniteľné väčšinou zbraní, delá veľkého kalibru sú proti nim o niečo menej účinné.
        
        Zhrnutie:
        
            - Polomer výbuchu: Malý
            - Dohľad: Stredný
            - Silná proti ľahkej pechote, vojakom, raketovým tankom, Deviatoru
            - Slabá proti bojovým tankom, siežnym tankom, grenadírom, Sardaukarom
        
        Tip: Trojkolka má výhodu v dostrele 0,5 voči ľahkej pechote. Ustúpte s nimi, akonáhle sa ľahká pechota priblíži príliš blízko.

actor-quad =
    .name = Štvorkolka
    .description =
        Raketový prieskumník.
          Silná proti vozidlám
          Slabá proti pechote
    .encyclopedia =
        Štvorkolka, ktorá prevyšuje trojkolku v pancieri aj palebnej sile, je štvorkolesové vozidlo strieľajúce rakety prerážajúce pancier. Je účinná proti väčšine vozidiel.
        
        Štvorkolky sú odolné voči guľkám a v menšej miere aj voči výbušninám. Sú zraniteľné voči raketám a delám veľkého kalibru.
        
        Zhrnutie:
        
            - Polomer výbuchu: Stredný
            - Dohľad: Stredný
            - Silná proti siežnym tankom, sonickým tankom, budovám.
            - Slabá proti bojovým tankom, vojakom, raketovým tankom
        
        Tip: Štvorkolka má veľkú nepresnosť voči pohyblivým cieľom. Dostaňte sa k cieľu čo najbližšie, aby ste dosiahli maximálne poškodenie.

actor-siege-tank =
    .name = Siežny tank
    .description =
        Siežna artilérium.
          Silná proti pechote a budovám
          Slabá proti tankom
    .encyclopedia =
        Neuveriteľne účinný proti pechote a ľahko opancierovaným vozidlám, ale má problémy proti ťažko opancierovaným cieľom. Má dlhý dosah streľby.
        
        Siežny tanky sú odolné voči guľkám a do určitej miery aj voči výbušninám. Sú zraniteľné voči raketám a delám veľkého kalibru.
        
        Veľké zásoby vysoko výbušných granátov sú príčinou veľkého výbuchu po zničení vozidla.
        
        Zhrnutie:
        
            - Polomer výbuchu: Veľký
            - Dohľad: Veľký
            - Silný proti akejkoľvek pechote, trojkolkám, Deviatoru
            - Slabý proti bojovým tankom, štvorkolkám, raketovým tankom
        
        Tip: Siežny tank môže strieľať za hranicu svojho dohľadu.

actor-missile-tank =
    .name = Raketový tank
    .description =
        Raketové artiléria.
          Silná proti vozidlám, budovám a lietadlám
          Slabá proti pechote
    .encyclopedia =
        Zostreľuje lietadlá a je účinný proti väčšine cieľov, okrem pechoty.
        
        Raketové tanky sú zraniteľné väčšinou zbraní, delá veľkého kalibru sú o niečo menej účinné.
        
        Zhrnutie:
        
            - Polomer výbuchu: Stredný
            - Dohľad: Veľký
            - Silný proti bojovým tankom, Devastatoru, štvorkolkám
            - Slabý proti akémukoľvek typu pechoty, trojkolkám, neviditeľným trojkolkám
        
        Tip: Raketový tank môže strieľať za hranicu svojho dohľadu.


actor-sonic-tank =
    .name = Sonický tank
    .description =
        Vystreľuje sonické otrasy.
          Silná proti pechote a vozidlám
          Slabá proti artilérii
    .encyclopedia =
        Najúčinnejší proti pechote a ľahko opancierovaným vozidlám, ale slabší proti opancierovaným cieľom.
        
        Jeho sonické vlny poškodzujú všetky jednotky v ich ceste.
        
        Odolný voči guľkám a malým výbušninám, ale zraniteľný voči raketám a delám veľkého kalibru.
        
        Zhrnutie:
        
            - Polomer výbuchu: Veľmi veľký
            - Dohľad: Stredný
            - Silný: akákoľvek pechota, siežny tank, raketový tank, Deviator
            - Slabý proti bojovým tankom, štvorkolkám, Devastatoru
        
        Tip: Sila sonickej vlny sa zvyšuje s dosahom. Skúste strieľať na maximálny dosah, aby ste dosiahli maximálne poškodenie.

actor-devastator =
    .name = Devastátor
    .description =
        Super ťažký tank.
          Silná proti tankom
          Slabá proti artilérii
    .encyclopedia =
        Ako najsilnejší tank na Dune je Devastator pomalý, ale vysoko účinný proti väčšine jednotiek. Vystreľuje dvojité plazmové náboje a na príkaz sa môže sám zničiť, čím poškodí blízke jednotky a budovy.
        
        Odolný voči guľkám a silným výbušninám, ale zraniteľný voči raketám a delám veľkého kalibru.
        
        Zhrnutie:
        
            - Polomer výbuchu: Veľký
            - Dohľad: Stredný
            - Silný: bojový tank, siežny tank, ľahká pechota, sonický tank
            - Slabý proti vojakom, raketovým tankom, Deviatoru
        
        Tip: Devastator je zraniteľný voči veľkému počtu vojakov. Použite radšej sebadeštrukciu.

actor-raider =
    .name = Zájazdová trojkolka
    .description =
        Vylepšený prieskumník.
          Silná proti pechote a ľahkým vozidlám
          Slabá proti tankom
    .encyclopedia =
        Raider Trikes, upgraded by Rod Ordos, have enhanced firepower, speed, and armor. Equipped with dual 20mm cannons, they are strong against infantry and lightly armored vehicles.
        
        Raiders are vulnerable to most weapons, though high-caliber guns (combat tanks) are slightly less effective against them.
        
        Summary:
        
            - Explosion Radius: small
            - Vision: small
            - Strong vs Light Infantry, Trooper, Missile tank, Deviator, Trike
            - Weak vs Combat tank, Siege tank, Grenadier, Sardaukars, Quad

actor-stealth-raider =
    .name = Neviditeľná trojkolka
    .description =
        Neviditeľná zájazdová trojkolka.
          Silná proti pechote a ľahkým vozidlám
          Slabá proti tankom
    .encyclopedia =
        Maskovaná verzia trojkolky, dobrá na neviditeľné útoky. Odmaskuje sa, keď strieľa zo svojich guľometov.
        
        Zhrnutie:
        
            - Polomer výbuchu: Malý
            - Dohľad: Malý
            - Silná proti ľahkej pechote, vojakom, raketovým tankom, Deviatoru, trojkolkám
            - Slabá proti bojovým tankom, siežnym tankom, grenadírom, Sardaukarom
        
        Tip: Siežny a raketové tanky môžu strieľať za hranicu svojho dohľadu. Použite neviditeľnú trojkolku na rozšírenie ich dohľadu, aby mohli strieľať na maximálny dosah.

actor-deviator =
    .name = Deviátor
    .description = Vystreľuje hlavicu, ktorá mení vernosť nepriateľských vozidiel.
    .encyclopedia =
        Vystreľuje rakety, ktoré uvoľňujú kremíkový oblak, čím dočasne menia vernosť zasiahnutých vozidiel. Personál je oblakom ovplyvnený len mierne.
        
        Deviator je zraniteľný väčšinou zbraní, delá veľkého kalibru sú o niečo menej účinné.
        
        Zhrnutie:
            - Polomer výbuchu: Malý
            - Dohľad: Veľký
            - Silný proti bojovým tankom, štvorkolkám, Devastatoru, raketovým tankom
            - Slabý proti akejkoľvek pechote, raketovým tankom, sonickým tankom, trojkolkám
        
        Tip: Čas nabíjania Deviatora je veľmi dlhý. U niektorých Deviatorov vo vašej skupine vypnite automatickú paľbu, aby ste mali raketu vždy pripravenú, keď sa naskytne príležitosť.


meta-combat-tank-description =
    Hlavný bojový tank.
      Silná proti tankom
      Slabá proti pechote

actor-combat-tank-a =
    .name = Bojový tank Atreidov
    .encyclopedia =
        Účinný proti väčšine vozidiel, ale menej vhodný proti ľahko opancierovaným cieľom.
        
        Odolný voči guľkám a silným výbušninám, ale zraniteľný voči raketám a delám veľkého kalibru. Bojový tank Atreidov je dobrým kompromisom medzi mobilitou a pancierom s miernou výhodou v dostrele.
        
        Zhrnutie:
        
            - Polomer výbuchu: stredný
            - Dohľad: Stredný
            - Silný proti bojovým tankom, siežnym tankom, štvorkolkám, sonickým tankom
            - Slabý proti vojakom, raketovým tankom, Devastatoru, Deviatoru
        
        Bonus tanku Atreidov: lepší dostrel

actor-combat-tank-h =
    .name = Bojový tank Harkonnenov
    .encyclopedia =
        Účinný proti väčšine vozidiel, ale menej vhodný proti ľahko opancierovaným cieľom.
        
        Silnejší ako jeho náprotivky, ale aj pomalší a s nižšou rýchlosťou streľby.
        
        Zhrnutie:
        
            - Polomer výbuchu: stredný
            - Dohľad: Stredný
            - Silný proti bojovým tankom, siežnym tankom, štvorkolkám, sonickým tankom
            - Slabý proti vojakom, raketovým tankom, Devastatoru, Deviatoru
        
        Bonus tanku Harkonnenov: silnejší pancier

actor-combat-tank-o =
    .name = Bojový tank Ordov
    .encyclopedia =
        Účinný proti väčšine vozidiel, ale menej vhodný proti ľahko opancierovaným cieľom.
        
        Najrýchlejší variant bojového tanku, ale zároveň najslabší. Má lepšiu rýchlosť streľby ako jeho náprotivky.
        
        Zhrnutie:
        
            - Polomer výbuchu: stredný
            - Dohľad: Stredný
            - Silný proti bojovým tankom, siežnym tankom, štvorkolkám, sonickým tankom
            - Slabý proti vojakom, raketovým tankom, Devastatoru, Deviatoru
        
        Bonus tanku Ordov: rýchlosť streľby

meta-destroyabletile =
    .generic-name = Priechod (zničiteľný)
    .name = Priechod (zničiteľný)

meta-destroyedtile =
    .generic-name = Priechod (opraviteľný)
    .name = Priechod (opraviteľný)

## ai.yaml
bot-omnius =
    .name = Omnius

bot-vidius =
    .name = Vidius

bot-gladius =
    .name = Gladius

## map-generators.yaml
label-random-map = Náhodná Map
label-clear-map-generator-option-tile = Dlaždice
label-clear-map-generator-choice-tile-sand =
    .label = Piesok
label-clear-map-generator-choice-tile-concrete =
    .label = Betón
label-clear-map-generator-choice-tile-dune =
    .label = Duna
label-clear-map-generator-choice-tile-rock =
    .label = Skala
label-clear-map-generator-choice-tile-platform =
    .label = Plošina

label-d2k-map-generator-option-seed = Semiačko
label-d2k-map-generator-option-terrain-type = Typ terénu
label-d2k-map-generator-choice-terrain-type-rocky =
    .label = Skalnatý
label-d2k-map-generator-choice-terrain-type-rough =
    .label = Drsný
label-d2k-map-generator-choice-terrain-type-flat =
    .label = Plochý
label-d2k-map-generator-choice-terrain-type-pockets =
    .label = Vrecká
label-d2k-map-generator-option-players = Hráči

label-d2k-map-generator-option-symmetry = Symetria
label-d2k-map-generator-choice-mirror-none =
    .label = Žiadna
label-d2k-map-generator-choice-symmetry-mirror-horizontal =
    .label = Zrkadliť horizontálne
label-d2k-map-generator-choice-symmetry-mirror-vertical =
    .label = Zrkadliť vertikálne
label-d2k-map-generator-choice-symmetry-mirror-diagonal-tl =
    .label = Zrkadliť diagonálne (vľavo hore)
label-d2k-map-generator-choice-symmetry-mirror-diagonal-tr =
    .label = Zrkadliť diagonálne (vpravo hore)
label-d2k-map-generator-choice-symmetry-mirror-2-rotations =
    .label = 2 rotácie
label-d2k-map-generator-choice-symmetry-mirror-3-rotations =
    .label = 3 rotácie
label-d2k-map-generator-choice-symmetry-mirror-4-rotations =
    .label = 4 rotácie
label-d2k-map-generator-choice-symmetry-mirror-5-rotations =
    .label = 5 rotácií
label-d2k-map-generator-choice-symmetry-mirror-6-rotations =
    .label = 6 rotácií
label-d2k-map-generator-choice-symmetry-mirror-7-rotations =
    .label = 7 rotácií
label-d2k-map-generator-choice-symmetry-mirror-8-rotations =
    .label = 8 rotácií

label-d2k-map-generator-option-resources = Zdroje
label-d2k-map-generator-choice-resources-none =
    .label = Žiadne
label-d2k-map-generator-choice-resources-low =
    .label = Nízke
label-d2k-map-generator-choice-resources-medium =
    .label = Stredné
label-d2k-map-generator-choice-resources-high =
    .label = Vysoké
label-d2k-map-generator-choice-resources-very-high =
    .label = Veľmi vysoké
label-d2k-map-generator-choice-resources-full =
    .label = Plné

label-d2k-map-generator-option-worms = Červy
label-d2k-map-generator-choice-worms-none =
    .label = Žiadne
label-d2k-map-generator-choice-worms-low =
    .label = Nízke
label-d2k-map-generator-choice-worms-medium =
    .label = Stredné
label-d2k-map-generator-choice-worms-high =
    .label = Vysoké

label-d2k-map-generator-option-density = Hustota
label-d2k-map-generator-choice-density-players =
    .label = Mierka podľa počtu hráčov
label-d2k-map-generator-choice-density-area-and-players =
    .label = Mierka podľa veľkosti a počtu hráčov
label-d2k-map-generator-choice-density-area-very-low =
    .label = Veľmi nízka
label-d2k-map-generator-choice-density-area-low =
    .label = Nízka
label-d2k-map-generator-choice-density-area-medium =
    .label = Stredná
label-d2k-map-generator-choice-density-area-high =
    .label = Vysoká
label-d2k-map-generator-choice-density-area-very-high =
    .label = Veľmi vysoká
