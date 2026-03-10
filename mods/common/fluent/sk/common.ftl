## Buttons
button-cancel = Zrušiť
button-retry = Skúste to znova
button-back = Späť
button-continue = Pokračovať
button-quit = Ukončiť

## Server Orders
notification-custom-rules = Táto mapa obsahuje vlastné pravidlá. Zážitok z hry sa môže zmeniť.
notification-two-humans-required = Tento server vyžaduje na začatie zápasu aspoň dvoch ľudských hráčov.
notification-unknown-server-command = Neznámy príkaz servera: {…}.
notification-admin-start-game = Hru môže začať iba hostiteľ.
notification-no-start-until-required-slots-full = Hru nie je možné spustiť, kým sa nezaplnia požadované sloty.
notification-no-start-without-players = Hra nemôže začať bez hráčov.
notification-insufficient-enabled-spawn-points = Hru nie je možné spustiť, kým nebude povolených viac spawn bodov.
notification-malformed-command = Chybný príkaz {…}.
notification-state-unchanged-ready = Stav nemožno zmeniť, keď je označený ako pripravený.
notification-invalid-faction-selected = Vybraná neplatná frakcia: {…}.
notification-state-unchanged-game-started = Po spustení hry nie je možné zmeniť stav ({…}).
notification-requires-host = To môže urobiť iba hostiteľ.
notification-invalid-bot-slot = Nie je možné pridať roboty do slotu s iným klientom.
notification-invalid-bot-type = Neplatný typ robota.
notification-admin-change-map = Mapu môže zmeniť iba hostiteľ.
notification-player-disconnected = Zariadenie {…} sa odpojilo.
notification-team-player-disconnected = {…} (tím {…}) sa odpojil.
notification-observer-disconnected = {…} (divák) sa odpojil.
notification-unknown-map = Mapa sa na serveri nenašla.
notification-searching-map = Hľadá sa mapa v Centre zdrojov...
notification-admin-change-configuration = Konfiguráciu môže zmeniť iba hostiteľ.
notification-changed-map = {…} zmenil mapu na {…}.
notification-you-were-kicked = Boli ste vyhodení zo servera.
notification-admin-kicked = {…} vyhodil {…} zo servera.
notification-kicked = {…} bol vyhodený zo servera.
notification-temp-ban = {…} dočasne zakázal {…} na serveri.
notification-admin-transfer-admin = Iba správcovia môžu preniesť správcu na iného hráča.
notification-admin-move-spectators = Presúvať hráčov k divákom môže iba hostiteľ.
notification-empty-slot = Nikto v tom slote.
notification-move-spectators = {…} presunuté {…} medzi divákov.
notification-nick-changed = {…} je teraz známy ako {…}.
notification-player-dropped = Hráč bol vyradený po vypršaní časového limitu.
notification-connection-problems = {…} má problémy s pripojením.
notification-timeout-dropped = {…} bolo po vypršaní časového limitu zrušené.
notification-timeout-dropped-in = { $timeout -> [one] { $player } bude odpojený o { $timeout } sekundu. [few] { $player } bude odpojený o { $timeout } sekundy. *[other] { $player } bude odpojený o { $timeout } sekúnd. }
notification-error-game-started = Hra sa už začala.
notification-requires-password = Server vyžaduje heslo.
notification-incorrect-password = Nesprávne heslo.
notification-incompatible-mod = Na serveri je spustený nekompatibilný mod.
notification-incompatible-version = Server používa nekompatibilnú verziu.
notification-incompatible-protocol = Server používa nekompatibilný protokol.
notification-you-were-banned = Bol vám zakázaný prístup na server.
notification-you-were-temp-banned = Bol vám dočasne zakázaný prístup na server.
notification-game-full = Hra je plná.
notification-new-admin = {…} je teraz správcom.
notification-invalid-configuration-command = Neplatný konfiguračný príkaz.
notification-admin-option = Túto možnosť môže nastaviť iba hostiteľ.
notification-error-number-teams = Nepodarilo sa analyzovať počet tímov: {…}.
notification-admin-kick = Kopať hráčov môže iba hostiteľ.
notification-kick-self = Hostiteľ sa nemôže nakopnúť.
notification-kick-none = Nikto v tom slote.
notification-no-kick-game-started = Po začatí hry je možné kopať iba divákov a porazených hráčov.
notification-admin-clear-spawn = Iba správcovia môžu vymazávať body spawn.
notification-spawn-occupied = Nemôžete obsadiť rovnaký spawn point ako iný hráč.
notification-spawn-locked = Spawn point je uzamknutý na slote iného hráča.
notification-admin-lobby-info = Informácie o lobby môže nastaviť iba hostiteľ.
notification-invalid-lobby-info = Boli odoslané neplatné informácie o lobby.
notification-player-color-terrain = Farba bola upravená tak, aby bola menej podobná terénu.
notification-player-color-player = Farba bola upravená tak, aby bola menej podobná inému prehrávaču.
notification-invalid-player-color = Nedá sa určiť platná farba hráča. Bola vybratá náhodná farba.
notification-invalid-error-code = Chybové hlásenie sa nepodarilo analyzovať.
notification-master-server-connected = Nadviazala sa komunikácia so serverom.
notification-master-server-error = Komunikácia hlavného servera zlyhala.
notification-game-offline = Hra nebola inzerovaná online.
notification-no-port-forward = Port servera nie je dostupný z internetu.
notification-blacklisted-server-name = Názov servera obsahuje slovo na čiernej listine.
notification-requires-authentication = Server vyžaduje, aby hráči mali účet na fóre OpenRA.
notification-no-permission-to-join = Nemáte povolenie pripojiť sa k tomuto serveru.
notification-slot-closed = Váš priestor bol uzavretý hostiteľom.

## ServerOrders, UnitOrders
notification-joined = {…} sa pripojil k hre.
notification-lobby-disconnected = {…} odišiel.

## UnitOrders
notification-game-has-started = Hra sa začala.
notification-game-paused = Hra bola pozastavená používateľom {…}.
notification-game-unpaused = Hru zrušil {…}.

## Server
notification-game-started = Hra začala.

## PlayerMessageTracker
notification-chat-temp-disabled = { $remaining -> [one] Chat je dočasne zablokovaný. Skúste to prosím znova o { $remaining } sekundu. [few] Chat je dočasne zablokovaný. Skúste to prosím znova o { $remaining } sekundy. *[other] Chat je dočasne zablokovaný. Skúste to prosím znova o { $remaining } sekúnd. }

## VoteKickTracker
notification-unable-to-start-a-vote = Nedá sa spustiť hlasovanie.
notification-insufficient-votes-to-kick = Nedostatok hlasov na vykopnutie hráča {…}.
notification-kick-already-voted = Už ste hlasovali.
notification-vote-kick-started = Hráč {…} začal hlasovať za vykopnutie hráča {…}.
notification-vote-kick-in-progress = {…}% hráčov hlasovalo za vykopnutie hráča {…}.
notification-vote-kick-ended = Hlasovanie za vykopnutie hráča {…} zlyhalo.

## ActorEditLogic
label-duplicate-actor-id = Duplicitné ID aktéra
label-actor-id = Zadajte ID herca
label-actor-owner = Vlastník

## ActorSelectorLogic
label-actor-type = Typ: {…}

## CommonSelectorLogic
options-common-selector =
    .search-results = Výsledky vyhľadávania
    .all = Všetky
    .multiple = Viacnásobné
    .none = nan

## SaveMapLogic
label-unpacked-map = rozbalené

dialog-save-map-failed =
    .title = Nepodarilo sa uložiť mapu
    .prompt = Podrobnosti nájdete v debug.log.
    .confirm = OK

dialog-overwrite-map-failed =
    .title = Upozornenie
    .prompt =
        Uložením prepíšete
        už existujúcu mapu.
    .confirm = Uložiť

dialog-overwrite-map-outside-edit =
    .title = Upozornenie
    .prompt =
        Mapa bola upravená mimo editora.
        Uložením môžete prepísať priebeh.
    .confirm = Uložiť

notification-save-current-map = Uložená aktuálna mapa.

## GameInfoLogic
menu-game-info =
    .objectives = Ciele
    .briefing = Brífing
    .options = Možnosti
    .debug = Ladiť
    .chat = Chat

## GameInfoObjectivesLogic, GameInfoStatsLogic
label-mission-in-progress = Prebieha
label-mission-accomplished = Splnené
label-mission-failed = Nepodarilo sa

## GameInfoStatsLogic
label-mute-player = Ignorovať tohto hráča
label-unmute-player = Prestať ignorovať tohto hráča
button-kick-player = Kick tohto hráča
button-vote-kick-player = Hlasujte za vykopnutie tohto hráča

dialog-kick =
    .title = Kick {…}?
    .prompt = Tento hráč sa nebude môcť znova zapojiť do hry.
    .confirm = Kick

dialog-vote-kick =
    .title = Vote to kick { $player }?
    .prompt = This player will not be able to rejoin the game.
    .prompt-break-bots = { $bots -> [one] Vyhodenie správcu hry tiež vyhodí 1 bota. [few] Vyhodenie správcu hry tiež vyhodí { $bots } botov. *[other] Vyhodenie správcu hry tiež vyhodí { $bots } botov. }
    .vote-start = Start Vote
    .vote-for = Vote For
    .vote-against = Vote Against
    .vote-cancel = Abstain

notification-vote-kick-disabled = Hlasovanie je na tomto serveri zakázané.

## GameTimerLogic
label-paused = Pozastavené
label-max-speed = Maximálna rýchlosť
label-replay-speed = {…}% Speed
label-replay-complete = {…}% complete

## LobbyLogic, InGameChatLogic
label-chat-disabled = Chat vypnutý
label-chat-availability = { $seconds -> [one] Chat bude dostupný o { $seconds } sekundu... [few] Chat bude dostupný o { $seconds } sekundy... *[other] Chat bude dostupný o { $seconds } sekúnd... }

## LobbyLogic, ServerListLogic
label-bot-player = AI prehrávač

## LobbyLogic
notification-lobby-option = {…}: {…}.
notification-lobby-option-changed = {…} changed to {…}.
notification-map-bots-disabled = Roboty boli na tejto mape zakázané.

## IngameMenuLogic
menu-ingame =
    .leave = Opustiť
    .abort = Prerušiť misiu
    .restart = Reštartovať
    .surrender = Vzdať sa
    .load-game = Načítať hru
    .save-game = Uložiť hru
    .music = Hudba
    .settings = Nastavenia
    .return-to-map = Späť na mapu
    .resume = Pokračovať
    .save-map = Uložiť mapu
    .exit-map = Ukončiť editor mapy

dialog-leave-mission =
    .title = Opustiť misiu
    .prompt = Opustiť túto hru a vrátiť sa do menu?
    .confirm = Opustiť
    .cancel = Zostaň

dialog-restart-mission =
    .title = Reštartovať
    .prompt = Naozaj chcete reštartovať?
    .confirm = Reštartovať
    .cancel = Zostaň

dialog-surrender =
    .title = Vzdať sa
    .prompt = Si si istý, že sa chceš vzdať?
    .confirm = Vzdať sa
    .cancel = Zostaň

dialog-error-max-player =
    .title = Chyba: Prekročený maximálny počet hráčov
    .prompt = Je definovaných príliš veľa hráčov ({…}/{…}).
    .confirm = Späť

dialog-exit-map-editor =
    .title = Ukončiť editor mapy
    .prompt-unsaved = Ukončiť a stratiť všetky neuložené zmeny?
    .prompt-deleted = Mapa mohla byť vymazaná mimo editora
    .confirm-anyway = Napriek tomu odísť
    .confirm = Ukončiť

dialog-play-map-warning =
    .title = Upozornenie
    .prompt =
        Mapa mohla byť vymazaná alebo obsahuje
        chyby, ktoré bránia jeho načítaniu.
    .cancel = Dobre

dialog-exit-to-map-editor =
    .title = Opustiť misiu
    .prompt = Opustiť túto hru a vrátiť sa do editora?
    .confirm = Späť do editora
    .cancel = Zostaň

## IngamePowerBarLogic
## IngamePowerCounterLogic
label-power-usage = Spotreba energie: {…}/{…}
label-infinite-power = Nekonečné

## IngameSiloBarLogic
## IngameCashCounterLogic
label-silo-usage = Využitie sila: {…}/{…}

## ObserverShroudSelectorLogic
options-shroud-selector =
    .all-players = Všetci hráči
    .disable-shroud = Zakázať plášť
    .other = Iné

## ObserverStatsLogic
options-observer-stats =
    .none = Informácie: Žiadne
    .basic = Základné
    .economy = Ekonomika
    .production = Výroba
    .support-powers = Podporné právomoci
    .combat = Boj
    .army = armáda
    .earnings-graph = Zárobky (graf)
    .army-graph = armáda (graf)

## WorldTooltipLogic
label-unrevealed-terrain = Neodhalený terén

## KickClientLogic
dialog-kick-client =
    .prompt = Vykopnúť {…}?

## KickSpectatorsLogic
dialog-kick-spectators =
    .prompt = { $count -> [one] Naozaj chcete vyhodiť jedného diváka? [few] Naozaj chcete vyhodiť { $count } divákov? *[other] Naozaj chcete vyhodiť { $count } divákov? }

## LobbyLogic
options-slot-admin =
    .add-bots = Pridať
    .remove-bots = Odstrániť
    .configure-bots = Konfigurovať roboty
    .teams-count = {…} Tímy
    .humans-vs-bots = Ľudia vs roboti
    .free-for-all = Zadarmo pre všetkých
    .configure-teams = Konfigurovať tímy

## LobbyLogic, InGameChatLogic
button-general-chat = Všetky
button-team-chat = Tím

## LobbyOptionsLogic, MissionBrowserLogic
label-not-available = Nedostupné

## LobbyUtils
options-lobby-slot =
    .slot = Slot
    .open = Otvoriť
    .closed = Zatvorené
    .bots = Boti
    .bots-disabled = Roboty sú zakázané

## MapPreviewLogic
label-connecting = Pripája sa...
label-downloading-map = Sťahuje sa {…} kB
label-downloading-map-progress = Sťahuje sa {…} kB ({…} %)
button-retry-install = Zopakovať inštaláciu
button-retry-search = Opakovať vyhľadávanie
## also MapChooserLogic
label-created-by = Vytvoril {…}

## SpawnSelectorTooltipLogic
label-disabled-spawn = Zakázané spawn
label-available-spawn = Dostupné spawn

## DisplaySettingsLogic
options-camera =
    .close = Zavrieť
    .medium = Stredné
    .far = Ďaleko
    .furthest = Najďalej

options-display-mode =
    .windowed = Okno
    .legacy-fullscreen = Celá obrazovka (staršie)
    .fullscreen = Celá obrazovka

label-video-display-index = Zobraziť {…}

options-status-bars =
    .standard = Štandardné
    .show-on-damage = Show On Damage
    .always-show = Vždy zobraziť

options-target-lines =
    .automatic = Automatické
    .manual = Manuál
    .disabled = Zakázané

checkbox-frame-limiter = Povoliť obmedzovač snímok ({…} FPS)

## HotkeysSettingsLogic
label-original-notice = Predvolená hodnota je "{…}"
label-duplicate-notice = Toto sa už používa pre „{…}“ v kontexte {…}
hotkey-context-any = Akékoľvek

## GameplaySettingsLogic
auto-save-interval =
    .disabled = Disabled
    .options = { $seconds -> [one] 1 sekunda [few] { $seconds } sekundy *[other] { $seconds } sekúnd }
    .minute-options = { $minutes -> [one] 1 minúta [few] { $minutes } minúty *[other] { $minutes } minút }

auto-save-max-file-number = {…} ušetrí

## InputSettingsLogic
options-mouse-scroll-type =
    .disabled = Zakázané
    .standard = Štandardné
    .inverted = Obrátené
    .joystick = Joystick

## InputSettingsLogic, IntroductionPromptLogic
options-control-scheme =
    .classic = Klasické
    .modern = Moderné
    .otherrts = Iné RTS

## SettingsLogic
dialog-settings-save =
    .title = Vyžaduje sa reštart
    .prompt =
        Niektoré zmeny sa prejavia až po
        hra sa reštartuje.
    .cancel = Pokračovať

dialog-settings-restart =
    .title = Reštartovať teraz?
    .prompt =
        Niektoré zmeny sa prejavia až po
        hra sa reštartuje. Reštartovať teraz?
    .confirm = Reštartovať teraz
    .cancel = Reštartovať neskôr

dialog-settings-reset =
    .title = Resetovať {…}
    .prompt =
        Naozaj chcete resetovať?
        všetky nastavenia na tomto paneli?
    .confirm = Resetovať
    .cancel = Zrušiť

## AssetBrowserLogic
label-all-packages = Všetky balíčky
label-length-in-seconds = {…} sek

## ConnectionLogic
label-connecting-to-endpoint = Pripája sa k {…}...
label-could-not-connect-to-target = Nepodarilo sa pripojiť k {…}
label-unknown-error = Neznáma chyba
label-password-required = Vyžaduje sa heslo
label-connection-failed = Spojenie zlyhalo
notification-mod-switch-failed = Nepodarilo sa prepnúť mod.

## GameSaveBrowserLogic
dialog-rename-save =
    .title = Premenovať Uložiť
    .prompt = Zadajte nový názov súboru:
    .confirm = Premenovať

dialog-delete-save =
    .title = Odstrániť vybraté uloženie hry?
    .prompt = Odstrániť '{…}'.
    .confirm = Odstrániť

dialog-delete-all-saves =
    .title = Delete all game saves?
    .prompt = { $count -> [one] Zmazať { $count } uloženú hru. [few] Zmazať { $count } uložené hry. *[other] Zmazať { $count } uložených hier. }
    .confirm = Delete All

notification-save-deletion-failed = Nepodarilo sa odstrániť uložený súbor '{…}'. Podrobnosti nájdete v protokoloch.

dialog-overwrite-save =
    .title = Prepísať uloženú hru?
    .prompt = Prepísať {…}?
    .confirm = Prepísať

## MainMenuLogic
label-loading-news = Načítavam novinky
label-news-retrieval-failed = Nepodarilo sa načítať správy: {…}
label-news-parsing-failed = Nepodarilo sa analyzovať správy: {…}
label-author-datetime = od {…} o {…}

## MapChooserLogic
label-all-maps = Všetky mapy
label-no-matches = Žiadne zhody
label-player-count = { $players -> [one] { $players } hráč [few] { $players } hráči *[other] { $players } hráčov }
label-map-size-huge = Obrovské
label-map-size-large = Veľký
label-map-size-medium = Stredné
label-map-size-small = Malý
label-map-searching-count = { $count -> [one] Hľadanie { $count } mapy v Centre zdrojov OpenRA... [few] Hľadanie { $count } máp v Centre zdrojov OpenRA... *[other] Hľadanie { $count } máp v Centre zdrojov OpenRA... }
label-map-unavailable-count = { $count -> [one] { $count } mapa nebola nájdená v Centre zdrojov OpenRA [few] { $count } mapy neboli nájdené v Centre zdrojov OpenRA *[other] { $count } máp nebolo nájdených v Centre zdrojov OpenRA }

notification-map-deletion-failed = Nepodarilo sa odstrániť mapu '{…}'. Podrobnosti nájdete v súbore debug.log.

dialog-delete-map =
    .title = Odstrániť mapu
    .prompt = Odstrániť mapu '{…}'?
    .confirm = Odstrániť

dialog-delete-all-maps =
    .title = Odstrániť mapy
    .prompt = Chcete odstrániť všetky mapy na tejto stránke?
    .confirm = Odstrániť

options-order-maps =
    .player-count = Hráči
    .title = Názov
    .date = Dátum
    .size = Veľkosť

button-mapchooser-system-maps-tab = Oficiálne mapy
button-mapchooser-remote-maps-tab = Serverové mapy
button-mapchooser-user-maps-tab = Vlastné mapy
button-mapchooser-generated-maps-tab = Vytvoriť mapu

## MissionBrowserLogic
dialog-no-video =
    .title = Video nie je nainštalované
    .prompt =
        Herné videá je možné nainštalovať z
        menu "Spravovať obsah".
    .cancel = Späť

dialog-cant-play-video =
    .title = Video sa nedá prehrať
    .prompt = Počas prehrávania videa sa niečo pokazilo.
    .cancel = Späť

## MusicPlayerLogic
label-sound-muted = Zvuk bol v nastaveniach stlmený.
label-no-song-playing = Neprehráva sa žiadna skladba

## MuteHotkeyLogic
label-audio-muted = Zvuk je stlmený.
label-audio-unmuted = Zvuk je vypnutý.

## PlayerProfileLogic
label-loading-player-profile = Načítava sa profil hráča...
label-loading-player-profile-failed = Nepodarilo sa načítať profil hráča.

## ProductionTooltipLogic, EncyclopediaLogic
label-requires = Vyžaduje {…}.

## ReplayBrowserLogic
label-duration = Trvanie: {…}

options-replay-type =
    .singleplayer = Pre jedného hráča
    .multiplayer = Multiplayer

options-winstate =
    .victory = Víťazstvo
    .defeat = Porážka

options-replay-date =
    .today = Dnes
    .last-week = Posledných 7 dní
    .last-fortnight = Posledných 14 dní
    .last-month = Posledných 30 dní

options-replay-duration =
    .very-short = Menej ako 5 minút
    .short = Krátke (10 min)
    .medium = Stredné (30 min)
    .long = Dlhé (60+ min.)

dialog-rename-replay =
    .title = Premenovať Replay
    .prompt = Zadajte nový názov súboru:
    .confirm = Premenovať

dialog-delete-replay =
    .title = Odstrániť vybraté prehrávanie?
    .prompt = Odstrániť prehratie {…}?
    .confirm = Odstrániť

dialog-delete-all-replays =
    .title = Delete all selected replays?
    .prompt = { $count -> [one] Zmazať { $count } záznam. [few] Zmazať { $count } záznamy. *[other] Zmazať { $count } záznamov. }
    .confirm = Delete All

notification-replay-deletion-failed = Nepodarilo sa odstrániť súbor prehratia '{…}'. Podrobnosti nájdete v súbore debug.log.

## ReplayUtils
-incompatible-replay-recorded = Bolo zaznamenané s

dialog-incompatible-replay =
    .title = Nekompatibilné opätovné prehrávanie
    .prompt = Metadáta prehratia sa nepodarilo prečítať.
    .confirm = OK
    .prompt-unknown-version = {…} neznáma verzia.
    .prompt-unknown-mod = {…} neznámy mod.
    .prompt-unavailable-mod = {…} nedostupný mod: {…}.
    .prompt-incompatible-version =
        {…} nekompatibilná verzia:
        {…}.
    .prompt-unavailable-map =
        {…} nedostupná mapa:
        {…}.

# SelectUnitsByTypeHotkeyLogic
nothing-selected = Nie je vybraté nič.

## SelectUnitsByTypeHotkeyLogic, SelectAllUnitsHotkeyLogic
selected-units-across-screen = { $units -> [one] Vybraná jedna jednotka na obrazovke. [few] Vybrané { $units } jednotky na obrazovke. *[other] Vybraných { $units } jednotiek na obrazovke. }

selected-units-across-map = { $units -> [one] Vybraná jedna jednotka na mape. [few] Vybrané { $units } jednotky na mape. *[other] Vybraných { $units } jednotiek na mape. }

## ServerCreationLogic
label-internet-server-nat-A = Internetový server (UPnP/NAT-PMP
label-internet-server-nat-B-enabled = Povolené
label-internet-server-nat-B-not-supported = Nepodporované
label-internet-server-nat-B-disabled = Zakázané
label-internet-server-nat-C = ):

label-local-server = Lokálny server:

dialog-server-creation-failed =
    .prompt = Nepodarilo sa počúvať na porte {…}.
    .prompt-port-used = Skontrolujte, či sa port už používa.
    .prompt-error = Chyba je: "{…}" ({…}).
    .title = Vytvorenie servera zlyhalo
    .cancel = Späť

## ServerListLogic
label-players-online-count = { $players -> [one] { $players } hráč online [few] { $players } hráči online *[other] { $players } hráčov online }

label-search-status-failed = Dopyt na zoznam serverov zlyhal.
label-search-status-no-games = Nenašli sa žiadne hry. Skúste vymeniť filtre.
label-no-server-selected = Nie je vybratý žiadny server

label-map-status-searching = Hľadám...
label-map-classification-unknown = Neznáma mapa

label-players-count = { $players -> [0] Žiadni hráči [one] Jeden hráč [few] { $players } hráči *[other] { $players } hráčov }

label-bots-count = { $bots -> [0] Žiadni boti [one] Jeden bot [few] { $bots } boti *[other] { $bots } botov }

## ServerListLogic, ReplayBrowserLogic, ObserverShroudSelectorLogic
label-players = Hráči

## ServerListLogic, GameInfoStatsLogic
label-spectators = Diváci
label-spectators-count = { $spectators -> [0] Žiadni diváci [one] Jeden divák [few] { $spectators } diváci *[other] { $spectators } divákov }

## ServerlistLogic, GameInfoStatsLogic, ObserverShroudSelectorLogic, SpawnSelectorTooltipLogic, ReplayBrowserLogic
label-team-name = Tím {…}
label-no-team = Žiadny tím

label-playing = Hrá sa
label-waiting = Čakanie

label-other-players-count = { $players -> [one] Jeden ďalší hráč [few] { $players } ďalší hráči *[other] { $players } ďalších hráčov }

label-in-progress-for = { $minutes -> [0] Prebieha menej ako minútu. [one] Prebieha { $minutes } minútu. [few] Prebieha { $minutes } minúty. *[other] Prebieha { $minutes } minút. }

label-password-protected = Chránené heslom
label-waiting-for-players = Čakanie na hráčov
label-server-shutting-down = Server sa vypína
label-unknown-server-state = Neznámy stav servera

## Game
notification-saved-screenshot = Uložená snímka obrazovky {…}

## ChatCommands
notification-invalid-command = {…} nie je platný príkaz.

## DebugVisualizationCommands
description-combat-geometry = prepína prekrytie bojovej geometrie.
description-render-geometry = prepína prekrytie geometrie vykreslenia.
description-screen-map-overlay = prepína prekrytie mapy na obrazovke.
description-depth-buffer = prepína prekrytie vyrovnávacej pamäte hĺbky.
description-actor-tags-overlay = prepína prekrytie herných značiek.

## DevCommands
notification-cheats-disabled = Cheaty sú zakázané.
notification-invalid-cash-amount = Neplatná suma v hotovosti.
description-toggle-visibility = prepína kontroly viditeľnosti a minimapu.
description-give-cash = dáva predvolenú alebo špecifikovanú sumu peňazí.
description-give-cash-all = dáva predvolenú alebo špecifikovanú sumu peňazí všetkým hráčom a AI.
description-instant-building = prepína okamžité budovanie.
description-build-anywhere = prepína možnosť stavať kdekoľvek.
description-unlimited-power = prepína nekonečnú silu.
description-enable-tech = prepína schopnosť postaviť všetko.
description-fast-charge = prepína takmer okamžitú podporu nabíjania.
description-dev-cheat-all = prepne všetky cheaty a dá vám nejaké peniaze za vaše problémy.
description-dev-crash = zrúti hru.
description-levelup-actor = pridáva vybraným hercom určený počet úrovní.
description-player-experience = pridáva určené množstvo hráčskych skúseností vlastníkom (majiteľom) vybraných hercov.
description-power-outage = spôsobí 5-sekundový výpadok prúdu pre vlastníka (majiteľov) vybraných aktérov.
description-kill-selected-actors = zabije vybraných hercov.
description-dispose-selected-actors = disponuje vybranými aktérmi.

## HelpCommands
notification-available-commands = Tu sú dostupné príkazy:
description-no-description = nie je k dispozícii žiadny popis.
description-help-description = poskytuje užitočné informácie o rôznych príkazoch.

## PlayerCommands
description-pause-description = pozastaviť alebo zrušiť pozastavenie hry.
description-surrender-description = sebazničiť všetko a prehrať hru.

## DeveloperMode
notification-cheat-used = Použitý cheat: {…} od {…}{…}.

## CustomTerrainDebugOverlay
description-custom-terrain-debug-overlay = prepína vlastné prekrytie ladenia terénu.

## CellTriggerOverlay
description-cell-triggers-overlay = prepína prekrytie spúšťačov skriptu.

## HierarchicalPathFinderOverlay
description-hpf-debug-overlay = prepína hierarchické prekrytie cestovateľa.

## PathFinderOverlay
description-path-debug-overlay = prepína vizualizáciu hľadania cesty.

## TerrainGeometryOverlay
description-terrain-geometry-overlay = prepína prekrytie geometrie terénu.

## ActorMapOverlay
description-actor-map-overlay = prepína prekrytie mapy herca.

## MapOptions, MissionBrowserLogic
options-game-speed =
    .slowest = Najpomalšie
    .slower = Pomalšie
    .normal = Normálne
    .fast = Rýchlo
    .faster = Rýchlejšie
    .fastest = Najrýchlejšie

## TimeLimitManager
options-time-limit =
    .no-limit = No limit
    .options = { $minutes -> [one] { $minutes } minúta [few] { $minutes } minúty *[other] { $minutes } minút }

notification-time-limit-expired = Časový limit vypršal.

## EditorActorBrush
notification-added-actor = Pridané {…} ({…})

## EditorCopyPasteBrush
notification-copied-tiles = Skopírovaných {…} dlaždíc
notification-copied-actors = Skopírovaných {…} hercov
notification-copied-tiles-actors = Skopírovaných {…} dlaždíc a {…} hercov

## EditorDefaultBrush
notification-selected-area = Vybraná oblasť {…},{…} ({…},{…})
notification-removed-area = Odstránená oblasť {…},{…} ({…},{…})
notification-selected-actor = Vybraný herec {…}
notification-cleared-selection = Vymazaný výber
notification-removed-actor = Odstránené {…} ({…})
notification-removed-resource = Odstránené {…}
notification-moved-actor = Presunuté {…} z {…},{…} do {…},{…}

## EditorResourceBrush
notification-added-resource = Pridané { $amount } { $resource }.

## EditorTileBrush
notification-added-tile = Pridaná dlaždica {…}
notification-filled-tile = Vyplnené dlaždicou {…}

## EditorMarkerLayerBrush
notification-added-marker-tiles-markers =
    .red = červená
    .orange = oranžová
    .yellow = žltá
    .green = zelená
    .cyan = azúrová
    .blue = modrá
    .purple = fialová
    .magenta = purpurová
notification-added-marker-tiles = Pridaných { $count } značkových dlaždíc.
notification-removed-marker-tiles = Odstránených { $count } značkových dlaždíc.
notification-cleared-selected-marker-tiles = Vymazané vybrané značkové dlaždice.
notification-cleared-all-marker-tiles = Vymazané {…} dlaždice značiek

## EditorActionManager
notification-opened = Otvorené

## MapOverlaysLogic
mirror-mode =
    .none = nan
    .flip = Prevrátiť
    .rotate = Otočiť

## ActorEditLogic
notification-edited-actor = Upravené {…} ({…})
notification-edited-actor-id = Upravené {…} ({…}-> {…})

## ConquestVictoryConditions, StrategicVictoryConditions
notification-player-is-victorious = {…} je víťazný.
notification-player-is-defeated = {…} je porazený.

## OrderManager
notification-desync-compare-logs =
    Nesynchronizované v rámci {…}.
    Porovnajte syncreport.log s ostatnými hráčmi.

## WidgetUtils
label-win-state-won = Vyhral
label-win-state-lost = Stratené
label-client-state-disconnected = Preč

## Player
enumerated-bot-name = {…} {…}

## ModifiersExts
keycode-modifier =
    .alt = Alt
    .ctrl = Ctrl
    .meta = Meta
    .cmd = Cmd
    .shift = Shift
    .none = Žiadny

## KeycodeExts
keycode =
    .unknown = Nedefinované
    .return = Enter
    .escape = Esc
    .backspace = Backspace
    .tab = Tab
    .space = Medzerník
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
    .capslock = Caps Lock
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
    .printscreen = Print Screen
    .scrolllock = Scroll Lock
    .pause = Pause
    .insert = Insert
    .home = Home
    .pageup = Page Up
    .delete = Delete
    .end = End
    .pagedown = Page Down
    .right = Vpravo
    .left = Vľavo
    .down = Dole
    .up = Up
    .numlockclear = Num Lock
    .kp_divide = Numerická klávesnica /
    .kp_multiply = Numerická klávesnica *
    .kp_minus = Numerická klávesnica -
    .kp_plus = Numerická klávesnica +
    .kp_enter = Enter na numerickej klávesnici
    .kp_1 = Numerická klávesnica 1
    .kp_2 = Numerická klávesnica 2
    .kp_3 = Numerická klávesnica 3
    .kp_4 = Numerická klávesnica 4
    .kp_5 = Numerická klávesnica 5
    .kp_6 = Numerická klávesnica 6
    .kp_7 = Numerická klávesnica 7
    .kp_8 = Numerická klávesnica 8
    .kp_9 = Numerická klávesnica 9
    .kp_0 = Numerická klávesnica 0
    .kp_period = Numerická klávesnica .
    .application = Aplikácia
    .power = Napájanie
    .kp_equals = Numerická klávesnica =
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
    .execute = Spustiť
    .help = Pomoc
    .menu = Ponuka
    .select = Vybrať
    .stop = Zastaviť
    .again = Znova
    .undo = Späť
    .cut = Vystrihnúť
    .copy = Kopírovať
    .paste = Vložiť
    .find = Nájsť
    .mute = Stlmiť
    .volumeup = Zvýšiť hlasitosť
    .volumedown = Znížiť hlasitosť
    .kp_comma = Numerická klávesnica ,
    .kp_equalsas400 = Numerická klávesnica (AS400)
    .alterase = AltErase
    .sysreq = SysReq
    .cancel = Zrušiť
    .clear = Vymazať
    .prior = Predchádzajúci
    .return2 = Enter
    .separator = Oddeľovač
    .out = Von
    .oper = Oper
    .clearagain = Vymazať / Znova
    .crsel = CrSel
    .exsel = ExSel
    .kp_00 = Numerická klávesnica 00
    .kp_000 = Numerická klávesnica 000
    .thousandsseparator = Oddeľovač tisícov
    .decimalseparator = Desatinný oddeľovač
    .currencyunit = Mena
    .currencysubunit = Čiastková mena
    .kp_leftparen = Numerická klávesnica (
    .kp_rightparen = Numerická klávesnica )
    .kp_leftbrace = Numerická klávesnica {
    .kp_rightbrace = Numerická klávesnica }
    .kp_tab = Numerická klávesnica Tab
    .kp_backspace = Numerická klávesnica Backspace
    .kp_a = Numerická klávesnica A
    .kp_b = Numerická klávesnica B
    .kp_c = Numerická klávesnica C
    .kp_d = Numerická klávesnica D
    .kp_e = Numerická klávesnica E
    .kp_f = Numerická klávesnica F
    .kp_xor = Numerická klávesnica XOR
    .kp_power = Numerická klávesnica ^
    .kp_percent = Numerická klávesnica %
    .kp_less = Numerická klávesnica <
    .kp_greater = Numerická klávesnica >
    .kp_ampersand = Numerická klávesnica &
    .kp_dblampersand = Numerická klávesnica &&
    .kp_verticalbar = Numerická klávesnica |
    .kp_dblverticalbar = Numerická klávesnica ||
    .kp_colon = Numerická klávesnica :
    .kp_hash = Numerická klávesnica #
    .kp_space = Numerická klávesnica Medzerník
    .kp_at = Numerická klávesnica @
    .kp_exclam = Numerická klávesnica !
    .kp_memstore = Numerická klávesnica MemStore
    .kp_memrecall = Numerická klávesnica MemRecall
    .kp_memclear = Numerická klávesnica MemClear
    .kp_memadd = Numerická klávesnica MemAdd
    .kp_memsubtract = Numerická klávesnica MemSubtract
    .kp_memmultiply = Numerická klávesnica MemMultiply
    .kp_memdivide = Numerická klávesnica MemDivide
    .kp_plusminus = Numerická klávesnica +/-
    .kp_clear = Numerická klávesnica Vymazať
    .kp_clearentry = Numerická klávesnica ClearEntry
    .kp_binary = Numerická klávesnica Binárna
    .kp_octal = Numerická klávesnica Osmičková
    .kp_decimal = Numerická klávesnica Desatinná
    .kp_hexadecimal = Numerická klávesnica Šestnástková
    .lctrl = Ľavý Ctrl
    .lshift = Ľavý Shift
    .lalt = Ľavý Alt
    .lgui = Ľavá klávesa Windows/GUI
    .rctrl = Pravý Ctrl
    .rshift = Pravý Shift
    .ralt = Pravý Alt
    .rgui = Pravá klávesa Windows/GUI
    .mode = Prepínač režimu
    .audionext = Nasledujúca skladba
    .audioprev = Predchádzajúca skladba
    .audiostop = Zastaviť zvuk
    .audioplay = Prehrať zvuk
    .audiomute = Stlmiť zvuk
    .mediaselect = Vybrať médiá
    .www = WWW
    .mail = Pošta
    .calculator = Kalkulačka
    .computer = Počítač
    .ac_search = Hľadať
    .ac_home = Domov
    .ac_back = Späť
    .ac_forward = Vpred
    .ac_stop = Zastaviť
    .ac_refresh = Obnoviť
    .ac_bookmarks = Záložky
    .brightnessdown = Znížiť jas
    .brightnessup = Zvýšiť jas
    .displayswitch = Prepnúť displej
    .kbdillumtoggle = Prepnúť podsvietenie klávesnice
    .kbdillumdown = Znížiť podsvietenie klávesnice
    .kbdillumup = Zvýšiť podsvietenie klávesnice
    .eject = Vysunúť
    .sleep = Spánok
    .mouse4 = Myš 4
    .mouse5 = Myš 5

## MapGeneratorToolLogic
notification-map-generator-generated = Vygenerované pomocou {…}

dialog-notification-map-generator-failed =
    .title = Generovanie mapy zlyhalo
    .prompt = Podrobnosti nájdete v debug.log.
    .cancel = Odmietnuť

## EditorTilingPathBrush
notification-tiling-path-started = Začatá cesta obkladov
notification-tiling-path-updated = Aktualizovaná cesta obkladov
notification-tiling-path-reset = Vyhodená cesta obkladov
notification-tiling-path-painted = Maľovaný obkladový chodník
