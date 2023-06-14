#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Downloads\triangle-outline-512.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.0
 Author:         N3utro

 Script Function:
	Lancement auto conflits frontaliers TOF

#ce ----------------------------------------------------------------------------


HotKeySet ("{F6}", "stop")

sleep(5000)

$conflit_lance = 0

$delta_timer = 0

while 1

	;si jour de reset conflit et heure reset on arrête pour ne pas gâcher les try

	if @WDAY = 2 OR @WDAY = 4 OR @WDAY = 6 AND @HOUR = "05" then stop()

	send("{ESC}")

	sleep(1000)

	send("{ESC}")

	sleep(1000)

	send("{ESC}")

	sleep(1000)

	send("{ESC}")

	sleep(1000)

    send("{ALT DOWN}")

    sleep(100)

	send("3")

	sleep(100)

	send("{ALT UP}")

    sleep(1000)

    Mouseclick("left", 106, 663, 1, 0)

	sleep(1000)

	Mouseclick("left", 1025, 219, 1, 0)

	sleep(1000)

	Mouseclick("left", 1505, 792, 1, 0) ; clic sur bouton "y aller"

	sleep(1000)

	Mouseclick("left", 1267, 584, 1, 0) ; click sur bouton "grouper"

	$timer = TimerInit()

	while $conflit_lance = 0

		;recherche fenêtre matchmaking

		while hex(PixelGetColor(464,290)) <> "00A25858"

			;on vérifie si cela ne fait pas plus de 55 secondes que le matchmaking tourne, sinon on relance

			if TimerDiff($timer) + $delta_timer > 50000 then

				Mouseclick("left", 1505, 792, 1, 0) ; clic sur bouton "groupage"

				sleep(500)

				Mouseclick("left", 1505, 792, 1, 0) ; clic sur bouton "y aller"

				sleep(1000)

				Mouseclick("left", 1267, 584, 1, 0) ; click sur bouton "grouper"

				$delta_timer = 0

				$timer = TimerInit()

			EndIf

			ConsoleWrite(TimerDiff($timer) + $delta_timer & @CRLF)

			sleep(50)

		WEnd

		;matchmaking trouvé, on valide et vérifie combien de temps la fenêtre reste affichée

		$delta_timer = $delta_timer + TimerDiff($timer)

		ConsoleWrite("delta " & $delta_timer & @CRLF)

		sleep(200)

		Mouseclick("left", 810, 876, 1, 0) ; click sur "aide"

		sleep(50)

		Mouseclick("left", 1122, 754, 1, 0) ; click sur "approuver"

		ConsoleWrite("pixel_apres_approuver : " & hex(PixelGetColor(464,290)) & @CRLF)

		while hex(PixelGetColor(464,290)) = "00A25858"

			;ConsoleWrite("attente lancement conflit" & @CRLF)

			sleep(1)

		WEnd

		ConsoleWrite("fenêtre matchmaking fermée" & @CRLF)

		sleep(1000)

		;la fenêtre de matchmaking s'est fermée. 3 possibilités :
		; - soit le matchmaking a échoué et on revient sur la page de recherche de groupe,
		; - soit le matchmaking a échoué et on revient sur la page de matckmaking (le jeu a retrouvé un équipier instantanément),
		; - soit le conflit se lance

		if hex(PixelGetColor(619,739)) <> "004286DC" AND hex(PixelGetColor(464,290)) <> "00A25858" Then

			$conflit_lance = 1 ;le matchmaking a réussi, le conflit se lance

		Else

				$timer = TimerInit()

				ConsoleWrite("reinit timer" & @CRLF)

		EndIf

	WEnd ;le conflit frontalier demarre

	ConsoleWrite("conflit en cours lancement" & @CRLF)

	sleep(5000)

	;on attend que le niveau ait chargé

	While PixelGetColor(265,53) <> "00FFFFFF" AND PixelGetColor(257,65) <> "00FFFFFF" AND PixelGetColor(265,577) <> "00FFFFFF"

		sleep(50)

	WEnd

	;le niveau a chargé, on clique sur le bouton auto

	ConsoleWrite("conflit a fini de charger" & @CRLF)

	sleep(9500)

	;start auto mode

	send("{ALT DOWN}")

	sleep(100)

	MouseClick("left", 1161, 925, 1, 0) ;click "auto" button

	sleep(100)

	send("{ALT UP}")

	;on attend que l'on retourne sur l'écran du jeu habituel

	while hex(PixelGetColor(20,64)) <> "003EA6ED"

		sleep(1000)

	WEnd

	ConsoleWrite("revenu sur l'écran principal du jeu" & @CRLF)

	sleep(2000)

	$conflit_lance = 0

	$delta_timer = 0

WEnd

Func stop()

	send("{ALT UP}")

	Exit

EndFunc