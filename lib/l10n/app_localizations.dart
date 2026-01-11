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

  /// No description provided for @statsAnalysisIntroContent.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Desen Analizi, haftalık olarak kaydettiğin rüyaları bir arada inceleyerek bilinçaltının tekrar eden temalarını, duygusal döngülerini ve sembolik eğilimlerini ortaya çıkarır. Bu sistem, tek tek rüya yorumlarından farklı olarak zaman içinde oluşan kalıpları, yani zihninin sana anlatmaya çalıştığı büyük resmi gösterir.'**
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
  /// **'Yeterli veri yok'**
  String get statsNoData;

  /// No description provided for @statsProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Rüya Deseniniz hazırlanıyor,\nlütfen kısa bir süre bekleyiniz.'**
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
  /// **'Sürüm 1.0.0'**
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
  /// **'Lucid Rüya Rehberinin tüm aşamalarını tamamladın.'**
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
  /// **'Artık zihinsel niyetini oluşturdun. Şimdi, rüyaların en yoğun yaşandığı REM evresine, bilinçli bir şekilde yeniden giriş yapmayı öğreneceğiz. WBTB tekniği, yarı uyanıklık halinde yeniden uykuya dalmanı sağlayarak lucid dream potansiyelini ciddi oranda artırır.'**
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
  /// **'Lucid dreaming\'in en etkileyici tekniklerinden biri olan WILD, seni doğrudan bilinçli şekilde rüya alemine taşır. Uyumadan önce zihnin uyanık kalırken bedenin uyumasına izin verirsin ve rüyaya gözlerini bile kırpmadan geçiş yaparsın.'**
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
  /// **'Artık zihnin lucid dreaming ile tanıştı. Bu aşamada rüya pratiğinden bir adım geri çekiliyor ve zihinsel kimyanı düzenleyerek lucid rüyaların kalitesini artıracak ortamı hazırlıyoruz.'**
  String get guideStage6Content;

  /// No description provided for @guideStage6Importance.
  ///
  /// In tr, this message translates to:
  /// **'Dopamin; motivasyon, hayal gücü ve ödül sisteminin merkezidir. Aşırı uyaranlar bu dengeyi bozar ve rüya netliğini düşürür.'**
  String get guideStage6Importance;

  /// No description provided for @guideStage6Steps.
  ///
  /// In tr, this message translates to:
  /// **'5 gün boyunca sosyal medya süreni 1 saatle sınırla.\nHafif egzersiz, yürüyüş ve güneş ışığı al.\nOmega-3 açısından zengin, şekerden uzak beslen.\nUyku öncesi odak egzersizleri yap.'**
  String get guideStage6Steps;

  /// No description provided for @guideStage6Criteria.
  ///
  /// In tr, this message translates to:
  /// **'1 hafta içinde 2 lucid rüyada bilinçli şekilde ortamı, ışığı veya bir objeyi yönettiysen son aşamaya geçebilirsin.'**
  String get guideStage6Criteria;

  /// No description provided for @guideStage6BrainNote.
  ///
  /// In tr, this message translates to:
  /// **'Artık zihnini sadece eğitmedin, onun biyolojik yapısını da optimize ettin. Şimdi bilinçli rüyalar sadece mümkün değil; senin doğan haline dönüşüyor.'**
  String get guideStage6BrainNote;

  /// No description provided for @guideStage7Title.
  ///
  /// In tr, this message translates to:
  /// **'7. İleri Bilinç ve Yaratıcı Manipülasyon'**
  String get guideStage7Title;

  /// No description provided for @guideStage7Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyanın Efendisi Olmak'**
  String get guideStage7Subtitle;

  /// No description provided for @guideStage7Content.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuğun sonuna geldik. Bu noktada artık sadece lucid olmakla kalmayacak, rüya içeriğini bilinçli şekilde değiştirecek seviyeye ulaşacaksın. Rüya dünyanı özgürce yaratma zamanı geldi.'**
  String get guideStage7Content;

  /// No description provided for @guideStage7Importance.
  ///
  /// In tr, this message translates to:
  /// **'Bu teknikle bilinçaltına erişebilir, korkularla yüzleşebilir, hayal ettiğin her şeyi test edebilirsin. Bu, hem zihinsel hem ruhsal bir devrimdir.'**
  String get guideStage7Importance;

  /// No description provided for @guideStage7Steps.
  ///
  /// In tr, this message translates to:
  /// **'Rüyada yapmak istediğin senaryoyu detaylıca yaz ve hayal et.\nRüyada bilinçli olarak mekanı, zamanı, karakteri veya sonucu değiştir.\nFarkındalık meditasyonlarını gündelik rutine ekle.'**
  String get guideStage7Steps;

  /// No description provided for @guideStage7Criteria.
  ///
  /// In tr, this message translates to:
  /// **'2 hafta içinde en az 2 rüyada aktif manipülasyon yaptıysan (uçmak, ortamı değiştirmek, bir şeyi çağırmak), lucid dreaming ustasısın.'**
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
  /// **'PRO Versiyon ve En Az 5 Kaydedilmiş Rüya Gerekir'**
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
  /// **'İlerlemek İstediğine Emin Misin?'**
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
  /// **'NovaBloom Studio olarak gizliliğinize en üst düzeyde önem veriyoruz. DreamBoat, rüyalarınızı güvenle kaydetmeniz ve analiz etmeniz için tasarlanmıştır.'**
  String get privacyNoticeContent;

  /// No description provided for @privacySection1Title.
  ///
  /// In tr, this message translates to:
  /// **'1. Veri Güvenliği ve İşleme:'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarınız şifrelenmiş olarak saklanır. Yapay zeka analizleri için gönderilen veriler anonimleştirilir ve asla AI modellerinin eğitimi için kullanılmaz. Verileriniz KVKK ve GDPR standartlarına uygun olarak korunur.'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In tr, this message translates to:
  /// **'2. Hesap ve Kullanım:'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama tamamen anonim olarak kullanılır ve herhangi bir üyelik gerektirmez. Kişisel verileriniz ve rüya kayıtlarınız sadece cihazınızda saklanır. Herhangi bir hesap oluşturma işlemi veya kişisel veri toplama süreci bulunmamaktadır.'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In tr, this message translates to:
  /// **'3. İletişim:'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In tr, this message translates to:
  /// **'Her türlü soru, öneri ve veri talepleriniz için info@novabloomstudio.com adresi üzerinden bizimle iletişime geçebilirsiniz.'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In tr, this message translates to:
  /// **'4. Sağlık ve Tıbbi Feragat (ÖNEMLİ):'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama tıbbi bir cihaz değildir. Sunulan rüya yorumları ve analizler tamamen eğlence ve kişisel gelişim amaçlıdır, tıbbi tavsiye niteliği taşımaz. Uygulamamız herhangi bir biyometrik veya sağlık verisi toplamaz ve işlemez.'**
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
  /// **'Sadece rüyalarınıza ve rüya dünyanıza odaklanın.'**
  String get proFeatureAdsSubtitle;

  /// No description provided for @proFeatureAnalysisTitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Rüya Desen Analizi'**
  String get proFeatureAnalysisTitle;

  /// No description provided for @proFeatureAnalysisSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarınız arasındaki gizli bağlantıları ortaya çıkarın. Tekrarlayan temaları, duyguları ve bilinçaltı mesajlarını zamanla keşfedin.'**
  String get proFeatureAnalysisSubtitle;

  /// No description provided for @proFeatureGuideTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lucid Rüya Rehberi'**
  String get proFeatureGuideTitle;

  /// No description provided for @proFeatureGuideSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rüyalarınızın kontrolünü elinize alın. Sıfırdan ileri seviyeye, adım adım rehberli lucid rüya teknikleri.'**
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
  /// **'Rüyanızı kaydetmeyi unutmayın! 🌙'**
  String get notifReminderBody;

  /// No description provided for @pressBackToExit.
  ///
  /// In tr, this message translates to:
  /// **'Çıkmak için tekrar geri tuşuna basın'**
  String get pressBackToExit;

  /// No description provided for @moonSyncTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ay ve Gezegen Senkronizasyonu'**
  String get moonSyncTitle;

  /// No description provided for @moonSyncDescription.
  ///
  /// In tr, this message translates to:
  /// **'Ay ve Gezegen Senkronizasyonu, rüyalarını gördüğün günkü Ayın evresiyle birlikte analiz ederek bilinçaltındaki duygusal dalgalanmaları Ayın evrelerine göre yorumlar. Rüyalarının kelime yoğunluğunu, duygusal tonunu ve seçtiğin ruh hâli etiketlerini Ay\'ın döngüsüyle eşleştirir. Bu sayede rüyalarının yalnızca içeriğine değil, Ay ve Gezegen düzeninin senin üzerindeki etkisini de anlarsın.'**
  String get moonSyncDescription;

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
  /// **'Kozmik Analiz hazırlanıyor,\nlütfen bekleyiniz.'**
  String get moonSyncProcessing;

  /// No description provided for @moonPhaseNewMoon.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ay'**
  String get moonPhaseNewMoon;

  /// No description provided for @moonPhaseWaxingCrescent.
  ///
  /// In tr, this message translates to:
  /// **'Hilal (Büyüyen)'**
  String get moonPhaseWaxingCrescent;

  /// No description provided for @moonPhaseFirstQuarter.
  ///
  /// In tr, this message translates to:
  /// **'İlk Dördün'**
  String get moonPhaseFirstQuarter;

  /// No description provided for @moonPhaseWaxingGibbous.
  ///
  /// In tr, this message translates to:
  /// **'Şişkin Ay (Büyüyen)'**
  String get moonPhaseWaxingGibbous;

  /// No description provided for @moonPhaseFullMoon.
  ///
  /// In tr, this message translates to:
  /// **'Dolunay'**
  String get moonPhaseFullMoon;

  /// No description provided for @moonPhaseWaningGibbous.
  ///
  /// In tr, this message translates to:
  /// **'Şişkin Ay (Küçülen)'**
  String get moonPhaseWaningGibbous;

  /// No description provided for @moonPhaseThirdQuarter.
  ///
  /// In tr, this message translates to:
  /// **'Son Dördün'**
  String get moonPhaseThirdQuarter;

  /// No description provided for @moonPhaseWaningCrescent.
  ///
  /// In tr, this message translates to:
  /// **'Hilal (Küçülen)'**
  String get moonPhaseWaningCrescent;

  /// No description provided for @actionShareInterpretation.
  ///
  /// In tr, this message translates to:
  /// **'Yorumu\nPaylaş'**
  String get actionShareInterpretation;

  /// No description provided for @sharePrivacyHint.
  ///
  /// In tr, this message translates to:
  /// **'Not: Paylaş butonu yalnızca rüya yorumunuzu paylaşır. Rüyalarınız size aittir ve herhangi bir şekilde üçüncü şahıslara gösterilmez.'**
  String get sharePrivacyHint;
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
