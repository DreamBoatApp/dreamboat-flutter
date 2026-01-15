// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'DreamBoat';

  @override
  String get homeSubtitle => 'Embark on a Journey in Your Dream World';

  @override
  String get homeNewDream => 'Add New Dream';

  @override
  String get homeJournal => 'Dream Journal';

  @override
  String get homeStats => 'My Dream World';

  @override
  String get homeGuide => 'Lucid Dream Guide';

  @override
  String get homeSettings => 'Settings';

  @override
  String get statsTitle => 'My Dream World';

  @override
  String get statsTipTitle => 'Daily Dream Tip';

  @override
  String get statsTipContent =>
      'Today, try keeping a journal to deepen your inner journey. Connect with your childhood self seen in dreams, take a few minutes to rediscover that pure love, and write down your feelings.';

  @override
  String get statsAnalysisTitle => 'Monthly Emotion Distribution';

  @override
  String get statsAnalysisResult => 'Dream Pattern Analysis';

  @override
  String get statsAnalyzeBtn => 'See Dream Pattern';

  @override
  String get statsAnalysisIntroTitle => 'Dream Pattern Analysis';

  @override
  String get statsAnalysisIntroSubtitle => 'Can be done once a week';

  @override
  String get statsAnalysisIntroContent =>
      'Dream Pattern Analysis examines all dreams recorded in your Dream Journal together to reveal recurring themes, emotional cycles, and symbolic trends of your subconscious. Unlike individual dream interpretations, this system shows patterns formed over time, the big picture your mind is trying to tell you. It can be done only once a week to let you track changing elements more regularly over time.';

  @override
  String statsAnalysisWait(Object days) {
    return 'You must wait $days days for a new analysis.';
  }

  @override
  String get statsAnalysisMinDreams => 'At Least 5 Recorded Dreams Required';

  @override
  String get statsAnalysisDone => 'Weekly Analysis Done';

  @override
  String get statsAnalyzing => 'Analyzing...';

  @override
  String get statsOffline => 'Internet required';

  @override
  String get statsNoData => 'Not enough data';

  @override
  String get statsProcessing =>
      'Your Dream Pattern is being prepared,\nplease wait a moment.';

  @override
  String get guideTitle => 'Lucid Dream Guide';

  @override
  String get guideIntroTitle => 'What is Lucid Dreaming?';

  @override
  String get guideIntroContent =>
      'Lucid dreaming is the unique experience of becoming aware that you are dreaming and potentially controlling your dream.';

  @override
  String get moodLove => 'Love';

  @override
  String get moodHappy => 'Happiness';

  @override
  String get moodSad => 'Sadness';

  @override
  String get moodScared => 'Fear';

  @override
  String get moodAnger => 'Anger';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodPeace => 'Peace';

  @override
  String get moodAwe => 'Awe';

  @override
  String get moodAnxiety => 'Anxiety';

  @override
  String get moodConfusion => 'Confusion';

  @override
  String get moodEmpowered => 'Empowered';

  @override
  String get moodLonging => 'Longing';

  @override
  String get moodSelectPrompt =>
      'What is the first feeling when you think of this dream?';

  @override
  String get moodIntensityLabel => 'Intensity';

  @override
  String get moodIntensityLow => 'Low';

  @override
  String get moodIntensityMedium => 'Medium';

  @override
  String get moodIntensityHigh => 'High';

  @override
  String get moodVividnessLabel => 'Vividness';

  @override
  String get moodVividnessQuestion => 'How clearly do you remember the dream?';

  @override
  String get moodVividnessLow => 'Vague';

  @override
  String get moodVividnessMedium => 'Partially Clear';

  @override
  String get moodVividnessHigh => 'Very Clear';

  @override
  String get moodNotSure => 'Not Sure';

  @override
  String get moodSaving => 'Saving your dream...';

  @override
  String get newDreamModalTitle => 'Which Emotion Dominated\nThis Dream?';

  @override
  String get close => 'Close';

  @override
  String get journalTitle => 'Dream Journal';

  @override
  String get journalAll => 'All';

  @override
  String get journalFavorites => 'Favorites';

  @override
  String get journalNoDreams => 'No dreams recorded yet.';

  @override
  String get journalNoFavorites => 'No favorite dreams yet.';

  @override
  String get journalAnalysis => 'Dream Interpretation';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsVersion => 'Version 1.0.0';

  @override
  String get settingsNotifOpen => 'Enable Notifications';

  @override
  String get settingsNotifTime => 'Daily Reminder';

  @override
  String get settingsNotifDesc =>
      'Get a gentle reminder to record your dreams every morning.';

  @override
  String get settingsPrivacyTitle => 'Privacy Policy';

  @override
  String get settingsSupportTitle => 'Support';

  @override
  String get settingsAppStatus => 'Application Status';

  @override
  String get settingsSupportDesc => 'Have a question or feedback? Let us know!';

  @override
  String get settingsSend => 'Send Message';

  @override
  String get settingsSending => 'Message sent!';

  @override
  String get newDreamMinCharHint =>
      'You must enter at least 50 characters for your dream to be interpreted.';

  @override
  String get homeSpecialBadge => 'PRO';

  @override
  String get newDreamTitle => 'New Dream';

  @override
  String get newDreamSubtitle =>
      'Don\'t forget to record your dreams every day...';

  @override
  String get newDreamSave => 'Save & Interpret My Dream';

  @override
  String get newDreamPlaceholderDetail =>
      'Detail your dream here...\n\nExample: I was walking in a quiet garden full of flowers. Soft light was filtering through the leaves. Water was gently rippling in a small bird bath nearby.';

  @override
  String get newDreamPlaceholder => 'Detail your dream here...';

  @override
  String get guideCompletionTitle => 'Congratulations!';

  @override
  String get guideCompletionContent =>
      'You have completed all stages of the Lucid Dream Guide.';

  @override
  String get guideStage1Title =>
      '1. MILD Technique (Mnemonic Induction of Lucid Dreams)';

  @override
  String get guideStage1Subtitle =>
      'Planting the Seed of Awakening in Your Dreams';

  @override
  String get guideStage1Content =>
      'This is the starting point of the lucid dreaming journey. MILD, or \"Mnemonic Induction of Lucid Dreams\", is a technique of planting a clear intention into the subconscious before falling asleep. This intention allows you to catch the awareness of \"I am dreaming\" during a dream. We will open the first door to conscious dreaming at this stage.';

  @override
  String get guideStage1Importance =>
      'MILD uses the mind\'s ability to recall and form intentions to prepare a mental ground for lucid dreaming. By activating the hippocampus and prefrontal cortex, it increases the probability of being conscious in a dream.';

  @override
  String get guideStage1Steps =>
      'After waking from a dream at night, try to recall your last dream in detail.\nRepeat this sentence to yourself: \"In my next dream, I will realize that I am dreaming.\"\nVisualize this scene in your mind. Imagine yourself being aware in the dream.\nClose your eyes and go back to sleep with this intention.\nWrite in detail in your dream journal when you wake up in the morning.';

  @override
  String get guideStage1Criteria =>
      'If you realized you were dreaming at least once in a week, you can proceed to the next stage.';

  @override
  String get guideStage1BrainNote =>
      'This is a journey of awakening. In the first step, you start training your mind. Every repetition means conscious dreams are one step closer. Remember, patience and repetition are your greatest allies.';

  @override
  String get guideStage2Title => '2. WBTB (Wake Back To Bed)';

  @override
  String get guideStage2Subtitle => 'Opening the Door to Conscious Dreaming';

  @override
  String get guideStage2Content =>
      'You have formed your mental intention. Now, we will learn to consciously re-enter the REM phase where dreams are most intense. The WBTB technique significantly increases lucid dream potential by allowing you to fall back asleep in a semi-awake state.';

  @override
  String get guideStage2Importance =>
      'With WBTB, your brain stays between wakefulness and sleep. This transition point provides the most suitable mental environment for lucid dreams.';

  @override
  String get guideStage2Steps =>
      'Set an alarm to wake up 4–6 hours after falling asleep.\nRead a book in low light, meditate, or repeat MILD for 15–30 minutes.\nAt the end of this time, lie down again and fall asleep with the MILD intention.';

  @override
  String get guideStage2Criteria =>
      'If you gained awareness of your surroundings in your dream at least 2 nights in a week, you can proceed to the next stage.';

  @override
  String get guideStage2BrainNote =>
      'You are opening your mind a little more. The veil between dream and reality is thinning. You are about to meet the dream with wakefulness.';

  @override
  String get guideStage3Title => '3. WILD (Wake Initiated Lucid Dream)';

  @override
  String get guideStage3Subtitle =>
      'Direct Entry into Dream with Consciousness';

  @override
  String get guideStage3Content =>
      'One of the most impressive techniques of lucid dreaming, WILD takes you directly into the dream realm consciously. You allow your body to sleep while your mind stays awake before sleeping, and you transition into the dream without even blinking.';

  @override
  String get guideStage3Importance =>
      'WILD requires simultaneous execution of mental clarity and physical relaxation. This technique is different from others as you enter the dream directly and requires a high level of practice.';

  @override
  String get guideStage3Steps =>
      'Apply after WBTB.\nLie down, relax your entire body.\nFocus on your breath, keep your mind active.\nYou may see lights, patterns while your eyes are closed — watch calmly.\nTake control when you realize the dream has started.';

  @override
  String get guideStage3Criteria =>
      'If you have transitioned directly into a dream consciously at least once in 2 weeks, you are ready for stage 4.';

  @override
  String get guideStage3BrainNote =>
      'Now you are on the threshold of mastery. You are learning to close your eyes and open them in another world. Remember, this technique requires a lot of practice and patience is your greatest ally.';

  @override
  String get guideStage4Title => '4. Time Awareness and Reality Checks';

  @override
  String get guideStage4Subtitle => 'Mastering Our Perception of Reality';

  @override
  String get guideStage4Content =>
      'Awareness of lucid dreams has started. Now it\'s time to deepen this awareness and use the concept of time-space in the dream. The goal at this stage: to remember concepts such as year, age, date while dreaming.';

  @override
  String get guideStage4Importance =>
      'Reality checks make it easier to realize you are dreaming. Time perception shows the depth of mental awareness.';

  @override
  String get guideStage4Steps =>
      'Ask \"Am I dreaming right now?\" at least 5–10 times a day.\nDo tests like counting fingers, re-reading text.\nBefore sleeping, repeat the intention: \"I will notice what year I am in in my dream.\"';

  @override
  String get guideStage4Criteria =>
      'If you experienced time-related awareness in your dream 3 nights in a week (e.g., year, birthday, calendar) → you can proceed to the next stage.';

  @override
  String get guideStage4BrainNote =>
      'You are aware not only that you are in a dream but also of the time in the dream. Your mind has started to move to a new dimension.';

  @override
  String get guideStage5Title => '5. Sleep Routine Optimization';

  @override
  String get guideStage5Subtitle => 'Preparing the Ground for Lucid Dreaming';

  @override
  String get guideStage5Content =>
      'At this stage, we take a break from direct lucid dream attempts. It is time to build a regular sleep routine to support the brain\'s basic mechanism and deepen mental clarity.';

  @override
  String get guideStage5Importance =>
      'Regular sleep and an ideal environment directly affect lucid dreaming success. A regular rhythm is required for the healthy progression of REM duration.';

  @override
  String get guideStage5Steps =>
      'Create a sleep-wake schedule at the same time every day.\nDo a digital detox 1 hour before bed.\nTake care to sleep in a quiet, dark, cool room.\nCalm the mind with short meditations.';

  @override
  String get guideStage5Criteria =>
      'If you kept a dream journal for 7 nights over 10 days and experienced awareness signals in 3 of your dreams → you can proceed to the next stage.';

  @override
  String get guideStage5BrainNote =>
      'A building cannot exist without a foundation. This stage establishes a solid ground for your conscious dreams. Remember, a rested mind means a conscious mind.';

  @override
  String get guideStage6Title => '6. Dopamine Balance';

  @override
  String get guideStage6Subtitle => 'Balancing Mind Chemistry';

  @override
  String get guideStage6Content =>
      'Your mind has now met lucid dreaming. At this stage, we take a step back from dream practice and prepare the environment that will increase the quality of lucid dreams by regulating your mental chemistry.';

  @override
  String get guideStage6Importance =>
      'Dopamine is the center of motivation, imagination, and the reward system. Excessive stimuli disrupt this balance and reduce dream clarity.';

  @override
  String get guideStage6Steps =>
      'Limit your social media time to 1 hour for 5 days.\nGet light exercise, walk, and sunlight.\nEat rich in Omega-3, stay away from sugar.\nDo focus exercises before sleep.';

  @override
  String get guideStage6Criteria =>
      'If you consciously managed the environment, light, or an object in 2 lucid dreams in a week, you can proceed to the final stage.';

  @override
  String get guideStage6BrainNote =>
      'You didn\'t just train your mind, you optimized its biological structure. Now conscious dreams are not just possible; they are becoming your nature.';

  @override
  String get guideStage7Title =>
      '7. Advanced Consciousness and Creative Manipulation';

  @override
  String get guideStage7Subtitle => 'Becoming the Master of the Dream';

  @override
  String get guideStage7Content =>
      'We have come to the end of the journey. At this point, you will not only be lucid but reach the level to consciously change the dream content. It is time to freely create your dream world.';

  @override
  String get guideStage7Importance =>
      'With this technique, you can access the subconscious, face fears, and test everything you imagine. This is a revolution both mentally and spiritually.';

  @override
  String get guideStage7Steps =>
      'Write down and imagine the scenario you want to do in the dream in detail.\nConsciously change the place, time, character, or outcome in the dream.\nAdd mindfulness meditations to your daily routine.';

  @override
  String get guideStage7Criteria =>
      'If you have performed active manipulation in at least 2 dreams in 2 weeks (flying, changing the environment, summoning something), you are a lucid dreaming master.';

  @override
  String get guideStage7BrainNote =>
      'At the end of this journey, not only conscious dreams but the limitless potential of your imagination awaits you. You are now creating life not only when awake but also when asleep.';

  @override
  String get guideAppBarTitle => 'Lucid Dream Guide';

  @override
  String get guideIntroTitle1 => 'What is Lucid Dreaming?';

  @override
  String get guideIntroContent1 =>
      'Lucid dreaming is a unique sleep experience where you become aware that you are dreaming and can consciously guide the dream.';

  @override
  String get guideIntroListTitle => 'In a Lucid Dream state:';

  @override
  String get guideIntroBullet1 => 'You are conscious during the dream.';

  @override
  String get guideIntroBullet2 => 'You can evaluate your surroundings.';

  @override
  String get guideIntroBullet3 => 'Your decision-making ability increases.';

  @override
  String get guideIntroBullet4 => 'You can change the flow of the dream.';

  @override
  String get guideIntroFooter =>
      'Lucid dreaming is a skill that some of us experience by chance at some point in our lives, but can be learned with the right techniques.';

  @override
  String get guideIntroTitle2 => 'What is Lucid Dreaming Good For?';

  @override
  String get guideBenefit1 => 'Managing Your Dreams';

  @override
  String get guideBenefit2 => 'Exploring the Subconscious';

  @override
  String get guideBenefit3 => 'Mastering Sleep';

  @override
  String get guideBenefit4 => 'Coping with Stress';

  @override
  String get guideIntroContent2 =>
      'Lucid dreams open the doors of the subconscious, carrying you to a higher level of awareness. This experience eventually reflects on your daily life.';

  @override
  String get guideIntroTitle3 => 'How to Use This Guide?';

  @override
  String get guideIntroContent3 =>
      'This guide is built on a special 7-stage lucid dream system. At each stage, you will acquire a powerful habit that will directly affect your dreams.';

  @override
  String get guideIntroGainTitle => 'What You Will Gain As You Progress:';

  @override
  String get guideIntroGain1 => 'Manage Dreams';

  @override
  String get guideIntroGain2 => 'Explore Subconscious';

  @override
  String get guideIntroGain3 => 'Master Sleep';

  @override
  String get guideIntroGain4 => 'Handle Stress';

  @override
  String get guideBuyButton => 'Unlock Full Guide';

  @override
  String get guideNo => 'No';

  @override
  String get guideYes => 'Yes';

  @override
  String get guideDebugResetTitle => 'Reset Guide?';

  @override
  String get guideDebugResetContent =>
      'This will lock all stages except the first one. (Debug)';

  @override
  String get journalDeleteTitle => 'Delete Dream?';

  @override
  String get journalDeleteContent =>
      'Are you sure you want to delete this dream? This action cannot be undone.';

  @override
  String get journalDeleteConfirm => 'Delete';

  @override
  String get journalDeleteCancel => 'Cancel';

  @override
  String get proVersion => 'PRO';

  @override
  String get standardVersion => 'Standard';

  @override
  String get upgradeTitle => 'Upgrade to DreamBoat PRO';

  @override
  String get upgradeBenefits =>
      'Ad-Free Experience\nFull Dream Analysis\nUnlimited Dream Interpretation\nExclusive Guide Access';

  @override
  String get upgradeBtn => 'Unlock DreamBoat PRO (88.99 ₺)';

  @override
  String get upgradeCancel => 'Maybe later';

  @override
  String get upgradeSuccess => 'Welcome to DreamBoat PRO!';

  @override
  String get upgradeStart => 'Start';

  @override
  String get proRequired => 'PRO Version Required';

  @override
  String get proRequiredDetail =>
      'PRO Version and At Least 5 Recorded Dreams Required';

  @override
  String get guideUnlockPro => 'Unlock PRO Version';

  @override
  String get guideUnlockHint => 'You must upgrade to PRO to unlock the guide.';

  @override
  String get guideContent => 'Content';

  @override
  String get guideImportance => 'Why is it Important?';

  @override
  String get guideSteps => 'Steps';

  @override
  String get guideCriteria => 'Completion Criteria';

  @override
  String get guideBrainNoteTitle => 'Note to Brain';

  @override
  String get guideNextStep => 'Next Step';

  @override
  String get guideDialogTitle => 'Unlock Next Stage?';

  @override
  String get guideDialogContent =>
      'Moving to the next stage without completing the current step may harm your journey. Are you sure you want to proceed?';

  @override
  String get guideDialogCancel => 'Wait';

  @override
  String get guideDialogConfirm => 'I\'m Ready';

  @override
  String get guideStart => 'Start Guide';

  @override
  String get privacyTitle => 'Privacy and GDPR';

  @override
  String get privacyNoticeTitle => 'NovaBloom Studio Privacy Notice';

  @override
  String get privacyNoticeContent =>
      'At NovaBloom Studio, we value your privacy at the highest level. DreamBoat is designed for you to safely record and analyze your dreams.';

  @override
  String get privacySection1Title => '1. Data Security and Processing:';

  @override
  String get privacySection1Content =>
      'Your dreams are stored encrypted. Data sent for AI analysis is anonymized and never used for training AI models. Your data is protected in compliance with GDPR and KVKK standards.';

  @override
  String get privacySection2Title => '2. Account and Usage:';

  @override
  String get privacySection2Content =>
      'The app is used completely anonymously and does not require any membership. Your personal data and dream records are only stored on your device. There is no account creation process or personal data collection.';

  @override
  String get privacySection3Title => '3. Contact:';

  @override
  String get privacySection3Content =>
      'For any questions, suggestions, and data requests, you can contact us at info@novabloomstudio.com.';

  @override
  String get privacySection4Title =>
      '4. Health and Medical Disclaimer (IMPORTANT):';

  @override
  String get privacySection4Content =>
      'This app is not a medical device. Dream interpretations and analyses provided are solely for entertainment and personal development purposes and do not constitute medical advice. Our app does not collect or process any biometric or health data.';

  @override
  String get supportTitle => 'Contact Us';

  @override
  String get supportContent =>
      'Your feedback is very valuable to NovaBloom Studio.\n\nYou can send us an email for suggestions, bug reports, or collaboration requests.';

  @override
  String get supportSendEmail => 'Send Email';

  @override
  String get supportEmailNotFound => 'Email app not found.';

  @override
  String get debugResetTitle => 'Debug Reset';

  @override
  String get debugResetContent =>
      'Do you want to restore the app to Standard version?';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get standard => 'STANDARD';

  @override
  String get save => 'Save';

  @override
  String get timeFormat24h => '24-Hour Format';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get languageEnglish => 'English';

  @override
  String get guideSlide1Title => 'The Wisdom of Ancient Egypt';

  @override
  String get guideSlide1Subtitle => 'Gateway to the Soul\'s Journey';

  @override
  String get guideSlide1Content1 =>
      'Traces of what we call lucid dreaming today could be seen in Ancient Egypt. The Egyptians interpreted dreaming as a conscious experience within the framework of the cultural and spiritual beliefs of the period.\n\nIndeed, symbolic narratives exist describing Pharaohs interacting with divine figures in the dream realm through priests.';

  @override
  String get guideSlide1Content2 =>
      'In modern medicine, sleep research in the field of somnology has observed that the frontal cortex is active during REM sleep, meaning the areas of the brain associated with consciousness and awareness work similarly to when awake. These findings are interpreted as bearing some conceptual similarities to the conscious experience narratives attributed to dreaming in Ancient Egypt.';

  @override
  String get guideSlide2Title => 'Meditations of Tibetan Monks';

  @override
  String get guideSlide2Subtitle => 'Transcending the Limits of the Mind';

  @override
  String get guideSlide2Content1 =>
      'Tibetan monks, through deep meditation practices lasting a lifetime, treated lucid dreaming as an inner experience aimed at increasing mental awareness.\n\nHigh in the Himalayas, monks exploring the layers of the mind supported conscious dream experiences with mental discipline and traditional practices.';

  @override
  String get guideSlide2Content2 =>
      'In recent neurological studies, the relationship between meditation practices and sleep awareness has been examined.\n\nIn light of these ancient traditions, this special guide we prepared aims to awaken this potential in the depths of your mind and carry your awareness to the dream realm. You can start the journey of becoming the conscious architect of your own inner world, leaving behind being just a spectator in your dreams.';

  @override
  String get guideSlide3Title => 'The Secret of Dreamcatchers';

  @override
  String get guideSlide3Subtitle => 'Guardian of Conscious Dreams';

  @override
  String get guideSlide3Content1 =>
      'In Native American cultures, the dreamcatcher was seen as a symbolic object associated with lucid dreams.\n\nThis practice, passed down through generations, was interpreted as a cultural symbol representing dream experiences. Under the guidance of shamans, the dreamcatcher was valued as a symbol associated with conscious awareness and symbolizing spiritual connections.';

  @override
  String get guideSlide3Content2 =>
      'In the modern information age, lucid dreaming is treated not only as a mystical experience of ancient cultures but also as a consciousness experience studied in modern scientific research.\n\nIn this lucid dreaming guide, created by compiling the most current research and teachings passed down from generation to generation, it is possible for you to discover different experiences by deepening your mental awareness.';

  @override
  String get guideSlide4Title => 'Lucid Dream Guide';

  @override
  String get guideSlide4Content =>
      'How to Use This Guide?\n\nThis guide is built on a special 7-stage lucid dream system.\nIn each stage, you develop powerful habits that support dream awareness.';

  @override
  String get guideSlide4GainsTitle => 'What You Will Gain As You Progress';

  @override
  String get guideSlide4Gain1 => 'You access the deep layers of your dreams';

  @override
  String get guideSlide4Gain2 => 'Your consciousness begins to guide dreams';

  @override
  String get guideSlide4Gain3 =>
      'Places and people take shape according to you';

  @override
  String get guideSlide4Gain4 => 'You gain more awareness over your dreams.';

  @override
  String get guideSlide4ProRequired =>
      'You must have the PRO version to access the guide.';

  @override
  String get guideSlide4UnlockButton => 'Unlock PRO Version';

  @override
  String get guideCompleted =>
      'Congratulations! You\'ve completed the entire guide.';

  @override
  String get delete => 'Delete';

  @override
  String get actionFavorite => 'Favorite';

  @override
  String get understand => 'I Understand, Continue';

  @override
  String get error => 'Error';

  @override
  String get testNotification => 'Send Test Notification';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get journalSearchHint => 'Search your dreams...';

  @override
  String get newDreamLoadingText => 'Preparing your dream interpretation...';

  @override
  String get dreamInterpretationTitle => 'Dream Interpretation';

  @override
  String get dreamInterpretationReadMore => 'Read More';

  @override
  String get dreamTooShort => 'Dream was too short to interpret.';

  @override
  String get dailyLimitReached =>
      'You\'ve reached the daily dream interpretation limit (100/100).';

  @override
  String get settingsRestorePurchases => 'Restore Purchases';

  @override
  String get restoreSuccess => 'PRO version restored successfully!';

  @override
  String get restoreNotFound => 'No previous purchases found.';

  @override
  String get restoreError => 'Failed to restore purchases. Please try again.';

  @override
  String get restoreUnavailable =>
      'Store is currently unavailable. Please try again later.';

  @override
  String get restoring => 'Restoring...';

  @override
  String get offlineInterpretation =>
      'Dream could not be interpreted due to no internet connection.';

  @override
  String get offlinePurchase =>
      'Internet connection is required to make a purchase.';

  @override
  String get offlineAnalysis => 'Internet connection is required for analysis.';

  @override
  String get proUpgradeSubtitle =>
      'No subscription. One-time purchase, lifetime access.';

  @override
  String get proFeatureAdsTitle => 'Ad-Free Experience';

  @override
  String get proFeatureAdsSubtitle =>
      'Focus only on your dreams and your dream world.';

  @override
  String get proFeatureAnalysisTitle => 'Weekly Dream Pattern Analysis';

  @override
  String get proFeatureAnalysisSubtitle =>
      'Uncover hidden connections between your dreams. Discover recurring themes, emotions, and subconscious messages over time.';

  @override
  String get proFeatureGuideTitle => 'Lucid Dream Guide';

  @override
  String get proFeatureGuideSubtitle =>
      'Take control of your dreams. Step-by-step guided lucid dream techniques from beginner to advanced.';

  @override
  String get proProcessing => 'Processing...';

  @override
  String get notifDialogTitle => 'Enable Notifications';

  @override
  String get notifDialogBody =>
      'Allow DreamBoat to remind you to record your dreams every morning.';

  @override
  String get notifPermissionDenied => 'Notification Permission Denied';

  @override
  String get notifOpenSettings => 'Open Settings';

  @override
  String get notifOpenSettingsHint =>
      'You need to enable notifications in settings.';

  @override
  String get allow => 'Allow';

  @override
  String get notifReminderBody => 'Don\'t forget to record your dream! 🌙';

  @override
  String get pressBackToExit => 'Press back again to exit';

  @override
  String get moonSyncTitle => 'Moon & Planet Synchronization';

  @override
  String get moonSyncSubtitle => 'Can be done once a month';

  @override
  String get moonSyncDescription =>
      'Moon & Planet Synchronization analyzes your subconscious emotional fluctuations by matching your dreams with the Moon’s phase and any cosmic events (Blue Moon, Super Moon, eclipses) of the last month. It correlates your dreams\' word count, emotional intensity, and mood tags with the lunar cycle, offering advice for alignment. This lets you understand not just dream content but the cosmic influence on you. Done only once a month to help you track changing effects and align with the Moon’s cycle.';

  @override
  String get moonSyncBtn => 'Start Cosmic Analysis';

  @override
  String moonSyncWait(int days) {
    return 'You must wait $days days for a new analysis.';
  }

  @override
  String get moonSyncMinDreams => 'At Least 5 Recorded Dreams Required';

  @override
  String get moonSyncDone => 'Monthly Cosmic Analysis Done';

  @override
  String get moonSyncProcessing =>
      'Cosmic Analysis is being prepared,\nplease wait.';

  @override
  String get moonPhaseNewMoon => 'New Moon';

  @override
  String get moonPhaseWaxingCrescent => 'Waxing Crescent';

  @override
  String get moonPhaseFirstQuarter => 'First Quarter';

  @override
  String get moonPhaseWaxingGibbous => 'Waxing Gibbous';

  @override
  String get moonPhaseFullMoon => 'Full Moon';

  @override
  String get moonPhaseWaningGibbous => 'Waning Gibbous';

  @override
  String get moonPhaseThirdQuarter => 'Third Quarter';

  @override
  String get moonPhaseWaningCrescent => 'Waning Crescent';

  @override
  String get actionShareInterpretation => 'Share\nInterpretation';

  @override
  String get sharePrivacyHint =>
      'Note: The Share Interpretation button only shares the dream interpretation. Your dreams belong to you and are never shared with third parties.';

  @override
  String get moonPhaseLabel => 'Moon Phase:';

  @override
  String get readMore => 'Read More...';

  @override
  String get tapForDetails => 'Tap for details...';

  @override
  String nSelected(int count) {
    return '$count Selected';
  }

  @override
  String get shareCardHeader => 'MY DAILY DREAM INTERPRETATION';

  @override
  String get shareCardWatermark => 'Interpreted with DreamBoat App';

  @override
  String get subscriptionComingSoon => 'Subscription system coming very soon!';

  @override
  String get subscribeMonthly => 'Subscribe Monthly';

  @override
  String get subscribeYearly => 'Subscribe Yearly';

  @override
  String get planMonthly => 'MONTHLY';

  @override
  String get planAnnual => 'ANNUAL';

  @override
  String get mostPopular => 'MOST POPULAR';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get billingMonthly => 'Recurring monthly payment. Cancel anytime.';

  @override
  String get billingAnnual =>
      'Billed as one payment. Recurring annual payment.';

  @override
  String get proFeatureAds => 'Ad-Free Experience';

  @override
  String get proFeatureAnalysis => 'Weekly Pattern Analysis';

  @override
  String get proFeatureGuide => 'Lucid Dream Guide';

  @override
  String get proFeatureMoonSync => 'Moon & Planet Synchronization';

  @override
  String get freeTrialDays => 'Days Free Trial';

  @override
  String get then => 'Then';

  @override
  String get reviewSatisfactionTitle => 'Enjoying DreamBoat?';

  @override
  String get reviewSatisfactionContent => 'Share your experience with us!';

  @override
  String get reviewOptionYes => 'Yes, loved it!';

  @override
  String get reviewOptionNeutral => 'It\'s okay';

  @override
  String get reviewOptionNo => 'No, not really';

  @override
  String get reviewFeedbackTitle => 'Your feedback matters';

  @override
  String get reviewFeedbackContent =>
      'How can we improve? Feel free to write to us.';

  @override
  String get reviewFeedbackButton => 'Contact Us';

  @override
  String get reviewCancel => 'Cancel';

  @override
  String get adConsentTitle => 'One More Dream Interpretation ✨';

  @override
  String get adConsentBody =>
      'DreamBoat offers free dream interpretations. To sustain this, a short video will be shown before each interpretation.';

  @override
  String get adConsentWatch => 'Watch Ad & Get Interpretation';

  @override
  String get adConsentPro => 'Upgrade to PRO (Ad-Free)';

  @override
  String get adLoadError =>
      'The ad could not be loaded at the moment. You can try again shortly or upgrade to PRO.';

  @override
  String get adRetry => 'Retry';

  @override
  String get intensityFeltLight => 'Felt lightly';

  @override
  String get intensityFeltMedium => 'Felt moderately';

  @override
  String get intensityFeltIntense => 'Felt intensely';

  @override
  String get statsDreamLabel => 'Dreams';

  @override
  String statsRecordedDreams(Object count) {
    return 'Recorded dreams: $count';
  }
}
