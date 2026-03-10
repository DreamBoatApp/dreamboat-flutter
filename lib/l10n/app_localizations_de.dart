// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get homeTitle => 'DreamBoat';

  @override
  String get homeSubtitle => 'Begib dich auf eine Reise in deiner Traumwelt';

  @override
  String get homeNewDream => 'Neuen Traum hinzufügen';

  @override
  String get homeJournal => 'Traumtagebuch';

  @override
  String get homeStats => 'Meine Traumwelt';

  @override
  String get homeGuide => 'Klartraum-Leitfaden';

  @override
  String get homeSettings => 'Einstellungen';

  @override
  String get statsTitle => 'Statistiken';

  @override
  String get statsTipTitle => 'Täglicher Traumtipp';

  @override
  String get statsTipContent =>
      'Versuche heute, ein Tagebuch zu führen, um deine innere Reise zu vertiefen. Verbinde dich mit deinem Kind-Ich aus deinen Träumen, nimm dir ein paar Minuten Zeit, um diese reine Liebe wiederzuentdecken.';

  @override
  String get statsAnalysisTitle => 'Monatliche Emotionsverteilung';

  @override
  String get statsAnalysisResult => 'Traummuster-Analyse';

  @override
  String get statsAnalyzeBtn => 'Traummuster anzeigen';

  @override
  String get statsAnalysisIntroTitle => 'Traummuster-Analyse';

  @override
  String get statsAnalysisIntroSubtitle =>
      'Kann einmal pro Woche durchgeführt werden';

  @override
  String get statsAnalysisIntroContent =>
      'Die Traummuster-Analyse untersucht deine wöchentlich aufgezeichneten Träume, um wiederkehrende Themen, emotionale Zyklen und symbolische Trends deines Unterbewusstseins aufzudecken. Anders als bei einzelnen Traumdeutungen zeigt dieses System Muster auf, die im Laufe der Zeit entstehen – das große Ganze, das dein Geist dir mitteilen möchte. Sie kann nur einmal pro Woche durchgeführt werden, damit du verändernde Elemente im Laufe der Zeit regelmäßiger verfolgen kannst.';

  @override
  String statsAnalysisWait(Object days) {
    return 'Du musst $days Tage auf eine neue Analyse warten.';
  }

  @override
  String get statsAnalysisMinDreams =>
      'Mindestens 5 aufgezeichnete Träume erforderlich';

  @override
  String get statsAnalysisDone => 'Wöchentliche Analyse abgeschlossen';

  @override
  String get statsAnalyzing => 'Analysiere...';

  @override
  String get statsOffline => 'Internet erforderlich';

  @override
  String get statsNoData => 'Nicht genügend Daten';

  @override
  String get statsProcessing =>
      'Traummuster wird vorbereitet, bitte warten Sie einen Moment.';

  @override
  String get analysisConfirmBody =>
      'Die Traummuster-Analyse kann einmal pro Woche durchgeführt werden, damit Sie Veränderungen Ihrer Muster im Laufe der Zeit klar erkennen können.\n\nMöchten Sie fortfahren?';

  @override
  String get moonSyncConfirmBody =>
      'Die Mond- und Planetensynchronisation kann einmal im Monat durchgeführt werden, um Veränderungen in den kosmischen Zyklen genau zu verfolgen.\n\nMöchten Sie fortfahren?';

  @override
  String get confirmContinue => 'Fortfahren';

  @override
  String get guideTitle => 'Klartraum-Leitfaden';

  @override
  String get guideIntroTitle => 'Was ist Klarträumen?';

  @override
  String get guideIntroContent =>
      'Klarträumen ist die einzigartige Erfahrung, sich bewusst zu werden, dass man träumt, und potenziell den Traum zu steuern.';

  @override
  String get moodLove => 'Liebe';

  @override
  String get moodHappy => 'Freude';

  @override
  String get moodSad => 'Traurigkeit';

  @override
  String get moodScared => 'Angst';

  @override
  String get moodAnger => 'Wut';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodPeace => 'Frieden';

  @override
  String get moodAwe => 'Ehrfurcht';

  @override
  String get moodAnxiety => 'Angst';

  @override
  String get moodConfusion => 'Verwirrung';

  @override
  String get moodEmpowered => 'Stark';

  @override
  String get moodLonging => 'Sehnsucht';

  @override
  String get feltMood => 'Stimmung:';

  @override
  String get moodSelectPrompt => 'Welches Gefühl kommt als erstes auf?';

  @override
  String get moodIntensityLabel => 'Intensität';

  @override
  String get moodIntensityLow => 'Niedrig';

  @override
  String get moodIntensityMedium => 'Mittel';

  @override
  String get moodIntensityHigh => 'Hoch';

  @override
  String get moodVividnessLabel => 'Klarheit';

  @override
  String get moodVividnessQuestion => 'Wie klar erinnerst du dich?';

  @override
  String get moodVividnessLow => 'Vage';

  @override
  String get moodVividnessMedium => 'Teilweise';

  @override
  String get moodVividnessHigh => 'Sehr Klar';

  @override
  String get moodNotSure => 'Nicht Sicher';

  @override
  String get moodSaving => 'Dein Traum wird gespeichert...';

  @override
  String get newDreamModalTitle => 'Welche Emotion Dominierte\nDiesen Traum?';

  @override
  String get close => 'Schließen';

  @override
  String get journalTitle => 'Traumtagebuch';

  @override
  String get journalAll => 'Alle';

  @override
  String get journalFavorites => 'Favoriten';

  @override
  String get journalNoDreams => 'Noch keine Träume aufgezeichnet.';

  @override
  String get journalNoFavorites => 'Noch keine Lieblingsträume.';

  @override
  String get journalAnalysis => 'Traumdeutung';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsPrivacy => 'Datenschutzrichtlinie';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsVersion => 'Version:';

  @override
  String get settingsNotifOpen => 'Benachrichtigungen aktivieren';

  @override
  String get settingsNotifTime => 'Tägliche Erinnerung';

  @override
  String get settingsNotifDesc =>
      'Erhalte jeden Morgen eine sanfte Erinnerung, deine Träume aufzuzeichnen.';

  @override
  String get settingsPrivacyTitle => 'Datenschutzrichtlinie';

  @override
  String get settingsSupportTitle => 'Support';

  @override
  String get settingsAppStatus => 'App-Status';

  @override
  String get settingsSupportDesc =>
      'Hast du eine Frage oder Feedback? Lass es uns wissen!';

  @override
  String get settingsSend => 'Nachricht Senden';

  @override
  String get settingsSending => 'Nachricht gesendet!';

  @override
  String get newDreamMinCharHint =>
      'Du musst mindestens 50 Zeichen eingeben, damit dein Traum gedeutet werden kann.';

  @override
  String get homeSpecialBadge => 'PRO';

  @override
  String get newDreamTitle => 'Neuer Traum';

  @override
  String get newDreamSubtitle =>
      'Vergiss nicht, deine Träume jeden Tag aufzuzeichnen...';

  @override
  String get newDreamSave => 'Traum speichern & interpretieren';

  @override
  String get newDreamPlaceholderDetail =>
      'Beschreibe deinen Traum hier...\n\nBeispiel: Ich ging durch einen ruhigen Garten voller Blumen. Sanftes Licht fiel durch die Blätter. Wasser kräuselte sich sanft in einem kleinen Vogelbad in der Nähe.';

  @override
  String get newDreamPlaceholder => 'Beschreibe deinen Traum hier...';

  @override
  String get guideCompletionTitle => 'Herzlichen Glückwunsch!';

  @override
  String get guideCompletionContent =>
      'Du hast alle Stufen des Klartraum-Leitfadens abgeschlossen.\n\nJetzt, da du alle Techniken beherrschst, kannst du dich frei in der Klartraumwelt bewegen!';

  @override
  String get guideStage1Title =>
      '1. MILD-Technik (Mnemotechnische Induktion von Klarträumen)';

  @override
  String get guideStage1Subtitle =>
      'Den Samen des Erwachens in deine Träume pflanzen';

  @override
  String get guideStage1Content =>
      'Dies ist der Ausgangspunkt der Klartraumreise. MILD, oder \"Mnemotechnische Induktion von Klarträumen\", ist eine Technik, bei der vor dem Einschlafen eine klare Absicht in das Unterbewusstsein gepflanzt wird. Diese Absicht ermöglicht es dir, das Bewusstsein von \"Ich träume\" während eines Traums zu erlangen. Wir werden in dieser Phase die erste Tür zum bewussten Träumen öffnen.';

  @override
  String get guideStage1Importance =>
      'MILD nutzt die Fähigkeit des Geistes, sich zu erinnern und Absichten zu bilden, um einen mentalen Boden für Klarträume zu bereiten. Durch die Aktivierung des Hippocampus und des präfrontalen Kortex erhöht es die Wahrscheinlichkeit, im Traum bewusst zu sein.';

  @override
  String get guideStage1Steps =>
      'Versuche nach dem Aufwachen aus einem Traum in der Nacht, dich im Detail an deinen letzten Traum zu erinnern.\nWiederhole diesen Satz für dich selbst: \"In meinem nächsten Traum werde ich erkennen, dass ich träume.\"\nVisualisiere diese Szene in deinem Kopf. Stell dir vor, du wärst dir im Traum bewusst.\nSchließe die Augen und schlafe mit dieser Absicht wieder ein.\nSchreibe morgens nach dem Aufwachen alles detailliert in dein Traumtagebuch.';

  @override
  String get guideStage1Criteria =>
      'Wenn du mindestens einmal in der Woche erkannt hast, dass du geträumt hast, kannst du zur nächsten Stufe übergehen.';

  @override
  String get guideStage1BrainNote =>
      'Dies ist eine Reise des Erwachens. Im ersten Schritt beginnst du, deinen Geist zu trainieren. Jede Wiederholung bedeutet, dass bewusste Träume einen Schritt näher kommen. Denke daran, Geduld und Wiederholung sind deine größten Verbündeten.';

  @override
  String get guideStage2Title => '2. WBTB (Wake Back To Bed)';

  @override
  String get guideStage2Subtitle => 'Die Tür zum bewussten Träumen öffnen';

  @override
  String get guideStage2Content =>
      'Du hast deine mentale Absicht geformt. Jetzt lernen wir, bewusst wieder in die REM-Phase einzutreten, in der Träume am intensivsten sind. Die WBTB-Technik kann das Klartraum-Bewusstsein unterstützen, indem sie dir erlaubt, in einem halb wachen Zustand wieder einzuschlafen.';

  @override
  String get guideStage2Importance =>
      'Mit WBTB bleibt dein Gehirn zwischen Wachen und Schlafen. Dieser Übergangspunkt bietet die geeignetste mentale Umgebung für Klarträume.';

  @override
  String get guideStage2Steps =>
      'Stelle einen Wecker, um 4–6 Stunden nach dem Einschlafen aufzuwachen.\nLies ein Buch bei schwachem Licht, meditiere oder wiederhole MILD für 15–30 Minuten.\nLege dich am Ende dieser Zeit wieder hin und schlafe mit der MILD-Absicht ein.';

  @override
  String get guideStage2Criteria =>
      'Wenn du mindestens 2 Nächte in einer Woche das Bewusstsein für deine Umgebung im Traum erlangt hast, kannst du zur nächsten Stufe übergehen.';

  @override
  String get guideStage2BrainNote =>
      'Du öffnest deinen Geist ein wenig mehr. Der Schleier zwischen Traum und Realität wird dünner. Du bist dabei, dem Traum mit Wachheit zu begegnen.';

  @override
  String get guideStage3Title => '3. WILD (Wake Initiated Lucid Dream)';

  @override
  String get guideStage3Subtitle =>
      'Direkter Eintritt in den Traum mit Bewusstsein';

  @override
  String get guideStage3Content =>
      'Eine der beeindruckendsten Techniken des Klarträumens, WILD, führt dich direkt und bewusst in das Traumreich. Du erlaubst deinem Körper zu schlafen, während dein Geist wach bleibt, und du kannst deutlicher bemerken, wann der Traum beginnt.';

  @override
  String get guideStage3Importance =>
      'WILD erfordert die gleichzeitige Ausführung von geistiger Klarheit und körperlicher Entspannung. Diese Technik unterscheidet sich von anderen, da du direkt in den Traum eintrittst, und erfordert ein hohes Maß an Übung.';

  @override
  String get guideStage3Steps =>
      'Wende es nach WBTB an.\nLege dich hin, entspanne deinen ganzen Körper.\nKonzentriere dich auf deinen Atem, halte deinen Geist aktiv.\nDu siehst vielleicht Lichter oder Muster bei geschlossenen Augen — beobachte sie ruhig.\nÜbernimm die Kontrolle, wenn du merkst, dass der Traum begonnen hat.';

  @override
  String get guideStage3Criteria =>
      'Wenn du mindestens einmal in 2 Wochen direkt bewusst in einen Traum übergegangen bist, bist du bereit für Stufe 4.';

  @override
  String get guideStage3BrainNote =>
      'Jetzt stehst du an der Schwelle zur Meisterschaft. Du lernst, deine Augen zu schließen und sie in einer anderen Welt zu öffnen. Denke daran, diese Technik erfordert viel Übung und Geduld ist dein größter Verbündeter.';

  @override
  String get guideStage4Title => '4. Zeitbewusstsein und Realitätschecks';

  @override
  String get guideStage4Subtitle => 'Unsere Wahrnehmung der Realität meistern';

  @override
  String get guideStage4Content =>
      'Das Bewusstsein für Klarträume hat begonnen. Jetzt ist es Zeit, dieses Bewusstsein zu vertiefen und das Konzept von Zeit und Raum im Traum zu nutzen. Das Ziel dieser Stufe: sich im Traum an Konzepte wie Jahr, Alter, Datum zu erinnern.';

  @override
  String get guideStage4Importance =>
      'Realitätschecks machen es einfacher zu erkennen, dass du träumst. Die Zeitwahrnehmung zeigt die Tiefe des geistigen Bewusstseins.';

  @override
  String get guideStage4Steps =>
      'Frage dich mindestens 5–10 Mal am Tag: \"Träume ich gerade?\"\nMache Tests wie Finger zählen, Text nochmal lesen.\nWiederhole vor dem Schlafen die Absicht: \"Ich werde bemerken, in welchem Jahr ich in meinem Traum bin.\"';

  @override
  String get guideStage4Criteria =>
      'Wenn du in 3 Nächten einer Woche zeitbezogenes Bewusstsein im Traum erlebt hast (z.B. Jahr, Geburtstag, Kalender) → kannst du zur nächsten Stufe übergehen.';

  @override
  String get guideStage4BrainNote =>
      'Du bist dir nicht nur bewusst, dass du in einem Traum bist, sondern auch der Zeit im Traum. Dein Geist hat begonnen, sich in eine neue Dimension zu bewegen.';

  @override
  String get guideStage5Title => '5. Schlafroutine-Optimierung';

  @override
  String get guideStage5Subtitle => 'Den Boden für Klarträume bereiten';

  @override
  String get guideStage5Content =>
      'In dieser Phase machen wir eine Pause von direkten Klartraumversuchen. Es ist Zeit, eine regelmäßige Schlafroutine aufzubauen, um den grundlegenden Mechanismus des Gehirns zu unterstützen und die geistige Klarheit zu vertiefen.';

  @override
  String get guideStage5Importance =>
      'Regelmäßiger Schlaf und eine ideale Umgebung beeinflussen den Erfolg von Klarträumen direkt. Ein regelmäßiger Rhythmus ist für den gesunden Verlauf der REM-Dauer erforderlich.';

  @override
  String get guideStage5Steps =>
      'Erstelle einen Schlaf-Wach-Plan zur gleichen Zeit jeden Tag.\nMache 1 Stunde vor dem Bett einen digitalen Detox.\nAchte darauf, in einem ruhigen, dunklen, kühlen Raum zu schlafen.\nBeruhige den Geist mit kurzen Meditationen.';

  @override
  String get guideStage5Criteria =>
      'Wenn du 7 Nächte in 10 Tagen ein Traumtagebuch geführt hast und in 3 deiner Träume Bewusstseinssignale erlebt hast → kannst du zur nächsten Stufe übergehen.';

  @override
  String get guideStage5BrainNote =>
      'Ein Gebäude kann nicht ohne Fundament existieren. Diese Stufe schafft einen soliden Boden für deine bewussten Träume. Denke daran, ein ausgeruhter Geist bedeutet ein bewusster Geist.';

  @override
  String get guideStage6Title => '6. Dopamin-Gleichgewicht';

  @override
  String get guideStage6Subtitle => 'Die mentale Chemie ausbalancieren';

  @override
  String get guideStage6Content =>
      'Dein Geist hat nun das Klarträumen kennengelernt. In dieser Phase treten wir einen Schritt von der Traumpraxis zurück und versuchen, eine gesündere mentale Umgebung für Klarträume zu schaffen, indem wir das mentale Gleichgewicht unterstützen.';

  @override
  String get guideStage6Importance =>
      'Dopamin ist ein Neurotransmitter, der bei Motivations- und Aufmerksamkeitsprozessen eine Rolle spielt. Übermäßige Reize können die mentale Fokussierung erschweren. Dieser Inhalt ist kein medizinischer Rat; er bietet nur Vorschläge für Bewusstsein und Lebensstil.';

  @override
  String get guideStage6Steps =>
      'Begrenze deine Social-Media-Zeit für 5 Tage auf 1 Stunde.\nMache leichte Übungen, gehe spazieren und tanke Sonne.\nIss Omega-3-reich, bleibe fern von Zucker.\nMache Fokusübungen vor dem Schlafen.';

  @override
  String get guideStage6Criteria =>
      'Wenn du die Umgebung, das Licht oder ein Objekt 3 Mal in Klarträumen in einer Woche bewusst manipuliert hast, kannst du zur letzten Stufe übergehen.';

  @override
  String get guideStage6BrainNote =>
      'Du hast nicht nur deinen Geist trainiert, du hast seine biologische Struktur optimiert. Jetzt sind bewusste Träume nicht nur möglich; sie werden zu deiner Natur.';

  @override
  String get guideStage7Title =>
      '7. Erweitertes Bewusstsein und Kreative Anleitung';

  @override
  String get guideStage7Subtitle => 'Meister des Traums werden';

  @override
  String get guideStage7Content =>
      'Wir sind am Ende der Reise angelangt. An diesem Punkt wirst du nicht nur klar sein, sondern ein Niveau erreichen, auf dem du das Traumerlebnis bewusster erkunden kannst. Es ist Zeit, deine Traumwelt frei zu erschaffen.';

  @override
  String get guideStage7Importance =>
      'Mit dieser Technik kannst du das Bewusstsein für Traumsymbole und mentale Bilder entwickeln und alles testen, was du dir vorstellst. Dies ist ein wichtiger Schritt sowohl in Bezug auf das geistige als auch auf das persönliche Bewusstsein.';

  @override
  String get guideStage7Steps =>
      'Schreibe das Szenario, das du im Traum erleben möchtest, detailliert auf und stelle es dir vor.\nÄndere bewusst den Ort, die Zeit, den Charakter oder das Ergebnis im Traum.\nFüge Achtsamkeitsmeditationen zu deiner täglichen Routine hinzu.';

  @override
  String get guideStage7Criteria =>
      'Wenn du in 2 Wochen in mindestens 2 Träumen eine aktive Manipulation durchgeführt hast (Fliegen, Umgebung ändern, etwas beschwören), willkommen in der Welt des Klarträumens.';

  @override
  String get guideStage7BrainNote =>
      'Am Ende dieser Reise erwarten dich nicht nur bewusste Träume, sondern das grenzenlose Potenzial deiner Vorstellungskraft. Du erschaffst jetzt Leben nicht nur, wenn du wach bist, sondern auch, wenn du schläfst.';

  @override
  String get guideAppBarTitle => 'Klartraum-Leitfaden';

  @override
  String get guideIntroTitle1 => 'Was ist Klarträumen?';

  @override
  String get guideIntroContent1 =>
      'Klarträumen ist eine einzigartige Schlaferfahrung, bei der du dir bewusst wirst, dass du träumst, und den Traum bewusst lenken kannst.';

  @override
  String get guideIntroListTitle => 'In einem Klartraum-Zustand:';

  @override
  String get guideIntroBullet1 => 'Bist du dir während des Traums bewusst.';

  @override
  String get guideIntroBullet2 => 'Kannst du deine Umgebung bewerten.';

  @override
  String get guideIntroBullet3 => 'Steigt deine Entscheidungsfähigkeit.';

  @override
  String get guideIntroBullet4 => 'Kannst du den Fluss des Traums ändern.';

  @override
  String get guideIntroFooter =>
      'Klarträumen ist eine Fähigkeit, die einige von uns irgendwann im Leben zufällig erleben, die aber mit den richtigen Techniken erlernt werden kann.';

  @override
  String get guideIntroTitle2 => 'Wofür ist Klarträumen gut?';

  @override
  String get guideBenefit1 => 'Deine Träume steuern';

  @override
  String get guideBenefit2 => 'Das Unterbewusstsein erkunden';

  @override
  String get guideBenefit3 => 'Den Schlaf meistern';

  @override
  String get guideBenefit4 => 'Stress bewältigen';

  @override
  String get guideIntroContent2 =>
      'Klarträume öffnen die Türen des Unterbewusstseins und bringen dich auf eine höhere Bewusstseinsebene. Diese Erfahrung spiegelt sich schließlich in deinem täglichen Leben wider.';

  @override
  String get guideIntroTitle3 => 'Wie benutzt man diesen Leitfaden?';

  @override
  String get guideIntroContent3 =>
      'Dieser Leitfaden basiert auf einem speziellen 7-Stufen-Klartraumsystem. In jeder Stufe wirst du eine kraftvolle Gewohnheit erwerben, die deine Träume direkt beeinflusst.';

  @override
  String get guideIntroGainTitle => 'Was du gewinnst, wenn du fortschreitest:';

  @override
  String get guideIntroGain1 => 'Träume steuern';

  @override
  String get guideIntroGain2 => 'Unterbewusstsein erkunden';

  @override
  String get guideIntroGain3 => 'Schlaf meistern';

  @override
  String get guideIntroGain4 => 'Stress bewältigen';

  @override
  String get guideBuyButton => 'Vollständigen Leitfaden freischalten';

  @override
  String get guideNo => 'Nein';

  @override
  String get guideYes => 'Ja';

  @override
  String get guideDebugResetTitle => 'Leitfaden zurücksetzen?';

  @override
  String get guideDebugResetContent =>
      'Dies sperrt alle Stufen außer der ersten. (Debug)';

  @override
  String get journalDeleteTitle => 'Traum löschen?';

  @override
  String get journalDeleteContent =>
      'Bist du sicher, dass du diesen Traum löschen möchtest? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get journalDeleteConfirm => 'Löschen';

  @override
  String get journalDeleteCancel => 'Abbrechen';

  @override
  String journalDeleteMultiTitle(int count) {
    return '$count Träume löschen?';
  }

  @override
  String get journalDeleteMultiContent =>
      'Bist du sicher, dass du die ausgewählten Träume löschen möchtest? Dies kann nicht rückgängig gemacht werden.';

  @override
  String get proVersion => 'PRO';

  @override
  String get standardVersion => 'Standard';

  @override
  String get upgradeTitle => 'Auf DreamBoat PRO upgraden';

  @override
  String get upgradeBenefits =>
      'Werbefreie Erfahrung\nVollständige Traumanalyse\nUnbegrenzte Traumdeutung\nExklusiver Zugang zum Leitfaden';

  @override
  String get upgradeBtn => 'DreamBoat PRO freischalten (88,99 ₺)';

  @override
  String get upgradeCancel => 'Vielleicht später';

  @override
  String get privacyPolicyLink => 'Datenschutzrichtlinie';

  @override
  String get termsOfUseLink => 'Nutzungsbedingungen';

  @override
  String get upgradeSuccess => 'Willkommen bei DreamBoat PRO!';

  @override
  String get upgradeStart => 'Starten';

  @override
  String get proRequired => 'PRO-Version erforderlich';

  @override
  String get proRequiredDetail =>
      'PRO-Version und mindestens 5 aufgezeichnete Träume erforderlich';

  @override
  String get guideUnlockPro => 'PRO-Version freischalten';

  @override
  String get guideUnlockHint =>
      'Du musst auf PRO upgraden, um den Leitfaden freizuschalten.';

  @override
  String get guideContent => 'Inhalt';

  @override
  String get guideImportance => 'Warum ist es wichtig?';

  @override
  String get guideSteps => 'Schritte';

  @override
  String get guideCriteria => 'Abschlusskriterien';

  @override
  String get guideBrainNoteTitle => 'Notiz ans Gehirn';

  @override
  String get guideNextStep => 'Nächster Schritt';

  @override
  String get guideDialogTitle => 'Bist du sicher, dass du weitermachen willst?';

  @override
  String get guideDialogContent =>
      'Das Fortfahren zurächsten Stufe, ohne den aktuellen Schritt abzuschließen, könnte deiner Reise schaden. Bist du sicher, dass du fortfahren möchtest?';

  @override
  String get guideDialogCancel => 'Warten';

  @override
  String get guideDialogConfirm => 'Ich bin bereit';

  @override
  String get guideStart => 'Leitfaden starten';

  @override
  String get privacyTitle => 'Datenschutz und DSGVO';

  @override
  String get privacyNoticeTitle => 'NovaBloom Studio Datenschutzerklärung';

  @override
  String get privacyNoticeContent =>
      'DreamBoat wird von dem unabhängigen Entwickler Guney Yilmazer unter der Marke NovaBloom Studio entwickelt. Ihre Privatsphäre hat für uns höchste Priorität. DreamBoat wurde entwickelt, damit Sie Ihre Träume sicher aufzeichnen und für Ihr persönliches Bewusstsein analysieren können.';

  @override
  String get privacySection1Title => '1. Datensicherheit und Verarbeitung';

  @override
  String get privacySection1Content =>
      'Ihre Traumaufzeichnungen und In-App-Daten werden sicher gespeichert.\nIhre Träume werden nur verarbeitet, um die von der Anwendung angebotenen Funktionen auszuführen.\n\nTrauminhalte werden niemals mit Dritten geteilt\n\nDaten werden nicht für Werbung, Marketing oder Benutzerprofilierung verwendet\n\nKI-gestützte Analysen werden ausschließlich zur Verbesserung der Benutzererfahrung durchgeführt\n\nTraumtexte werden nicht zum Trainieren von KI-Modellen verwendet\n\nAlle Vorgänge werden in Übereinstimmung mit KVKK- und DSGVO-Standards durchgeführt';

  @override
  String get privacySection2Title => '2. Konto und Nutzung';

  @override
  String get privacySection2Content =>
      'DreamBoat funktioniert ohne die Notwendigkeit, ein Konto zu erstellen.\n\nDie Anwendung kann anonym genutzt werden\n\nIhre Träume und Einstellungen werden nur auf Ihrem Gerät oder in sicheren Bereichen der Anwendung gespeichert\n\nPersonenbezogene Identitätsdaten (Name, E-Mail usw.) werden nicht zwingend erhoben';

  @override
  String get privacySection3Title => '3. Datenschutz- und Sperrfunktionen';

  @override
  String get privacySection3Content =>
      'DreamBoat bietet zusätzliche Sicherheitsoptionen zum Schutz der Privatsphäre:\n\nDas Traumtagebuch kann mit Face ID oder Fingerabdruck gesperrt werden\n\nTräume sind standardmäßig vollkommen privat\n\nDie Teilen-Funktion ist optional und funktioniert nur, wenn der Benutzer ausdrücklich entscheidet zu teilen\n\nTräume werden niemals automatisch oder mit Dritten geteilt';

  @override
  String get privacySection4Title =>
      '4. Gesundheits- und medizinischer Haftungsausschluss (WICHTIG)';

  @override
  String get privacySection4Content =>
      'DreamBoat ist keine Gesundheits- oder medizinische Anwendung.\n\nDie bereitgestellten Traumdeutungen und Analysen dienen ausschließlich Unterhaltungs- und Persönlichkeitsentwicklungszwecken\n\nSie stellen keine medizinische, psychologische oder professionelle Beratung dar\n\nDie Anwendung sammelt oder verarbeitet keine biometrischen oder gesundheitsbezogenen Daten\n\n5. Kontakt\n\nSie können unsere detaillierte Datenschutzrichtlinie auch auf unserer Website einsehen:\nhttps://www.novabloomstudio.com/de/privacy';

  @override
  String get supportTitle => 'Kontaktieren Sie uns';

  @override
  String get supportContent =>
      'Ihr Feedback ist für NovaBloom Studio sehr wertvoll.\n\nSie können uns eine E-Mail für Vorschläge, Fehlerberichte oder Kooperationsanfragen senden.';

  @override
  String get supportSendEmail => 'E-Mail senden';

  @override
  String get supportEmailNotFound => 'E-Mail-App nicht gefunden.';

  @override
  String get supportEmailSubject => 'DreamBoat Support-Anfrage';

  @override
  String get debugResetTitle => 'Debug-Reset';

  @override
  String get debugResetContent =>
      'Möchtest du die App auf die Standardversion zurücksetzen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get standard => 'STANDARD';

  @override
  String get save => 'Speichern';

  @override
  String get timeFormat24h => '24-Stunden-Format';

  @override
  String get languageTurkish => 'Türkisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get guideSlide1Title => 'Die Weisheit des Alten Ägypten';

  @override
  String get guideSlide1Subtitle => 'Tor zur Reise der Seele';

  @override
  String get guideSlide1Content1 =>
      'Spuren dessen, was wir heute luzides Träumen nennen, konnten im Alten Ägypten gesehen werden. Die Ägypter interpretierten das Träumen als eine bewusste Erfahrung im Rahmen der kulturellen und spirituellen Überzeugungen der Zeit.\n\nTatsächlich existieren symbolische Erzählungen, die Pharaonen beschreiben, die im Traumreich durch Priester mit göttlichen Figuren interagieren.';

  @override
  String get guideSlide1Content2 =>
      'In der modernen Medizin haben Schlafexperten (Somnologie) entdeckt, dass während des REM-Schlafs – dem Teil des Schlafs, in dem wir träumen – der frontale Kortex aktiv ist, was bedeutet, dass die mit Bewusstsein verbundenen Gehirnregionen ähnlich wie im Wachzustand arbeiten. Diese Erkenntnisse werden so interpretiert, dass sie einige konzeptionelle Ähnlichkeiten mit den bewussten Erfahrungserzählungen aufweisen, die dem Träumen im Alten Ägypten zugeschrieben wurden.';

  @override
  String get guideSlide2Title => 'Meditationen tibetischer Mönche';

  @override
  String get guideSlide2Subtitle => 'Die Grenzen des Geistes überschreiten';

  @override
  String get guideSlide2Content1 =>
      'Tibetische Mönche behandelten luzides Träumen durch lebenslange tiefe Meditationspraktiken als innere Erfahrung, die darauf abzielte, das geistige Bewusstsein zu steigern.\n\nHoch im Himalaya unterstützten Mönche, die die Schichten des Geistes erforschten, bewusste Traumerfahrungen mit geistiger Disziplin und traditionellen Praktiken.';

  @override
  String get guideSlide2Content2 =>
      'In jüngsten neurologischen Studien wurde der Zusammenhang zwischen Meditationspraktiken und Schlafbewusstsein untersucht.\n\nIm Lichte dieser alten Traditionen zielt dieser spezielle Leitfaden, den wir vorbereitet haben, darauf ab, dieses Potenzial in den Tiefen deines Geistes zu wecken und dein Bewusstsein in das Traumreich zu tragen. Du kannst die Reise beginnen, der bewusste Architekt deiner eigenen inneren Welt zu werden und aufhören, nur ein Zuschauer in deinen Träumen zu sein.';

  @override
  String get guideSlide3Title => 'Das Geheimnis der Traumfänger';

  @override
  String get guideSlide3Subtitle => 'Wächter der bewussten Träume';

  @override
  String get guideSlide3Content1 =>
      'In den Kulturen der amerikanischen Ureinwohner wurde der Traumfänger als symbolisches Objekt angesehen, das mit luziden Träumen verbunden ist.\n\nDiese Praxis, die über Generationen weitergegeben wurde, wurde als kulturelles Symbol interpretiert, das Traumerfahrungen darstellt. Unter der Führung von Schamanen wurde der Traumfänger als Symbol geschätzt, das mit bewusstem Bewusstsein verbunden ist und spirituelle Verbindungen symbolisiert.';

  @override
  String get guideSlide3Content2 =>
      'Im modernen Informationszeitalter wird luzides Träumen nicht nur als mystische Erfahrung alter Kulturen behandelt, sondern auch als Bewusstseinserfahrung, die in der modernen wissenschaftlichen Forschung untersucht wird.\n\nIn diesem Klartraum-Leitfaden, der durch Zusammenstellung der aktuellsten Forschungen und Lehren erstellt wurde, die von Generation zu Generation weitergegeben wurden, ist es möglich, verschiedene Erfahrungen zu entdecken, indem du dein geistiges Bewusstsein vertiefst.';

  @override
  String get guideSlide4Title => 'Klartraum-Leitfaden';

  @override
  String get guideSlide4Content =>
      'Wie benutzt man diesen Leitfaden?\n\nDieser Leitfaden basiert auf einem speziellen 7-Stufen-Klartraumsystem.\nIn jeder Stufe wirst du kraftvolle Gewohnheiten entwickeln, die das Traumbewusstsein unterstützen.';

  @override
  String get guideSlide4GainsTitle => 'Was du gewinnst, wenn du fortschreitest';

  @override
  String get guideSlide4Gain1 =>
      'Du greifst auf die tiefen Schichten deiner Träume zu';

  @override
  String get guideSlide4Gain2 => 'Dein Bewusstsein beginnt, Träume zu lenken';

  @override
  String get guideSlide4Gain3 => 'Orte und Menschen nehmen Gestalt nach dir an';

  @override
  String get guideSlide4Gain4 =>
      'Du gewinnst mehr Bewusstsein über deine Träume';

  @override
  String get guideSlide4ProRequired =>
      'Du musst die PRO-Version haben, um auf den Leitfaden zuzugreifen.';

  @override
  String get guideSlide4UnlockButton => 'PRO-Version freischalten';

  @override
  String get guideCompleted =>
      'Herzlichen Glückwunsch! Du hast den gesamten Leitfaden abgeschlossen.';

  @override
  String get delete => 'Löschen';

  @override
  String get actionFavorite => 'Favorit';

  @override
  String get understand => 'Verstanden, Weiter';

  @override
  String get error => 'Fehler';

  @override
  String get testNotification => 'Testbenachrichtigung senden';

  @override
  String get testNotificationSent => 'Testbenachrichtigung gesendet!';

  @override
  String get journalSearchHint => 'Deine Träume durchsuchen...';

  @override
  String get newDreamLoadingText => 'Bereite deine Traumdeutung vor...';

  @override
  String get dreamInterpretationTitle => 'Traumdeutung';

  @override
  String get dreamInterpretationReadMore => 'Mehr lesen';

  @override
  String get dreamTooShort => 'Traum war zu kurz zum Deuten.';

  @override
  String get dreamGibberish =>
      'Ihr Traum konnte nicht gedeutet werden, da er nicht genügend aussagekräftigen Inhalt enthielt.';

  @override
  String get dailyLimitReached =>
      'Du hast das tägliche Traumdeutungslimit erreicht (100/100).';

  @override
  String get settingsRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get restoreSuccess => 'PRO-Version erfolgreich wiederhergestellt!';

  @override
  String get restoreNotFound => 'Keine früheren Käufe gefunden.';

  @override
  String get restoreError =>
      'Käufe konnten nicht wiederhergestellt werden. Bitte versuche es erneut.';

  @override
  String get restoreUnavailable =>
      'Der Store ist derzeit nicht verfügbar. Bitte versuche es später erneut.';

  @override
  String get restoring => 'Wiederherstellen...';

  @override
  String get offlineInterpretation =>
      'Traum konnte mangels Internetverbindung nicht gedeutet werden.';

  @override
  String get offlinePurchase =>
      'Für den Kauf ist eine Internetverbindung erforderlich.';

  @override
  String get offlineAnalysis =>
      'Für die Analyse ist eine Internetverbindung erforderlich.';

  @override
  String get proUpgradeSubtitle =>
      'Kein Abo. Einmalkauf, lebenslanger Zugriff.';

  @override
  String get proFeatureAdsTitle => 'Werbefreie Erfahrung';

  @override
  String get proFeatureAdsSubtitle =>
      'Keine Werbung bei Traumdeutungen.\nKonzentriere dich nur auf deine Träume und was sie dir sagen wollen.';

  @override
  String get proFeatureCosmicTitle => 'Kosmische Verbindungen Freischalten';

  @override
  String get proFeatureCosmicSubtitle =>
      'Zeigt zusätzliche kosmische Verbindungen in Traumdeutungen.\nInterpretiert deine Träume zusammen mit Mondphasen und planetaren Einflüssen.';

  @override
  String get proFeatureAnalysisTitle => 'Wöchentliche Traummuster-Analyse';

  @override
  String get proFeatureAnalysisSubtitle =>
      'Deckt verborgene Verbindungen zwischen deinen Träumen auf.\nEntdecke wiederkehrende Themen, Emotionen und Botschaften des Unterbewusstseins im Laufe der Zeit.';

  @override
  String get proFeatureGuideTitle => 'Klartraum-Leitfaden';

  @override
  String get proFeatureGuideSubtitle =>
      'Übernimm die Kontrolle über deine Träume.\nSchritt-für-Schritt angeleitete Klartraumtechniken von Anfänger bis Fortgeschritten.';

  @override
  String get proProcessing => 'Verarbeitung...';

  @override
  String get notifDialogTitle => 'Benachrichtigungen Aktivieren';

  @override
  String get notifDialogBody =>
      'Erlaube DreamBoat, dich jeden Morgen daran zu erinnern, deine Träume aufzuzeichnen.';

  @override
  String get notifPermissionDenied =>
      'Benachrichtigungsberechtigung Verweigert';

  @override
  String get notifOpenSettings => 'Einstellungen Öffnen';

  @override
  String get notifOpenSettingsHint =>
      'Du musst Benachrichtigungen in den Einstellungen aktivieren.';

  @override
  String get allow => 'Erlauben';

  @override
  String get notifReminderBody =>
      'Vergiss nicht, deinen Traum aufzuzeichnen! 📝';

  @override
  String get notifReminder1 =>
      'Was hat dir das Universum heute Nacht zugeflüstert? ✨';

  @override
  String get notifReminder2 =>
      'Fang deine Träume ein, bevor sie verblassen! 📓';

  @override
  String get notifReminder3 =>
      'Dein Unterbewusstsein hat dir eine Nachricht hinterlassen... 🌙';

  @override
  String get notifReminder4 =>
      'Bist du nicht neugierig, was diese Symbole bedeuten? 🔮';

  @override
  String get notifReminder5 => 'Dein Traumtagebuch wartet auf dich ✍️';

  @override
  String get pressBackToExit => 'Drücke erneut zurück zum Beenden';

  @override
  String get moonSyncTitle => 'Monatliche Mond- & Planetensynchronisation';

  @override
  String get moonSyncSubtitle => 'Kann einmal im Monat durchgeführt werden';

  @override
  String get moonSyncDescription =>
      'Die Mond- und Planetensynchronisation analysiert deine Träume des letzten Monats zusammen mit der Mondphase am Tag, an dem du sie hattest, und kosmischen Ereignissen in diesem Zeitraum (wie Blutmond, Finsternisse). Indem sie die Emotionen, Intensität und Stimmung deiner Träume mit dem Mondzyklus abgleicht, offenbart sie die Harmonie zwischen deinem inneren Zustand und den kosmischen Rhythmen und worauf du in bestimmten Mondphasen (Vollmond, Halbmond usw.) achten solltest. Da sie sich auf den Mondzyklus konzentriert, wird sie einmal im Monat erstellt.';

  @override
  String get moonSyncDescriptionShort =>
      'Interpretiert deine Träume zusammen mit Mondzyklen und kosmischen Ereignissen. Erfahre, was dich diesen Monat beeinflusst hat und worauf du achten solltest.';

  @override
  String get moonSyncBtn => 'Kosmische Analyse Starten';

  @override
  String moonSyncWait(int days) {
    return 'Du musst $days Tage auf eine neue Analyse warten.';
  }

  @override
  String get moonSyncMinDreams =>
      'Mindestens 5 aufgezeichnete Träume erforderlich';

  @override
  String get moonSyncDone => 'Monatliche Kosmische Analyse Abgeschlossen';

  @override
  String get moonSyncProcessing =>
      'Kosmische Analyse wird vorbereitet, bitte warten Sie einen Moment.';

  @override
  String get moonPhaseNewMoon => 'Neumond';

  @override
  String get moonPhaseWaxingMoon => 'Zunehmender Mond';

  @override
  String get moonPhaseFullMoon => 'Vollmond';

  @override
  String get moonPhaseWaningMoon => 'Abnehmender Mond';

  @override
  String get actionShareInterpretation => 'Deutung\nteilen';

  @override
  String get shareImage => 'Bild\nteilen';

  @override
  String get sharePrivacyHint =>
      'Hinweis: Der Button Deutung teilen teilt nur die Traumdeutung. Ihre Träume gehören Ihnen und werden niemals mit Dritten geteilt.';

  @override
  String get moonPhaseLabel => 'Mondphase:';

  @override
  String get readMore => 'Mehr lesen...';

  @override
  String get tapForDetails => 'Für Details tippen...';

  @override
  String nSelected(int count) {
    return '$count Ausgewählt';
  }

  @override
  String get shareCardHeader => 'MEINE TÄGLICHE TRAUMDEUTUNG';

  @override
  String get shareCardWatermark => 'Interpretiert mit DreamBoat App';

  @override
  String get subscriptionComingSoon => 'Das Abonnement-System kommt sehr bald!';

  @override
  String get subscribeMonthly => 'Monatlich abonnieren';

  @override
  String get subscribeYearly => 'Jährlich abonnieren';

  @override
  String get planMonthly => 'MONATLICH';

  @override
  String get planAnnual => 'JÄHRLICH';

  @override
  String get mostPopular => 'BELIEBTESTE';

  @override
  String get discountPercent => '-30% RABATT';

  @override
  String get subscribeNow => 'Jetzt abonnieren';

  @override
  String get billingMonthly =>
      'Monatliches Abo mit automatischer Verlängerung.\nJederzeit kündbar.';

  @override
  String get billingAnnual =>
      'Jährliches Abo mit automatischer Verlängerung. Einmal pro Jahr abgerechnet. Jederzeit kündbar.';

  @override
  String get proFeatureAds => 'Werbefreie Erfahrung';

  @override
  String get proFeatureAnalysis => 'Wöchentliche Muster-Analyse';

  @override
  String get proFeatureGuide => 'Klartraum-Leitfaden';

  @override
  String get proFeatureMoonSync => 'Mond- und Planetensynchronisation';

  @override
  String get freeTrialDays => 'Tage Kostenlos Testen';

  @override
  String get freeTrialBadge => 'Erste 7 Tage kostenlos';

  @override
  String get priceLoading => 'Laden...';

  @override
  String get priceLoadError => 'Preis nicht verfügbar';

  @override
  String get priceRetryButton => 'Erneut versuchen';

  @override
  String get then => 'Danach';

  @override
  String get reviewSatisfactionTitle => 'Gefällt dir DreamBoat?';

  @override
  String get reviewSatisfactionContent => 'Teile deine Erfahrung mit uns!';

  @override
  String get reviewOptionYes => 'Ja, sehr!';

  @override
  String get reviewOptionNeutral => 'Es geht';

  @override
  String get reviewOptionNo => 'Nein, nicht wirklich';

  @override
  String get reviewFeedbackTitle => 'Deine Meinung zählt';

  @override
  String get reviewFeedbackContent =>
      'Was können wir verbessern? Schreib uns gerne.';

  @override
  String get reviewFeedbackButton => 'Kontaktieren';

  @override
  String get reviewCancel => 'Abbrechen';

  @override
  String get adConsentTitle => 'Noch eine Traumdeutung ✨';

  @override
  String get adConsentBody =>
      'Um DreamBoat kostenlos zu halten, kannst du eine kurze Werbung ansehen, um diesen Traum zu deuten, oder auf PRO upgraden.';

  @override
  String get adConsentWatch => 'Werbung ansehen & Deuten';

  @override
  String get adConsentPro => 'Auf PRO upgraden (Werbefrei)';

  @override
  String get adLoadError =>
      'Werbung ist nicht bereit. Bitte versuche es erneut oder wechsle zu PRO.';

  @override
  String get adRetry => 'Erneut versuchen';

  @override
  String get adSkipThisTime => 'Bu sefer reklamsız devam';

  @override
  String get intensityFeltLight => 'Leicht gefühlt';

  @override
  String get intensityFeltMedium => 'Mäßig gefühlt';

  @override
  String get intensityFeltIntense => 'Intensiv gefühlt';

  @override
  String get statsDreamLabel => 'Träume';

  @override
  String statsRecordedDreams(Object count) {
    return 'Aufgezeichnete Träume: $count';
  }

  @override
  String get settingsSupportId => 'Support-ID';

  @override
  String get settingsSupportIdCopied =>
      'ID kopiert! Du kannst diesen Code an unser Support-Team senden.';

  @override
  String get guideIntentExerciseTitle =>
      'Lass uns vor dem Schlafen gemeinsam wiederholen';

  @override
  String get guideIntentPhrase =>
      'In meinem nächsten Traum werde ich erkennen, dass ich träume.';

  @override
  String get guideIntentRepeatButton => 'Wiederholen';

  @override
  String guideIntentProgress(Object count) {
    return '$count / 10 Wiederholungen';
  }

  @override
  String get guideIntentComplete =>
      'Du bist bereit! Jetzt kannst du mit dieser Absicht schlafen. 🌙';

  @override
  String get wildBreathTitle => 'Atem- und Entspannungsmodus';

  @override
  String get wildBreathStart => 'Atem- und Entspannungsmodus starten';

  @override
  String get wildBreathInhale => 'Einatmen';

  @override
  String get wildBreathHold => 'Halten';

  @override
  String get wildBreathExhale => 'Ausatmen';

  @override
  String get wildBreathFocus => 'Konzentriere dich nur auf deinen Atem';

  @override
  String get wildBreathTapToExit => 'Zum Beenden tippen';

  @override
  String get wbtbDreamsTitle => 'Deine WBTB-Träume';

  @override
  String get wbtbDreamsDesc =>
      'Sieh dir Träume an, die in Nächten aufgezeichnet wurden, in denen du diese Technik geübt hast.';

  @override
  String get wbtbDreamsButton => 'WBTB-Träume ansehen';

  @override
  String get wbtbNoDreamsTitle => 'Noch keine Träume für diese Stufe';

  @override
  String get wbtbNoDreamsDesc =>
      'Zeichne deine Träume auf, nachdem du diese Technik geübt hast.';

  @override
  String get wbtbAddFirstDream => 'Meinen ersten Traum hinzufügen';

  @override
  String get timeAwarenessTitle => 'Realitätscheck-Übung';

  @override
  String get timeAwarenessInstruction => 'Antworte laut vor dem Schlafen';

  @override
  String get timeAwarenessQ1 => 'Welches Datum ist heute?';

  @override
  String get timeAwarenessQ2 => 'Welcher Wochentag ist heute?';

  @override
  String get timeAwarenessQ3 => 'REMOVED';

  @override
  String get timeAwarenessQ4 => 'Wie spät ist es genau?';

  @override
  String get timeAwarenessQ5 => 'Schau dich um und nenne 3 Gegenstände.';

  @override
  String get timeAwarenessQ6 => 'Welche Farbe hat deine Kleidung?';

  @override
  String get timeAwarenessQ11 => 'Welche Geräusche hörst du gerade?';

  @override
  String get timeAwarenessQ7 => 'Mit wem hast du heute zuerst gesprochen?';

  @override
  String get timeAwarenessQ8 => 'Schau auf deine Hände und zähle deine Finger.';

  @override
  String get timeAwarenessQ9 => 'Atme ein und frage \'Träume ich?\'';

  @override
  String get timeAwarenessQ10 =>
      'Schließe jetzt deine Augen und stelle dir vor, du schläfst.';

  @override
  String get stage5Task1 => 'Traumtagebuch geführt';

  @override
  String get stage5Task2 => 'Bewusstseinssignal im Traum erlebt';

  @override
  String get stage5Hint =>
      'Tippe auf Sterne bei Erfüllung. Fortschritt wird freigeschaltet, wenn alle Aufgaben erledigt sind.';

  @override
  String get stage6Task1 => 'Ich konnte meinen Traum bewusst manipulieren';

  @override
  String get stage6Hint =>
      'Tippe auf die Sterne, wenn du die Bedingungen erfüllst. Der Fortschritt wird freigeschaltet, wenn alle 3 Sterne markiert sind.';

  @override
  String get guideCriteriaNotMet =>
      'Du musst die Kriterien dieser Stufe erfüllen, um fortzufahren.';

  @override
  String rateLimitWait(int minutes) {
    return 'Zu viele Anfragen. Bitte versuche es in $minutes Minute(n) erneut.';
  }

  @override
  String get analysisStep1 => 'Traumsymbole werden gescannt...';

  @override
  String get analysisStep2 => 'Unterbewusstsein wird kartiert...';

  @override
  String get analysisStep3 => 'Archetypen werden verbunden...';

  @override
  String get analysisStep4 => 'Psychologische Tiefe wird analysiert...';

  @override
  String get analysisStep5 => 'Die Interpretation wird vorbereitet...';

  @override
  String get analysisLongWait => 'Dein Traum wird detailliert analysiert...';

  @override
  String get newDreamSaveShort => 'Traum Speichern';

  @override
  String get supportTechInfoNote =>
      'Die folgenden technischen Informationen helfen uns, Ihr Problem schneller zu lösen. Bitte nicht löschen.';

  @override
  String get onboardingWelcomeTitle => 'Du hast vielleicht noch nicht geträumt';

  @override
  String get onboardingWelcomeSubtitle =>
      'Lass uns in der Zwischenzeit dein allgemeines Traumprofil entdecken.';

  @override
  String get surveyQ1 =>
      'Wie oft erinnerst du dich normalerweise an deine Träume?';

  @override
  String get surveyQ1Option1 => 'Nie';

  @override
  String get surveyQ1Option2 => '1-2 Mal im Monat';

  @override
  String get surveyQ1Option3 => '1-2 Mal pro Woche';

  @override
  String get surveyQ1Option4 => 'Fast jeden Tag';

  @override
  String get surveyQ2 => 'Was beschreibt deinen Schlafrhythmus am besten?';

  @override
  String get surveyQ2Option1 => 'Sehr unregelmäßig';

  @override
  String get surveyQ2Option2 => 'Etwas unregelmäßig';

  @override
  String get surveyQ2Option3 => 'Meistens regelmäßig';

  @override
  String get surveyQ2Option4 => 'Sehr regelmäßig';

  @override
  String get surveyQ3 => 'Wie ist die allgemeine Stimmung deiner Träume?';

  @override
  String get surveyQ3Option1 => 'Friedlich';

  @override
  String get surveyQ3Option2 => 'Gemischt';

  @override
  String get surveyQ3Option3 => 'Angespannt';

  @override
  String get surveyQ3Option4 => 'Beängstigend';

  @override
  String get surveyQ4 => 'Wie fühlst du dich normalerweise in deinen Träumen?';

  @override
  String get surveyQ4Option1 => 'Unter Kontrolle';

  @override
  String get surveyQ4Option2 => 'Wie ein Beobachter';

  @override
  String get surveyQ4Option3 => 'Auf der Flucht';

  @override
  String get surveyQ4Option4 => 'Erforschend';

  @override
  String get profile1Name => 'Träumerischer Reisender';

  @override
  String get profile1Desc =>
      'Erkundung, Suche nach Bedeutung und emotionales Bewusstsein stehen in deinen Träumen im Vordergrund.\n\nDein Unterbewusstsein spricht oft in Symbolen zu dir. Du hast das Gefühl, dass kleine Details im Leben tatsächlich eine große Bedeutung haben.\n\nWenn du deine Träume aufzeichnest, wirst du deine innere Welt klarer sehen.';

  @override
  String get profile2Name => 'Stiller Beobachter';

  @override
  String get profile2Desc =>
      'Du bist mitten im Geschehen deiner Träume, hast aber das Gefühl, keine Kontrolle zu haben.\n\nDein Unterbewusstsein versucht zu verarbeiten, was du erlebt hast. Gedanken aus dem Alltag sickern mit sanften Übergängen in deine Träume.\n\nDas Aufschreiben deiner Träume kann die Last deines Geistes erleichtern.';

  @override
  String get profile3Name => 'Emotionaler Entdecker';

  @override
  String get profile3Desc =>
      'Deine Träume sind intensiv, detailliert und emotional stark.\n\nDein Unterbewusstsein bietet dir Szenen an, um dich selbst kennenzulernen. Du hast eine starke Bindung zu deiner inneren Welt.\n\nDas Verfolgen deiner Träume kann dir ernsthafte Erkenntnisse liefern.';

  @override
  String get profile4Name => 'Mentaler Krieger';

  @override
  String get profile4Desc =>
      'Themen wie Druck, Flucht und Kampf stehen in deinen Träumen im Vordergrund.\n\nTäglicher Stress kann sich in deinen Träumen widerspiegeln. Dein Unterbewusstsein signalisiert dir, „langsamer zu machen“.\n\nDas Aufschreiben deiner Träume kann geistige Erleichterung verschaffen.';

  @override
  String get profile5Name => 'Kontrollierender Architekt';

  @override
  String get profile5Desc =>
      'In deinen Träumen gibt es ein Gefühl für Richtung und bewusste Dominanz.\n\nDu hast vielleicht eine geplante, organisierte und bewusste Struktur in deinem Leben. Träume dienen dir als Spielplatz.\n\nDein Potenzial für Klarträume ist hoch.';

  @override
  String get profile6Name => 'Tieftaucher';

  @override
  String get profile6Desc =>
      'Deine Träume können intensiv und manchmal verstörend sein.\n\nDein Unterbewusstsein bringt unterdrückte Gefühle auf die Bühne. Das ist nichts Schlechtes; betrachte es als einen Reinigungsprozess.\n\nDas Aufschreiben deiner Träume kann deine inneren Lasten erleichtern.';

  @override
  String get profile7Name => 'Traumreisender';

  @override
  String get profile7Desc =>
      'In deinen Träumen herrscht ein Zustand von Ruhe und Fluss.\n\nDu bist vielleicht jemand, der das Leben aus der Ferne beobachtet und Emotionen tief erlebt. Träume dienen dir als geistiger Ruhebereich.\n\nEin Traumtagebuch stärkt dich noch weiter.';

  @override
  String get profile8Name => 'Bewusstseins-Schwellen-Passagier';

  @override
  String get profile8Desc =>
      'Deine Träume sind sehr lebendig, aber manchmal ermüdend.\n\nDu wechselst zwischen Bewusstsein und Unterbewusstsein hin und her. Du gehörst zu den Profilen, die dem Klarträumen am nächsten sind.\n\nMit etwas Balance kannst du deine Träume bewusst steuern.';

  @override
  String get surveyDisclaimer =>
      'Diese Analyse ist keine wissenschaftliche oder medizinische Bewertung.\nSie dient nur zu Unterhaltungs- und Bewusstseinszwecken.';

  @override
  String get surveyResultTitle => 'Dein Traumprofil';

  @override
  String get surveyContinue => 'DreamBoat Starten';

  @override
  String get welcomeHeader => 'Willkommen bei DreamBoat';

  @override
  String stepProgress(Object current, Object total) {
    return 'Schritt $current / $total';
  }

  @override
  String get emailLabelSupportId => 'Support-ID (Benutzer-ID)';

  @override
  String get emailLabelAppVersion => 'App-Version';

  @override
  String get emailLabelPlatform => 'Plattform';

  @override
  String get emailLabelLanguage => 'Sprache';

  @override
  String get biometricLockTitle => 'Möchtest du dein Traumtagebuch sperren?';

  @override
  String get biometricLockMessage =>
      'Deine Träume können sehr persönlich sein.\nDu kannst dein Traumtagebuch mit Fingerabdruck / Face ID schützen.';

  @override
  String get biometricLockYes => 'Ja, Schützen';

  @override
  String get biometricLockNo => 'Jetzt Nicht';

  @override
  String get biometricLockReason =>
      'Authentifiziere dich für den Zugriff auf das Traumtagebuch';

  @override
  String get biometricLockSettingsTitle => 'Traumtagebuch-Sperre';

  @override
  String get biometricLockSettingsSubtitle =>
      'Mit Fingerabdruck / Face ID schützen';

  @override
  String get biometricNotAvailable =>
      'Biometrische Funktion auf deinem Gerät nicht gefunden. Du kannst biometrische Daten in Einstellungen > Sicherheit hinzufügen.';

  @override
  String get biometricAuthFailed => 'Authentifizierung fehlgeschlagen';

  @override
  String get offlineSaveTitle => 'Keine Internetverbindung';

  @override
  String get offlineSaveContent =>
      'Du kannst deinen Traum im Tagebuch speichern, aber ohne Internet kann er nicht gedeutet werden.';

  @override
  String get offlineSaveConfirm => 'Ohne Deutung Speichern';

  @override
  String get offlineSaveCancel => 'Abbrechen';

  @override
  String get errorNoInternet => 'Keine Internetverbindung.';

  @override
  String get errorGeneric => 'Ein unerwarteter Fehler ist aufgetreten.';

  @override
  String get errorGenericRetry =>
      'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';

  @override
  String get dreamSavedNoInterpretation => 'Traum im Tagebuch gespeichert.';

  @override
  String get watchAdForInterpretation =>
      'Werde PRO oder sieh dir Werbung an für die AI-Deutung.';

  @override
  String get interpretationSkipped =>
      'Werbung nicht angesehen, Traum ohne Deutung gespeichert.';

  @override
  String weeklyLimitLeft(int count) {
    return 'Noch $count kostenlose Traumdeutungen diese Woche';
  }

  @override
  String get specialOffer => '🔥 SONDERANGEBOT';

  @override
  String get welcomeOfferFirstTime => 'Erstabonnenten-Angebot';

  @override
  String welcomeOfferExpires(String time) {
    return 'Angebot endet in: $time';
  }

  @override
  String streakDays(int count) {
    return '$count Tage am Stück';
  }

  @override
  String get streakSubtitle => 'Deine Traumreise geht weiter';

  @override
  String get proFeatureImageGenTitle => 'Täglich Traumbilder generieren';

  @override
  String get proFeatureImageGenSubtitle =>
      'Verwandle deine Träume in lebendige Kunst. Erwecke jeden Tag einen Traum zum Leben.';

  @override
  String get visualizeDream => 'Traum visualisieren';

  @override
  String get visualizingDream =>
      'KI verwandelt Ihren Traum in ein einzigartiges Kunstwerk... Dieser Vorgang kann etwa 30-45 Sekunden dauern.';

  @override
  String get imageGenLimitReached => 'Tageslimit erreicht';

  @override
  String get imageGenLimitDesc =>
      'Du kannst 1 Traumbild pro Tag erstellen. Komm morgen wieder!';

  @override
  String get imageGenLimitTrial => 'Testlimit erreicht';

  @override
  String get imageGenLimitTrialDesc =>
      'Testversion enthält 1 kostenloses Bild. Upgrade auf PRO für tägliche Bilder.';

  @override
  String get shareVisualizedBy => 'Visualisiert mit DreamBoat App';

  @override
  String get shareVisualSubject => 'Rüya Görselleştirmem';

  @override
  String get offlineImageGenTitle => 'Verbindungsfehler';

  @override
  String get offlineImageGenContent =>
      'Bild konnte nicht erstellt werden. Prüfe deine Verbindung. Limit wurde nicht verbraucht.';

  @override
  String get limitReachedTitle => 'Limit Erreicht';

  @override
  String get trialImageLimitReached =>
      'Du hast deine kostenlose Testvisualisierung verwendet. Nach Ablauf der Testversion kannst du mit PRO täglich ein neues Bild erstellen!';

  @override
  String get dailyImageLimitReached =>
      'Du hast deine tägliche Visualisierung verwendet. Komm morgen für ein neues Bild zurück!';

  @override
  String get visualizeDreamSubtitle =>
      'Ein von deinem Traum inspiriertes Gemälde, erstellt mit KI.';

  @override
  String get cosmicConnectionTitle => 'Kosmische Verbindung';

  @override
  String get unlockProConnection => 'Freischalten';

  @override
  String dreamMoonPhasePrefix(Object phase) {
    return '(Mondphase Ihres Traums: $phase)';
  }

  @override
  String get ok => 'OK';

  @override
  String get notifOff => 'Aus';

  @override
  String get notifChannelName => 'Tägliche Erinnerungen';

  @override
  String get notifChannelDesc =>
      'Tägliche Erinnerung, deine Träume aufzuzeichnen';

  @override
  String get subscriptionNotAvailable =>
      'Abonnement-Pakete sind derzeit nicht verfügbar';
}
