class AppLocalizations {
  static final AppLocalizations _instance = new AppLocalizations._internal();

  factory AppLocalizations() => _instance;

  AppLocalizations._internal(){
    _languageCode = "de";
    _subscribers = List();
  }

  String _languageCode;
  List<ChangeDetector> _subscribers;

  final Map<String, Map<String, String>> _localizedValues = {
    "en":{
      "userData":"User data",
      "language":"Language",
      "userName":"Username",
      "email":"Email",
      "about":"Impressum",
      "firstName":"First name",
      "surname":"Surname",
      "password":"Password",
      "usernameOrEmail":"Username or Email",
      "usernameOrEmailMustHaveAtLeastForCharacters":"Username or Email must have at least 4 characters.",
      "successfullySignedIn":"Successfully signed in",
      "signInToLearnable":"Sign In To learnable",
      "signIn":"Sign In",
      "signOut":"Sign Out",
      "loadingData":"Loading Data...",
      "fetchingData":"Fetching Data...",
      "timetable":"Timetable",
      "events":"Events",
      "classes":"Classes",
      "account":"Account",
      "pleaseRestartTheApplicationForOptimalPerformance":"Please restart the application for optimal performance.",
      "title":"Title",
      "eventType":"Event type",
      "description":"Description",
      "date":"Date",
      "startTime":"Start Time",
      "endTime":"End Time",
      "room":"Room",
      "createdBy":"Created by",
      "noEventsListed":"No events listed.",
      "pleaseCheckYourCredentials":"We could not find your information in our system.",
      "currentPassword":"Current password",
      "newPassword":"New password",
      "confirmPassword":"Confirm password",
      "filterBy":"Filter by",
      "credits":"Credits",
      "classmates":"Classmates",
      "teachers":"Class teachers",
    },
    "de":{
      "userData":"Benutzerdaten",
      "language":"Sprache",
      "userName":"Benutzername",
      "email":"E-Mail",
      "about":"Impressum",
      "firstName":"Vorname",
      "surname":"Nachname",
      "password":"Passwort",
      "usernameOrEmail":"Benutzername oder E-Mail",
      "usernameOrEmailMustHaveAtLeastForCharacters":"Benutzername oder E-Mail müssen mindestens 4 Zeichen lang sein.",
      "successfullySignedIn":"Erfolgreich angemeldet",
      "signInToLearnable":"Meld dich an bei Learnable.",
      "signIn":"Anmelden",
      "signOut":"Abmelden",
      "loadingData":"Lade Daten...",
      "fetchingData":"Lade Daten...",
      "timetable":"Stundenplan",
      "events":"Ereignisse",
      "classes":"Klassen",
      "account":"Profil",
      "pleaseRestartTheApplicationForOptimalPerformance":"Bitte starte die Anwendung neu, um eine optimale Leistung zu erhalten.",
      "title":"Titel",
      "eventType":"Ereignistyp",
      "description":"Beschreibung",
      "date":"Datum",
      "startTime":"Startzeit",
      "endTime":"Endzeit",
      "room":"Zimmer",
      "createdBy":"Erstellt von",
      "noEventsListed":"Keine Ereignisse aufgelistet.",
      "pleaseCheckYourCredentials":"Wir konnten Ihre Angaben nicht in unserem System finden.",
      "currentPassword":"Aktuelles Passwort",
      "newPassword":"Neues Passwort",
      "confirmPassword":"Passwort bestätigen",
      "filterBy":"Filtern nach",
      "credits":"Danksagungen",
      "classmates":"Klassenmitglieder",
      "teachers":"Klassenlehrer",
    },
    "fr":{
      "userData":"Données utilisateur",
      "language":"Langue",
      "userName":"Nom d'utilisateur",
      "email":"E-Mail",
      "about":"Mentions légales",
      "firstName":"Prénom",
      "surname":"Nom de famille",
      "password":"Mot de passe",
      "usernameOrEmail":"Nom d'utilisateur or E-Mail",
      "usernameOrEmailMustHaveAtLeastForCharacters":"Le nom d'utilisateur ou le courriel doit avoir au moins 4 caractères.",
      "successfullySignedIn":"Signé avec succès en",
      "signInToLearnable":"S'inscrire à Learnable",
      "signIn":"Inscrire",
      "signOut":"Annuler",
      "loadingData":"Chargement des données...",
      "fetchingData":"Chargement des données...",
      "timetable":"Plan de cours",
      "events":"Événements",
      "classes":"Classes",
      "account":"Compte",
      "pleaseRestartTheApplicationForOptimalPerformance":"Veuillez redémarrer l'application pour des performances optimales.",
      "title":"Titre",
      "eventType":"Type d'événement",
      "description":"Description",
      "date":"Date",
      "startTime":"Heure de début",
      "endTime":"Heure de fin",
      "room":"Espace",
      "createdBy":"Créé par",
      "noEventsListed":"Aucun événement n'est répertorié.",
      "pleaseCheckYourCredentials":"Nous n'avons pas pu trouver vos informations dans notre système.",
      "currentPassword":"Mot de passe actuel",
      "newPassword":"Nouveau mot de passe",
      "confirmPassword":"Confirmer le mot de passe",
      "filterBy":"Filtrer par",
      "credits":"Générique",
      "classmates":"Membres du groupe",
      "teachers":"Professeurs de classe",
    },
    "es":{
      "userData":"Datos de usuario",
      "language":"Lenguage",
      "userName":"Nombre de usuario",
      "email":"Email",
      "about":"Impressum",
      "firstName":"Primer nombre",
      "surname":"Apellido",
      "password":"Contraseña",
      "usernameOrEmail":"Nombre de usuraio o email",
      "usernameOrEmailMustHaveAtLeastForCharacters":"Nombre de usuraio o email deven tener por lo menos 4 signos.",
      "successfullySignedIn":"La seción ha sido comensada exitosamente.",
      "signInToLearnable":"Inciar la seción en Learnable",
      "signIn":"Inciar seción",
      "signOut":"Cerrar seción",
      "loadingData":"Cargar datos...",
      "fetchingData":"Descargar datos...",
      "timetable":"Calendario",
      "events":"Eventos",
      "classes":"Cursos",
      "account":"Cuentas",
      "pleaseRestartTheApplicationForOptimalPerformance":"Por favor reinciar la aplicación parar mejorar la rendimiento.",
      "title":"Titulo",
      "eventType":"Tipo de evento",
      "description":"Descripción",
      "date":"Fecha",
      "startTime":"Comienso",
      "endTime":"Fin",
      "room":"Cuarto",
      "createdBy":"Creado por",
      "noEventsListed":"Ningun evento inscrito",
      "pleaseCheckYourCredentials":"Por favor controla tus credenciales.",
      "currentPassword":"Contraseña presente",
      "newPassword":"Contraseña nueva",
      "confirmPassword":"Confirma la contraseña",
      "filterBy":"Filtrar por",
      "credits":"Reconocimientos",
      "classmates":"Miembros de clase",
      "teachers":"Maestro de clase",
    },
    "it":{
      "userData":"Dati dell'uutilizzatore",
      "language":"Lingua",
      "userName":"ome dell'utilizzatore",
      "email":"Email",
      "about":"Impresso",
      "firstName":"Nome",
      "surname":"Cognome",
      "password":"Password",
      "usernameOrEmail":"Nome dell'utilizzatore o Email",
      "usernameOrEmailMustHaveAtLeastForCharacters":"Nome dell'utilizzatore o Email devono avere almeno 4 simboli",
      "successfullySignedIn":"Successamente inscrito",
      "signInToLearnable":"Inscriversi a Learnable",
      "signIn":"Inscriversi",
      "signOut":"Disconnettersi",
      "loadingData":"Scaricare dati...",
      "fetchingData":"Scaricare dati...",
      "timetable":"Calendario",
      "events":"Fatti",
      "classes":"Gradazioni",
      "account":"Conto",
      "pleaseRestartTheApplicationForOptimalPerformance":"Riavviare l'applicazione per ottenere una presentazione ottimale.",
      "title":"Titolo",
      "eventType":"Tipo d'evento",
      "description":"Descrizione",
      "date":"Data",
      "startTime":"Ora di inizio",
      "endTime":"Ora di fine",
      "room":"Camera",
      "createdBy":"Creato da",
      "noEventsListed":"Nessun evento é in un elenco.",
      "pleaseCheckYourCredentials":"Non siamo riusciti a trovare le vostre informazioni nel nostro sistema.",
      "currentPassword":"Password attuale",
      "newPassword":"Nuovo password",
      "confirmPassword":"Confermare password",
      "filterBy":"Filtra per",
      "credits":"Accrediti",
      "classmates":"Membri della classe",
      "teachers":"Insegnante di classe",
    },
    "be_de":{
      "userData":"Benutzerdatä",
      "language":"Spraach",
      "userName":"Benutzernamä",
      "email":"E-Mail",
      "about":"Über üs",
      "firstName":"Vorname",
      "surname":"Nachname",
      "password":"Passwort",
      "usernameOrEmail":"Benutzername odr E-Mail",
      "usernameOrEmailMustHaveAtLeastForCharacters":"Chum itz, dr Benutzername odr z'Email müesse zmingscht 4 Zeichä läng si.",
      "successfullySignedIn":"Du hesch di erfougrych ahgmäudet!",
      "signInToLearnable":"Chum und mäud di ah bi Learnable.",
      "signIn":"Ahmäudä",
      "signOut":"Abmäudä",
      "loadingData":"Muess Date abelade...",
      "fetchingData":"Muess Date abelade...",
      "timetable":"Stundäplan",
      "events":"Ereigniss",
      "classes":"Klassene",
      "account":"Profiu",
      "pleaseRestartTheApplicationForOptimalPerformance":"Für die beschti leischtig sötsch eventuell schnäu d'App nöistarte.",
      "title":"Titu",
      "eventType":"Ereignistyp",
      "description":"Beschrybig",
      "date":"Datum",
      "startTime":"Startzyt",
      "endTime":"Endzyt",
      "room":"Zimmr",
      "createdBy":"Ersteut vom",
      "noEventsListed":"Sonä chabis, kenni Ereigniss sy ufglischtet.",
      "pleaseCheckYourCredentials":"Mir hei dyni Ahgabe nid ih üsem System chönnä finde.",
      "currentPassword":"Z'Aktuelle Passwort",
      "newPassword":"Z'Nöiä Passwort",
      "confirmPassword":"Passwort bestätige",
      "filterBy":"Fiutere nach",
      "credits":"Es grosses MERCI ah",
      "classmates":"Klassehomies",
      "teachers":"Klasselehrer",
    },
  };

  String get applicationName => "Learnable";
  String get userData => _localizedValues[_languageCode]["userData"];
  String get language => _localizedValues[_languageCode]["language"];
  String get userName => _localizedValues[_languageCode]["userName"];
  String get email => _localizedValues[_languageCode]["email"];
  String get about => _localizedValues[_languageCode]["about"];
  String get firstName => _localizedValues[_languageCode]["firstName"];
  String get surname => _localizedValues[_languageCode]["surname"];
  String get password => _localizedValues[_languageCode]["password"];
  String get usernameOrEmail => _localizedValues[_languageCode]["usernameOrEmail"];
  String get usernameOrEmailMustHaveAtLeastForCharacters => _localizedValues[_languageCode]["usernameOrEmailMustHaveAtLeastForCharacters"];
  String get successfullySignedIn => _localizedValues[_languageCode]["successfullySignedIn"];
  String get signInToLearnable => _localizedValues[_languageCode]["signInToLearnable"];
  String get signIn => _localizedValues[_languageCode]["signIn"];
  String get signOut => _localizedValues[_languageCode]["signOut"];
  String get loadingData => _localizedValues[_languageCode]["loadingData"];
  String get fetchingData => _localizedValues[_languageCode]["fetchingData"];
  String get timetable => _localizedValues[_languageCode]["timetable"];
  String get events => _localizedValues[_languageCode]["events"];
  String get classes => _localizedValues[_languageCode]["classes"];
  String get account => _localizedValues[_languageCode]["account"];
  String get pleaseRestartTheApplicationForOptimalPerformance => _localizedValues[_languageCode]["pleaseRestartTheApplicationForOptimalPerformance"];
  String get title => _localizedValues[_languageCode]["title"];
  String get eventType => _localizedValues[_languageCode]["eventType"];
  String get description => _localizedValues[_languageCode]["description"];
  String get date => _localizedValues[_languageCode]["date"];
  String get startTime => _localizedValues[_languageCode]["startTime"];
  String get endTime => _localizedValues[_languageCode]["endTime"];
  String get room => _localizedValues[_languageCode]["room"];
  String get createdBy => _localizedValues[_languageCode]["createdBy"];
  String get noEventsListed => _localizedValues[_languageCode]["noEventsListed"];
  String get pleaseCheckYourCredentials => _localizedValues[_languageCode]["pleaseCheckYourCredentials"];
  String get currentPassword => _localizedValues[_languageCode]["currentPassword"];
  String get newPassword => _localizedValues[_languageCode]["newPassword"];
  String get confirmPassword => _localizedValues[_languageCode]["confirmPassword"];
  String get filterBy => _localizedValues[_languageCode]["filterBy"];
  String get credits => _localizedValues[_languageCode]["credits"];
  String get classmates => _localizedValues[_languageCode]["classmates"];
  String get teachers => _localizedValues[_languageCode]["teachers"];

  String getLanguageCode() => _languageCode;

  String setLanguageCode(String languageCode) {
    _languageCode = _localizedValues.containsKey(languageCode)
        ? languageCode
        : "de";

    if (_subscribers.length > 0)
      for (ChangeDetector c in _subscribers)
        c.onLanguageCodeChange(_languageCode);

    return _languageCode;
  }

  void subscribe(ChangeDetector detector) {
    this._subscribers.add(detector);
  }
}

abstract class ChangeDetector {
  void onLanguageCodeChange(String languageCode);
}