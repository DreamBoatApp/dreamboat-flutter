// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get homeTitle => 'DreamBoat';

  @override
  String get homeSubtitle => 'Rüya Dünyanızda Bir Yolculuğa Çıkın';

  @override
  String get homeNewDream => 'Yeni Rüya Ekle';

  @override
  String get homeJournal => 'Rüya Günlüğüm';

  @override
  String get homeStats => 'Rüya Dünyam';

  @override
  String get homeGuide => 'Lucid Rüya Rehberi';

  @override
  String get homeSettings => 'Ayarlar';

  @override
  String get statsTitle => 'Rüya Dünyam';

  @override
  String get statsTipTitle => 'Günün Rüya Tavsiyesi';

  @override
  String get statsTipContent =>
      'Bugün, içsel yolculuğunu derinleştirmek için bir anı defteri tutmayı deneyebilirsin. Rüyalarında gördüğün çocukluk hâlinle bağ kurarak, o saf sevgiyi yeniden keşfetmek için birkaç dakikanı ayır ve hislerini kaleme al.';

  @override
  String get statsAnalysisTitle => 'Bu Ayın Duygu Dağılımı';

  @override
  String get statsAnalysisResult => 'Rüya Desen Analizi';

  @override
  String get statsAnalyzeBtn => 'Rüya Desenini Gör';

  @override
  String get statsAnalysisIntroTitle => 'Rüya Desen Analizi';

  @override
  String get statsAnalysisIntroSubtitle => 'Haftada bir kez yapılabilir';

  @override
  String get statsAnalysisIntroContent =>
      'Rüya Desen Analizi, Rüya Günlüğünde kayıtlı olan tüm rüyaları bir arada inceleyerek bilinçaltının tekrar eden temalarını, duygusal döngülerini ve sembolik eğilimlerini ortaya çıkarır. Bu sistem, tek tek rüya yorumlarından farklı olarak zaman içinde oluşan kalıpları, yani zihninin sana anlatmaya çalıştığı büyük resmi gösterir. Zaman içinde değişen ögeleri daha düzenli takip edebilmen için haftada sadece bir kez yapılabilir.';

  @override
  String statsAnalysisWait(Object days) {
    return 'Yeni analiz için $days gün beklemelisiniz.';
  }

  @override
  String get statsAnalysisMinDreams => 'En Az 5 Kaydedilmiş Rüya Gerekir';

  @override
  String get statsAnalysisDone => 'Haftalık Analiz Yapıldı';

  @override
  String get statsAnalyzing => 'Analiz Ediliyor...';

  @override
  String get statsOffline => 'İnternet gerekli';

  @override
  String get statsNoData =>
      'Detaylı verilere erişebilmek için rüyalarını her gün kaydet';

  @override
  String get statsProcessing =>
      'Rüya Deseni hazırlanıyor, lütfen kısa bir süre bekleyin.';

  @override
  String get guideTitle => 'Lucid Rüya Rehberi';

  @override
  String get guideIntroTitle => 'Lucid Rüya Nedir?';

  @override
  String get guideIntroContent =>
      'Lucid rüya (bilinçli rüya), rüyada olduğunun farkına vardığın ve rüyanı kontrol edebildiğin eşsiz bir deneyimdir.';

  @override
  String get moodLove => 'Aşk';

  @override
  String get moodHappy => 'Mutluluk';

  @override
  String get moodSad => 'Üzüntü';

  @override
  String get moodScared => 'Korku';

  @override
  String get moodAnger => 'Öfke';

  @override
  String get moodNeutral => 'Nötr';

  @override
  String get moodPeace => 'Huzur';

  @override
  String get moodAwe => 'Şaşkınlık';

  @override
  String get moodAnxiety => 'Kaygı';

  @override
  String get moodConfusion => 'Kafa Karışıklığı';

  @override
  String get moodEmpowered => 'Güçlü';

  @override
  String get moodLonging => 'Özlem';

  @override
  String get feltMood => 'Duygu:';

  @override
  String get moodSelectPrompt => 'Bu rüyayı düşündüğünde içindeki ilk his ne?';

  @override
  String get moodIntensityLabel => 'Duygu Yoğunluğu';

  @override
  String get moodIntensityLow => 'Hafif';

  @override
  String get moodIntensityMedium => 'Orta';

  @override
  String get moodIntensityHigh => 'Yoğun';

  @override
  String get moodVividnessLabel => 'Berraklık';

  @override
  String get moodVividnessQuestion => 'Rüyayı ne kadar net hatırlıyorsun?';

  @override
  String get moodVividnessLow => 'Bulanık';

  @override
  String get moodVividnessMedium => 'Kısmen Net';

  @override
  String get moodVividnessHigh => 'Çok Net';

  @override
  String get moodNotSure => 'Emin Değilim';

  @override
  String get moodSaving => 'Rüyan kaydediliyor...';

  @override
  String get newDreamModalTitle => 'Bu Rüyada Hangi Duygu\nHakimdi?';

  @override
  String get close => 'Kapat';

  @override
  String get journalTitle => 'Rüya Günlüğüm';

  @override
  String get journalAll => 'Tümü';

  @override
  String get journalFavorites => 'Favorilerim';

  @override
  String get journalNoDreams => 'Henüz kaydedilmiş rüya yok.';

  @override
  String get journalNoFavorites => 'Henüz favori rüya yok.';

  @override
  String get journalAnalysis => 'Rüya Yorumu';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsNotifications => 'Bildirimler';

  @override
  String get settingsPrivacy => 'Gizlilik Politikası';

  @override
  String get settingsSupport => 'Destek';

  @override
  String get settingsVersion => 'Sürüm:';

  @override
  String get settingsNotifOpen => 'Bildirimleri Aç';

  @override
  String get settingsNotifTime => 'Günlük Hatırlatıcı';

  @override
  String get settingsNotifDesc =>
      'Her sabah rüyalarını kaydetmen için nazik bir hatırlatma al.';

  @override
  String get settingsPrivacyTitle => 'Gizlilik Politikası';

  @override
  String get settingsSupportTitle => 'Destek';

  @override
  String get settingsAppStatus => 'Uygulama Durumu';

  @override
  String get settingsSupportDesc => 'Bir sorun mu var? Bize ulaşın!';

  @override
  String get settingsSend => 'Mesaj Gönder';

  @override
  String get settingsSending => 'Mesaj gönderildi!';

  @override
  String get newDreamMinCharHint =>
      'Rüyanın yorumlanabilmesi için minimum 50 karakter girmelisin.';

  @override
  String get homeSpecialBadge => 'PRO';

  @override
  String get newDreamTitle => 'Yeni Rüya';

  @override
  String get newDreamSubtitle => 'Rüyalarını her gün kaydetmeyi unutma...';

  @override
  String get newDreamSave => 'Rüyamı Kaydet ve Yorumla';

  @override
  String get newDreamPlaceholderDetail =>
      'Rüyanı buraya detaylandır...\n\nÖrnek: Çiçeklerle dolu sakin bir bahçede yürüyordum. Güneş yaprakların arasından yumuşak bir ışık yayıyordu. Yakındaki küçük bir kuş havuzunda su hafifçe dalgalanıyordu.';

  @override
  String get newDreamPlaceholder => 'Rüyanı buraya detaylandır...';

  @override
  String get guideCompletionTitle => 'Tebrikler!';

  @override
  String get guideCompletionContent =>
      'Lucid Rüya Rehberinin tüm aşamalarını tamamladın.\n\nArtık tüm teknikler üzerinde ustalaşarak Lucid Rüya dünyasında serbestçe ilerleyebilirsin!';

  @override
  String get guideStage1Title =>
      '1. MILD Tekniği (Mnemonic Induction of Lucid Dreams)';

  @override
  String get guideStage1Subtitle => 'Rüyalarınıza uyanış tohumunu ekmek';

  @override
  String get guideStage1Content =>
      'Lucid dreaming yolculuğunun başlangıç noktasıdır. MILD, yani \"Mnemonic Induction of Lucid Dreams\", uykuya dalmadan önce bilinçaltına net bir niyet yerleştirme tekniğidir. Bu niyet, rüya sırasında \"ben rüyadayım\" farkındalığını yakalamanı sağlar. Bilinçli rüyaların ilk kapısını bu aşamada aralayacağız.';

  @override
  String get guideStage1Importance =>
      'MILD, zihnin hatırlama ve niyet oluşturma yeteneğini kullanarak, lucid dreaming\'e zihinsel bir zemin hazırlar. Hipokampus ve prefrontal korteksi aktif hale getirerek rüyada bilinçli olma ihtimalini artırır.';

  @override
  String get guideStage1Steps =>
      'Gece rüyadan uyandıktan sonra son rüyanı detaylıca hatırlamaya çalış.\nKendine şu cümleyi tekrar et: \"Bir sonraki rüyamda rüya gördüğümü fark edeceğim.\"\nBu sahneyi zihninde canlandır. Kendini rüyada farkında şekilde görselleştir.\nGözlerini kapat, bu niyetle uykuya dön.\nSabah uyandığında rüya günlüğüne detaylıca yaz.';

  @override
  String get guideStage1Criteria =>
      '1 hafta içinde en az 1 defa rüyanda rüya gördüğünü fark ettiysen bir sonraki aşamaya geçebilirsin.';

  @override
  String get guideStage1BrainNote =>
      'Bu bir uyanış yolculuğu. İlk adımda zihnini eğitmeye başlıyorsun. Her tekrar, bilinçli rüyaların bir adım daha yakın olması demektir. Unutma, sabır ve tekrar en büyük yardımcın.';

  @override
  String get guideStage2Title => '2. WBTB (Wake Back To Bed)';

  @override
  String get guideStage2Subtitle => 'Bilinçli Rüya Kapısını Aralamak';

  @override
  String get guideStage2Content =>
      'Artık zihinsel niyetini oluşturdun. Şimdi, rüyaların en yoğun yaşandığı REM evresine, bilinçli bir şekilde yeniden giriş yapmayı öğreneceğiz. WBTB tekniği, yarı uyanıklık halinde yeniden uykuya dalmanı sağlayarak lucid rüya farkındalığını destekleyebilir.';

  @override
  String get guideStage2Importance =>
      'WBTB ile beynin hem uyanıklık hem uyku arasında kalır. Bu geçiş noktası, lucid rüyalar için en uygun zihinsel ortamı sağlar.';

  @override
  String get guideStage2Steps =>
      'Gece uyuduktan 4–6 saat sonra alarm kurup uyan.\n15–30 dakika boyunca düşük ışıkta kitap oku, meditasyon yap ya da MILD tekrarı yap.\nBu sürenin sonunda tekrar yat ve MILD niyetiyle uykuya dal.';

  @override
  String get guideStage2Criteria =>
      '1 hafta içinde en az 2 gece rüyanda bulunduğun ortamın farkındalığını kazandıysan bir sonraki aşamaya geçebilirsin.';

  @override
  String get guideStage2BrainNote =>
      'Zihnini biraz daha açıyorsun. Rüya ile gerçeklik arasındaki perde inceliyor. Uyanıklıkla rüyayı buluşturmak üzeresin.';

  @override
  String get guideStage3Title => '3. WILD (Wake Initiated Lucid Dream)';

  @override
  String get guideStage3Subtitle => 'Bilincinle Rüyaya Doğrudan Giriş';

  @override
  String get guideStage3Content =>
      'Lucid dreaming\'in en etkileyici tekniklerinden biri olan WILD, seni doğrudan bilinçli şekilde rüya alemine taşır. Uyumadan önce zihnin uyanık kalırken bedenin uyumasına izin verirsin ve rüya başlangıcını daha net fark edebilirsin.';

  @override
  String get guideStage3Importance =>
      'WILD, zihinsel berraklık ile bedensel rahatlamanın eş zamanlı yürütülmesini gerektirir. Bu teknik, doğrudan rüyaya giriş yaptığın için diğerlerinden farklıdır ve yüksek düzeyde pratik ister.';

  @override
  String get guideStage3Steps =>
      'WBTB sonrası uygula.\nYatağa uzan, tüm bedenini gevşet.\nNefesine odaklan, zihnini aktif tut.\nGözlerin kapalıyken ışıklar, desenler görebilirsin — sakince izle.\nRüyanın başladığını fark ettiğinde kontrolü ele al.';

  @override
  String get guideStage3Criteria =>
      '2 hafta içinde en az 1 kez doğrudan bilinçli bir şekilde rüya içine geçiş yaptıysan 4. aşamaya hazırsın.';

  @override
  String get guideStage3BrainNote =>
      'Şimdi ustalığın eşiğindesin. Gözlerini kapatıp başka bir dünyada açmayı öğreniyorsun. Unutma, bu teknik çok fazla pratik ister ve sabır en büyük müttefikindir.';

  @override
  String get guideStage4Title =>
      '4. Zaman Farkındalığı ve Gerçeklik Kontrolleri';

  @override
  String get guideStage4Subtitle => 'Gerçeklik Algımıza Hâkim Olmak';

  @override
  String get guideStage4Content =>
      'Artık lucid rüyaların farkındalığı başladı. Şimdi bu farkındalığı derinleştirmenin ve zaman-mekan kavramını rüyada kullanabilmenin zamanı geldi. Bu aşamada hedef: rüyadayken yıl, yaş, tarih gibi kavramları hatırlamak.';

  @override
  String get guideStage4Importance =>
      'Gerçeklik kontrolleri, rüyada olduğunun farkına varmanı kolaylaştırır. Zaman algısı ise zihinsel farkındalığın derinliğini gösterir.';

  @override
  String get guideStage4Steps =>
      'Günde en az 5–10 kez \"Şu an rüyada mıyım?\" diye sor.\nParmak saymak, yazı tekrar okumak gibi testler yap.\nUyumadan önce: \"Rüyamda hangi yılda olduğumu fark edeceğim\" niyetini tekrar et.';

  @override
  String get guideStage4Criteria =>
      '1 hafta içinde 3 gece rüyanda zamanla ilgili bir farkındalık yaşadıysan (örneğin yıl, doğum günün, takvim) → sıradaki aşamaya geçebilirsin.';

  @override
  String get guideStage4BrainNote =>
      'Artık sadece rüyada olduğunu değil, rüyadaki zamanın da farkındasın. Zihnin yeni bir boyuta geçmeye başladı.';

  @override
  String get guideStage5Title => '5. Uyku Rutini Optimizasyonu';

  @override
  String get guideStage5Subtitle => 'Lucid Rüyaya Zemin Hazırlamak';

  @override
  String get guideStage5Content =>
      'Bu aşamada doğrudan lucid rüya denemelerine ara veriyoruz. Artık beynin temel mekanizmasını desteklemek, zihinsel berraklığı derinleştirmek için düzenli bir uyku rutini inşa etme zamanı.';

  @override
  String get guideStage5Importance =>
      'Düzenli uyku ve ideal ortam lucid dreaming başarısını doğrudan etkiler. REM süresinin sağlıklı ilerlemesi için düzenli bir ritim gerekir.';

  @override
  String get guideStage5Steps =>
      'Her gün aynı saatte yat-kalk düzeni oluştur.\nYatmadan 1 saat önce dijital detoks yap.\nSessiz, karanlık, serin odada uyumaya özen göster.\nKısa meditasyonlarla zihni yatıştır.';

  @override
  String get guideStage5Criteria =>
      '10 gün boyunca 7 gece rüya günlüğü tuttuysan ve rüyaların 3\'ünde farkındalık sinyalleri yaşadıysan → sıradaki aşamaya geçebilirsin.';

  @override
  String get guideStage5BrainNote =>
      'Bir bina temelsiz olmaz. Bu aşama, bilinçli rüyalarına sağlam bir zemin kurar. Unutma, dinlenmiş bir zihin bilinçli bir zihin demektir.';

  @override
  String get guideStage6Title => '6. Dopamin Dengesi';

  @override
  String get guideStage6Subtitle => 'Zihin Kimyasını Dengelemek';

  @override
  String get guideStage6Content =>
      'Artık zihnin lucid dreaming ile tanıştı. Bu aşamada rüya pratiğinden bir adım geri çekiliyor ve zihinsel dengeyi destekleyerek lucid rüyalar için daha sağlıklı bir zihinsel ortam oluşturmayı amaçlıyoruz.';

  @override
  String get guideStage6Importance =>
      'Dopamin, motivasyon ve dikkat süreçlerinde rol oynayan bir nörotransmitterdir. Aşırı uyaranlar zihinsel odaklanmayı zorlaştırabilir. Bu içerikler tıbbi tavsiye değildir; yalnızca farkındalık ve yaşam tarzı önerileri sunar.';

  @override
  String get guideStage6Steps =>
      '5 gün boyunca sosyal medya süreni 1 saatle sınırla.\nHafif egzersiz, yürüyüş ve güneş ışığı al.\nOmega-3 açısından zengin, şekerden uzak beslen.\nUyku öncesi odak egzersizleri yap.';

  @override
  String get guideStage6Criteria =>
      '1 hafta içinde 3 kez lucid rüyada bilinçli şekilde ortamı, ışığı veya bir objeyi manipüle edebildiysen son aşamaya geçebilirsin.';

  @override
  String get guideStage6BrainNote =>
      'Artık zihnini sadece eğitmedin, onun biyolojik yapısını da optimize ettin. Şimdi bilinçli rüyalar sadece mümkün değil; senin doğan haline dönüşüyor.';

  @override
  String get guideStage7Title => '7. İleri Farkındalık ve Yaratıcı Yönlendirme';

  @override
  String get guideStage7Subtitle => 'Rüyanın Efendisi Olmak';

  @override
  String get guideStage7Content =>
      'Yolculuğun sonuna geldik. Bu noktada artık sadece lucid olmakla kalmayacak, rüya deneyimini daha bilinçli şekilde keşfedebileceğin bir seviyeye ulaşacaksın. Rüya dünyanı özgürce yaratma zamanı geldi.';

  @override
  String get guideStage7Importance =>
      'Bu teknikle rüya sembolleri ve zihinsel imgeler üzerine farkındalık geliştirebilirsin, hayal ettiğin her şeyi test edebilirsin. Bu hem zihinsel hem de kişisel farkındalık açısından önemli bir adımdır.';

  @override
  String get guideStage7Steps =>
      'Rüyada yapmak istediğin senaryoyu detaylıca yaz ve hayal et.\nRüyada bilinçli olarak mekanı, zamanı, karakteri veya sonucu değiştir.\nFarkındalık meditasyonlarını gündelik rutine ekle.';

  @override
  String get guideStage7Criteria =>
      '2 hafta içinde en az 2 rüyada aktif manipülasyon yaptıysan (uçmak, ortamı değiştirmek, bir şeyi çağırmak), lucid rüya dünyasına hoş geldin.';

  @override
  String get guideStage7BrainNote =>
      'Bu yolculuğun sonunda sadece bilinçli rüyalar değil, hayal gücünün sınırsız potansiyeli seni bekliyor. Artık sadece uyanıkken değil, uyurken de hayatı yaratıyorsun.';

  @override
  String get guideAppBarTitle => 'Lucid Rüya Rehberi';

  @override
  String get guideIntroTitle1 => 'Lucid rüya nedir?';

  @override
  String get guideIntroContent1 =>
      'Lucid rüya (bilinçli rüya), rüyada olduğunun farkına vardığın ve rüyanı kontrol edebildiğin eşsiz bir deneyimdir.';

  @override
  String get guideIntroListTitle => 'Lucid Rüya durumunda:';

  @override
  String get guideIntroBullet1 => 'Rüya sırasında bilincin yerindedir';

  @override
  String get guideIntroBullet2 => 'Çevreni değerlendirebilirsin';

  @override
  String get guideIntroBullet3 => 'Karar verme yetin artar';

  @override
  String get guideIntroBullet4 => 'Rüyanın akışını değiştirebilirsin';

  @override
  String get guideIntroFooter =>
      'Lucid rüya, çok azımızın hayatının bir noktasında tesadüfen tecrübe edebildiği fakat doğru teknikler ile üzerinde uzmanlaşılabilen bir beceridir.';

  @override
  String get guideIntroTitle2 => 'Lucid rüya ne işe yarar?';

  @override
  String get guideBenefit1 => 'Rüyalarını yönetirsin';

  @override
  String get guideBenefit2 => 'Bilinçaltını keşfedersin';

  @override
  String get guideBenefit3 => 'Uykunun efendisi olursun';

  @override
  String get guideBenefit4 => 'Stresle daha iyi başa çıkarsın';

  @override
  String get guideIntroContent2 =>
      'Lucid rüyalar, bilinçaltının kapılarını aralayarak seni daha yüksek bir farkındalık seviyesine taşır. Bu deneyim zamanla gündelik hayatına bile yansır.';

  @override
  String get guideIntroTitle3 => 'Bu rehber nasıl kullanılır?';

  @override
  String get guideIntroContent3 =>
      'Bu rehber 7 aşamalı özel bir lucid rüya sistemi üzerine kuruludur. Her aşamada rüyalarına doğrudan etki edecek güçlü bir alışkanlık edinirsin. Hazırlamış olduğumuz kapsamlı rehber, bir kez satın alındıktan sonra seni hedeflerine ulaşana kadar her adımda yönlendirecek.';

  @override
  String get guideIntroGainTitle => 'İlerledikçe Kazanacakların';

  @override
  String get guideIntroGain1 => 'Rüyalarının derin katmanlarına erişirsin';

  @override
  String get guideIntroGain2 => 'Bilincin rüyaya yön vermeye başlar';

  @override
  String get guideIntroGain3 => 'Mekânlar ve kişiler sana göre şekil alır';

  @override
  String get guideIntroGain4 => 'Rüyalarının yönetmeni olursun';

  @override
  String get guideBuyButton => 'Rehberi Satın Al (179.00 TL)';

  @override
  String get guideNo => 'Hayır';

  @override
  String get guideYes => 'Evet';

  @override
  String get guideDebugResetTitle => 'Rehberi Sıfırla?';

  @override
  String get guideDebugResetContent =>
      'Birinci aşama hariç tüm kilitleri kapatacak. (Debug)';

  @override
  String get journalDeleteTitle => 'Rüyayı Sil?';

  @override
  String get journalDeleteContent =>
      'Bu rüyayı silmek istediğine emin misin? Bu işlem geri alınamaz.';

  @override
  String get journalDeleteConfirm => 'Sil';

  @override
  String get journalDeleteCancel => 'Vazgeç';

  @override
  String get proVersion => 'PRO';

  @override
  String get standardVersion => 'Standart';

  @override
  String get upgradeTitle => 'DreamBoat PRO\'ya Yükselt';

  @override
  String get upgradeBenefits =>
      'Reklamsız Deneyim\nTam Rüya Analizi\nLimitsiz Rüya Yorumu\nÖzel Rehber Erişimi';

  @override
  String get upgradeBtn => 'DreamBoat PRO\'yu Aç (88,99 ₺)';

  @override
  String get upgradeCancel => 'Belki daha sonra';

  @override
  String get privacyPolicyLink => 'Gizlilik Politikası';

  @override
  String get termsOfUseLink => 'Kullanım Şartları';

  @override
  String get upgradeSuccess => 'DreamBoat PRO\'ya hoşgeldin!';

  @override
  String get upgradeStart => 'Başla';

  @override
  String get proRequired => 'PRO Versiyon Gerekir';

  @override
  String get proRequiredDetail =>
      'PRO Versiyon ve En Az 5 Kaydedilmiş Rüya Gerekir';

  @override
  String get guideUnlockPro => 'PRO Sürümünün Kilidini Aç';

  @override
  String get guideUnlockHint =>
      'Rehberin kilidini açmak için PRO sürümüne geçmelisin.';

  @override
  String get guideContent => 'İçerik';

  @override
  String get guideImportance => 'Neden Önemli?';

  @override
  String get guideSteps => 'Uygulama Adımları';

  @override
  String get guideCriteria => 'Geçiş Kriteri';

  @override
  String get guideBrainNoteTitle => 'Note to Brain';

  @override
  String get guideNextStep => 'İlerle';

  @override
  String get guideDialogTitle => 'İlerlemek istediğine emin misin?';

  @override
  String get guideDialogContent =>
      'Mevcut adımı gerçekleştirmeden sonraki aşamaya geçmek yolculuğuna zarar verebilir. Devam etmek istediğine emin misin?';

  @override
  String get guideDialogCancel => 'Vazgeç';

  @override
  String get guideDialogConfirm => 'Devam Et';

  @override
  String get guideStart => 'Rehbere Başla';

  @override
  String get privacyTitle => 'Gizlilik ve KVKK';

  @override
  String get privacyNoticeTitle => 'NovaBloom Studio Gizlilik Bildirimi';

  @override
  String get privacyNoticeContent =>
      'DreamBoat, bağımsız geliştirici Guney Yilmazer tarafından NovaBloom Studio markası altında geliştirilmiştir. Gizliliğiniz bizim için en yüksek önceliktir. DreamBoat, rüyalarınızı güvenle kaydetmeniz ve kişisel farkındalık için analiz etmeniz amacıyla tasarlanmıştır.';

  @override
  String get privacySection1Title => '1. Veri Güvenliği ve İşleme';

  @override
  String get privacySection1Content =>
      'Rüya kayıtlarınız ve uygulama içi verileriniz güvenli bir şekilde saklanır.\nRüyalarınız yalnızca uygulamanın sunduğu özellikleri çalıştırmak için işlenir.\n\nRüya içerikleri üçüncü kişilerle asla paylaşılmaz\n\nVeriler reklam, pazarlama veya kullanıcı profilleme amacıyla kullanılmaz\n\nYapay zekâ destekli analizler yalnızca kullanıcı deneyimini geliştirmek için yapılır\n\nRüya metinleri AI modellerinin eğitimi için kullanılmaz\n\nTüm işlemler KVKK ve GDPR standartlarına uygun şekilde yürütülür';

  @override
  String get privacySection2Title => '2. Hesap ve Kullanım';

  @override
  String get privacySection2Content =>
      'DreamBoat, hesap oluşturma zorunluluğu olmadan çalışır.\n\nUygulama anonim olarak kullanılabilir\n\nRüyalarınız ve ayarlarınız yalnızca cihazınızda veya uygulamaya ait güvenli alanlarda saklanır\n\nKişisel kimlik bilgileri (isim, e-posta vb.) zorunlu olarak toplanmaz';

  @override
  String get privacySection3Title => '3. Gizlilik ve Kilitleme Özellikleri';

  @override
  String get privacySection3Content =>
      'DreamBoat, gizliliği korumak için ek güvenlik seçenekleri sunar:\n\nRüya günlüğü Face ID veya parmak izi ile kilitlenebilir\n\nRüyalar varsayılan olarak tamamen özeldir\n\nPaylaşım özelliği isteğe bağlıdır ve yalnızca kullanıcı açıkça paylaşmayı seçtiğinde çalışır\n\nRüyalar hiçbir zaman otomatik olarak veya üçüncü taraflarla paylaşılmaz';

  @override
  String get privacySection4Title => '4. Sağlık ve Tıbbi Feragat (ÖNEMLİ)';

  @override
  String get privacySection4Content =>
      'DreamBoat bir sağlık veya tıbbi uygulama değildir.\n\nSunulan rüya yorumları ve analizler eğlence ve kişisel farkındalık amaçlıdır\n\nTıbbi, psikolojik veya profesyonel tavsiye niteliği taşımaz\n\nUygulama biyometrik veya sağlık verisi toplamaz ve işlemez\n\n5. İletişim\n\nDetaylı gizlilik politikamıza web sitemiz üzerinden de ulaşabilirsiniz:\nhttps://www.novabloomstudio.com/tr/privacy';

  @override
  String get supportTitle => 'Bize Ulaşın';

  @override
  String get supportContent =>
      'Görüşleriniz NovaBloom Studio için çok değerli.\n\nÖneri, hata bildirimi veya işbirliği talepleriniz için bize e-posta gönderebilirsiniz.';

  @override
  String get supportSendEmail => 'E-posta Gönder';

  @override
  String get supportEmailNotFound => 'E-posta uygulaması bulunamadı.';

  @override
  String get supportEmailSubject => 'DreamBoat Destek Talebi';

  @override
  String get debugResetTitle => 'Debug Reset';

  @override
  String get debugResetContent =>
      'Uygulama durumunu Standart versiyona döndürmek istiyor musunuz?';

  @override
  String get cancel => 'İptal';

  @override
  String get reset => 'Sıfırla';

  @override
  String get standard => 'STANDART';

  @override
  String get save => 'Kaydet';

  @override
  String get timeFormat24h => '24 Saat Formatı';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get guideSlide1Title => 'Eski Mısır’ın Bilgeliği';

  @override
  String get guideSlide1Subtitle => 'Ruhun Yolculuğuna Açılan Kapı';

  @override
  String get guideSlide1Content1 =>
      'Günümüzde adına lucid rüya dediğimiz kavramın izlerini Antik Mısır’da görmek mümkündü. Mısırlılar rüyayı, dönemin kültürel ve spiritüel inançları çerçevesinde bilinçli bir deneyim olarak yorumlarlardı.\n\nÖyle ki Firavunların, rahipler aracılığıyla rüya aleminde ilahi figürlerle etkileşim yaşadıklarına dair sembolik anlatımlar yer alır.';

  @override
  String get guideSlide1Content2 =>
      'Modern tıpta somnoloji alanındaki uyku araştırmalarında, rüya gördüğümüz evre olan REM uykusunda frontal korteksin aktif olduğu, yani beynin bilinç ve farkındalıkla ilişkili bölgelerinin uyanık haldekine benzer bir şekilde çalıştığı gözlemlenmiştir. Bu bulgular, Antik Mısır’da rüyaya atfedilen bilinçli deneyim anlatımlarıyla bazı kavramsal benzerlikler taşıdığı şeklinde yorumlanmaktadır.';

  @override
  String get guideSlide2Title => 'Tibet Rahiplerinin Meditasyonları';

  @override
  String get guideSlide2Subtitle => 'Zihnin Sınırlarını Aşmak';

  @override
  String get guideSlide2Content1 =>
      'Tibet rahipleri, bir ömür süren derin meditasyon pratikleriyle lucid rüyayı, zihinsel farkındalığı artırmaya yönelik bir içsel deneyim olarak ele aldılar.\n\nHimalayaların yüksek zirvelerinde, zihnin katmanlarını keşfeden rahipler, bilinçli rüya deneyimlerini zihinsel disiplin ve geleneksel pratiklerle destekledi.';

  @override
  String get guideSlide2Content2 =>
      'Günümüzde bazı nörolojik çalışmalarda, meditasyon pratikleri ile uyku farkındalığı arasındaki ilişki incelenmiştir.\n\nBu kadim geleneklerin ışığında hazırladığımız bu özel rehber, zihninizin derinliklerindeki bu potansiyeli uyandırmayı ve farkındalığınızı rüya alemine taşımayı hedefler. Rüyalarınızda bir izleyici olmaktan çıkıp, kendi iç dünyanızın bilinçli mimarı olma yolculuğuna şimdi başlayabilirsiniz.';

  @override
  String get guideSlide3Title => 'Rüya Kapanlarının Sırrı';

  @override
  String get guideSlide3Subtitle => 'Bilinçli Rüyaların Koruyucusu';

  @override
  String get guideSlide3Content1 =>
      'Kızılderili kültürlerinde rüya kapanı, bilinçli rüyalarla ilişkilendirilen sembolik bir obje olarak görülürdü.\n\nNesilden nesile aktarılan bu pratik, rüya deneyimlerini temsil eden kültürel bir sembol olarak yorumlanırdı. Şamanların rehberliğinde, rüya kapanı bilinçli farkındalıkla ilişkilendirilen ve ruhani bağları simgeleyen bir sembol olarak değer gördü.';

  @override
  String get guideSlide3Content2 =>
      'Modern bilgi çağında lucid rüya sadece eski kültürlerin mistik bir deneyimi değil, modern bilimsel araştırmalarda üzerinde çalışılan bir bilinç deneyimi olarak ele alınmaktadır.\n\nEn güncel araştırmalar ve nesilden nesile aktarılan öğretileri derleyerek oluşturduğumuz bu lucid rüya rehberinde, zihinsel farkındalığınızı derinleştirerek farklı deneyimleri keşfetmeniz mümkün.';

  @override
  String get guideSlide4Title => 'Lucid Rüya Rehberi';

  @override
  String get guideSlide4Content =>
      'Bu rehber nasıl kullanılır?\n\nBu rehber 7 aşamalı özel bir lucid rüya sistemi üzerine kuruludur.\nHer aşamada rüya farkındalığını destekleyen güçlü alışkanlıklar geliştirirsin.';

  @override
  String get guideSlide4GainsTitle => 'İlerledikçe Kazanacakların';

  @override
  String get guideSlide4Gain1 => 'Rüyalarının derin katmanlarına erişirsin';

  @override
  String get guideSlide4Gain2 => 'Bilincin rüyaya yön vermeye başlar';

  @override
  String get guideSlide4Gain3 => 'Mekânlar ve kişiler sana göre şekil alır';

  @override
  String get guideSlide4Gain4 =>
      'Rüyaların üzerinde daha fazla farkındalık kazanırsın.';

  @override
  String get guideSlide4ProRequired =>
      'Rehbere erişebilmek için PRO sürüme sahip olmalısın.';

  @override
  String get guideSlide4UnlockButton => 'PRO Sürümünün Kilidini Aç';

  @override
  String get guideCompleted => 'Tebrikler! Tüm rehberi tamamladın.';

  @override
  String get delete => 'Sil';

  @override
  String get actionFavorite => 'Favori';

  @override
  String get understand => 'Anladım, Devam Et';

  @override
  String get error => 'Hata';

  @override
  String get testNotification => 'Send Test Notification';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get journalSearchHint => 'Rüyalarında ara...';

  @override
  String get newDreamLoadingText => 'Rüya yorumun hazırlanıyor...';

  @override
  String get dreamInterpretationTitle => 'Rüya Yorumu';

  @override
  String get dreamInterpretationReadMore => 'Devamını Oku';

  @override
  String get dreamTooShort => 'Rüya çok kısa olduğundan yorumlanamadı.';

  @override
  String get dreamGibberish =>
      'Rüyanız yeterli anlam içermediği için yorumlanamadı.';

  @override
  String get dailyLimitReached =>
      'Günlük rüya yorumlama limitine ulaştınız (100/100).';

  @override
  String get settingsRestorePurchases => 'Satın Alımları Geri Yükle';

  @override
  String get restoreSuccess => 'PRO sürümü başarıyla geri yüklendi!';

  @override
  String get restoreNotFound => 'Önceki satın alım bulunamadı.';

  @override
  String get restoreError =>
      'Satın alımlar geri yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get restoreUnavailable =>
      'Mağaza şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.';

  @override
  String get restoring => 'Geri yükleniyor...';

  @override
  String get offlineInterpretation =>
      'İnternet bağlantısı olmadığı için rüya yorumlanamadı.';

  @override
  String get offlinePurchase =>
      'Satın alma işlemi için internet bağlantısı gerekiyor.';

  @override
  String get offlineAnalysis => 'Analiz için internet bağlantısı gerekiyor.';

  @override
  String get proUpgradeSubtitle =>
      'Abonelik yok. Tek sefer satın alır, ömür boyu erişim sağlarsın.';

  @override
  String get proFeatureAdsTitle => 'Reklamsız Deneyim';

  @override
  String get proFeatureAdsSubtitle =>
      'Rüya yorumlamalarında reklam yok.\nSadece rüyalarına ve sana anlatmak istediklerine odaklan.';

  @override
  String get proFeatureCosmicTitle => 'Kozmik Bağlantıların Kilidini Aç';

  @override
  String get proFeatureCosmicSubtitle =>
      'Rüya yorumlarına ek kozmik bağlantıları ortaya çıkarır.\nRüyalarını Ay evreleri ve gezegen etkileriyle birlikte yorumlar.';

  @override
  String get proFeatureAnalysisTitle => 'Haftalık Rüya Desen Analizi';

  @override
  String get proFeatureAnalysisSubtitle =>
      'Rüyaların arasındaki gizli bağlantıları ortaya çıkarır.\nTekrarlayan temaları, duyguları ve bilinçaltı mesajlarını zamanla keşfet.';

  @override
  String get proFeatureGuideTitle => 'Lucid Rüya Rehberi';

  @override
  String get proFeatureGuideSubtitle =>
      'Rüyalarının kontrolünü eline al.\nAdım adım rehberli lucid rüya teknikleri.';

  @override
  String get proProcessing => 'İşleniyor...';

  @override
  String get notifDialogTitle => 'Bildirimlere İzin Ver';

  @override
  String get notifDialogBody =>
      'DreamBoat\'un her sabah rüyalarınızı kaydetmenizi hatırlatmasına izin verin.';

  @override
  String get notifPermissionDenied => 'Bildirim İzni Reddedildi';

  @override
  String get notifOpenSettings => 'Ayarları Aç';

  @override
  String get notifOpenSettingsHint =>
      'Bildirimleri etkinleştirmek için ayarlardan izin vermeniz gerekiyor.';

  @override
  String get allow => 'İzin Ver';

  @override
  String get notifReminderBody => 'Rüyanızı kaydetmeyi unutmayın! 📝';

  @override
  String get notifReminder1 => 'Bu gece evren sana ne fısıldadı? ✨';

  @override
  String get notifReminder2 => 'Rüyaların silinmeden onları yakala! 📓';

  @override
  String get notifReminder3 => 'Bilinçaltın sana bir mesaj bıraktı... 🌙';

  @override
  String get notifReminder4 =>
      'Gördüğün sembollerin anlamını merak etmiyor musun? 🔮';

  @override
  String get notifReminder5 => 'Rüya günlüğün seni bekliyor ✍️';

  @override
  String get pressBackToExit => 'Çıkmak için tekrar geri tuşuna basın';

  @override
  String get moonSyncTitle => 'Aylık Ay ve Gezegen Senkronizasyonu';

  @override
  String get moonSyncSubtitle => 'Ayda bir kez yapılabilir';

  @override
  String get moonSyncDescription =>
      'Ay ve Gezegen Senkronizasyonu, son bir ay içindeki rüyalarını gördüğün güne ait Ay evresi ve o dönemdeki kozmik olaylarla (Kanlı Ay, tutulmalar gibi) birlikte analiz eder. Rüyalarındaki duygu, yoğunluk ve ruh hâlini Ay döngüsüyle eşleştirerek, bu ay iç dünyan ile kozmik döngüler arasındaki uyumu ve belirli ay döngülerinde (dolunay, yarım ay gibi) nelere dikkat etmen gerektiğini gösterir. Ay\'ın döngüsüne odaklı olduğu için ayda bir kez oluşturulur.';

  @override
  String get moonSyncDescriptionShort =>
      'Kozmik olayları rüyalarınla birlikte yorumlar.\nBu ay seni nelerin etkilediğini öğren.';

  @override
  String get moonSyncBtn => 'Kozmik Analizi Başlat';

  @override
  String moonSyncWait(int days) {
    return 'Yeni analiz için $days gün beklemelisiniz.';
  }

  @override
  String get moonSyncMinDreams => 'En Az 5 Kaydedilmiş Rüya Gerekir';

  @override
  String get moonSyncDone => 'Aylık Kozmik Analiz Yapıldı';

  @override
  String get moonSyncProcessing =>
      'Kozmik Analiz hazırlanıyor, lütfen kısa bir süre bekleyin.';

  @override
  String get moonPhaseNewMoon => 'Yeni Ay';

  @override
  String get moonPhaseWaxingCrescent => 'Büyüyen Hilal';

  @override
  String get moonPhaseFirstQuarter => 'İlk Dördün';

  @override
  String get moonPhaseWaxingGibbous => 'Büyüyen Şişkin Ay';

  @override
  String get moonPhaseFullMoon => 'Dolunay';

  @override
  String get moonPhaseWaningGibbous => 'Küçülen Şişkin Ay';

  @override
  String get moonPhaseThirdQuarter => 'Son Dördün';

  @override
  String get moonPhaseWaningCrescent => 'Küçülen Hilal';

  @override
  String get actionShareInterpretation => 'Yorumu Paylaş';

  @override
  String get shareImage => 'Görseli\nPaylaş';

  @override
  String get sharePrivacyHint =>
      'Not: Yorumu paylaş butonu yalnızca rüya yorumunuzu paylaşır. Rüyalarınız size aittir ve herhangi bir şekilde üçüncü şahıslara gösterilmez.';

  @override
  String get moonPhaseLabel => 'Ay Evresi:';

  @override
  String get readMore => 'Devamını Oku...';

  @override
  String get tapForDetails => 'Detaylar için tıklayın...';

  @override
  String nSelected(int count) {
    return '$count Seçildi';
  }

  @override
  String get shareCardHeader => 'GÜNLÜK RÜYA YORUMUM';

  @override
  String get shareCardWatermark => 'DreamBoat App ile yorumlandı';

  @override
  String get subscriptionComingSoon =>
      'Abonelik sistemi çok yakında aktif olacak!';

  @override
  String get subscribeMonthly => 'Aylık Abone Ol';

  @override
  String get subscribeYearly => 'Yıllık Abone Ol';

  @override
  String get planMonthly => 'AYLIK';

  @override
  String get planAnnual => 'YILLIK';

  @override
  String get mostPopular => 'EN POPÜLER';

  @override
  String get discountPercent => '-%30 İNDİRİM';

  @override
  String get subscribeNow => 'Abone Ol';

  @override
  String get billingMonthly =>
      'Aylık otomatik yenilenen abonelik.\nİstediğin zaman iptal edebilirsin.';

  @override
  String get billingAnnual =>
      'Yıllık otomatik yenilenen abonelik.\nHer yıl bir kez faturalandırılır.';

  @override
  String get proFeatureAds => 'Reklamsız Deneyim';

  @override
  String get proFeatureAnalysis => 'Haftalık Desen Analizi';

  @override
  String get proFeatureGuide => 'Lucid Rüya Rehberi';

  @override
  String get proFeatureMoonSync => 'Aylık Ay ve Gezegen Senkronizasyonu';

  @override
  String get freeTrialDays => 'Gün Ücretsiz Dene';

  @override
  String get freeTrialBadge => 'İlk 7 gün ücretsiz dene';

  @override
  String get priceLoading => 'Yükleniyor...';

  @override
  String get priceLoadError => 'Fiyat yüklenemedi';

  @override
  String get priceRetryButton => 'Tekrar Dene';

  @override
  String get then => 'Sonra';

  @override
  String get reviewSatisfactionTitle => 'DreamBoat\'u sevdin mi?';

  @override
  String get reviewSatisfactionContent => 'Deneyimini bizimle paylaş!';

  @override
  String get reviewOptionYes => 'Evet, bayıldım!';

  @override
  String get reviewOptionNeutral => 'Eh işte';

  @override
  String get reviewOptionNo => 'Hayır, sevmedim';

  @override
  String get reviewFeedbackTitle => 'Görüşlerin önemli';

  @override
  String get reviewFeedbackContent =>
      'Daha iyi bir deneyim için ne yapabiliriz? Bize yazmaktan çekinme.';

  @override
  String get reviewFeedbackButton => 'Bize Yaz';

  @override
  String get reviewCancel => 'Vazgeç';

  @override
  String get adConsentTitle => 'Bir rüya yorumu daha';

  @override
  String get adConsentBody =>
      'DreamBoat’ta rüya yorumları ücretsiz sunulur. Bunu sürdürebilmek için her yorumdan önce kısa bir video gösterilir.';

  @override
  String get adConsentWatch => 'Reklam İzle ve Yorumu Al';

  @override
  String get adConsentPro => 'PRO’ya Geç (Reklamsız)';

  @override
  String get adLoadError =>
      'Şu anda reklam yüklenemedi. Biraz sonra tekrar deneyebilirsin veya PRO’ya geçebilirsin.';

  @override
  String get adRetry => 'Tekrar Dene';

  @override
  String get adSkipThisTime => 'Bu sefer reklamsız devam';

  @override
  String get intensityFeltLight => 'Hafif hissediliyor';

  @override
  String get intensityFeltMedium => 'Orta hissediliyor';

  @override
  String get intensityFeltIntense => 'Yoğun hissediliyor';

  @override
  String get statsDreamLabel => 'Rüya';

  @override
  String statsRecordedDreams(Object count) {
    return 'Kaydedilen rüya sayısı: $count';
  }

  @override
  String get settingsSupportId => 'Destek ID\'si';

  @override
  String get settingsSupportIdCopied =>
      'ID kopyalandı! Destek ekibine bu kodu gönderebilirsiniz.';

  @override
  String get guideIntentExerciseTitle => 'Uyumadan önce birlikte tekrar edelim';

  @override
  String get guideIntentPhrase =>
      'Bir sonraki rüyamda rüya gördüğümü fark edeceğim.';

  @override
  String get guideIntentRepeatButton => 'Tekrarla';

  @override
  String guideIntentProgress(Object count) {
    return '$count / 10 tekrar';
  }

  @override
  String get guideIntentComplete =>
      'Hazırsın! Şimdi bu niyetle uyuyabilirsin. 🌙';

  @override
  String get wildBreathTitle => 'Nefes ve Gevşeme Modu';

  @override
  String get wildBreathStart => 'Nefes ve Gevşeme Modunu Başlat';

  @override
  String get wildBreathInhale => 'Nefes Al';

  @override
  String get wildBreathHold => 'Tut';

  @override
  String get wildBreathExhale => 'Ver';

  @override
  String get wildBreathFocus => 'Sadece nefesine odaklan';

  @override
  String get wildBreathTapToExit => 'Çıkmak için dokun';

  @override
  String get wbtbDreamsTitle => 'WBTB Sonrası Rüyaların';

  @override
  String get wbtbDreamsDesc =>
      'Bu aşamayı uyguladığın gecelerde kaydettiğin rüyaları burada inceleyebilirsin.';

  @override
  String get wbtbDreamsButton => 'WBTB Rüyalarını Gör';

  @override
  String get wbtbNoDreamsTitle => 'Henüz bu aşamaya ait rüya yok';

  @override
  String get wbtbNoDreamsDesc =>
      'Bu tekniği uyguladıktan sonra rüyalarını kaydet ve burada analiz et.';

  @override
  String get wbtbAddFirstDream => 'İlk Rüyamı Ekle';

  @override
  String get timeAwarenessTitle => 'Gerçeklik Kontrolleri Egzersizi';

  @override
  String get timeAwarenessInstruction => 'Uyumadan önce sesli cevapla';

  @override
  String get timeAwarenessQ1 => 'Bugünün tarihi ne?';

  @override
  String get timeAwarenessQ2 => 'Haftanın hangi günündeyiz?';

  @override
  String get timeAwarenessQ3 => 'REMOVED';

  @override
  String get timeAwarenessQ4 => 'Saat tam olarak kaç?';

  @override
  String get timeAwarenessQ5 => 'Etrafına bak ve 3 farklı nesne say.';

  @override
  String get timeAwarenessQ6 => 'Üzerinde ne renk kıyafet var?';

  @override
  String get timeAwarenessQ11 => 'Şu an hangi sesleri duyuyorsun?';

  @override
  String get timeAwarenessQ7 => 'Bugün ilk konuştuğun kişi kimdi?';

  @override
  String get timeAwarenessQ8 => 'Ellerine bak ve parmaklarını say.';

  @override
  String get timeAwarenessQ9 => 'Nefes al ve \'Rüya görüyor muyum?\' diye sor.';

  @override
  String get timeAwarenessQ10 => 'Şimdi gözlerini kapat ve uyuduğunu hayal et.';

  @override
  String get stage5Task1 => 'Rüya Günlüğü Tuttum';

  @override
  String get stage5Task2 => 'Rüyamda Farkındalık Sinyali Yaşadım';

  @override
  String get stage5Hint =>
      'Şartları sağladıkça yıldızlara tıklayarak görevleri gerçekleştirebilirsin. Tüm görevler tamamlandığında ilerlemenin kilidi açılır.';

  @override
  String get stage6Task1 => 'Rüyamı bilinçli bir şekilde manipüle edebildim';

  @override
  String get stage6Hint =>
      'Şartları sağladıkça yıldızlara tıkla. 3 yıldız işaretlendiğinde ilerlemenin kilidi açılır.';

  @override
  String get guideCriteriaNotMet =>
      'İlerlemek için bu aşamanın şartlarını tamamlamalısın.';

  @override
  String rateLimitWait(int minutes) {
    return 'Çok fazla istek gönderildi. Lütfen $minutes dakika sonra tekrar deneyin.';
  }

  @override
  String get analysisStep1 => 'Rüya sembolleri taranıyor...';

  @override
  String get analysisStep2 => 'Bilinçaltı haritası çıkarılıyor...';

  @override
  String get analysisStep3 => 'Arketipsel bağlantılar kuruluyor...';

  @override
  String get analysisStep4 => 'Psikolojik derinlik çözümleniyor...';

  @override
  String get analysisStep5 => 'Yorum hazırlanıyor...';

  @override
  String get analysisLongWait => 'Rüyanız detaylı inceleniyor...';

  @override
  String get newDreamSaveShort => 'Rüyayı Kaydet';

  @override
  String get supportTechInfoNote =>
      'Aşağıdaki teknik bilgiler, sorununuzu daha hızlı çözmemize yardımcı olur. Lütfen silmeyiniz.';

  @override
  String get onboardingWelcomeTitle => 'Henüz bir rüya görmemiş olabilirsin';

  @override
  String get onboardingWelcomeSubtitle =>
      'Bu sırada senin genel rüya profilini çıkaralım.';

  @override
  String get surveyQ1 => 'Genelde rüyalarını ne sıklıkla hatırlarsın?';

  @override
  String get surveyQ1Option1 => 'Hiç';

  @override
  String get surveyQ1Option2 => 'Ayda 1–2';

  @override
  String get surveyQ1Option3 => 'Haftada 1–2';

  @override
  String get surveyQ1Option4 => 'Neredeyse her gün';

  @override
  String get surveyQ2 => 'Uyku düzenini en iyi hangisi tanımlar?';

  @override
  String get surveyQ2Option1 => 'Çok düzensiz';

  @override
  String get surveyQ2Option2 => 'Biraz düzensiz';

  @override
  String get surveyQ2Option3 => 'Genelde düzenli';

  @override
  String get surveyQ2Option4 => 'Çok düzenli';

  @override
  String get surveyQ3 => 'Rüyalarının tonu genelde nasıl?';

  @override
  String get surveyQ3Option1 => 'Huzurlu';

  @override
  String get surveyQ3Option2 => 'Karışık';

  @override
  String get surveyQ3Option3 => 'Gergin';

  @override
  String get surveyQ3Option4 => 'Korkutucu';

  @override
  String get surveyQ4 => 'Rüyalarında kendini daha çok nasıl hissedersin?';

  @override
  String get surveyQ4Option1 => 'Kontrolde';

  @override
  String get surveyQ4Option2 => 'İzleyici gibi';

  @override
  String get surveyQ4Option3 => 'Kaçıyor gibi';

  @override
  String get surveyQ4Option4 => 'Keşfediyor gibi';

  @override
  String get profile1Name => 'Hayalci Gezgin';

  @override
  String get profile1Desc =>
      'Rüyalarında keşif, anlam arayışı ve duygusal farkındalık öne çıkıyor.\n\nBilinçaltın sana sık sık sembollerle konuşuyor. Hayatındaki küçük detayların aslında büyük anlamlar taşıdığını hissediyorsun.\n\nRüyalarını kaydettikçe iç dünyanı daha net görmeye başlayacaksın.';

  @override
  String get profile2Name => 'Sessiz Gözlemci';

  @override
  String get profile2Desc =>
      'Rüyalarında olayların içindesin ama kontrol sende değil gibi hissediyorsun.\n\nBilinçaltın yaşadıklarını sindirmeye çalışıyor. Günlük hayattaki düşüncelerin rüyalarına yumuşak geçişlerle sızıyor.\n\nRüyalarını yazmak, zihninin yükünü hafifletebilir.';

  @override
  String get profile3Name => 'Duygusal Kaşif';

  @override
  String get profile3Desc =>
      'Rüyaların yoğun, detaylı ve duygusal olarak güçlü.\n\nBilinçaltın sana kendini tanıman için sahneler sunuyor. İç dünyanla güçlü bir bağın var.\n\nRüyalarını takip etmek sana ciddi içgörüler kazandırabilir.';

  @override
  String get profile4Name => 'Zihinsel Savaşçı';

  @override
  String get profile4Desc =>
      'Rüyalarında baskı, kaçış ve mücadele temaları öne çıkıyor.\n\nGünlük streslerin rüyalarına yansıyor olabilir. Bilinçaltın sana “yavaşla” sinyali veriyor.\n\nRüyalarını yazmak zihinsel rahatlama sağlayabilir.';

  @override
  String get profile5Name => 'Kontrolcü Mimar';

  @override
  String get profile5Desc =>
      'Rüyalarında yön duygusu ve bilinç hâkimiyeti var.\n\nHayatında da planlı, düzenli ve farkında bir yapın olabilir. Rüyalar senin için bir oyun alanı gibi çalışıyor.\n\nLucid rüya potansiyelin yüksek.';

  @override
  String get profile6Name => 'Derin Dalgıç';

  @override
  String get profile6Desc =>
      'Rüyaların yoğun ve bazen rahatsız edici olabilir.\n\nBilinçaltın bastırılmış duyguları sahneye çıkarıyor. Bu kötü bir şey değil; bir temizlik süreci gibi düşün.\n\nRüyalarını yazmak içsel yüklerini hafifletebilir.';

  @override
  String get profile7Name => 'Rüya Gezgini';

  @override
  String get profile7Desc =>
      'Rüyalarında sakinlik ve akış hâli var.\n\nHayatı biraz uzaktan izleyen, duygularını derin yaşayan bir yapın olabilir. Rüyalar senin için zihinsel dinlenme alanı gibi çalışıyor.\n\nRüya günlüğü seni daha da güçlendirir.';

  @override
  String get profile8Name => 'Bilinç Eşiği Yolcusu';

  @override
  String get profile8Desc =>
      'Rüyaların çok canlı ama bazen yorucu.\n\nBilinç ile bilinçaltı arasında gidip geliyorsun. Lucid rüyaya en yakın profillerden birisin.\n\nBiraz dengeyle rüyalarını bilinçli yönetebilirsin.';

  @override
  String get surveyDisclaimer =>
      'Bu analiz bilimsel veya tıbbi bir değerlendirme değildir.\nSadece eğlence ve farkındalık amaçlıdır.';

  @override
  String get surveyResultTitle => 'Rüya Profilin';

  @override
  String get surveyContinue => 'DreamBoat\'a Başla';

  @override
  String get welcomeHeader => 'DreamBoat\'a Hoşgeldin';

  @override
  String stepProgress(Object current, Object total) {
    return 'Adım $current / $total';
  }

  @override
  String get emailLabelSupportId => 'Destek Kimliği (User ID)';

  @override
  String get emailLabelAppVersion => 'Uygulama Sürümü';

  @override
  String get emailLabelPlatform => 'Platform';

  @override
  String get emailLabelLanguage => 'Dil';

  @override
  String get biometricLockTitle => 'Rüya Günlüğünü Kilitlemek İster misin?';

  @override
  String get biometricLockMessage =>
      'Rüyaların çok kişisel olabilir.\nİstersen Rüya Günlüğü\'nü parmak izi / Face ID ile koruyabilirsin.';

  @override
  String get biometricLockYes => 'Evet, Koru';

  @override
  String get biometricLockNo => 'Şimdilik Hayır';

  @override
  String get biometricLockReason => 'Rüya Günlüğü\'ne erişmek için doğrula';

  @override
  String get biometricLockSettingsTitle => 'Rüya Günlüğü Kilidi';

  @override
  String get biometricLockSettingsSubtitle => 'Parmak izi / Face ID ile koru';

  @override
  String get biometricNotAvailable =>
      'Cihazınızda biyometrik özellik bulunamadı. Ayarlar > Güvenlik kısmından biyometrik verinizi ekleyebilirsiniz.';

  @override
  String get biometricAuthFailed => 'Doğrulama başarısız';

  @override
  String get offlineSaveTitle => 'İnternet Bağlantısı Yok';

  @override
  String get offlineSaveContent =>
      'Rüyanızı günlüğe kaydedebilirsiniz fakat şu an internet olmadığı için yorumlanamaz.';

  @override
  String get offlineSaveConfirm => 'Yorumsuz Kaydet';

  @override
  String get offlineSaveCancel => 'Vazgeç';

  @override
  String get errorNoInternet => 'İnternet bağlantısı yok.';

  @override
  String get errorGeneric => 'Beklenmedik bir hata oluştu.';

  @override
  String get dreamSavedNoInterpretation => 'Rüya günlüğe kaydedildi.';

  @override
  String get watchAdForInterpretation =>
      'AI yorumu için PRO\'ya geç veya reklam izle.';

  @override
  String get interpretationSkipped =>
      'Reklam izlenmediği için rüya yorumsuz kaydedildi.';

  @override
  String weeklyLimitLeft(int count) {
    return 'Bu hafta $count ücretsiz rüya yorumu hakkın kaldı';
  }

  @override
  String get specialOffer => '🔥 ÖZEL TEKLİF';

  @override
  String get welcomeOfferFirstTime => 'İlk abone özel teklifi';

  @override
  String welcomeOfferExpires(String time) {
    return 'Teklifin bitmesine: $time';
  }

  @override
  String streakDays(int count) {
    return '$count gün üst üste';
  }

  @override
  String get streakSubtitle => 'Rüya yolculuğun devam ediyor';

  @override
  String get proFeatureImageGenTitle => 'Günlük Rüya Görseli Oluştur';

  @override
  String get proFeatureImageGenSubtitle =>
      'Rüyalarını büyüleyici bir sanata dönüştürür. \nHer gün bir rüyanı canlandırabilirsin.';

  @override
  String get visualizeDream => 'Rüyayı Görselleştir';

  @override
  String get visualizingDream =>
      'Yapay zeka rüyanı eşsiz bir sanat eserine dönüştürüyor... Bu işlem yaklaşık 30-45 saniye sürebilir.';

  @override
  String get imageGenLimitReached => 'Günlük Limit Doldu';

  @override
  String get imageGenLimitDesc =>
      'Günde 1 rüya görseli oluşturabilirsin. Yarın görüşürüz!';

  @override
  String get imageGenLimitTrial => 'Deneme Sürümü Limiti';

  @override
  String get imageGenLimitTrialDesc =>
      'Deneme süresi 1 ücretsiz görsel içerir. Her gün görsel için PRO\'ya geç.';

  @override
  String get shareVisualizedBy => 'DreamBoat app ile Görselleştirildi';

  @override
  String get shareVisualSubject => 'Rüya Görselleştirmem';

  @override
  String get offlineImageGenTitle => 'Bağlantı Hatası';

  @override
  String get offlineImageGenContent =>
      'Görsel oluşturulamadı. İnternet bağlantını kontrol et. Limitinden düşülmedi.';

  @override
  String get limitReachedTitle => 'Limit Doldu';

  @override
  String get trialImageLimitReached =>
      'Deneme sürümündeki ücretsiz görselleştirme hakkınızı kullandınız. Trial sona erdiğinde PRO ile her gün yeni görsel oluşturabilirsiniz.';

  @override
  String get dailyImageLimitReached =>
      'Günlük görselleştirme hakkını kullandın. Yeni bir görsel için yarın tekrar gel!';

  @override
  String get visualizeDreamSubtitle =>
      'Yapay zeka ile rüyandan ilham alınan bir tablo.';

  @override
  String get cosmicConnectionTitle => 'Kozmik Bağlantı';

  @override
  String get unlockProConnection => 'Kilidi Aç';

  @override
  String dreamMoonPhasePrefix(Object phase) {
    return '(Rüyanızı Gördüğünüz Ay Evresi: $phase)';
  }
}
