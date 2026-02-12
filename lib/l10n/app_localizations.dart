import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('tr')
  ];

  /// No description provided for @homeTitle.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Dünyanızda Bir Yolculuğa Çıkın'**
  String get homeSubtitle;

  /// No description provided for @homeNewDream.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Rüya Ekle'**
  String get homeNewDream;

  /// No description provided for @homeJournal.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Günlüğüm'**
  String get homeJournal;

  /// No description provided for @homeStats.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Dünyam'**
  String get homeStats;

  /// No description provided for @homeGuide.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get homeGuide;

  /// No description provided for @homeSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get homeSettings;

  /// No description provided for @statsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Dünyam'**
  String get statsTitle;

  /// No description provided for @statsTipTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günün Rüya Tavsiyesi'**
  String get statsTipTitle;

  /// No description provided for @statsTipContent.
  ///
  /// In tr, this message translates to:
  /// **'Bugün, içsel yolculuğunu derinleştirmek için bir anı defteri tutmayı deneyebilirsin. Rüyalarında gördüğün çocukluk hâlinle bağ kurarak, o saf sevgiyi yeniden keşfetmek için birkaç dakikanı ayır ve hislerini kaleme al.'**
  String get statsTipContent;

  /// No description provided for @statsAnalysisTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu Ayın Duygu Dağılımı'**
  String get statsAnalysisTitle;

  /// No description provided for @statsAnalysisResult.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Desen Analizi'**
  String get statsAnalysisResult;

  /// No description provided for @statsAnalyzeBtn.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Desenini Gör'**
  String get statsAnalyzeBtn;

  /// No description provided for @statsAnalysisIntroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Desen Analizi'**
  String get statsAnalysisIntroTitle;

  /// No description provided for @statsAnalysisIntroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftada bir kez yapılabilir'**
  String get statsAnalysisIntroSubtitle;

  /// No description provided for @statsAnalysisIntroContent.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Desen Analizi, Rüya Günlüğünde kayıtlı olan tüm rüyaları bir arada inceleyerek bilinçaltının tekrar eden temalarını, duygusal döngülerini ve sembolik eğilimlerini ortaya çıkarır. Bu sistem, tek tek rüya yorumlarından farklı olarak zaman içinde oluşan kalıpları, yani zihninin sana anlatmaya çalıştığı büyük resmi gösterir. Zaman içinde değişen ögeleri daha düzenli takip edebilmen için haftada sadece bir kez yapılabilir.'**
  String get statsAnalysisIntroContent;

  /// No description provided for @statsAnalysisWait.
  ///
  /// In tr, this message translates to:
  /// **'Yeni analiz için {days} gün beklemelisiniz.'**
  String statsAnalysisWait(Object days);

  /// No description provided for @statsAnalysisMinDreams.
  ///
  /// In tr, this message translates to:
  /// **'En Az 5 Kaydedilmiş Rüya Gerekir'**
  String get statsAnalysisMinDreams;

  /// No description provided for @statsAnalysisDone.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Analiz Yapıldı'**
  String get statsAnalysisDone;

  /// No description provided for @statsAnalyzing.
  ///
  /// In tr, this message translates to:
  /// **'Analiz Ediliyor...'**
  String get statsAnalyzing;

  /// No description provided for @statsOffline.
  ///
  /// In tr, this message translates to:
  /// **'İnternet gerekli'**
  String get statsOffline;

  /// No description provided for @statsNoData.
  ///
  /// In tr, this message translates to:
  /// **'Detaylı verilere erişebilmek için rüyalarını her gün kaydet'**
  String get statsNoData;

  /// No description provided for @statsProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Deseni hazırlanıyor, lütfen kısa bir süre bekleyin.'**
  String get statsProcessing;

  /// No description provided for @guideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get guideTitle;

  /// No description provided for @guideIntroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Nedir?'**
  String get guideIntroTitle;

  /// No description provided for @guideIntroContent.
  ///
  /// In tr, this message translates to:
  /// **'Lucid rüya (bilinçli rüya), rüyada olduğunun farkına vardığın ve rüyanı kontrol edebildiğin eşsiz bir deneyimdir.'**
  String get guideIntroContent;

  /// No description provided for @moodLove.
  ///
  /// In tr, this message translates to:
  /// **'Aşk'**
  String get moodLove;

  /// No description provided for @moodHappy.
  ///
  /// In tr, this message translates to:
  /// **'Mutluluk'**
  String get moodHappy;

  /// No description provided for @moodSad.
  ///
  /// In tr, this message translates to:
  /// **'Üzüntü'**
  String get moodSad;

  /// No description provided for @moodScared.
  ///
  /// In tr, this message translates to:
  /// **'Korku'**
  String get moodScared;

  /// No description provided for @moodAnger.
  ///
  /// In tr, this message translates to:
  /// **'Öfke'**
  String get moodAnger;

  /// No description provided for @moodNeutral.
  ///
  /// In tr, this message translates to:
  /// **'Nötr'**
  String get moodNeutral;

  /// No description provided for @moodPeace.
  ///
  /// In tr, this message translates to:
  /// **'Huzur'**
  String get moodPeace;

  /// No description provided for @moodAwe.
  ///
  /// In tr, this message translates to:
  /// **'Şaşkınlık'**
  String get moodAwe;

  /// No description provided for @moodAnxiety.
  ///
  /// In tr, this message translates to:
  /// **'Kaygı'**
  String get moodAnxiety;

  /// No description provided for @moodConfusion.
  ///
  /// In tr, this message translates to:
  /// **'Kafa Karışıklığı'**
  String get moodConfusion;

  /// No description provided for @moodEmpowered.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü'**
  String get moodEmpowered;

  /// No description provided for @moodLonging.
  ///
  /// In tr, this message translates to:
  /// **'Özlem'**
  String get moodLonging;

  /// No description provided for @feltMood.
  ///
  /// In tr, this message translates to:
  /// **'Duygu:'**
  String get feltMood;

  /// No description provided for @moodSelectPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Bu rüyayı düşündüğünde içindeki ilk his ne?'**
  String get moodSelectPrompt;

  /// No description provided for @moodIntensityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Duygu Yoğunluğu'**
  String get moodIntensityLabel;

  /// No description provided for @moodIntensityLow.
  ///
  /// In tr, this message translates to:
  /// **'Hafif'**
  String get moodIntensityLow;

  /// No description provided for @moodIntensityMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get moodIntensityMedium;

  /// No description provided for @moodIntensityHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yoğun'**
  String get moodIntensityHigh;

  /// No description provided for @moodVividnessLabel.
  ///
  /// In tr, this message translates to:
  /// **'Berraklık'**
  String get moodVividnessLabel;

  /// No description provided for @moodVividnessQuestion.
  ///
  /// In tr, this message translates to:
  /// **'Rüyayı ne kadar net hatırlıyorsun?'**
  String get moodVividnessQuestion;

  /// No description provided for @moodVividnessLow.
  ///
  /// In tr, this message translates to:
  /// **'Bulanık'**
  String get moodVividnessLow;

  /// No description provided for @moodVividnessMedium.
  ///
  /// In tr, this message translates to:
  /// **'Kısmen Net'**
  String get moodVividnessMedium;

  /// No description provided for @moodVividnessHigh.
  ///
  /// In tr, this message translates to:
  /// **'Çok Net'**
  String get moodVividnessHigh;

  /// No description provided for @moodNotSure.
  ///
  /// In tr, this message translates to:
  /// **'Emin Değilim'**
  String get moodNotSure;

  /// No description provided for @moodSaving.
  ///
  /// In tr, this message translates to:
  /// **'Rüyan kaydediliyor...'**
  String get moodSaving;

  /// No description provided for @newDreamModalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu Rüyada Hangi Duygu\nHakimdi?'**
  String get newDreamModalTitle;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @journalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Günlüğüm'**
  String get journalTitle;

  /// No description provided for @journalAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get journalAll;

  /// No description provided for @journalFavorites.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerim'**
  String get journalFavorites;

  /// No description provided for @journalNoDreams.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kaydedilmiş rüya yok.'**
  String get journalNoDreams;

  /// No description provided for @journalNoFavorites.
  ///
  /// In tr, this message translates to:
  /// **'Henüz favori rüya yok.'**
  String get journalNoFavorites;

  /// No description provided for @journalAnalysis.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Yorumu'**
  String get journalAnalysis;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingsNotifications;

  /// No description provided for @settingsPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get settingsPrivacy;

  /// No description provided for @settingsSupport.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get settingsSupport;

  /// No description provided for @settingsVersion.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm:'**
  String get settingsVersion;

  /// No description provided for @settingsNotifOpen.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri Aç'**
  String get settingsNotifOpen;

  /// No description provided for @settingsNotifTime.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Hatırlatıcı'**
  String get settingsNotifTime;

  /// No description provided for @settingsNotifDesc.
  ///
  /// In tr, this message translates to:
  /// **'Her sabah rüyalarını kaydetmen için nazik bir hatırlatma al.'**
  String get settingsNotifDesc;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsSupportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get settingsSupportTitle;

  /// No description provided for @settingsAppStatus.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Durumu'**
  String get settingsAppStatus;

  /// No description provided for @settingsSupportDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun mu var? Bize ulaşın!'**
  String get settingsSupportDesc;

  /// No description provided for @settingsSend.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj Gönder'**
  String get settingsSend;

  /// No description provided for @settingsSending.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj gönderildi!'**
  String get settingsSending;

  /// No description provided for @newDreamMinCharHint.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanın yorumlanabilmesi için minimum 50 karakter girmelisin.'**
  String get newDreamMinCharHint;

  /// No description provided for @homeSpecialBadge.
  ///
  /// In tr, this message translates to:
  /// **'PRO'**
  String get homeSpecialBadge;

  /// No description provided for @newDreamTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Rüya'**
  String get newDreamTitle;

  /// No description provided for @newDreamSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarını her gün kaydetmeyi unutma...'**
  String get newDreamSubtitle;

  /// No description provided for @newDreamSave.
  ///
  /// In tr, this message translates to:
  /// **'Rüyamı Kaydet ve Yorumla'**
  String get newDreamSave;

  /// No description provided for @newDreamPlaceholderDetail.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanı buraya detaylandır...\n\nÖrnek: Çiçeklerle dolu sakin bir bahçede yürüyordum. Güneş yaprakların arasından yumuşak bir ışık yayıyordu. Yakındaki küçük bir kuş havuzunda su hafifçe dalgalanıyordu.'**
  String get newDreamPlaceholderDetail;

  /// No description provided for @newDreamPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanı buraya detaylandır...'**
  String get newDreamPlaceholder;

  /// No description provided for @guideCompletionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler!'**
  String get guideCompletionTitle;

  /// No description provided for @guideCompletionContent.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberinin tüm aşamalarını tamamladın.\n\nArtık tüm teknikler üzerinde ustalaşarak Lucid Rüya dünyasında serbestçe ilerleyebilirsin!'**
  String get guideCompletionContent;

  /// No description provided for @guideStage1Title.
  ///
  /// In tr, this message translates to:
  /// **'1. MILD Tekniği (Mnemonic Induction of Lucid Dreams)'**
  String get guideStage1Title;

  /// No description provided for @guideStage1Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarınıza uyanış tohumunu ekmek'**
  String get guideStage1Subtitle;

  /// No description provided for @guideStage1Content.
  ///
  /// In tr, this message translates to:
  /// **'Lucid dreaming yolculuğunun başlangıç noktasıdır. MILD, yani \"Mnemonic Induction of Lucid Dreams\", uykuya dalmadan önce bilinçaltına net bir niyet yerleştirme tekniğidir. Bu niyet, rüya sırasında \"ben rüyadayım\" farkındalığını yakalamanı sağlar. Bilinçli rüyaların ilk kapısını bu aşamada aralayacağız.'**
  String get guideStage1Content;

  /// No description provided for @guideStage1Importance.
  ///
  /// In tr, this message translates to:
  /// **'MILD, zihnin hatırlama ve niyet oluşturma yeteneğini kullanarak, lucid dreaming\'e zihinsel bir zemin hazırlar. Hipokampus ve prefrontal korteksi aktif hale getirerek rüyada bilinçli olma ihtimalini artırır.'**
  String get guideStage1Importance;

  /// No description provided for @guideStage1Steps.
  ///
  /// In tr, this message translates to:
  /// **'Gece rüyadan uyandıktan sonra son rüyanı detaylıca hatırlamaya çalış.\nKendine şu cümleyi tekrar et: \"Bir sonraki rüyamda rüya gördüğümü fark edeceğim.\"\nBu sahneyi zihninde canlandır. Kendini rüyada farkında şekilde görselleştir.\nGözlerini kapat, bu niyetle uykuya dön.\nSabah uyandığında rüya günlüğüne detaylıca yaz.'**
  String get guideStage1Steps;

  /// No description provided for @guideStage1Criteria.
  ///
  /// In tr, this message translates to:
  /// **'1 hafta içinde en az 1 defa rüyanda rüya gördüğünü fark ettiysen bir sonraki aşamaya geçebilirsin.'**
  String get guideStage1Criteria;

  /// No description provided for @guideStage1BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu bir uyanış yolculuğu. İlk adımda zihnini eğitmeye başlıyorsun. Her tekrar, bilinçli rüyaların bir adım daha yakın olması demektir. Unutma, sabır ve tekrar en büyük yardımcın.'**
  String get guideStage1BrainNote;

  /// No description provided for @guideStage2Title.
  ///
  /// In tr, this message translates to:
  /// **'2. WBTB (Wake Back To Bed)'**
  String get guideStage2Title;

  /// No description provided for @guideStage2Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bilinçli Rüya Kapısını Aralamak'**
  String get guideStage2Subtitle;

  /// No description provided for @guideStage2Content.
  ///
  /// In tr, this message translates to:
  /// **'Artık zihinsel niyetini oluşturdun. Şimdi, rüyaların en yoğun yaşandığı REM evresine, bilinçli bir şekilde yeniden giriş yapmayı öğreneceğiz. WBTB tekniği, yarı uyanıklık halinde yeniden uykuya dalmanı sağlayarak lucid rüya farkındalığını destekleyebilir.'**
  String get guideStage2Content;

  /// No description provided for @guideStage2Importance.
  ///
  /// In tr, this message translates to:
  /// **'WBTB ile beynin hem uyanıklık hem uyku arasında kalır. Bu geçiş noktası, lucid rüyalar için en uygun zihinsel ortamı sağlar.'**
  String get guideStage2Importance;

  /// No description provided for @guideStage2Steps.
  ///
  /// In tr, this message translates to:
  /// **'Gece uyuduktan 4–6 saat sonra alarm kurup uyan.\n15–30 dakika boyunca düşük ışıkta kitap oku, meditasyon yap ya da MILD tekrarı yap.\nBu sürenin sonunda tekrar yat ve MILD niyetiyle uykuya dal.'**
  String get guideStage2Steps;

  /// No description provided for @guideStage2Criteria.
  ///
  /// In tr, this message translates to:
  /// **'1 hafta içinde en az 2 gece rüyanda bulunduğun ortamın farkındalığını kazandıysan bir sonraki aşamaya geçebilirsin.'**
  String get guideStage2Criteria;

  /// No description provided for @guideStage2BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Zihnini biraz daha açıyorsun. Rüya ile gerçeklik arasındaki perde inceliyor. Uyanıklıkla rüyayı buluşturmak üzeresin.'**
  String get guideStage2BrainNote;

  /// No description provided for @guideStage3Title.
  ///
  /// In tr, this message translates to:
  /// **'3. WILD (Wake Initiated Lucid Dream)'**
  String get guideStage3Title;

  /// No description provided for @guideStage3Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bilincinle Rüyaya Doğrudan Giriş'**
  String get guideStage3Subtitle;

  /// No description provided for @guideStage3Content.
  ///
  /// In tr, this message translates to:
  /// **'Lucid dreaming\'in en etkileyici tekniklerinden biri olan WILD, seni doğrudan bilinçli şekilde rüya alemine taşır. Uyumadan önce zihnin uyanık kalırken bedenin uyumasına izin verirsin ve rüya başlangıcını daha net fark edebilirsin.'**
  String get guideStage3Content;

  /// No description provided for @guideStage3Importance.
  ///
  /// In tr, this message translates to:
  /// **'WILD, zihinsel berraklık ile bedensel rahatlamanın eş zamanlı yürütülmesini gerektirir. Bu teknik, doğrudan rüyaya giriş yaptığın için diğerlerinden farklıdır ve yüksek düzeyde pratik ister.'**
  String get guideStage3Importance;

  /// No description provided for @guideStage3Steps.
  ///
  /// In tr, this message translates to:
  /// **'WBTB sonrası uygula.\nYatağa uzan, tüm bedenini gevşet.\nNefesine odaklan, zihnini aktif tut.\nGözlerin kapalıyken ışıklar, desenler görebilirsin — sakince izle.\nRüyanın başladığını fark ettiğinde kontrolü ele al.'**
  String get guideStage3Steps;

  /// No description provided for @guideStage3Criteria.
  ///
  /// In tr, this message translates to:
  /// **'2 hafta içinde en az 1 kez doğrudan bilinçli bir şekilde rüya içine geçiş yaptıysan 4. aşamaya hazırsın.'**
  String get guideStage3Criteria;

  /// No description provided for @guideStage3BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi ustalığın eşiğindesin. Gözlerini kapatıp başka bir dünyada açmayı öğreniyorsun. Unutma, bu teknik çok fazla pratik ister ve sabır en büyük müttefikindir.'**
  String get guideStage3BrainNote;

  /// No description provided for @guideStage4Title.
  ///
  /// In tr, this message translates to:
  /// **'4. Zaman Farkındalığı ve Gerçeklik Kontrolleri'**
  String get guideStage4Title;

  /// No description provided for @guideStage4Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Gerçeklik Algımıza Hâkim Olmak'**
  String get guideStage4Subtitle;

  /// No description provided for @guideStage4Content.
  ///
  /// In tr, this message translates to:
  /// **'Artık lucid rüyaların farkındalığı başladı. Şimdi bu farkındalığı derinleştirmenin ve zaman-mekan kavramını rüyada kullanabilmenin zamanı geldi. Bu aşamada hedef: rüyadayken yıl, yaş, tarih gibi kavramları hatırlamak.'**
  String get guideStage4Content;

  /// No description provided for @guideStage4Importance.
  ///
  /// In tr, this message translates to:
  /// **'Gerçeklik kontrolleri, rüyada olduğunun farkına varmanı kolaylaştırır. Zaman algısı ise zihinsel farkındalığın derinliğini gösterir.'**
  String get guideStage4Importance;

  /// No description provided for @guideStage4Steps.
  ///
  /// In tr, this message translates to:
  /// **'Günde en az 5–10 kez \"Şu an rüyada mıyım?\" diye sor.\nParmak saymak, yazı tekrar okumak gibi testler yap.\nUyumadan önce: \"Rüyamda hangi yılda olduğumu fark edeceğim\" niyetini tekrar et.'**
  String get guideStage4Steps;

  /// No description provided for @guideStage4Criteria.
  ///
  /// In tr, this message translates to:
  /// **'1 hafta içinde 3 gece rüyanda zamanla ilgili bir farkındalık yaşadıysan (örneğin yıl, doğum günün, takvim) → sıradaki aşamaya geçebilirsin.'**
  String get guideStage4Criteria;

  /// No description provided for @guideStage4BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Artık sadece rüyada olduğunu değil, rüyadaki zamanın da farkındasın. Zihnin yeni bir boyuta geçmeye başladı.'**
  String get guideStage4BrainNote;

  /// No description provided for @guideStage5Title.
  ///
  /// In tr, this message translates to:
  /// **'5. Uyku Rutini Optimizasyonu'**
  String get guideStage5Title;

  /// No description provided for @guideStage5Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüyaya Zemin Hazırlamak'**
  String get guideStage5Subtitle;

  /// No description provided for @guideStage5Content.
  ///
  /// In tr, this message translates to:
  /// **'Bu aşamada doğrudan lucid rüya denemelerine ara veriyoruz. Artık beynin temel mekanizmasını desteklemek, zihinsel berraklığı derinleştirmek için düzenli bir uyku rutini inşa etme zamanı.'**
  String get guideStage5Content;

  /// No description provided for @guideStage5Importance.
  ///
  /// In tr, this message translates to:
  /// **'Düzenli uyku ve ideal ortam lucid dreaming başarısını doğrudan etkiler. REM süresinin sağlıklı ilerlemesi için düzenli bir ritim gerekir.'**
  String get guideStage5Importance;

  /// No description provided for @guideStage5Steps.
  ///
  /// In tr, this message translates to:
  /// **'Her gün aynı saatte yat-kalk düzeni oluştur.\nYatmadan 1 saat önce dijital detoks yap.\nSessiz, karanlık, serin odada uyumaya özen göster.\nKısa meditasyonlarla zihni yatıştır.'**
  String get guideStage5Steps;

  /// No description provided for @guideStage5Criteria.
  ///
  /// In tr, this message translates to:
  /// **'10 gün boyunca 7 gece rüya günlüğü tuttuysan ve rüyaların 3\'ünde farkındalık sinyalleri yaşadıysan → sıradaki aşamaya geçebilirsin.'**
  String get guideStage5Criteria;

  /// No description provided for @guideStage5BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Bir bina temelsiz olmaz. Bu aşama, bilinçli rüyalarına sağlam bir zemin kurar. Unutma, dinlenmiş bir zihin bilinçli bir zihin demektir.'**
  String get guideStage5BrainNote;

  /// No description provided for @guideStage6Title.
  ///
  /// In tr, this message translates to:
  /// **'6. Dopamin Dengesi'**
  String get guideStage6Title;

  /// No description provided for @guideStage6Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Zihin Kimyasını Dengelemek'**
  String get guideStage6Subtitle;

  /// No description provided for @guideStage6Content.
  ///
  /// In tr, this message translates to:
  /// **'Artık zihnin lucid dreaming ile tanıştı. Bu aşamada rüya pratiğinden bir adım geri çekiliyor ve zihinsel dengeyi destekleyerek lucid rüyalar için daha sağlıklı bir zihinsel ortam oluşturmayı amaçlıyoruz.'**
  String get guideStage6Content;

  /// No description provided for @guideStage6Importance.
  ///
  /// In tr, this message translates to:
  /// **'Dopamin, motivasyon ve dikkat süreçlerinde rol oynayan bir nörotransmitterdir. Aşırı uyaranlar zihinsel odaklanmayı zorlaştırabilir. Bu içerikler tıbbi tavsiye değildir; yalnızca farkındalık ve yaşam tarzı önerileri sunar.'**
  String get guideStage6Importance;

  /// No description provided for @guideStage6Steps.
  ///
  /// In tr, this message translates to:
  /// **'5 gün boyunca sosyal medya süreni 1 saatle sınırla.\nHafif egzersiz, yürüyüş ve güneş ışığı al.\nOmega-3 açısından zengin, şekerden uzak beslen.\nUyku öncesi odak egzersizleri yap.'**
  String get guideStage6Steps;

  /// No description provided for @guideStage6Criteria.
  ///
  /// In tr, this message translates to:
  /// **'1 hafta içinde 3 kez lucid rüyada bilinçli şekilde ortamı, ışığı veya bir objeyi manipüle edebildiysen son aşamaya geçebilirsin.'**
  String get guideStage6Criteria;

  /// No description provided for @guideStage6BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Artık zihnini sadece eğitmedin, onun biyolojik yapısını da optimize ettin. Şimdi bilinçli rüyalar sadece mümkün değil; senin doğan haline dönüşüyor.'**
  String get guideStage6BrainNote;

  /// No description provided for @guideStage7Title.
  ///
  /// In tr, this message translates to:
  /// **'7. İleri Farkındalık ve Yaratıcı Yönlendirme'**
  String get guideStage7Title;

  /// No description provided for @guideStage7Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanın Efendisi Olmak'**
  String get guideStage7Subtitle;

  /// No description provided for @guideStage7Content.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuğun sonuna geldik. Bu noktada artık sadece lucid olmakla kalmayacak, rüya deneyimini daha bilinçli şekilde keşfedebileceğin bir seviyeye ulaşacaksın. Rüya dünyanı özgürce yaratma zamanı geldi.'**
  String get guideStage7Content;

  /// No description provided for @guideStage7Importance.
  ///
  /// In tr, this message translates to:
  /// **'Bu teknikle rüya sembolleri ve zihinsel imgeler üzerine farkındalık geliştirebilirsin, hayal ettiğin her şeyi test edebilirsin. Bu hem zihinsel hem de kişisel farkındalık açısından önemli bir adımdır.'**
  String get guideStage7Importance;

  /// No description provided for @guideStage7Steps.
  ///
  /// In tr, this message translates to:
  /// **'Rüyada yapmak istediğin senaryoyu detaylıca yaz ve hayal et.\nRüyada bilinçli olarak mekanı, zamanı, karakteri veya sonucu değiştir.\nFarkındalık meditasyonlarını gündelik rutine ekle.'**
  String get guideStage7Steps;

  /// No description provided for @guideStage7Criteria.
  ///
  /// In tr, this message translates to:
  /// **'2 hafta içinde en az 2 rüyada aktif manipülasyon yaptıysan (uçmak, ortamı değiştirmek, bir şeyi çağırmak), lucid rüya dünyasına hoş geldin.'**
  String get guideStage7Criteria;

  /// No description provided for @guideStage7BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu yolculuğun sonunda sadece bilinçli rüyalar değil, hayal gücünün sınırsız potansiyeli seni bekliyor. Artık sadece uyanıkken değil, uyurken de hayatı yaratıyorsun.'**
  String get guideStage7BrainNote;

  /// No description provided for @guideAppBarTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get guideAppBarTitle;

  /// No description provided for @guideIntroTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Lucid rüya nedir?'**
  String get guideIntroTitle1;

  /// No description provided for @guideIntroContent1.
  ///
  /// In tr, this message translates to:
  /// **'Lucid rüya (bilinçli rüya), rüyada olduğunun farkına vardığın ve rüyanı kontrol edebildiğin eşsiz bir deneyimdir.'**
  String get guideIntroContent1;

  /// No description provided for @guideIntroListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya durumunda:'**
  String get guideIntroListTitle;

  /// No description provided for @guideIntroBullet1.
  ///
  /// In tr, this message translates to:
  /// **'Rüya sırasında bilincin yerindedir'**
  String get guideIntroBullet1;

  /// No description provided for @guideIntroBullet2.
  ///
  /// In tr, this message translates to:
  /// **'Çevreni değerlendirebilirsin'**
  String get guideIntroBullet2;

  /// No description provided for @guideIntroBullet3.
  ///
  /// In tr, this message translates to:
  /// **'Karar verme yetin artar'**
  String get guideIntroBullet3;

  /// No description provided for @guideIntroBullet4.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanın akışını değiştirebilirsin'**
  String get guideIntroBullet4;

  /// No description provided for @guideIntroFooter.
  ///
  /// In tr, this message translates to:
  /// **'Lucid rüya, çok azımızın hayatının bir noktasında tesadüfen tecrübe edebildiği fakat doğru teknikler ile üzerinde uzmanlaşılabilen bir beceridir.'**
  String get guideIntroFooter;

  /// No description provided for @guideIntroTitle2.
  ///
  /// In tr, this message translates to:
  /// **'Lucid rüya ne işe yarar?'**
  String get guideIntroTitle2;

  /// No description provided for @guideBenefit1.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarını yönetirsin'**
  String get guideBenefit1;

  /// No description provided for @guideBenefit2.
  ///
  /// In tr, this message translates to:
  /// **'Bilinçaltını keşfedersin'**
  String get guideBenefit2;

  /// No description provided for @guideBenefit3.
  ///
  /// In tr, this message translates to:
  /// **'Uykunun efendisi olursun'**
  String get guideBenefit3;

  /// No description provided for @guideBenefit4.
  ///
  /// In tr, this message translates to:
  /// **'Stresle daha iyi başa çıkarsın'**
  String get guideBenefit4;

  /// No description provided for @guideIntroContent2.
  ///
  /// In tr, this message translates to:
  /// **'Lucid rüyalar, bilinçaltının kapılarını aralayarak seni daha yüksek bir farkındalık seviyesine taşır. Bu deneyim zamanla gündelik hayatına bile yansır.'**
  String get guideIntroContent2;

  /// No description provided for @guideIntroTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Bu rehber nasıl kullanılır?'**
  String get guideIntroTitle3;

  /// No description provided for @guideIntroContent3.
  ///
  /// In tr, this message translates to:
  /// **'Bu rehber 7 aşamalı özel bir lucid rüya sistemi üzerine kuruludur. Her aşamada rüyalarına doğrudan etki edecek güçlü bir alışkanlık edinirsin. Hazırlamış olduğumuz kapsamlı rehber, bir kez satın alındıktan sonra seni hedeflerine ulaşana kadar her adımda yönlendirecek.'**
  String get guideIntroContent3;

  /// No description provided for @guideIntroGainTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerledikçe Kazanacakların'**
  String get guideIntroGainTitle;

  /// No description provided for @guideIntroGain1.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarının derin katmanlarına erişirsin'**
  String get guideIntroGain1;

  /// No description provided for @guideIntroGain2.
  ///
  /// In tr, this message translates to:
  /// **'Bilincin rüyaya yön vermeye başlar'**
  String get guideIntroGain2;

  /// No description provided for @guideIntroGain3.
  ///
  /// In tr, this message translates to:
  /// **'Mekânlar ve kişiler sana göre şekil alır'**
  String get guideIntroGain3;

  /// No description provided for @guideIntroGain4.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarının yönetmeni olursun'**
  String get guideIntroGain4;

  /// No description provided for @guideBuyButton.
  ///
  /// In tr, this message translates to:
  /// **'Rehberi Satın Al (179.00 TL)'**
  String get guideBuyButton;

  /// No description provided for @guideNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get guideNo;

  /// No description provided for @guideYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get guideYes;

  /// No description provided for @guideDebugResetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rehberi Sıfırla?'**
  String get guideDebugResetTitle;

  /// No description provided for @guideDebugResetContent.
  ///
  /// In tr, this message translates to:
  /// **'Birinci aşama hariç tüm kilitleri kapatacak. (Debug)'**
  String get guideDebugResetContent;

  /// No description provided for @journalDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyayı Sil?'**
  String get journalDeleteTitle;

  /// No description provided for @journalDeleteContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu rüyayı silmek istediğine emin misin? Bu işlem geri alınamaz.'**
  String get journalDeleteContent;

  /// No description provided for @journalDeleteConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get journalDeleteConfirm;

  /// No description provided for @journalDeleteCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get journalDeleteCancel;

  /// No description provided for @proVersion.
  ///
  /// In tr, this message translates to:
  /// **'PRO'**
  String get proVersion;

  /// No description provided for @standardVersion.
  ///
  /// In tr, this message translates to:
  /// **'Standart'**
  String get standardVersion;

  /// No description provided for @upgradeTitle.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat PRO\'ya Yükselt'**
  String get upgradeTitle;

  /// No description provided for @upgradeBenefits.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız Deneyim\nTam Rüya Analizi\nLimitsiz Rüya Yorumu\nÖzel Rehber Erişimi'**
  String get upgradeBenefits;

  /// No description provided for @upgradeBtn.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat PRO\'yu Aç (88,99 ₺)'**
  String get upgradeBtn;

  /// No description provided for @upgradeCancel.
  ///
  /// In tr, this message translates to:
  /// **'Belki daha sonra'**
  String get upgradeCancel;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyPolicyLink;

  /// No description provided for @termsOfUseLink.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Şartları'**
  String get termsOfUseLink;

  /// No description provided for @upgradeSuccess.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat PRO\'ya hoşgeldin!'**
  String get upgradeSuccess;

  /// No description provided for @upgradeStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get upgradeStart;

  /// No description provided for @proRequired.
  ///
  /// In tr, this message translates to:
  /// **'PRO Versiyon Gerekir'**
  String get proRequired;

  /// No description provided for @proRequiredDetail.
  ///
  /// In tr, this message translates to:
  /// **'PRO Versiyon ve En Az 5 Kaydedilmiş Rüya Gerekir'**
  String get proRequiredDetail;

  /// No description provided for @guideUnlockPro.
  ///
  /// In tr, this message translates to:
  /// **'PRO Sürümünün Kilidini Aç'**
  String get guideUnlockPro;

  /// No description provided for @guideUnlockHint.
  ///
  /// In tr, this message translates to:
  /// **'Rehberin kilidini açmak için PRO sürümüne geçmelisin.'**
  String get guideUnlockHint;

  /// No description provided for @guideContent.
  ///
  /// In tr, this message translates to:
  /// **'İçerik'**
  String get guideContent;

  /// No description provided for @guideImportance.
  ///
  /// In tr, this message translates to:
  /// **'Neden Önemli?'**
  String get guideImportance;

  /// No description provided for @guideSteps.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Adımları'**
  String get guideSteps;

  /// No description provided for @guideCriteria.
  ///
  /// In tr, this message translates to:
  /// **'Geçiş Kriteri'**
  String get guideCriteria;

  /// No description provided for @guideBrainNoteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Note to Brain'**
  String get guideBrainNoteTitle;

  /// No description provided for @guideNextStep.
  ///
  /// In tr, this message translates to:
  /// **'İlerle'**
  String get guideNextStep;

  /// No description provided for @guideDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemek istediğine emin misin?'**
  String get guideDialogTitle;

  /// No description provided for @guideDialogContent.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut adımı gerçekleştirmeden sonraki aşamaya geçmek yolculuğuna zarar verebilir. Devam etmek istediğine emin misin?'**
  String get guideDialogContent;

  /// No description provided for @guideDialogCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get guideDialogCancel;

  /// No description provided for @guideDialogConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get guideDialogConfirm;

  /// No description provided for @guideStart.
  ///
  /// In tr, this message translates to:
  /// **'Rehbere Başla'**
  String get guideStart;

  /// No description provided for @privacyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik ve KVKK'**
  String get privacyTitle;

  /// No description provided for @privacyNoticeTitle.
  ///
  /// In tr, this message translates to:
  /// **'NovaBloom Studio Gizlilik Bildirimi'**
  String get privacyNoticeTitle;

  /// No description provided for @privacyNoticeContent.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat, bağımsız geliştirici Guney Yilmazer tarafından NovaBloom Studio markası altında geliştirilmiştir. Gizliliğiniz bizim için en yüksek önceliktir. DreamBoat, rüyalarınızı güvenle kaydetmeniz ve kişisel farkındalık için analiz etmeniz amacıyla tasarlanmıştır.'**
  String get privacyNoticeContent;

  /// No description provided for @privacySection1Title.
  ///
  /// In tr, this message translates to:
  /// **'1. Veri Güvenliği ve İşleme'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In tr, this message translates to:
  /// **'Rüya kayıtlarınız ve uygulama içi verileriniz güvenli bir şekilde saklanır.\nRüyalarınız yalnızca uygulamanın sunduğu özellikleri çalıştırmak için işlenir.\n\nRüya içerikleri üçüncü kişilerle asla paylaşılmaz\n\nVeriler reklam, pazarlama veya kullanıcı profilleme amacıyla kullanılmaz\n\nYapay zekâ destekli analizler yalnızca kullanıcı deneyimini geliştirmek için yapılır\n\nRüya metinleri AI modellerinin eğitimi için kullanılmaz\n\nTüm işlemler KVKK ve GDPR standartlarına uygun şekilde yürütülür'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In tr, this message translates to:
  /// **'2. Hesap ve Kullanım'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat, hesap oluşturma zorunluluğu olmadan çalışır.\n\nUygulama anonim olarak kullanılabilir\n\nRüyalarınız ve ayarlarınız yalnızca cihazınızda veya uygulamaya ait güvenli alanlarda saklanır\n\nKişisel kimlik bilgileri (isim, e-posta vb.) zorunlu olarak toplanmaz'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In tr, this message translates to:
  /// **'3. Gizlilik ve Kilitleme Özellikleri'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat, gizliliği korumak için ek güvenlik seçenekleri sunar:\n\nRüya günlüğü Face ID veya parmak izi ile kilitlenebilir\n\nRüyalar varsayılan olarak tamamen özeldir\n\nPaylaşım özelliği isteğe bağlıdır ve yalnızca kullanıcı açıkça paylaşmayı seçtiğinde çalışır\n\nRüyalar hiçbir zaman otomatik olarak veya üçüncü taraflarla paylaşılmaz'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In tr, this message translates to:
  /// **'4. Sağlık ve Tıbbi Feragat (ÖNEMLİ)'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat bir sağlık veya tıbbi uygulama değildir.\n\nSunulan rüya yorumları ve analizler eğlence ve kişisel farkındalık amaçlıdır\n\nTıbbi, psikolojik veya profesyonel tavsiye niteliği taşımaz\n\nUygulama biyometrik veya sağlık verisi toplamaz ve işlemez\n\n5. İletişim\n\nDetaylı gizlilik politikamıza web sitemiz üzerinden de ulaşabilirsiniz:\nhttps://www.novabloomstudio.com/tr/privacy'**
  String get privacySection4Content;

  /// No description provided for @supportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bize Ulaşın'**
  String get supportTitle;

  /// No description provided for @supportContent.
  ///
  /// In tr, this message translates to:
  /// **'Görüşleriniz NovaBloom Studio için çok değerli.\n\nÖneri, hata bildirimi veya işbirliği talepleriniz için bize e-posta gönderebilirsiniz.'**
  String get supportContent;

  /// No description provided for @supportSendEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Gönder'**
  String get supportSendEmail;

  /// No description provided for @supportEmailNotFound.
  ///
  /// In tr, this message translates to:
  /// **'E-posta uygulaması bulunamadı.'**
  String get supportEmailNotFound;

  /// No description provided for @supportEmailSubject.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat Destek Talebi'**
  String get supportEmailSubject;

  /// No description provided for @debugResetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Debug Reset'**
  String get debugResetTitle;

  /// No description provided for @debugResetContent.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama durumunu Standart versiyona döndürmek istiyor musunuz?'**
  String get debugResetContent;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// No description provided for @standard.
  ///
  /// In tr, this message translates to:
  /// **'STANDART'**
  String get standard;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @timeFormat24h.
  ///
  /// In tr, this message translates to:
  /// **'24 Saat Formatı'**
  String get timeFormat24h;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @guideSlide1Title.
  ///
  /// In tr, this message translates to:
  /// **'Eski Mısır’ın Bilgeliği'**
  String get guideSlide1Title;

  /// No description provided for @guideSlide1Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ruhun Yolculuğuna Açılan Kapı'**
  String get guideSlide1Subtitle;

  /// No description provided for @guideSlide1Content1.
  ///
  /// In tr, this message translates to:
  /// **'Günümüzde adına lucid rüya dediğimiz kavramın izlerini Antik Mısır’da görmek mümkündü. Mısırlılar rüyayı, dönemin kültürel ve spiritüel inançları çerçevesinde bilinçli bir deneyim olarak yorumlarlardı.\n\nÖyle ki Firavunların, rahipler aracılığıyla rüya aleminde ilahi figürlerle etkileşim yaşadıklarına dair sembolik anlatımlar yer alır.'**
  String get guideSlide1Content1;

  /// No description provided for @guideSlide1Content2.
  ///
  /// In tr, this message translates to:
  /// **'Modern tıpta somnoloji alanındaki uyku araştırmalarında, rüya gördüğümüz evre olan REM uykusunda frontal korteksin aktif olduğu, yani beynin bilinç ve farkındalıkla ilişkili bölgelerinin uyanık haldekine benzer bir şekilde çalıştığı gözlemlenmiştir. Bu bulgular, Antik Mısır’da rüyaya atfedilen bilinçli deneyim anlatımlarıyla bazı kavramsal benzerlikler taşıdığı şeklinde yorumlanmaktadır.'**
  String get guideSlide1Content2;

  /// No description provided for @guideSlide2Title.
  ///
  /// In tr, this message translates to:
  /// **'Tibet Rahiplerinin Meditasyonları'**
  String get guideSlide2Title;

  /// No description provided for @guideSlide2Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Zihnin Sınırlarını Aşmak'**
  String get guideSlide2Subtitle;

  /// No description provided for @guideSlide2Content1.
  ///
  /// In tr, this message translates to:
  /// **'Tibet rahipleri, bir ömür süren derin meditasyon pratikleriyle lucid rüyayı, zihinsel farkındalığı artırmaya yönelik bir içsel deneyim olarak ele aldılar.\n\nHimalayaların yüksek zirvelerinde, zihnin katmanlarını keşfeden rahipler, bilinçli rüya deneyimlerini zihinsel disiplin ve geleneksel pratiklerle destekledi.'**
  String get guideSlide2Content1;

  /// No description provided for @guideSlide2Content2.
  ///
  /// In tr, this message translates to:
  /// **'Günümüzde bazı nörolojik çalışmalarda, meditasyon pratikleri ile uyku farkındalığı arasındaki ilişki incelenmiştir.\n\nBu kadim geleneklerin ışığında hazırladığımız bu özel rehber, zihninizin derinliklerindeki bu potansiyeli uyandırmayı ve farkındalığınızı rüya alemine taşımayı hedefler. Rüyalarınızda bir izleyici olmaktan çıkıp, kendi iç dünyanızın bilinçli mimarı olma yolculuğuna şimdi başlayabilirsiniz.'**
  String get guideSlide2Content2;

  /// No description provided for @guideSlide3Title.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Kapanlarının Sırrı'**
  String get guideSlide3Title;

  /// No description provided for @guideSlide3Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bilinçli Rüyaların Koruyucusu'**
  String get guideSlide3Subtitle;

  /// No description provided for @guideSlide3Content1.
  ///
  /// In tr, this message translates to:
  /// **'Kızılderili kültürlerinde rüya kapanı, bilinçli rüyalarla ilişkilendirilen sembolik bir obje olarak görülürdü.\n\nNesilden nesile aktarılan bu pratik, rüya deneyimlerini temsil eden kültürel bir sembol olarak yorumlanırdı. Şamanların rehberliğinde, rüya kapanı bilinçli farkındalıkla ilişkilendirilen ve ruhani bağları simgeleyen bir sembol olarak değer gördü.'**
  String get guideSlide3Content1;

  /// No description provided for @guideSlide3Content2.
  ///
  /// In tr, this message translates to:
  /// **'Modern bilgi çağında lucid rüya sadece eski kültürlerin mistik bir deneyimi değil, modern bilimsel araştırmalarda üzerinde çalışılan bir bilinç deneyimi olarak ele alınmaktadır.\n\nEn güncel araştırmalar ve nesilden nesile aktarılan öğretileri derleyerek oluşturduğumuz bu lucid rüya rehberinde, zihinsel farkındalığınızı derinleştirerek farklı deneyimleri keşfetmeniz mümkün.'**
  String get guideSlide3Content2;

  /// No description provided for @guideSlide4Title.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get guideSlide4Title;

  /// No description provided for @guideSlide4Content.
  ///
  /// In tr, this message translates to:
  /// **'Bu rehber nasıl kullanılır?\n\nBu rehber 7 aşamalı özel bir lucid rüya sistemi üzerine kuruludur.\nHer aşamada rüya farkındalığını destekleyen güçlü alışkanlıklar geliştirirsin.'**
  String get guideSlide4Content;

  /// No description provided for @guideSlide4GainsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerledikçe Kazanacakların'**
  String get guideSlide4GainsTitle;

  /// No description provided for @guideSlide4Gain1.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarının derin katmanlarına erişirsin'**
  String get guideSlide4Gain1;

  /// No description provided for @guideSlide4Gain2.
  ///
  /// In tr, this message translates to:
  /// **'Bilincin rüyaya yön vermeye başlar'**
  String get guideSlide4Gain2;

  /// No description provided for @guideSlide4Gain3.
  ///
  /// In tr, this message translates to:
  /// **'Mekânlar ve kişiler sana göre şekil alır'**
  String get guideSlide4Gain3;

  /// No description provided for @guideSlide4Gain4.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların üzerinde daha fazla farkındalık kazanırsın.'**
  String get guideSlide4Gain4;

  /// No description provided for @guideSlide4ProRequired.
  ///
  /// In tr, this message translates to:
  /// **'Rehbere erişebilmek için PRO sürüme sahip olmalısın.'**
  String get guideSlide4ProRequired;

  /// No description provided for @guideSlide4UnlockButton.
  ///
  /// In tr, this message translates to:
  /// **'PRO Sürümünün Kilidini Aç'**
  String get guideSlide4UnlockButton;

  /// No description provided for @guideCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler! Tüm rehberi tamamladın.'**
  String get guideCompleted;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @actionFavorite.
  ///
  /// In tr, this message translates to:
  /// **'Favori'**
  String get actionFavorite;

  /// No description provided for @understand.
  ///
  /// In tr, this message translates to:
  /// **'Anladım, Devam Et'**
  String get understand;

  /// No description provided for @error.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @testNotification.
  ///
  /// In tr, this message translates to:
  /// **'Send Test Notification'**
  String get testNotification;

  /// No description provided for @testNotificationSent.
  ///
  /// In tr, this message translates to:
  /// **'Test notification sent!'**
  String get testNotificationSent;

  /// No description provided for @journalSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında ara...'**
  String get journalSearchHint;

  /// No description provided for @newDreamLoadingText.
  ///
  /// In tr, this message translates to:
  /// **'Rüya yorumun hazırlanıyor...'**
  String get newDreamLoadingText;

  /// No description provided for @dreamInterpretationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Yorumu'**
  String get dreamInterpretationTitle;

  /// No description provided for @dreamInterpretationReadMore.
  ///
  /// In tr, this message translates to:
  /// **'Devamını Oku'**
  String get dreamInterpretationReadMore;

  /// No description provided for @dreamTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Rüya çok kısa olduğundan yorumlanamadı.'**
  String get dreamTooShort;

  /// No description provided for @dreamGibberish.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanız yeterli anlam içermediği için yorumlanamadı.'**
  String get dreamGibberish;

  /// No description provided for @dailyLimitReached.
  ///
  /// In tr, this message translates to:
  /// **'Günlük rüya yorumlama limitine ulaştınız (100/100).'**
  String get dailyLimitReached;

  /// No description provided for @settingsRestorePurchases.
  ///
  /// In tr, this message translates to:
  /// **'Satın Alımları Geri Yükle'**
  String get settingsRestorePurchases;

  /// No description provided for @restoreSuccess.
  ///
  /// In tr, this message translates to:
  /// **'PRO sürümü başarıyla geri yüklendi!'**
  String get restoreSuccess;

  /// No description provided for @restoreNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Önceki satın alım bulunamadı.'**
  String get restoreNotFound;

  /// No description provided for @restoreError.
  ///
  /// In tr, this message translates to:
  /// **'Satın alımlar geri yüklenemedi. Lütfen tekrar deneyin.'**
  String get restoreError;

  /// No description provided for @restoreUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Mağaza şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.'**
  String get restoreUnavailable;

  /// No description provided for @restoring.
  ///
  /// In tr, this message translates to:
  /// **'Geri yükleniyor...'**
  String get restoring;

  /// No description provided for @offlineInterpretation.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı olmadığı için rüya yorumlanamadı.'**
  String get offlineInterpretation;

  /// No description provided for @offlinePurchase.
  ///
  /// In tr, this message translates to:
  /// **'Satın alma işlemi için internet bağlantısı gerekiyor.'**
  String get offlinePurchase;

  /// No description provided for @offlineAnalysis.
  ///
  /// In tr, this message translates to:
  /// **'Analiz için internet bağlantısı gerekiyor.'**
  String get offlineAnalysis;

  /// No description provided for @proUpgradeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik yok. Tek sefer satın alır, ömür boyu erişim sağlarsın.'**
  String get proUpgradeSubtitle;

  /// No description provided for @proFeatureAdsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız Deneyim'**
  String get proFeatureAdsTitle;

  /// No description provided for @proFeatureAdsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya yorumlamalarında reklam yok.\nSadece rüyalarına ve sana anlatmak istediklerine odaklan.'**
  String get proFeatureAdsSubtitle;

  /// No description provided for @proFeatureCosmicTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kozmik Bağlantıların Kilidini Aç'**
  String get proFeatureCosmicTitle;

  /// No description provided for @proFeatureCosmicSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya yorumlarına ek kozmik bağlantıları ortaya çıkarır.\nRüyalarını Ay evreleri ve gezegen etkileriyle birlikte yorumlar.'**
  String get proFeatureCosmicSubtitle;

  /// No description provided for @proFeatureAnalysisTitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Rüya Desen Analizi'**
  String get proFeatureAnalysisTitle;

  /// No description provided for @proFeatureAnalysisSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların arasındaki gizli bağlantıları ortaya çıkarır.\nTekrarlayan temaları, duyguları ve bilinçaltı mesajlarını zamanla keşfet.'**
  String get proFeatureAnalysisSubtitle;

  /// No description provided for @proFeatureGuideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get proFeatureGuideTitle;

  /// No description provided for @proFeatureGuideSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarının kontrolünü eline al.\nAdım adım rehberli lucid rüya teknikleri.'**
  String get proFeatureGuideSubtitle;

  /// No description provided for @proProcessing.
  ///
  /// In tr, this message translates to:
  /// **'İşleniyor...'**
  String get proProcessing;

  /// No description provided for @notifDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimlere İzin Ver'**
  String get notifDialogTitle;

  /// No description provided for @notifDialogBody.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat\'un her sabah rüyalarınızı kaydetmenizi hatırlatmasına izin verin.'**
  String get notifDialogBody;

  /// No description provided for @notifPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim İzni Reddedildi'**
  String get notifPermissionDenied;

  /// No description provided for @notifOpenSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları Aç'**
  String get notifOpenSettings;

  /// No description provided for @notifOpenSettingsHint.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri etkinleştirmek için ayarlardan izin vermeniz gerekiyor.'**
  String get notifOpenSettingsHint;

  /// No description provided for @allow.
  ///
  /// In tr, this message translates to:
  /// **'İzin Ver'**
  String get allow;

  /// No description provided for @notifReminderBody.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanızı kaydetmeyi unutmayın! 📝'**
  String get notifReminderBody;

  /// No description provided for @notifReminder1.
  ///
  /// In tr, this message translates to:
  /// **'Bu gece evren sana ne fısıldadı? ✨'**
  String get notifReminder1;

  /// No description provided for @notifReminder2.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların silinmeden onları yakala! 📓'**
  String get notifReminder2;

  /// No description provided for @notifReminder3.
  ///
  /// In tr, this message translates to:
  /// **'Bilinçaltın sana bir mesaj bıraktı... 🌙'**
  String get notifReminder3;

  /// No description provided for @notifReminder4.
  ///
  /// In tr, this message translates to:
  /// **'Gördüğün sembollerin anlamını merak etmiyor musun? 🔮'**
  String get notifReminder4;

  /// No description provided for @notifReminder5.
  ///
  /// In tr, this message translates to:
  /// **'Rüya günlüğün seni bekliyor ✍️'**
  String get notifReminder5;

  /// No description provided for @pressBackToExit.
  ///
  /// In tr, this message translates to:
  /// **'Çıkmak için tekrar geri tuşuna basın'**
  String get pressBackToExit;

  /// No description provided for @moonSyncTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Ay ve Gezegen Senkronizasyonu'**
  String get moonSyncTitle;

  /// No description provided for @moonSyncSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayda bir kez yapılabilir'**
  String get moonSyncSubtitle;

  /// No description provided for @moonSyncDescription.
  ///
  /// In tr, this message translates to:
  /// **'Ay ve Gezegen Senkronizasyonu, son bir ay içindeki rüyalarını gördüğün güne ait Ay evresi ve o dönemdeki kozmik olaylarla (Kanlı Ay, tutulmalar gibi) birlikte analiz eder. Rüyalarındaki duygu, yoğunluk ve ruh hâlini Ay döngüsüyle eşleştirerek, bu ay iç dünyan ile kozmik döngüler arasındaki uyumu ve belirli ay döngülerinde (dolunay, yarım ay gibi) nelere dikkat etmen gerektiğini gösterir. Ay\'ın döngüsüne odaklı olduğu için ayda bir kez oluşturulur.'**
  String get moonSyncDescription;

  /// No description provided for @moonSyncDescriptionShort.
  ///
  /// In tr, this message translates to:
  /// **'Kozmik olayları rüyalarınla birlikte yorumlar.\nBu ay seni nelerin etkilediğini öğren.'**
  String get moonSyncDescriptionShort;

  /// No description provided for @moonSyncBtn.
  ///
  /// In tr, this message translates to:
  /// **'Kozmik Analizi Başlat'**
  String get moonSyncBtn;

  /// No description provided for @moonSyncWait.
  ///
  /// In tr, this message translates to:
  /// **'Yeni analiz için {days} gün beklemelisiniz.'**
  String moonSyncWait(int days);

  /// No description provided for @moonSyncMinDreams.
  ///
  /// In tr, this message translates to:
  /// **'En Az 5 Kaydedilmiş Rüya Gerekir'**
  String get moonSyncMinDreams;

  /// No description provided for @moonSyncDone.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Kozmik Analiz Yapıldı'**
  String get moonSyncDone;

  /// No description provided for @moonSyncProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Kozmik Analiz hazırlanıyor, lütfen kısa bir süre bekleyin.'**
  String get moonSyncProcessing;

  /// No description provided for @moonPhaseNewMoon.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ay'**
  String get moonPhaseNewMoon;

  /// No description provided for @moonPhaseWaxingCrescent.
  ///
  /// In tr, this message translates to:
  /// **'Büyüyen Hilal'**
  String get moonPhaseWaxingCrescent;

  /// No description provided for @moonPhaseFirstQuarter.
  ///
  /// In tr, this message translates to:
  /// **'İlk Dördün'**
  String get moonPhaseFirstQuarter;

  /// No description provided for @moonPhaseWaxingGibbous.
  ///
  /// In tr, this message translates to:
  /// **'Büyüyen Şişkin Ay'**
  String get moonPhaseWaxingGibbous;

  /// No description provided for @moonPhaseFullMoon.
  ///
  /// In tr, this message translates to:
  /// **'Dolunay'**
  String get moonPhaseFullMoon;

  /// No description provided for @moonPhaseWaningGibbous.
  ///
  /// In tr, this message translates to:
  /// **'Küçülen Şişkin Ay'**
  String get moonPhaseWaningGibbous;

  /// No description provided for @moonPhaseThirdQuarter.
  ///
  /// In tr, this message translates to:
  /// **'Son Dördün'**
  String get moonPhaseThirdQuarter;

  /// No description provided for @moonPhaseWaningCrescent.
  ///
  /// In tr, this message translates to:
  /// **'Küçülen Hilal'**
  String get moonPhaseWaningCrescent;

  /// No description provided for @actionShareInterpretation.
  ///
  /// In tr, this message translates to:
  /// **'Yorumu Paylaş'**
  String get actionShareInterpretation;

  /// No description provided for @shareImage.
  ///
  /// In tr, this message translates to:
  /// **'Görseli\nPaylaş'**
  String get shareImage;

  /// No description provided for @sharePrivacyHint.
  ///
  /// In tr, this message translates to:
  /// **'Not: Yorumu paylaş butonu yalnızca rüya yorumunuzu paylaşır. Rüyalarınız size aittir ve herhangi bir şekilde üçüncü şahıslara gösterilmez.'**
  String get sharePrivacyHint;

  /// No description provided for @moonPhaseLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ay Evresi:'**
  String get moonPhaseLabel;

  /// No description provided for @readMore.
  ///
  /// In tr, this message translates to:
  /// **'Devamını Oku...'**
  String get readMore;

  /// No description provided for @tapForDetails.
  ///
  /// In tr, this message translates to:
  /// **'Detaylar için tıklayın...'**
  String get tapForDetails;

  /// No description provided for @nSelected.
  ///
  /// In tr, this message translates to:
  /// **'{count} Seçildi'**
  String nSelected(int count);

  /// No description provided for @shareCardHeader.
  ///
  /// In tr, this message translates to:
  /// **'GÜNLÜK RÜYA YORUMUM'**
  String get shareCardHeader;

  /// No description provided for @shareCardWatermark.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat App ile yorumlandı'**
  String get shareCardWatermark;

  /// No description provided for @subscriptionComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Abonelik sistemi çok yakında aktif olacak!'**
  String get subscriptionComingSoon;

  /// No description provided for @subscribeMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Abone Ol'**
  String get subscribeMonthly;

  /// No description provided for @subscribeYearly.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Abone Ol'**
  String get subscribeYearly;

  /// No description provided for @planMonthly.
  ///
  /// In tr, this message translates to:
  /// **'AYLIK'**
  String get planMonthly;

  /// No description provided for @planAnnual.
  ///
  /// In tr, this message translates to:
  /// **'YILLIK'**
  String get planAnnual;

  /// No description provided for @mostPopular.
  ///
  /// In tr, this message translates to:
  /// **'EN POPÜLER'**
  String get mostPopular;

  /// No description provided for @discountPercent.
  ///
  /// In tr, this message translates to:
  /// **'-%30 İNDİRİM'**
  String get discountPercent;

  /// No description provided for @subscribeNow.
  ///
  /// In tr, this message translates to:
  /// **'Abone Ol'**
  String get subscribeNow;

  /// No description provided for @billingMonthly.
  ///
  /// In tr, this message translates to:
  /// **'Aylık otomatik yenilenen abonelik.\nİstediğin zaman iptal edebilirsin.'**
  String get billingMonthly;

  /// No description provided for @billingAnnual.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık otomatik yenilenen abonelik.\nHer yıl bir kez faturalandırılır.'**
  String get billingAnnual;

  /// No description provided for @proFeatureAds.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız Deneyim'**
  String get proFeatureAds;

  /// No description provided for @proFeatureAnalysis.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Desen Analizi'**
  String get proFeatureAnalysis;

  /// No description provided for @proFeatureGuide.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get proFeatureGuide;

  /// No description provided for @proFeatureMoonSync.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Ay ve Gezegen Senkronizasyonu'**
  String get proFeatureMoonSync;

  /// No description provided for @freeTrialDays.
  ///
  /// In tr, this message translates to:
  /// **'Gün Ücretsiz Dene'**
  String get freeTrialDays;

  /// No description provided for @freeTrialBadge.
  ///
  /// In tr, this message translates to:
  /// **'İlk 7 gün ücretsiz dene'**
  String get freeTrialBadge;

  /// No description provided for @priceLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get priceLoading;

  /// No description provided for @priceLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat yüklenemedi'**
  String get priceLoadError;

  /// No description provided for @priceRetryButton.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get priceRetryButton;

  /// No description provided for @then.
  ///
  /// In tr, this message translates to:
  /// **'Sonra'**
  String get then;

  /// No description provided for @reviewSatisfactionTitle.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat\'u sevdin mi?'**
  String get reviewSatisfactionTitle;

  /// No description provided for @reviewSatisfactionContent.
  ///
  /// In tr, this message translates to:
  /// **'Deneyimini bizimle paylaş!'**
  String get reviewSatisfactionContent;

  /// No description provided for @reviewOptionYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet, bayıldım!'**
  String get reviewOptionYes;

  /// No description provided for @reviewOptionNeutral.
  ///
  /// In tr, this message translates to:
  /// **'Eh işte'**
  String get reviewOptionNeutral;

  /// No description provided for @reviewOptionNo.
  ///
  /// In tr, this message translates to:
  /// **'Hayır, sevmedim'**
  String get reviewOptionNo;

  /// No description provided for @reviewFeedbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görüşlerin önemli'**
  String get reviewFeedbackTitle;

  /// No description provided for @reviewFeedbackContent.
  ///
  /// In tr, this message translates to:
  /// **'Daha iyi bir deneyim için ne yapabiliriz? Bize yazmaktan çekinme.'**
  String get reviewFeedbackContent;

  /// No description provided for @reviewFeedbackButton.
  ///
  /// In tr, this message translates to:
  /// **'Bize Yaz'**
  String get reviewFeedbackButton;

  /// No description provided for @reviewCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get reviewCancel;

  /// No description provided for @adConsentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir rüya yorumu daha'**
  String get adConsentTitle;

  /// No description provided for @adConsentBody.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat’ta rüya yorumları ücretsiz sunulur. Bunu sürdürebilmek için her yorumdan önce kısa bir video gösterilir.'**
  String get adConsentBody;

  /// No description provided for @adConsentWatch.
  ///
  /// In tr, this message translates to:
  /// **'Reklam İzle ve Yorumu Al'**
  String get adConsentWatch;

  /// No description provided for @adConsentPro.
  ///
  /// In tr, this message translates to:
  /// **'PRO’ya Geç (Reklamsız)'**
  String get adConsentPro;

  /// No description provided for @adLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Şu anda reklam yüklenemedi. Biraz sonra tekrar deneyebilirsin veya PRO’ya geçebilirsin.'**
  String get adLoadError;

  /// No description provided for @adRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get adRetry;

  /// No description provided for @adSkipThisTime.
  ///
  /// In tr, this message translates to:
  /// **'Bu sefer reklamsız devam'**
  String get adSkipThisTime;

  /// No description provided for @intensityFeltLight.
  ///
  /// In tr, this message translates to:
  /// **'Hafif hissediliyor'**
  String get intensityFeltLight;

  /// No description provided for @intensityFeltMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta hissediliyor'**
  String get intensityFeltMedium;

  /// No description provided for @intensityFeltIntense.
  ///
  /// In tr, this message translates to:
  /// **'Yoğun hissediliyor'**
  String get intensityFeltIntense;

  /// No description provided for @statsDreamLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rüya'**
  String get statsDreamLabel;

  /// No description provided for @statsRecordedDreams.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilen rüya sayısı: {count}'**
  String statsRecordedDreams(Object count);

  /// No description provided for @settingsSupportId.
  ///
  /// In tr, this message translates to:
  /// **'Destek ID\'si'**
  String get settingsSupportId;

  /// No description provided for @settingsSupportIdCopied.
  ///
  /// In tr, this message translates to:
  /// **'ID kopyalandı! Destek ekibine bu kodu gönderebilirsiniz.'**
  String get settingsSupportIdCopied;

  /// No description provided for @guideIntentExerciseTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uyumadan önce birlikte tekrar edelim'**
  String get guideIntentExerciseTitle;

  /// No description provided for @guideIntentPhrase.
  ///
  /// In tr, this message translates to:
  /// **'Bir sonraki rüyamda rüya gördüğümü fark edeceğim.'**
  String get guideIntentPhrase;

  /// No description provided for @guideIntentRepeatButton.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarla'**
  String get guideIntentRepeatButton;

  /// No description provided for @guideIntentProgress.
  ///
  /// In tr, this message translates to:
  /// **'{count} / 10 tekrar'**
  String guideIntentProgress(Object count);

  /// No description provided for @guideIntentComplete.
  ///
  /// In tr, this message translates to:
  /// **'Hazırsın! Şimdi bu niyetle uyuyabilirsin. 🌙'**
  String get guideIntentComplete;

  /// No description provided for @wildBreathTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nefes ve Gevşeme Modu'**
  String get wildBreathTitle;

  /// No description provided for @wildBreathStart.
  ///
  /// In tr, this message translates to:
  /// **'Nefes ve Gevşeme Modunu Başlat'**
  String get wildBreathStart;

  /// No description provided for @wildBreathInhale.
  ///
  /// In tr, this message translates to:
  /// **'Nefes Al'**
  String get wildBreathInhale;

  /// No description provided for @wildBreathHold.
  ///
  /// In tr, this message translates to:
  /// **'Tut'**
  String get wildBreathHold;

  /// No description provided for @wildBreathExhale.
  ///
  /// In tr, this message translates to:
  /// **'Ver'**
  String get wildBreathExhale;

  /// No description provided for @wildBreathFocus.
  ///
  /// In tr, this message translates to:
  /// **'Sadece nefesine odaklan'**
  String get wildBreathFocus;

  /// No description provided for @wildBreathTapToExit.
  ///
  /// In tr, this message translates to:
  /// **'Çıkmak için dokun'**
  String get wildBreathTapToExit;

  /// No description provided for @wbtbDreamsTitle.
  ///
  /// In tr, this message translates to:
  /// **'WBTB Sonrası Rüyaların'**
  String get wbtbDreamsTitle;

  /// No description provided for @wbtbDreamsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu aşamayı uyguladığın gecelerde kaydettiğin rüyaları burada inceleyebilirsin.'**
  String get wbtbDreamsDesc;

  /// No description provided for @wbtbDreamsButton.
  ///
  /// In tr, this message translates to:
  /// **'WBTB Rüyalarını Gör'**
  String get wbtbDreamsButton;

  /// No description provided for @wbtbNoDreamsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bu aşamaya ait rüya yok'**
  String get wbtbNoDreamsTitle;

  /// No description provided for @wbtbNoDreamsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu tekniği uyguladıktan sonra rüyalarını kaydet ve burada analiz et.'**
  String get wbtbNoDreamsDesc;

  /// No description provided for @wbtbAddFirstDream.
  ///
  /// In tr, this message translates to:
  /// **'İlk Rüyamı Ekle'**
  String get wbtbAddFirstDream;

  /// No description provided for @timeAwarenessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gerçeklik Kontrolleri Egzersizi'**
  String get timeAwarenessTitle;

  /// No description provided for @timeAwarenessInstruction.
  ///
  /// In tr, this message translates to:
  /// **'Uyumadan önce sesli cevapla'**
  String get timeAwarenessInstruction;

  /// No description provided for @timeAwarenessQ1.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün tarihi ne?'**
  String get timeAwarenessQ1;

  /// No description provided for @timeAwarenessQ2.
  ///
  /// In tr, this message translates to:
  /// **'Haftanın hangi günündeyiz?'**
  String get timeAwarenessQ2;

  /// No description provided for @timeAwarenessQ3.
  ///
  /// In tr, this message translates to:
  /// **'REMOVED'**
  String get timeAwarenessQ3;

  /// No description provided for @timeAwarenessQ4.
  ///
  /// In tr, this message translates to:
  /// **'Saat tam olarak kaç?'**
  String get timeAwarenessQ4;

  /// No description provided for @timeAwarenessQ5.
  ///
  /// In tr, this message translates to:
  /// **'Etrafına bak ve 3 farklı nesne say.'**
  String get timeAwarenessQ5;

  /// No description provided for @timeAwarenessQ6.
  ///
  /// In tr, this message translates to:
  /// **'Üzerinde ne renk kıyafet var?'**
  String get timeAwarenessQ6;

  /// No description provided for @timeAwarenessQ11.
  ///
  /// In tr, this message translates to:
  /// **'Şu an hangi sesleri duyuyorsun?'**
  String get timeAwarenessQ11;

  /// No description provided for @timeAwarenessQ7.
  ///
  /// In tr, this message translates to:
  /// **'Bugün ilk konuştuğun kişi kimdi?'**
  String get timeAwarenessQ7;

  /// No description provided for @timeAwarenessQ8.
  ///
  /// In tr, this message translates to:
  /// **'Ellerine bak ve parmaklarını say.'**
  String get timeAwarenessQ8;

  /// No description provided for @timeAwarenessQ9.
  ///
  /// In tr, this message translates to:
  /// **'Nefes al ve \'Rüya görüyor muyum?\' diye sor.'**
  String get timeAwarenessQ9;

  /// No description provided for @timeAwarenessQ10.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi gözlerini kapat ve uyuduğunu hayal et.'**
  String get timeAwarenessQ10;

  /// No description provided for @stage5Task1.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Günlüğü Tuttum'**
  String get stage5Task1;

  /// No description provided for @stage5Task2.
  ///
  /// In tr, this message translates to:
  /// **'Rüyamda Farkındalık Sinyali Yaşadım'**
  String get stage5Task2;

  /// No description provided for @stage5Hint.
  ///
  /// In tr, this message translates to:
  /// **'Şartları sağladıkça yıldızlara tıklayarak görevleri gerçekleştirebilirsin. Tüm görevler tamamlandığında ilerlemenin kilidi açılır.'**
  String get stage5Hint;

  /// No description provided for @stage6Task1.
  ///
  /// In tr, this message translates to:
  /// **'Rüyamı bilinçli bir şekilde manipüle edebildim'**
  String get stage6Task1;

  /// No description provided for @stage6Hint.
  ///
  /// In tr, this message translates to:
  /// **'Şartları sağladıkça yıldızlara tıkla. 3 yıldız işaretlendiğinde ilerlemenin kilidi açılır.'**
  String get stage6Hint;

  /// No description provided for @guideCriteriaNotMet.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemek için bu aşamanın şartlarını tamamlamalısın.'**
  String get guideCriteriaNotMet;

  /// No description provided for @rateLimitWait.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla istek gönderildi. Lütfen {minutes} dakika sonra tekrar deneyin.'**
  String rateLimitWait(int minutes);

  /// No description provided for @analysisStep1.
  ///
  /// In tr, this message translates to:
  /// **'Rüya sembolleri taranıyor...'**
  String get analysisStep1;

  /// No description provided for @analysisStep2.
  ///
  /// In tr, this message translates to:
  /// **'Bilinçaltı haritası çıkarılıyor...'**
  String get analysisStep2;

  /// No description provided for @analysisStep3.
  ///
  /// In tr, this message translates to:
  /// **'Arketipsel bağlantılar kuruluyor...'**
  String get analysisStep3;

  /// No description provided for @analysisStep4.
  ///
  /// In tr, this message translates to:
  /// **'Psikolojik derinlik çözümleniyor...'**
  String get analysisStep4;

  /// No description provided for @analysisStep5.
  ///
  /// In tr, this message translates to:
  /// **'Yorum hazırlanıyor...'**
  String get analysisStep5;

  /// No description provided for @analysisLongWait.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanız detaylı inceleniyor...'**
  String get analysisLongWait;

  /// No description provided for @newDreamSaveShort.
  ///
  /// In tr, this message translates to:
  /// **'Rüyayı Kaydet'**
  String get newDreamSaveShort;

  /// No description provided for @supportTechInfoNote.
  ///
  /// In tr, this message translates to:
  /// **'Aşağıdaki teknik bilgiler, sorununuzu daha hızlı çözmemize yardımcı olur. Lütfen silmeyiniz.'**
  String get supportTechInfoNote;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir rüya görmemiş olabilirsin'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu sırada senin genel rüya profilini çıkaralım.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @surveyQ1.
  ///
  /// In tr, this message translates to:
  /// **'Genelde rüyalarını ne sıklıkla hatırlarsın?'**
  String get surveyQ1;

  /// No description provided for @surveyQ1Option1.
  ///
  /// In tr, this message translates to:
  /// **'Hiç'**
  String get surveyQ1Option1;

  /// No description provided for @surveyQ1Option2.
  ///
  /// In tr, this message translates to:
  /// **'Ayda 1–2'**
  String get surveyQ1Option2;

  /// No description provided for @surveyQ1Option3.
  ///
  /// In tr, this message translates to:
  /// **'Haftada 1–2'**
  String get surveyQ1Option3;

  /// No description provided for @surveyQ1Option4.
  ///
  /// In tr, this message translates to:
  /// **'Neredeyse her gün'**
  String get surveyQ1Option4;

  /// No description provided for @surveyQ2.
  ///
  /// In tr, this message translates to:
  /// **'Uyku düzenini en iyi hangisi tanımlar?'**
  String get surveyQ2;

  /// No description provided for @surveyQ2Option1.
  ///
  /// In tr, this message translates to:
  /// **'Çok düzensiz'**
  String get surveyQ2Option1;

  /// No description provided for @surveyQ2Option2.
  ///
  /// In tr, this message translates to:
  /// **'Biraz düzensiz'**
  String get surveyQ2Option2;

  /// No description provided for @surveyQ2Option3.
  ///
  /// In tr, this message translates to:
  /// **'Genelde düzenli'**
  String get surveyQ2Option3;

  /// No description provided for @surveyQ2Option4.
  ///
  /// In tr, this message translates to:
  /// **'Çok düzenli'**
  String get surveyQ2Option4;

  /// No description provided for @surveyQ3.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarının tonu genelde nasıl?'**
  String get surveyQ3;

  /// No description provided for @surveyQ3Option1.
  ///
  /// In tr, this message translates to:
  /// **'Huzurlu'**
  String get surveyQ3Option1;

  /// No description provided for @surveyQ3Option2.
  ///
  /// In tr, this message translates to:
  /// **'Karışık'**
  String get surveyQ3Option2;

  /// No description provided for @surveyQ3Option3.
  ///
  /// In tr, this message translates to:
  /// **'Gergin'**
  String get surveyQ3Option3;

  /// No description provided for @surveyQ3Option4.
  ///
  /// In tr, this message translates to:
  /// **'Korkutucu'**
  String get surveyQ3Option4;

  /// No description provided for @surveyQ4.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında kendini daha çok nasıl hissedersin?'**
  String get surveyQ4;

  /// No description provided for @surveyQ4Option1.
  ///
  /// In tr, this message translates to:
  /// **'Kontrolde'**
  String get surveyQ4Option1;

  /// No description provided for @surveyQ4Option2.
  ///
  /// In tr, this message translates to:
  /// **'İzleyici gibi'**
  String get surveyQ4Option2;

  /// No description provided for @surveyQ4Option3.
  ///
  /// In tr, this message translates to:
  /// **'Kaçıyor gibi'**
  String get surveyQ4Option3;

  /// No description provided for @surveyQ4Option4.
  ///
  /// In tr, this message translates to:
  /// **'Keşfediyor gibi'**
  String get surveyQ4Option4;

  /// No description provided for @profile1Name.
  ///
  /// In tr, this message translates to:
  /// **'Hayalci Gezgin'**
  String get profile1Name;

  /// No description provided for @profile1Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında keşif, anlam arayışı ve duygusal farkındalık öne çıkıyor.\n\nBilinçaltın sana sık sık sembollerle konuşuyor. Hayatındaki küçük detayların aslında büyük anlamlar taşıdığını hissediyorsun.\n\nRüyalarını kaydettikçe iç dünyanı daha net görmeye başlayacaksın.'**
  String get profile1Desc;

  /// No description provided for @profile2Name.
  ///
  /// In tr, this message translates to:
  /// **'Sessiz Gözlemci'**
  String get profile2Name;

  /// No description provided for @profile2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında olayların içindesin ama kontrol sende değil gibi hissediyorsun.\n\nBilinçaltın yaşadıklarını sindirmeye çalışıyor. Günlük hayattaki düşüncelerin rüyalarına yumuşak geçişlerle sızıyor.\n\nRüyalarını yazmak, zihninin yükünü hafifletebilir.'**
  String get profile2Desc;

  /// No description provided for @profile3Name.
  ///
  /// In tr, this message translates to:
  /// **'Duygusal Kaşif'**
  String get profile3Name;

  /// No description provided for @profile3Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların yoğun, detaylı ve duygusal olarak güçlü.\n\nBilinçaltın sana kendini tanıman için sahneler sunuyor. İç dünyanla güçlü bir bağın var.\n\nRüyalarını takip etmek sana ciddi içgörüler kazandırabilir.'**
  String get profile3Desc;

  /// No description provided for @profile4Name.
  ///
  /// In tr, this message translates to:
  /// **'Zihinsel Savaşçı'**
  String get profile4Name;

  /// No description provided for @profile4Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında baskı, kaçış ve mücadele temaları öne çıkıyor.\n\nGünlük streslerin rüyalarına yansıyor olabilir. Bilinçaltın sana “yavaşla” sinyali veriyor.\n\nRüyalarını yazmak zihinsel rahatlama sağlayabilir.'**
  String get profile4Desc;

  /// No description provided for @profile5Name.
  ///
  /// In tr, this message translates to:
  /// **'Kontrolcü Mimar'**
  String get profile5Name;

  /// No description provided for @profile5Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında yön duygusu ve bilinç hâkimiyeti var.\n\nHayatında da planlı, düzenli ve farkında bir yapın olabilir. Rüyalar senin için bir oyun alanı gibi çalışıyor.\n\nLucid rüya potansiyelin yüksek.'**
  String get profile5Desc;

  /// No description provided for @profile6Name.
  ///
  /// In tr, this message translates to:
  /// **'Derin Dalgıç'**
  String get profile6Name;

  /// No description provided for @profile6Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların yoğun ve bazen rahatsız edici olabilir.\n\nBilinçaltın bastırılmış duyguları sahneye çıkarıyor. Bu kötü bir şey değil; bir temizlik süreci gibi düşün.\n\nRüyalarını yazmak içsel yüklerini hafifletebilir.'**
  String get profile6Desc;

  /// No description provided for @profile7Name.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Gezgini'**
  String get profile7Name;

  /// No description provided for @profile7Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarında sakinlik ve akış hâli var.\n\nHayatı biraz uzaktan izleyen, duygularını derin yaşayan bir yapın olabilir. Rüyalar senin için zihinsel dinlenme alanı gibi çalışıyor.\n\nRüya günlüğü seni daha da güçlendirir.'**
  String get profile7Desc;

  /// No description provided for @profile8Name.
  ///
  /// In tr, this message translates to:
  /// **'Bilinç Eşiği Yolcusu'**
  String get profile8Name;

  /// No description provided for @profile8Desc.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların çok canlı ama bazen yorucu.\n\nBilinç ile bilinçaltı arasında gidip geliyorsun. Lucid rüyaya en yakın profillerden birisin.\n\nBiraz dengeyle rüyalarını bilinçli yönetebilirsin.'**
  String get profile8Desc;

  /// No description provided for @surveyDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Bu analiz bilimsel veya tıbbi bir değerlendirme değildir.\nSadece eğlence ve farkındalık amaçlıdır.'**
  String get surveyDisclaimer;

  /// No description provided for @surveyResultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Profilin'**
  String get surveyResultTitle;

  /// No description provided for @surveyContinue.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat\'a Başla'**
  String get surveyContinue;

  /// No description provided for @welcomeHeader.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat\'a Hoşgeldin'**
  String get welcomeHeader;

  /// No description provided for @stepProgress.
  ///
  /// In tr, this message translates to:
  /// **'Adım {current} / {total}'**
  String stepProgress(Object current, Object total);

  /// No description provided for @emailLabelSupportId.
  ///
  /// In tr, this message translates to:
  /// **'Destek Kimliği (User ID)'**
  String get emailLabelSupportId;

  /// No description provided for @emailLabelAppVersion.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Sürümü'**
  String get emailLabelAppVersion;

  /// No description provided for @emailLabelPlatform.
  ///
  /// In tr, this message translates to:
  /// **'Platform'**
  String get emailLabelPlatform;

  /// No description provided for @emailLabelLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get emailLabelLanguage;

  /// No description provided for @biometricLockTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Günlüğünü Kilitlemek İster misin?'**
  String get biometricLockTitle;

  /// No description provided for @biometricLockMessage.
  ///
  /// In tr, this message translates to:
  /// **'Rüyaların çok kişisel olabilir.\nİstersen Rüya Günlüğü\'nü parmak izi / Face ID ile koruyabilirsin.'**
  String get biometricLockMessage;

  /// No description provided for @biometricLockYes.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Koru'**
  String get biometricLockYes;

  /// No description provided for @biometricLockNo.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik Hayır'**
  String get biometricLockNo;

  /// No description provided for @biometricLockReason.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Günlüğü\'ne erişmek için doğrula'**
  String get biometricLockReason;

  /// No description provided for @biometricLockSettingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Günlüğü Kilidi'**
  String get biometricLockSettingsTitle;

  /// No description provided for @biometricLockSettingsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Parmak izi / Face ID ile koru'**
  String get biometricLockSettingsSubtitle;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In tr, this message translates to:
  /// **'Cihazınızda biyometrik özellik bulunamadı. Ayarlar > Güvenlik kısmından biyometrik verinizi ekleyebilirsiniz.'**
  String get biometricNotAvailable;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama başarısız'**
  String get biometricAuthFailed;

  /// No description provided for @offlineSaveTitle.
  ///
  /// In tr, this message translates to:
  /// **'İnternet Bağlantısı Yok'**
  String get offlineSaveTitle;

  /// No description provided for @offlineSaveContent.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanızı günlüğe kaydedebilirsiniz fakat şu an internet olmadığı için yorumlanamaz.'**
  String get offlineSaveContent;

  /// No description provided for @offlineSaveConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Yorumsuz Kaydet'**
  String get offlineSaveConfirm;

  /// No description provided for @offlineSaveCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get offlineSaveCancel;

  /// No description provided for @errorNoInternet.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı yok.'**
  String get errorNoInternet;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmedik bir hata oluştu.'**
  String get errorGeneric;

  /// No description provided for @dreamSavedNoInterpretation.
  ///
  /// In tr, this message translates to:
  /// **'Rüya günlüğe kaydedildi.'**
  String get dreamSavedNoInterpretation;

  /// No description provided for @watchAdForInterpretation.
  ///
  /// In tr, this message translates to:
  /// **'AI yorumu için PRO\'ya geç veya reklam izle.'**
  String get watchAdForInterpretation;

  /// No description provided for @interpretationSkipped.
  ///
  /// In tr, this message translates to:
  /// **'Reklam izlenmediği için rüya yorumsuz kaydedildi.'**
  String get interpretationSkipped;

  /// No description provided for @weeklyLimitLeft.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta {count} ücretsiz rüya yorumu hakkın kaldı'**
  String weeklyLimitLeft(int count);

  /// No description provided for @specialOffer.
  ///
  /// In tr, this message translates to:
  /// **'🔥 ÖZEL TEKLİF'**
  String get specialOffer;

  /// No description provided for @welcomeOfferFirstTime.
  ///
  /// In tr, this message translates to:
  /// **'İlk abone özel teklifi'**
  String get welcomeOfferFirstTime;

  /// No description provided for @welcomeOfferExpires.
  ///
  /// In tr, this message translates to:
  /// **'Teklifin bitmesine: {time}'**
  String welcomeOfferExpires(String time);

  /// No description provided for @streakDays.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün üst üste'**
  String streakDays(int count);

  /// No description provided for @streakSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüya yolculuğun devam ediyor'**
  String get streakSubtitle;

  /// No description provided for @proFeatureImageGenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Rüya Görseli Oluştur'**
  String get proFeatureImageGenTitle;

  /// No description provided for @proFeatureImageGenSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarını büyüleyici bir sanata dönüştürür. \nHer gün bir rüyanı canlandırabilirsin.'**
  String get proFeatureImageGenSubtitle;

  /// No description provided for @visualizeDream.
  ///
  /// In tr, this message translates to:
  /// **'Rüyayı Görselleştir'**
  String get visualizeDream;

  /// No description provided for @visualizingDream.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka rüyanı eşsiz bir sanat eserine dönüştürüyor... Bu işlem yaklaşık 30-45 saniye sürebilir.'**
  String get visualizingDream;

  /// No description provided for @imageGenLimitReached.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Limit Doldu'**
  String get imageGenLimitReached;

  /// No description provided for @imageGenLimitDesc.
  ///
  /// In tr, this message translates to:
  /// **'Günde 1 rüya görseli oluşturabilirsin. Yarın görüşürüz!'**
  String get imageGenLimitDesc;

  /// No description provided for @imageGenLimitTrial.
  ///
  /// In tr, this message translates to:
  /// **'Deneme Sürümü Limiti'**
  String get imageGenLimitTrial;

  /// No description provided for @imageGenLimitTrialDesc.
  ///
  /// In tr, this message translates to:
  /// **'Deneme süresi 1 ücretsiz görsel içerir. Her gün görsel için PRO\'ya geç.'**
  String get imageGenLimitTrialDesc;

  /// No description provided for @shareVisualizedBy.
  ///
  /// In tr, this message translates to:
  /// **'DreamBoat app ile Görselleştirildi'**
  String get shareVisualizedBy;

  /// No description provided for @shareVisualSubject.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Görselleştirmem'**
  String get shareVisualSubject;

  /// No description provided for @offlineImageGenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Hatası'**
  String get offlineImageGenTitle;

  /// No description provided for @offlineImageGenContent.
  ///
  /// In tr, this message translates to:
  /// **'Görsel oluşturulamadı. İnternet bağlantını kontrol et. Limitinden düşülmedi.'**
  String get offlineImageGenContent;

  /// No description provided for @limitReachedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Limit Doldu'**
  String get limitReachedTitle;

  /// No description provided for @trialImageLimitReached.
  ///
  /// In tr, this message translates to:
  /// **'Deneme sürümündeki ücretsiz görselleştirme hakkınızı kullandınız. Trial sona erdiğinde PRO ile her gün yeni görsel oluşturabilirsiniz.'**
  String get trialImageLimitReached;

  /// No description provided for @dailyImageLimitReached.
  ///
  /// In tr, this message translates to:
  /// **'Günlük görselleştirme hakkını kullandın. Yeni bir görsel için yarın tekrar gel!'**
  String get dailyImageLimitReached;

  /// No description provided for @visualizeDreamSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka ile rüyandan ilham alınan bir tablo.'**
  String get visualizeDreamSubtitle;

  /// No description provided for @cosmicConnectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kozmik Bağlantı'**
  String get cosmicConnectionTitle;

  /// No description provided for @unlockProConnection.
  ///
  /// In tr, this message translates to:
  /// **'Kilidi Aç'**
  String get unlockProConnection;

  /// No description provided for @dreamMoonPhasePrefix.
  ///
  /// In tr, this message translates to:
  /// **'(Rüyanızı Gördüğünüz Ay Evresi: {phase})'**
  String dreamMoonPhasePrefix(Object phase);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'pt', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
