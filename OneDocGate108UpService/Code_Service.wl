// ============================================================================
// OneDocGate108UpService - événements du service
// ============================================================================

// ----------------------------------------------------------------------------
// INITIALISATION DU SERVICE
// ----------------------------------------------------------------------------

Trace("[SERVICE UP] Démarrage")

gsFichierINI est une chaîne = ComplèteRep(fRepExe()) + "settings.ini"
gUri est une chaîne
gAuthorization est une chaîne
gsRepertoireJSON est une chaîne
gnIntervalleMS est un entier

SI PAS fFichierExiste(gsFichierINI) ALORS
	Trace("[SERVICE UP][ERREUR] Configuration absente : " + gsFichierINI)
	FinProgramme(1)
FIN

gUri = INILit("NEXAPI", "URI", "", gsFichierINI)
gAuthorization = INILit("NEXAPI", "AUTHORIZATION", "", gsFichierINI)
gsRepertoireJSON = INILit("UP", "DIRECTORY", "C:\Data\Public\OneDoc", gsFichierINI)
gnIntervalleMS = INILit("UP", "INTERVAL_MS", 1000, gsFichierINI)

SI gUri = "" OU gAuthorization = "" ALORS
	Trace("[SERVICE UP][ERREUR] Configuration NEXAPI incomplète")
	FinProgramme(2)
FIN

SI PAS fRépertoireExiste(gsRepertoireJSON) ALORS
	SI PAS fRepCrée(gsRepertoireJSON) ALORS
		Trace("[SERVICE UP][ERREUR] Impossible de créer : " + gsRepertoireJSON)
		FinProgramme(3)
	FIN
FIN

Trace("[SERVICE UP] Initialisation terminée, dossier=" + gsRepertoireJSON)


// ----------------------------------------------------------------------------
// EXÉCUTION DU SERVICE - APPELÉE EN BOUCLE PAR WINDOWS
// ----------------------------------------------------------------------------

SI PAS TraiteFichiersEnAttente() ALORS
	Trace("[SERVICE UP][ERREUR] Cycle terminé avec au moins une erreur")
FIN

ServiceTemporise(gnIntervalleMS)


// ----------------------------------------------------------------------------
// ARRÊT DU SERVICE
// ----------------------------------------------------------------------------

Trace("[SERVICE UP] Arrêt demandé")
