// ============================================================================
// Procédures sans dépendance à une fenêtre
// ============================================================================

PROCÉDURE TraiteFichiersEnAttente() : booléen

sListe est une chaîne = fListeFichier(ComplèteRep(gsRepertoireJSON) + "*.json", frFichier, fTriNom)
bCycleOK est un booléen = Vrai

POUR TOUTE CHAÎNE sFichier DE sListe SÉPARÉE PAR RC
	SI sFichier <> "" ALORS
		Trace("[SERVICE UP] Traitement : " + fExtraitChemin(sFichier, fFichier + fExtension))
		SI PAS TraiteUnFichierOneDoc(sFichier) ALORS
			bCycleOK = Faux
			Trace("[SERVICE UP][ERREUR] Fichier conservé : " + fExtraitChemin(sFichier, fFichier + fExtension))
		FIN
	FIN
FIN

RENVOYER bCycleOK


PROCÉDURE TraiteUnFichierOneDoc(sFichier est une chaîne) : booléen

SI PAS fFichierExiste(sFichier) ALORS
	Trace("[SERVICE UP][ERREUR] Fichier introuvable")
	RENVOYER Faux
FIN

QUAND EXCEPTION DANS
	jsJSON est un JSON = fChargeTexte(sFichier)
FAIRE
	Trace("[SERVICE UP][ERREUR] JSON invalide : " + ExceptionInfo(errMessage))
	RENVOYER Faux
FIN

// Un fichier ne contenant pas d'événement n'est pas transmissible.
SI PAS jsJSON.event..Existe ALORS
	Trace("[SERVICE UP][ERREUR] Élément event absent")
	RENVOYER Faux
FIN

// La construction du payload et les routes created/updated/deleted seront
// reprises de toOneDoc(), sans syslogDebug() ni référence à FEN_index.
// Cette étape sera intégrée et compilée directement dans WINDEV.

Trace("[SERVICE UP] Action détectée : " + jsJSON.action)
RENVOYER Faux
