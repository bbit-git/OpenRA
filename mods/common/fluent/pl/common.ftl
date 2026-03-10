## Buttons
button-cancel = Zrušit
button-retry = Zkusit znovu
button-back = Zpět
button-continue = Pokračovat
button-quit = Ukončit

## Server Orders
notification-custom-rules = Tato mapa obsahuje vlastní pravidla. Herní zážitek se může lišit.
notification-two-humans-required = Tento server vyžaduje alespoň dva lidské hráče pro zahájení zápasu.
notification-unknown-server-command = Neznámý příkaz serveru: { $command }.
notification-admin-start-game = Pouze hostitel může zahájit hru.
notification-no-start-until-required-slots-full = Nelze zahájit hru, dokud nejsou obsazeny všechny požadované sloty.
notification-no-start-without-players = Hra nemůže začít bez hráčů.
notification-insufficient-enabled-spawn-points = Nelze zahájit hru, dokud není povoleno více počátečních pozic.
notification-malformed-command = Chybný příkaz { $command }.
notification-state-unchanged-ready = Nelze změnit stav, pokud jste označeni jako připraveni.
notification-invalid-faction-selected = Vybrána neplatná frakce: { $faction }.
notification-state-unchanged-game-started = Stav nelze změnit po zahájení hry ({ $command }).
notification-requires-host = Toto může udělat pouze hostitel.
notification-invalid-bot-slot = Nelze přidat boty do slotu s jiným hráčem.
notification-invalid-bot-type = Neplatný typ bota.
notification-admin-change-map = Pouze hostitel může změnit mapu.
notification-player-disconnected = { $player } se odpojil(a).
notification-team-player-disconnected = { $player } (Tým { $team }) se odpojil(a).
notification-observer-disconnected = { $player } (Divák) se odpojil(a).
notification-unknown-map = Mapa nebyla nalezena na serveru.
notification-searching-map = Hledání mapy v Centru zdrojů...
notification-admin-change-configuration = Pouze hostitel může změnit konfiguraci.
notification-changed-map = { $player } změnil(a) mapu na { $map }.
notification-you-were-kicked = Byli jste vyloučeni ze serveru.
notification-admin-kicked = { $admin } vyloučil(a) hráče { $player } ze serveru.
notification-kicked = { $player } byl(a) vyloučen(a) ze serveru.
notification-temp-ban = { $admin } dočasně zablokoval(a) hráče { $player } na serveru.
notification-admin-transfer-admin = Pouze správci mohou předat správcovská práva jinému hráči.
notification-admin-move-spectators = Pouze hostitel může přesunout hráče mezi diváky.
notification-empty-slot = V tomto slotu nikdo není.
notification-move-spectators = { $admin } přesunul(a) hráče { $player } mezi diváky.
notification-nick-changed = { $player } je nyní znám(a) jako { $name }.
notification-player-dropped = Hráč byl odpojen kvůli vypršení časového limitu.
notification-connection-problems = { $player } má problémy s připojením.
notification-timeout-dropped = { $player } byl(a) odpojen(a) kvůli vypršení časového limitu.
notification-timeout-dropped-in =
    { $timeout ->
        [one] { $player } bude odpojen(a) za { $timeout } sekundu.
        [few] { $player } bude odpojen(a) za { $timeout } sekundy.
       *[other] { $player } bude odpojen(a) za { $timeout } sekund.
    }
notification-error-game-started = Hra již byla zahájena.
notification-requires-password = Server vyžaduje heslo.
notification-incorrect-password = Nesprávné heslo.
notification-incompatible-mod = Server používá nekompatibilní mod.
notification-incompatible-version = Server používá nekompatibilní verzi.
notification-incompatible-protocol = Server používá nekompatibilní protokol.
notification-you-were-banned = Byli jste zablokováni na tomto serveru.
notification-you-were-temp-banned = Byli jste dočasně zablokováni na tomto serveru.
notification-game-full = Hra je plná.
notification-new-admin = { $player } je nyní správce.
notification-invalid-configuration-command = Neplatný konfigurační příkaz.
notification-admin-option = Pouze hostitel může nastavit tuto možnost.
notification-error-number-teams = Nelze zpracovat počet týmů: { $raw }.
notification-admin-kick = Pouze hostitel může vyloučit hráče.
notification-kick-self = Hostitel nemůže vyloučit sám sebe.
notification-kick-none = V tomto slotu nikdo není.
notification-no-kick-game-started = Po zahájení hry mohou být vyloučeni pouze diváci a poražení hráči.
notification-admin-clear-spawn = Pouze správci mohou vymazat počáteční pozice.
notification-spawn-occupied = Nemůžete obsadit stejnou počáteční pozici jako jiný hráč.
notification-spawn-locked = Počáteční pozice je uzamčena pro jiný slot hráče.
notification-admin-lobby-info = Pouze hostitel může nastavit informace lobby.
notification-invalid-lobby-info = Odeslány neplatné informace lobby.
notification-player-color-terrain = Barva byla upravena, aby se méně podobala terénu.
notification-player-color-player = Barva byla upravena, aby se méně podobala jinému hráči.
notification-invalid-player-color = Nelze určit platnou barvu hráče. Byla vybrána náhodná barva.
notification-invalid-error-code = Nepodařilo se zpracovat chybovou zprávu.
notification-master-server-connected = Komunikace s hlavním serverem navázána.
notification-master-server-error = Komunikace s hlavním serverem selhala.
notification-game-offline = Hra nebyla inzerována online.
notification-no-port-forward = Port serveru není přístupný z internetu.
notification-blacklisted-server-name = Název serveru obsahuje zakázané slovo.
notification-requires-authentication = Server vyžaduje, aby hráči měli účet na fóru OpenRA.
notification-no-permission-to-join = Nemáte oprávnění připojit se k tomuto serveru.
notification-slot-closed = Váš slot byl uzavřen hostitelem.

## ServerOrders, UnitOrders
notification-joined = { $player } se připojil(a) ke hře.
notification-lobby-disconnected = { $player } odešel/odešla.

## UnitOrders
notification-game-has-started = Hra byla zahájena.
notification-game-paused = Hra byla pozastavena hráčem { $player }.
notification-game-unpaused = Hra byla obnovena hráčem { $player }.

## Server
notification-game-started = Hra zahájena.

## PlayerMessageTracker
notification-chat-temp-disabled =
    { $remaining ->
        [one] Chat je vypnut. Zkuste to znovu za { $remaining } sekundu.
        [few] Chat je vypnut. Zkuste to znovu za { $remaining } sekundy.
       *[other] Chat je vypnut. Zkuste to znovu za { $remaining } sekund.
    }

## VoteKickTracker
notification-unable-to-start-a-vote = Nelze zahájit hlasování.
notification-insufficient-votes-to-kick = Nedostatek hlasů pro vyloučení hráče { $kickee }.
notification-kick-already-voted = Již jste hlasovali.
notification-vote-kick-started = Hráč { $kicker } zahájil hlasování o vyloučení hráče { $kickee }.
notification-vote-kick-in-progress = { $percentage }% hráčů hlasovalo pro vyloučení hráče { $kickee }.
notification-vote-kick-ended = Hlasování o vyloučení hráče { $kickee } nebylo úspěšné.

## ActorEditLogic
label-duplicate-actor-id = Duplicitní ID objektu
label-actor-id = Zadejte ID objektu
label-actor-owner = Vlastník

## ActorSelectorLogic
label-actor-type = Typ: { $actorType }

## CommonSelectorLogic
options-common-selector =
    .search-results = Výsledky hledání
    .all = Vše
    .multiple = Více
    .none = Žádný

## SaveMapLogic
label-unpacked-map = rozbalená

dialog-save-map-failed =
    .title = Uložení mapy selhalo
    .prompt = Podrobnosti naleznete v debug.log.
    .confirm = OK

dialog-overwrite-map-failed =
    .title = Varování
    .prompt = Uložením přepíšete
    již existující mapu.
    .confirm = Uložit

dialog-overwrite-map-outside-edit =
    .title = Varování
    .prompt = Mapa byla upravena mimo editor.
    Uložením můžete přepsat provedené změny.
    .confirm = Uložit

notification-save-current-map = Aktuální mapa uložena.

## GameInfoLogic
menu-game-info =
    .objectives = Cíle
    .briefing = Zadání
    .options = Možnosti
    .debug = Ladění
    .chat = Chat

## GameInfoObjectivesLogic, GameInfoStatsLogic
label-mission-in-progress = Probíhá
label-mission-accomplished = Splněno
label-mission-failed = Neúspěch

## GameInfoStatsLogic
label-mute-player = Ztlumit tohoto hráče
label-unmute-player = Zrušit ztlumení tohoto hráče
button-kick-player = Vyloučit tohoto hráče
button-vote-kick-player = Hlasovat o vyloučení tohoto hráče

dialog-kick =
    .title = Vyloučit { $player }?
    .prompt = Tento hráč se nebude moci znovu připojit ke hře.
    .confirm = Vyloučit

dialog-vote-kick =
    .title = Hlasovat o vyloučení { $player }?
    .prompt = Tento hráč se nebude moci znovu připojit ke hře.
    .prompt-break-bots =
    { $bots ->
        [one] Vyloučením správce hry bude vyloučen i 1 bot.
        [few] Vyloučením správce hry budou vyloučeni i { $bots } boti.
       *[other] Vyloučením správce hry bude vyloučeno i { $bots } botů.
    }
    .vote-start = Zahájit hlasování
    .vote-for = Hlasovat pro
    .vote-against = Hlasovat proti
    .vote-cancel = Zdržet se

notification-vote-kick-disabled = Hlasování o vyloučení je na tomto serveru zakázáno.

## GameTimerLogic
label-paused = Pozastaveno
label-max-speed = Maximální rychlost
label-replay-speed = { $percentage }% rychlost
label-replay-complete = { $percentage }% dokončeno

## LobbyLogic, InGameChatLogic
label-chat-disabled = Chat vypnut
label-chat-availability =
    { $seconds ->
        [one] Chat dostupný za { $seconds } sekundu...
        [few] Chat dostupný za { $seconds } sekundy...
       *[other] Chat dostupný za { $seconds } sekund...
    }

## LobbyLogic, ServerListLogic
label-bot-player = AI hráč

## LobbyLogic
notification-lobby-option = { $name }: { $value }.
notification-lobby-option-changed = { $name } změněno na { $value }.
notification-map-bots-disabled = Boti byli na této mapě zakázáni.

## IngameMenuLogic
menu-ingame =
    .leave = Odejít
    .abort = Zrušit misi
    .restart = Restartovat
    .surrender = Vzdát se
    .load-game = Načíst hru
    .save-game = Uložit hru
    .music = Hudba
    .settings = Nastavení
    .return-to-map = Návrat k mapě
    .resume = Pokračovat
    .save-map = Uložit mapu
    .exit-map = Zavřít editor map

dialog-leave-mission =
    .title = Opustit misi
    .prompt = Opustit hru a vrátit se do menu?
    .confirm = Odejít
    .cancel = Zůstat

dialog-restart-mission =
    .title = Restartovat
    .prompt = Opravdu chcete restartovat?
    .confirm = Restartovat
    .cancel = Zůstat

dialog-surrender =
    .title = Vzdát se
    .prompt = Opravdu se chcete vzdát?
    .confirm = Vzdát se
    .cancel = Zůstat

dialog-error-max-player =
    .title = Chyba: Překročen maximální počet hráčů
    .prompt = Je definováno příliš mnoho hráčů ({ $players }/{ $max }).
    .confirm = Zpět

dialog-exit-map-editor =
    .title = Zavřít editor map
    .prompt-unsaved = Zavřít a ztratit všechny neuložené změny?
    .prompt-deleted = Mapa mohla být smazána mimo editor
    .confirm-anyway = Přesto zavřít
    .confirm = Zavřít

dialog-play-map-warning =
    .title = Varování
    .prompt = Mapa mohla být smazána nebo obsahuje
    chyby, které brání jejímu načtení.
    .cancel = OK

dialog-exit-to-map-editor =
    .title = Opustit misi
    .prompt = Opustit hru a vrátit se do editoru?
    .confirm = Zpět do editoru
    .cancel = Zůstat

## IngamePowerBarLogic
## IngamePowerCounterLogic
label-power-usage = Spotřeba energie: { $usage }/{ $capacity }
label-infinite-power = Nekonečná

## IngameSiloBarLogic
## IngameCashCounterLogic
label-silo-usage = Kapacita sila: { $usage }/{ $capacity }

## ObserverShroudSelectorLogic
options-shroud-selector =
    .all-players = Všichni hráči
    .disable-shroud = Vypnout mlhu
    .other = Ostatní

## ObserverStatsLogic
options-observer-stats =
    .none = Informace: Žádné
    .basic = Základní
    .economy = Ekonomika
    .production = Výroba
    .support-powers = Podpůrné schopnosti
    .combat = Boj
    .army = Armáda
    .earnings-graph = Příjmy (graf)
    .army-graph = Armáda (graf)

## WorldTooltipLogic
label-unrevealed-terrain = Neodhalený terén

## KickClientLogic
dialog-kick-client =
    .prompt = Vyloučit { $player }?

## KickSpectatorsLogic
dialog-kick-spectators =
    .prompt =
    { $count ->
        [one] Opravdu chcete vyloučit jednoho diváka?
        [few] Opravdu chcete vyloučit { $count } diváky?
       *[other] Opravdu chcete vyloučit { $count } diváků?
    }

## LobbyLogic
options-slot-admin =
    .add-bots = Přidat
    .remove-bots = Odebrat
    .configure-bots = Nastavit boty
    .teams-count =
        { $count ->
            [one] { $count } tým
            [few] { $count } týmy
           *[other] { $count } týmů
        }
    .humans-vs-bots = Lidé vs. boti
    .free-for-all = Každý sám za sebe
    .configure-teams = Nastavit týmy

## LobbyLogic, InGameChatLogic
button-general-chat = Všem
button-team-chat = Tým

## LobbyOptionsLogic, MissionBrowserLogic
label-not-available = Nedostupné

## LobbyUtils
options-lobby-slot =
    .slot = Slot
    .open = Otevřený
    .closed = Uzavřený
    .bots = Boti
    .bots-disabled = Boti zakázáni

## MapPreviewLogic
label-connecting = Připojování...
label-downloading-map = Stahování { $size } kB
label-downloading-map-progress = Stahování { $size } kB ({ $progress }%)
button-retry-install = Zkusit znovu instalovat
button-retry-search = Zkusit znovu hledat
## also MapChooserLogic
label-created-by = Vytvořil(a) { $author }

## SpawnSelectorTooltipLogic
label-disabled-spawn = Zakázaná počáteční pozice
label-available-spawn = Dostupná počáteční pozice

## DisplaySettingsLogic
options-camera =
    .close = Blízko
    .medium = Střední
    .far = Daleko
    .furthest = Nejdále

options-display-mode =
    .windowed = V okně
    .legacy-fullscreen = Celá obrazovka (starší)
    .fullscreen = Celá obrazovka

label-video-display-index = Displej { $number }

options-status-bars =
    .standard = Standardní
    .show-on-damage = Zobrazit při poškození
    .always-show = Vždy zobrazit

options-target-lines =
    .automatic = Automaticky
    .manual = Ručně
    .disabled = Vypnuto

checkbox-frame-limiter = Povolit omezení snímků ({ $fps } FPS)

## HotkeysSettingsLogic
label-original-notice = Výchozí je „{ $key }"
label-duplicate-notice = Toto je již použito pro „{ $key }" v kontextu { $context }
hotkey-context-any = Jakýkoli

## GameplaySettingsLogic
auto-save-interval =
    .disabled = Vypnuto
    .options =
        { $seconds ->
            [one] 1 sekunda
            [few] { $seconds } sekundy
           *[other] { $seconds } sekund
        }
    .minute-options =
        { $minutes ->
            [one] 1 minuta
            [few] { $minutes } minuty
           *[other] { $minutes } minut
        }

auto-save-max-file-number =
    { $saves ->
        [one] { $saves } uložení
        [few] { $saves } uložení
       *[other] { $saves } uložení
    }

## InputSettingsLogic
options-mouse-scroll-type =
    .disabled = Vypnuto
    .standard = Standardní
    .inverted = Invertované
    .joystick = Joystick

## InputSettingsLogic, IntroductionPromptLogic
options-control-scheme =
    .classic = Klasické
    .modern = Moderní
    .otherrts = Jiné RTS

## SettingsLogic
dialog-settings-save =
    .title = Vyžadován restart
    .prompt = Některé změny se projeví až po
    restartu hry.
    .cancel = Pokračovat

dialog-settings-restart =
    .title = Restartovat nyní?
    .prompt = Některé změny se projeví až po
    restartu hry. Restartovat nyní?
    .confirm = Restartovat nyní
    .cancel = Restartovat později

dialog-settings-reset =
    .title = Obnovit { $panel }
    .prompt = Opravdu chcete obnovit
    všechna nastavení v tomto panelu?
    .confirm = Obnovit
    .cancel = Zrušit

## AssetBrowserLogic
label-all-packages = Všechny balíčky
label-length-in-seconds = { $length } s

## ConnectionLogic
label-connecting-to-endpoint = Připojování k { $endpoint }...
label-could-not-connect-to-target = Nelze se připojit k { $target }
label-unknown-error = Neznámá chyba
label-password-required = Vyžadováno heslo
label-connection-failed = Připojení selhalo
notification-mod-switch-failed = Přepnutí modu selhalo.

## GameSaveBrowserLogic
dialog-rename-save =
    .title = Přejmenovat uloženou hru
    .prompt = Zadejte nový název souboru:
    .confirm = Přejmenovat

dialog-delete-save =
    .title = Smazat vybranou uloženou hru?
    .prompt = Smazat „{ $save }".
    .confirm = Smazat

dialog-delete-all-saves =
    .title = Smazat všechny uložené hry?
    .prompt =
    { $count ->
        [one] Smazat { $count } uloženou hru.
        [few] Smazat { $count } uložené hry.
       *[other] Smazat { $count } uložených her.
    }
    .confirm = Smazat vše

notification-save-deletion-failed = Nepodařilo se smazat soubor uložené hry „{ $savePath }". Podrobnosti naleznete v logách.

dialog-overwrite-save =
    .title = Přepsat uloženou hru?
    .prompt = Přepsat { $file }?
    .confirm = Přepsat

## MainMenuLogic
label-loading-news = Načítání novinek
label-news-retrieval-failed = Nepodařilo se získat novinky: { $message }
label-news-parsing-failed = Nepodařilo se zpracovat novinky: { $message }
label-author-datetime = od { $author } v { $datetime }

## MapChooserLogic
label-all-maps = Všechny mapy
label-no-matches = Žádné výsledky
label-player-count =
    { $players ->
        [one] { $players } hráč
        [few] { $players } hráči
       *[other] { $players } hráčů
    }
label-map-size-huge = Obrovská
label-map-size-large = Velká
label-map-size-medium = Střední
label-map-size-small = Malá
label-map-searching-count =
    { $count ->
        [one] Hledání { $count } mapy v Centru zdrojů OpenRA...
        [few] Hledání { $count } map v Centru zdrojů OpenRA...
       *[other] Hledání { $count } map v Centru zdrojů OpenRA...
    }
label-map-unavailable-count =
    { $count ->
        [one] { $count } mapa nebyla nalezena v Centru zdrojů OpenRA
        [few] { $count } mapy nebyly nalezeny v Centru zdrojů OpenRA
       *[other] { $count } map nebylo nalezeno v Centru zdrojů OpenRA
    }

notification-map-deletion-failed = Nepodařilo se smazat mapu „{ $map }". Podrobnosti naleznete v souboru debug.log.

dialog-delete-map =
    .title = Smazat mapu
    .prompt = Smazat mapu „{ $title }"?
    .confirm = Smazat

dialog-delete-all-maps =
    .title = Smazat mapy
    .prompt = Smazat všechny mapy na této stránce?
    .confirm = Smazat

options-order-maps =
    .player-count = Hráči
    .title = Název
    .date = Datum
    .size = Velikost

button-mapchooser-system-maps-tab = Oficiální mapy
button-mapchooser-remote-maps-tab = Mapy serveru
button-mapchooser-user-maps-tab = Vlastní mapy
button-mapchooser-generated-maps-tab = Generovat mapu

## MissionBrowserLogic
dialog-no-video =
    .title = Video nenainstalováno
    .prompt =
        Herní videa lze nainstalovat z nabídky
        „Správa obsahu".
    .cancel = Zpět

dialog-cant-play-video =
    .title = Nelze přehrát video
    .prompt = Při přehrávání videa došlo k chybě.
    .cancel = Zpět

## MusicPlayerLogic
label-sound-muted = Zvuk je v nastavení ztlumen.
label-no-song-playing = Nehraje žádná skladba

## MuteHotkeyLogic
label-audio-muted = Zvuk ztlumen.
label-audio-unmuted = Zvuk obnoven.

## PlayerProfileLogic
label-loading-player-profile = Načítání profilu hráče...
label-loading-player-profile-failed = Nepodařilo se načíst profil hráče.

## ProductionTooltipLogic, EncyclopediaLogic
label-requires = Vyžaduje { $prerequisites }.

## ReplayBrowserLogic
label-duration = Délka: { $time }

options-replay-type =
    .singleplayer = Jeden hráč
    .multiplayer = Více hráčů

options-winstate =
    .victory = Vítězství
    .defeat = Porážka

options-replay-date =
    .today = Dnes
    .last-week = Posledních 7 dní
    .last-fortnight = Posledních 14 dní
    .last-month = Posledních 30 dní

options-replay-duration =
    .very-short = Pod 5 min
    .short = Krátké (10 min)
    .medium = Střední (30 min)
    .long = Dlouhé (60+ min)

dialog-rename-replay =
    .title = Přejmenovat záznam
    .prompt = Zadejte nový název souboru:
    .confirm = Přejmenovat

dialog-delete-replay =
    .title = Smazat vybraný záznam?
    .prompt = Smazat záznam { $replay }?
    .confirm = Smazat

dialog-delete-all-replays =
    .title = Smazat všechny vybrané záznamy?
    .prompt =
    { $count ->
        [one] Smazat { $count } záznam.
        [few] Smazat { $count } záznamy.
       *[other] Smazat { $count } záznamů.
    }
    .confirm = Smazat vše

notification-replay-deletion-failed = Nepodařilo se smazat soubor záznamu „{ $file }". Podrobnosti naleznete v souboru debug.log.

## ReplayUtils
-incompatible-replay-recorded = Byl nahrán s

dialog-incompatible-replay =
    .title = Nekompatibilní záznam
    .prompt = Metadata záznamu nelze přečíst.
    .confirm = OK
    .prompt-unknown-version = { -incompatible-replay-recorded } neznámou verzí.
    .prompt-unknown-mod = { -incompatible-replay-recorded } neznámým modem.
    .prompt-unavailable-mod = { -incompatible-replay-recorded } nedostupným modem: { $mod }.
    .prompt-incompatible-version = { -incompatible-replay-recorded } nekompatibilní verzí:
    { $version }.
    .prompt-unavailable-map = { -incompatible-replay-recorded } nedostupnou mapou:
    { $map }.

# SelectUnitsByTypeHotkeyLogic
nothing-selected = Nic nevybráno.

## SelectUnitsByTypeHotkeyLogic, SelectAllUnitsHotkeyLogic
selected-units-across-screen =
    { $units ->
        [one] Vybrána jedna jednotka na obrazovce.
        [few] Vybrány { $units } jednotky na obrazovce.
       *[other] Vybráno { $units } jednotek na obrazovce.
    }

selected-units-across-map =
    { $units ->
        [one] Vybrána jedna jednotka na mapě.
        [few] Vybrány { $units } jednotky na mapě.
       *[other] Vybráno { $units } jednotek na mapě.
    }

## ServerCreationLogic
label-internet-server-nat-A = Internetový server (UPnP/NAT-PMP
label-internet-server-nat-B-enabled = Povoleno
label-internet-server-nat-B-not-supported = Nepodporováno
label-internet-server-nat-B-disabled = Zakázáno
label-internet-server-nat-C = ):

label-local-server = Místní server:

dialog-server-creation-failed =
    .prompt = Nelze naslouchat na portu { $port }.
    .prompt-port-used = Zkontrolujte, zda port není již používán.
    .prompt-error = Chyba: „{ $message }" ({ $code }).
    .title = Vytvoření serveru selhalo
    .cancel = Zpět

## ServerListLogic
label-players-online-count =
    { $players ->
        [one] { $players } hráč online
        [few] { $players } hráči online
       *[other] { $players } hráčů online
    }

label-search-status-failed = Nepodařilo se načíst seznam serverů.
label-search-status-no-games = Nenalezeny žádné hry. Zkuste změnit filtry.
label-no-server-selected = Žádný server nevybrán

label-map-status-searching = Hledání...
label-map-classification-unknown = Neznámá mapa

label-players-count =
    { $players ->
        [0] Žádní hráči
        [one] Jeden hráč
        [few] { $players } hráči
       *[other] { $players } hráčů
    }

label-bots-count =
    { $bots ->
        [0] Žádní boti
        [one] Jeden bot
        [few] { $bots } boti
       *[other] { $bots } botů
    }

## ServerListLogic, ReplayBrowserLogic, ObserverShroudSelectorLogic
label-players = Hráči

## ServerListLogic, GameInfoStatsLogic
label-spectators = Diváci
label-spectators-count =
    { $spectators ->
        [0] Žádní diváci
        [one] Jeden divák
        [few] { $spectators } diváci
       *[other] { $spectators } diváků
    }

## ServerlistLogic, GameInfoStatsLogic, ObserverShroudSelectorLogic, SpawnSelectorTooltipLogic, ReplayBrowserLogic
label-team-name = Tým { $team }
label-no-team = Bez týmu

label-playing = Hraje
label-waiting = Čeká

label-other-players-count =
    { $players ->
        [one] Jeden další hráč
        [few] { $players } další hráči
       *[other] { $players } dalších hráčů
    }

label-in-progress-for =
    { $minutes ->
        [0] Probíhá méně než minutu.
        [one] Probíhá { $minutes } minutu.
        [few] Probíhá { $minutes } minuty.
       *[other] Probíhá { $minutes } minut.
    }

label-password-protected = Chráněno heslem
label-waiting-for-players = Čeká se na hráče
label-server-shutting-down = Server se vypíná
label-unknown-server-state = Neznámý stav serveru

## Game
notification-saved-screenshot = Uložen snímek obrazovky { $filename }

## ChatCommands
notification-invalid-command = { $name } není platný příkaz.

## DebugVisualizationCommands
description-combat-geometry = přepíná překrytí bojové geometrie.
description-render-geometry = přepíná překrytí geometrie vykreslování.
description-screen-map-overlay = přepíná překrytí mapy obrazovky.
description-depth-buffer = přepíná překrytí hloubkového bufferu.
description-actor-tags-overlay = přepíná překrytí štítků objektů.

## DevCommands
notification-cheats-disabled = Cheaty jsou vypnuty.
notification-invalid-cash-amount = Neplatná částka.
description-toggle-visibility = přepíná kontroly viditelnosti a minimapu.
description-give-cash = přidá výchozí nebo zadanou částku peněz.
description-give-cash-all = přidá výchozí nebo zadanou částku peněz všem hráčům a AI.
description-instant-building = přepíná okamžitou stavbu.
description-build-anywhere = přepíná možnost stavět kdekoliv.
description-unlimited-power = přepíná nekonečnou energii.
description-enable-tech = přepíná možnost stavět cokoliv.
description-fast-charge = přepíná téměř okamžité nabíjení podpůrných schopností.
description-dev-cheat-all = přepíná všechny cheaty a přidá vám peníze navíc.
description-dev-crash = způsobí pád hry.
description-levelup-actor = přidá zadaný počet úrovní vybraným objektům.
description-player-experience = přidá zadané množství zkušeností hráče vlastníkovi/vlastníkům vybraných objektů.
description-power-outage = způsobí 5sekundový výpadek energie pro vlastníka/vlastníky vybraných objektů.
description-kill-selected-actors = zabije vybrané objekty.
description-dispose-selected-actors = odstraní vybrané objekty.

## HelpCommands
notification-available-commands = Zde jsou dostupné příkazy:
description-no-description = popis není k dispozici.
description-help-description = poskytuje užitečné informace o různých příkazech.

## PlayerCommands
description-pause-description = pozastaví nebo obnoví hru.
description-surrender-description = zničí vše a prohraje hru.

## DeveloperMode
notification-cheat-used = Použit cheat: { $cheat } hráčem { $player }{ $suffix }.

## CustomTerrainDebugOverlay
description-custom-terrain-debug-overlay = přepíná překrytí ladění vlastního terénu.

## CellTriggerOverlay
description-cell-triggers-overlay = přepíná překrytí skriptových spouštěčů.

## HierarchicalPathFinderOverlay
description-hpf-debug-overlay = přepíná překrytí hierarchického vyhledávače cest.

## PathFinderOverlay
description-path-debug-overlay = přepíná vizualizaci hledání cest.

## TerrainGeometryOverlay
description-terrain-geometry-overlay = přepíná překrytí geometrie terénu.

## ActorMapOverlay
description-actor-map-overlay = přepíná překrytí mapy objektů.

## MapOptions, MissionBrowserLogic
options-game-speed =
    .slowest = Nejpomalejší
    .slower = Pomalejší
    .normal = Normální
    .fast = Rychlá
    .faster = Rychlejší
    .fastest = Nejrychlejší

## TimeLimitManager
options-time-limit =
    .no-limit = Bez limitu
    .options =
        { $minutes ->
            [one] { $minutes } minuta
            [few] { $minutes } minuty
           *[other] { $minutes } minut
        }

notification-time-limit-expired = Časový limit vypršel.

## EditorActorBrush
notification-added-actor = Přidán { $name } ({ $id })

## EditorCopyPasteBrush
notification-copied-tiles =
    { $tiles ->
        [one] Zkopírován { $tiles } dílek
        [few] Zkopírovány { $tiles } dílky
       *[other] Zkopírováno { $tiles } dílků
    }
notification-copied-actors =
    { $actors ->
        [one] Zkopírován { $actors } objekt
        [few] Zkopírovány { $actors } objekty
       *[other] Zkopírováno { $actors } objektů
    }
notification-copied-tiles-actors = Zkopírováno { $tiles } dílků a { $actors } objektů

## EditorDefaultBrush
notification-selected-area = Vybrána oblast { $x },{ $y } ({ $width },{ $height })
notification-removed-area = Odstraněna oblast { $x },{ $y } ({ $width },{ $height })
notification-selected-actor = Vybrán objekt { $id }
notification-cleared-selection = Výběr vymazán
notification-removed-actor = Odstraněn { $name } ({ $id })
notification-removed-resource = Odstraněn { $type }
notification-moved-actor = Přesunut { $id } z { $x1 },{ $y1 } na { $x2 },{ $y2 }

## EditorResourceBrush
notification-added-resource =
    { $count ->
       [one] Přidáno jedno pole { $type }
       [few] Přidána { $count } pole { $type }
      *[other] Přidáno { $count } polí { $type }
    }

## EditorTileBrush
notification-added-tile = Přidán dílek { $id }
notification-filled-tile = Vyplněno dílkem { $id }

## EditorMarkerLayerBrush
notification-added-marker-tiles-markers =
    .red = červený
    .orange = oranžový
    .yellow = žlutý
    .green = zelený
    .cyan = azurový
    .blue = modrý
    .purple = fialový
    .magenta = purpurový
notification-added-marker-tiles =
    { $count ->
       [one] Přidán { $type } značkovací dílek
       [few] Přidány { $count } { $type } značkovací dílky
      *[other] Přidáno { $count } { $type } značkovacích dílků
    }
notification-removed-marker-tiles =
    { $count ->
       [one] Odstraněn značkovací dílek
       [few] Odstraněny { $count } značkovací dílky
      *[other] Odstraněno { $count } značkovacích dílků
    }
notification-cleared-selected-marker-tiles =
    { $count ->
       [one] Vymazán { $type } značkovací dílek
       [few] Vymazány { $count } { $type } značkovací dílky
      *[other] Vymazáno { $count } { $type } značkovacích dílků
    }
notification-cleared-all-marker-tiles = Vymazáno { $count } značkovacích dílků

## EditorActionManager
notification-opened = Otevřeno

## MapOverlaysLogic
mirror-mode =
    .none = Žádný
    .flip = Překlopit
    .rotate = Otočit

## ActorEditLogic
notification-edited-actor = Upraven { $name } ({ $id })
notification-edited-actor-id = Upraven { $name } ({ $old-id }-> { $new-id })

## ConquestVictoryConditions, StrategicVictoryConditions
notification-player-is-victorious = { $player } zvítězil(a).
notification-player-is-defeated = { $player } byl(a) poražen(a).

## OrderManager
notification-desync-compare-logs = Ztráta synchronizace ve snímku { $frame }.
    Porovnejte syncreport.log s ostatními hráči.

## WidgetUtils
label-win-state-won = Výhra
label-win-state-lost = Prohra
label-client-state-disconnected = Odešel/Odešla

## Player
enumerated-bot-name =
    { $name } { $number ->
       *[zero] {""}
        [other] { $number }
    }

## ModifiersExts
keycode-modifier =
    .alt = Alt
    .ctrl = Ctrl
    .meta = Meta
    .cmd = Cmd
    .shift = Shift
    .none = None

## KeycodeExts
keycode =
    .unknown = Undefined
    .return = Return
    .escape = Escape
    .backspace = Backspace
    .tab = Tab
    .space = Space
    .exclaim = !
    .quotedbl = "
    .hash = #
    .percent = %
    .dollar = $
    .ampersand = &
    .quote = '
    .leftparen = (
    .rightparen = )
    .asterisk = *
    .plus = +
    .comma = ,
    .minus = -
    .period = .
    .slash = /
    .number_0 = 0
    .number_1 = 1
    .number_2 = 2
    .number_3 = 3
    .number_4 = 4
    .number_5 = 5
    .number_6 = 6
    .number_7 = 7
    .number_8 = 8
    .number_9 = 9
    .colon = :
    .semicolon = ;
    .less = <
    .equals = =
    .greater = >
    .question = ?
    .at = @
    .leftbracket = [
    .backslash = \
    .rightbracket = ]
    .caret = ^
    .underscore = _
    .backquote = `
    .a = A
    .b = B
    .c = C
    .d = D
    .e = E
    .f = F
    .g = G
    .h = H
    .i = I
    .j = J
    .k = K
    .l = L
    .m = M
    .n = N
    .o = O
    .p = P
    .q = Q
    .r = R
    .s = S
    .t = T
    .u = U
    .v = V
    .w = W
    .x = X
    .y = Y
    .z = Z
    .capslock = CapsLock
    .f1 = F1
    .f2 = F2
    .f3 = F3
    .f4 = F4
    .f5 = F5
    .f6 = F6
    .f7 = F7
    .f8 = F8
    .f9 = F9
    .f10 = F10
    .f11 = F11
    .f12 = F12
    .printscreen = PrintScreen
    .scrolllock = ScrollLock
    .pause = Pause
    .insert = Insert
    .home = Home
    .pageup = PageUp
    .delete = Delete
    .end = End
    .pagedown = PageDown
    .right = Right
    .left = Left
    .down = Down
    .up = Up
    .numlockclear = Numlock
    .kp_divide = Keypad /
    .kp_multiply = Keypad *
    .kp_minus = Keypad -
    .kp_plus = Keypad +
    .kp_enter = Keypad Enter
    .kp_1 = Keypad 1
    .kp_2 = Keypad 2
    .kp_3 = Keypad 3
    .kp_4 = Keypad 4
    .kp_5 = Keypad 5
    .kp_6 = Keypad 6
    .kp_7 = Keypad 7
    .kp_8 = Keypad 8
    .kp_9 = Keypad 9
    .kp_0 = Keypad 0
    .kp_period = Keypad .
    .application = Application
    .power = Power
    .kp_equals = Keypad =
    .f13 = F13
    .f14 = F14
    .f15 = F15
    .f16 = F16
    .f17 = F17
    .f18 = F18
    .f19 = F19
    .f20 = F20
    .f21 = F21
    .f22 = F22
    .f23 = F23
    .f24 = F24
    .execute = Execute
    .help = Help
    .menu = Menu
    .select = Select
    .stop = Stop
    .again = Again
    .undo = Undo
    .cut = Cut
    .copy = Copy
    .paste = Paste
    .find = Find
    .mute = Mute
    .volumeup = VolumeUp
    .volumedown = VolumeDown
    .kp_comma = Keypad ,
    .kp_equalsas400 = Keypad (AS400)
    .alterase = AltErase
    .sysreq = SysReq
    .cancel = Cancel
    .clear = Clear
    .prior = Prior
    .return2 = Return
    .separator = Separator
    .out = Out
    .oper = Oper
    .clearagain = Clear / Again
    .crsel = CrSel
    .exsel = ExSel
    .kp_00 = Keypad 00
    .kp_000 = Keypad 000
    .thousandsseparator = ThousandsSeparator
    .decimalseparator = DecimalSeparator
    .currencyunit = CurrencyUnit
    .currencysubunit = CurrencySubUnit
    .kp_leftparen = Keypad (
    .kp_rightparen = Keypad )
    .kp_leftbrace = Keypad {"{"}
    .kp_rightbrace = Keypad {"}"}
    .kp_tab = Keypad Tab
    .kp_backspace = Keypad Backspace
    .kp_a = Keypad A
    .kp_b = Keypad B
    .kp_c = Keypad C
    .kp_d = Keypad D
    .kp_e = Keypad E
    .kp_f = Keypad F
    .kp_xor = Keypad XOR
    .kp_power = Keypad ^
    .kp_percent = Keypad %
    .kp_less = Keypad <
    .kp_greater = Keypad >
    .kp_ampersand = Keypad &
    .kp_dblampersand = Keypad &&
    .kp_verticalbar = Keypad |
    .kp_dblverticalbar = Keypad ||
    .kp_colon = Keypad :
    .kp_hash = Keypad #
    .kp_space = Keypad Space
    .kp_at = Keypad @
    .kp_exclam = Keypad !
    .kp_memstore = Keypad MemStore
    .kp_memrecall = Keypad MemRecall
    .kp_memclear = Keypad MemClear
    .kp_memadd = Keypad MemAdd
    .kp_memsubtract = Keypad MemSubtract
    .kp_memmultiply = Keypad MemMultiply
    .kp_memdivide = Keypad MemDivide
    .kp_plusminus = Keypad +/-
    .kp_clear = Keypad Clear
    .kp_clearentry = Keypad ClearEntry
    .kp_binary = Keypad Binary
    .kp_octal = Keypad Octal
    .kp_decimal = Keypad Decimal
    .kp_hexadecimal = Keypad Hexadecimal
    .lctrl = Left Ctrl
    .lshift = Left Shift
    .lalt = Left Alt
    .lgui = Left GUI
    .rctrl = Right Ctrl
    .rshift = Right Shift
    .ralt = Right Alt
    .rgui = Right GUI
    .mode = ModeSwitch
    .audionext = AudioNext
    .audioprev = AudioPrev
    .audiostop = AudioStop
    .audioplay = AudioPlay
    .audiomute = AudioMute
    .mediaselect = MediaSelect
    .www = WWW
    .mail = Mail
    .calculator = Calculator
    .computer = Computer
    .ac_search = AC Search
    .ac_home = AC Home
    .ac_back = AC Back
    .ac_forward = AC Forward
    .ac_stop = AC Stop
    .ac_refresh = AC Refresh
    .ac_bookmarks = AC Bookmarks
    .brightnessdown = BrightnessDown
    .brightnessup = BrightnessUp
    .displayswitch = DisplaySwitch
    .kbdillumtoggle = KBDIllumToggle
    .kbdillumdown = KBDIllumDown
    .kbdillumup = KBDIllumUp
    .eject = Eject
    .sleep = Sleep
    .mouse4 = Mouse 4
    .mouse5 = Mouse 5

## MapGeneratorToolLogic
notification-map-generator-generated = Vygenerováno pomocí { $name }

dialog-notification-map-generator-failed =
    .title = Generování mapy selhalo
    .prompt = Podrobnosti naleznete v debug.log.
    .cancel = Zavřít

## EditorTilingPathBrush
notification-tiling-path-started = Zahájena dlaždičková cesta
notification-tiling-path-updated = Aktualizována dlaždičková cesta
notification-tiling-path-reset = Zrušena dlaždičková cesta
notification-tiling-path-painted = Vykreslena dlaždičková cesta
