// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeTitle => 'DreamBoat';

  @override
  String get homeSubtitle => 'Emprende un Viaje en Tu Mundo de Sueños';

  @override
  String get homeNewDream => 'Añadir Nuevo Sueño';

  @override
  String get homeJournal => 'Diario de Sueños';

  @override
  String get homeStats => 'Mi Mundo de Sueños';

  @override
  String get homeGuide => 'Guía de Sueños Lúcidos';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get statsTitle => 'Mi Mundo de Sueños';

  @override
  String get statsTipTitle => 'Consejo del Día';

  @override
  String get statsTipContent =>
      'Hoy, intenta llevar un diario para profundizar tu viaje interior. Conecta con tu yo infantil visto en los sueños, tómate unos minutos para redescubrir ese amor puro y escribe tus sentimientos.';

  @override
  String get statsAnalysisTitle => 'Distribución Emocional Mensual';

  @override
  String get statsAnalysisResult => 'Análisis de Patrones de Sueños';

  @override
  String get statsAnalyzeBtn => 'Ver Patrón de Sueños';

  @override
  String get statsAnalysisIntroTitle => 'Análisis de Patrones de Sueños';

  @override
  String get statsAnalysisIntroSubtitle =>
      'Se puede realizar una vez por semana';

  @override
  String get statsAnalysisIntroContent =>
      'El Análisis de Patrones de Sueños examina tus sueños semanales registrados en conjunto para revelar temas recurrentes, ciclos emocionales y tendencias simbólicas de tu subconsciente. A diferencia de las interpretaciones individuales, este sistema muestra patrones formados con el tiempo, el panorama general que tu mente intenta comunicarte. Se puede realizar solo una vez a la semana para que puedas seguir los elementos cambiantes con mayor regularidad a lo largo del tiempo.';

  @override
  String statsAnalysisWait(Object days) {
    return 'Debes esperar $days días para un nuevo análisis.';
  }

  @override
  String get statsAnalysisMinDreams =>
      'Se Requieren Al Menos 5 Sueños Registrados';

  @override
  String get statsAnalysisDone => 'Análisis Semanal Completado';

  @override
  String get statsAnalyzing => 'Analizando...';

  @override
  String get statsOffline => 'Se requiere internet';

  @override
  String get statsNoData => 'Datos insuficientes';

  @override
  String get statsProcessing =>
      'Tu Patrón de Sueños se está preparando,\npor favor espera un momento.';

  @override
  String get guideTitle => 'Guía de Sueños Lúcidos';

  @override
  String get guideIntroTitle => '¿Qué son los Sueños Lúcidos?';

  @override
  String get guideIntroContent =>
      'Los sueños lúcidos son la experiencia única de darte cuenta de que estás soñando y potencialmente controlar tu sueño.';

  @override
  String get moodLove => 'Amor';

  @override
  String get moodHappy => 'Felicidad';

  @override
  String get moodSad => 'Tristeza';

  @override
  String get moodScared => 'Miedo';

  @override
  String get moodAnger => 'Ira';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodPeace => 'Paz';

  @override
  String get moodAwe => 'Asombro';

  @override
  String get moodAnxiety => 'Ansiedad';

  @override
  String get moodConfusion => 'Confusión';

  @override
  String get moodEmpowered => 'Empoderado';

  @override
  String get moodLonging => 'Nostalgia';

  @override
  String get feltMood => 'Emoción:';

  @override
  String get moodSelectPrompt => '¿Qué sientes al pensar en este sueño?';

  @override
  String get moodIntensityLabel => 'Intensidad';

  @override
  String get moodIntensityLow => 'Baja';

  @override
  String get moodIntensityMedium => 'Media';

  @override
  String get moodIntensityHigh => 'Alta';

  @override
  String get moodVividnessLabel => 'Vivacidad';

  @override
  String get moodVividnessQuestion => '¿Qué tan claro lo recuerdas?';

  @override
  String get moodVividnessLow => 'Vago';

  @override
  String get moodVividnessMedium => 'Parcial';

  @override
  String get moodVividnessHigh => 'Muy Claro';

  @override
  String get moodNotSure => 'No Estoy Seguro';

  @override
  String get moodSaving => 'Guardando tu sueño...';

  @override
  String get newDreamModalTitle => '¿Qué Emoción Dominó\nEste Sueño?';

  @override
  String get close => 'Cerrar';

  @override
  String get journalTitle => 'Diario de Sueños';

  @override
  String get journalAll => 'Todos';

  @override
  String get journalFavorites => 'Favoritos';

  @override
  String get journalNoDreams => 'Aún no hay sueños registrados.';

  @override
  String get journalNoFavorites => 'Aún no hay sueños favoritos.';

  @override
  String get journalAnalysis => 'Interpretación del Sueño';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsPrivacy => 'Política de Privacidad';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsVersion => 'Versión:';

  @override
  String get settingsNotifOpen => 'Activar Notificaciones';

  @override
  String get settingsNotifTime => 'Recordatorio Diario';

  @override
  String get settingsNotifDesc =>
      'Recibe un recordatorio suave para registrar tus sueños cada mañana.';

  @override
  String get settingsPrivacyTitle => 'Política de Privacidad';

  @override
  String get settingsSupportTitle => 'Soporte';

  @override
  String get settingsAppStatus => 'Estado de la Aplicación';

  @override
  String get settingsSupportDesc =>
      '¿Tienes una pregunta o comentario? ¡Cuéntanos!';

  @override
  String get settingsSend => 'Enviar Mensaje';

  @override
  String get settingsSending => '¡Mensaje enviado!';

  @override
  String get newDreamMinCharHint =>
      'Debes introducir al menos 50 caracteres para que tu sueño sea interpretado.';

  @override
  String get homeSpecialBadge => 'PRO';

  @override
  String get newDreamTitle => 'Nuevo Sueño';

  @override
  String get newDreamSubtitle => 'No olvides registrar tus sueños cada día...';

  @override
  String get newDreamSave => 'Guardar e Interpretar Mi Sueño';

  @override
  String get newDreamPlaceholderDetail =>
      'Detalla tu sueño aquí...\n\nEjemplo: Estaba caminando en un jardín tranquilo lleno de flores. Una luz suave se filtraba entre las hojas. El agua se ondulaba suavemente en una pequeña fuente cercana.';

  @override
  String get newDreamPlaceholder => 'Detalla tu sueño aquí...';

  @override
  String get guideCompletionTitle => '¡Felicidades!';

  @override
  String get guideCompletionContent =>
      'Has completado todas las etapas de la Guía de Sueños Lúcidos.\n\n¡Ahora, dominando todas las técnicas, puedes moverte libremente en el mundo de los Sueños Lúcidos!';

  @override
  String get guideStage1Title =>
      '1. Técnica MILD (Inducción Mnemónica de Sueños Lúcidos)';

  @override
  String get guideStage1Subtitle =>
      'Plantando la Semilla del Despertar en Tus Sueños';

  @override
  String get guideStage1Content =>
      'Este es el punto de partida del viaje de sueños lúcidos. MILD, o \"Inducción Mnemónica de Sueños Lúcidos\", es una técnica de plantar una intención clara en el subconsciente antes de dormir. Esta intención te permite captar la conciencia de \"Estoy soñando\" durante un sueño. Abriremos la primera puerta a los sueños conscientes en esta etapa.';

  @override
  String get guideStage1Importance =>
      'MILD utiliza la capacidad de la mente para recordar y formar intenciones para preparar un terreno mental para los sueños lúcidos. Al activar el hipocampo y la corteza prefrontal, aumenta la probabilidad de ser consciente en un sueño.';

  @override
  String get guideStage1Steps =>
      'Después de despertar de un sueño por la noche, intenta recordar tu último sueño en detalle.\nRepite esta frase para ti mismo: \"En mi próximo sueño, me daré cuenta de que estoy soñando.\"\nVisualiza esta escena en tu mente. Imagínate siendo consciente en el sueño.\nCierra los ojos y vuelve a dormir con esta intención.\nEscribe en detalle en tu diario de sueños cuando despiertes por la mañana.';

  @override
  String get guideStage1Criteria =>
      'Si te diste cuenta de que estabas soñando al menos una vez en una semana, puedes pasar a la siguiente etapa.';

  @override
  String get guideStage1BrainNote =>
      'Este es un viaje de despertar. En el primer paso, comienzas a entrenar tu mente. Cada repetición significa que los sueños conscientes están un paso más cerca. Recuerda, la paciencia y la repetición son tus mayores aliados.';

  @override
  String get guideStage2Title => '2. WBTB (Despertar para Volver a la Cama)';

  @override
  String get guideStage2Subtitle =>
      'Abriendo la Puerta a los Sueños Conscientes';

  @override
  String get guideStage2Content =>
      'Has formado tu intención mental. Ahora, aprenderemos a reingresar conscientemente a la fase REM donde los sueños son más intensos. La técnica WBTB puede apoyar la conciencia de sueños lúcidos al permitirte volver a dormir en un estado semi-despierto.';

  @override
  String get guideStage2Importance =>
      'Con WBTB, tu cerebro permanece entre la vigilia y el sueño. Este punto de transición proporciona el entorno mental más adecuado para los sueños lúcidos.';

  @override
  String get guideStage2Steps =>
      'Configura una alarma para despertar 4-6 horas después de dormirte.\nLee un libro con poca luz, medita o repite MILD durante 15-30 minutos.\nAl final de este tiempo, acuéstate de nuevo y duerme con la intención MILD.';

  @override
  String get guideStage2Criteria =>
      'Si ganaste conciencia de tu entorno en tu sueño al menos 2 noches en una semana, puedes pasar a la siguiente etapa.';

  @override
  String get guideStage2BrainNote =>
      'Estás abriendo tu mente un poco más. El velo entre el sueño y la realidad se está adelgazando. Estás a punto de encontrar el sueño con la vigilia.';

  @override
  String get guideStage3Title => '3. WILD (Sueño Lúcido Iniciado Despierto)';

  @override
  String get guideStage3Subtitle => 'Entrada Directa al Sueño con Conciencia';

  @override
  String get guideStage3Content =>
      'Una de las técnicas más impresionantes de los sueños lúcidos, WILD te lleva directamente al reino de los sueños conscientemente. Permites que tu cuerpo duerma mientras tu mente permanece despierta antes de dormir, y puedes notar más claramente cuándo comienza el sueño.';

  @override
  String get guideStage3Importance =>
      'WILD requiere la ejecución simultánea de claridad mental y relajación física. Esta técnica es diferente de otras ya que entras al sueño directamente y requiere un alto nivel de práctica.';

  @override
  String get guideStage3Steps =>
      'Aplica después de WBTB.\nAcuéstate, relaja todo tu cuerpo.\nConcéntrate en tu respiración, mantén tu mente activa.\nPuedes ver luces, patrones mientras tus ojos están cerrados — observa con calma.\nToma el control cuando te des cuenta de que el sueño ha comenzado.';

  @override
  String get guideStage3Criteria =>
      'Si has transitado directamente a un sueño conscientemente al menos una vez en 2 semanas, estás listo para la etapa 4.';

  @override
  String get guideStage3BrainNote =>
      'Ahora estás en el umbral de la maestría. Estás aprendiendo a cerrar los ojos y abrirlos en otro mundo. Recuerda, esta técnica requiere mucha práctica y la paciencia es tu mayor aliado.';

  @override
  String get guideStage4Title =>
      '4. Conciencia del Tiempo y Verificaciones de Realidad';

  @override
  String get guideStage4Subtitle =>
      'Dominando Nuestra Percepción de la Realidad';

  @override
  String get guideStage4Content =>
      'La conciencia de los sueños lúcidos ha comenzado. Ahora es el momento de profundizar esta conciencia y usar el concepto de tiempo-espacio en el sueño. El objetivo en esta etapa: recordar conceptos como año, edad, fecha mientras sueñas.';

  @override
  String get guideStage4Importance =>
      'Las verificaciones de realidad facilitan darte cuenta de que estás soñando. La percepción del tiempo muestra la profundidad de la conciencia mental.';

  @override
  String get guideStage4Steps =>
      'Pregunta \"¿Estoy soñando ahora mismo?\" al menos 5-10 veces al día.\nHaz pruebas como contar dedos, releer texto.\nAntes de dormir, repite la intención: \"Notaré en qué año estoy en mi sueño.\"';

  @override
  String get guideStage4Criteria =>
      'Si experimentaste conciencia relacionada con el tiempo en tu sueño 3 noches en una semana (ej., año, cumpleaños, calendario) → puedes pasar a la siguiente etapa.';

  @override
  String get guideStage4BrainNote =>
      'Eres consciente no solo de que estás en un sueño sino también del tiempo en el sueño. Tu mente ha comenzado a moverse a una nueva dimensión.';

  @override
  String get guideStage5Title => '5. Optimización de la Rutina de Sueño';

  @override
  String get guideStage5Subtitle => 'Preparando el Terreno para Sueños Lúcidos';

  @override
  String get guideStage5Content =>
      'En esta etapa, tomamos un descanso de los intentos directos de sueños lúcidos. Es hora de construir una rutina de sueño regular para apoyar el mecanismo básico del cerebro y profundizar la claridad mental.';

  @override
  String get guideStage5Importance =>
      'El sueño regular y un entorno ideal afectan directamente el éxito de los sueños lúcidos. Se requiere un ritmo regular para la progresión saludable de la duración REM.';

  @override
  String get guideStage5Steps =>
      'Crea un horario de sueño-vigilia a la misma hora todos los días.\nHaz una desintoxicación digital 1 hora antes de acostarte.\nProcura dormir en una habitación tranquila, oscura y fresca.\nCalma la mente con meditaciones cortas.';

  @override
  String get guideStage5Criteria =>
      'Si mantuviste un diario de sueños durante 7 noches en 10 días y experimentaste señales de conciencia en 3 de tus sueños → puedes pasar a la siguiente etapa.';

  @override
  String get guideStage5BrainNote =>
      'Un edificio no puede existir sin cimientos. Esta etapa establece una base sólida para tus sueños conscientes. Recuerda, una mente descansada significa una mente consciente.';

  @override
  String get guideStage6Title => '6. Equilibrio de Dopamina';

  @override
  String get guideStage6Subtitle => 'Equilibrando la Química Mental';

  @override
  String get guideStage6Content =>
      'Tu mente ahora ha conocido los sueños lúcidos. En esta etapa, damos un paso atrás de la práctica de sueños y buscamos crear un entorno mental más saludable para los sueños lúcidos apoyando el equilibrio mental.';

  @override
  String get guideStage6Importance =>
      'La dopamina es un neurotransmisor que desempeña un papel en los procesos de motivación y atención. Los estímulos excesivos pueden dificultar el enfoque mental. Este contenido no es consejo médico; solo ofrece sugerencias de conciencia y estilo de vida.';

  @override
  String get guideStage6Steps =>
      'Limita tu tiempo en redes sociales a 1 hora durante 5 días.\nHaz ejercicio ligero, camina y toma sol.\nCome rico en Omega-3, aléjate del azúcar.\nHaz ejercicios de concentración antes de dormir.';

  @override
  String get guideStage6Criteria =>
      'Si manipulaste conscientemente el entorno, la luz o un objeto 3 veces en sueños lúcidos en una semana, puedes pasar a la etapa final.';

  @override
  String get guideStage6BrainNote =>
      'No solo entrenaste tu mente, optimizaste su estructura biológica. Ahora los sueños conscientes no solo son posibles; se están convirtiendo en tu naturaleza.';

  @override
  String get guideStage7Title => '7. Conciencia Avanzada y Guía Creativa';

  @override
  String get guideStage7Subtitle => 'Convirtiéndote en el Maestro del Sueño';

  @override
  String get guideStage7Content =>
      'Hemos llegado al final del viaje. En este punto, no solo serás lúcido sino que alcanzarás un nivel donde puedes explorar la experiencia del sueño de manera más consciente. Es hora de crear libremente tu mundo de sueños.';

  @override
  String get guideStage7Importance =>
      'Con esta técnica, puedes desarrollar conciencia de los símbolos oníricos y la imaginería mental, y probar todo lo que imagines. Este es un paso significativo tanto en términos de conciencia mental como personal.';

  @override
  String get guideStage7Steps =>
      'Escribe e imagina el escenario que deseas hacer en el sueño con detalle.\nCambia conscientemente el lugar, el tiempo, el personaje o el resultado en el sueño.\nAñade meditaciones de atención plena a tu rutina diaria.';

  @override
  String get guideStage7Criteria =>
      'Si has realizado manipulación activa en al menos 2 sueños en 2 semanas (volar, cambiar el entorno, invocar algo), bienvenido al mundo de los sueños lúcidos.';

  @override
  String get guideStage7BrainNote =>
      'Al final de este viaje, no solo los sueños conscientes sino el potencial ilimitado de tu imaginación te esperan. Ahora estás creando vida no solo cuando estás despierto sino también cuando duermes.';

  @override
  String get guideAppBarTitle => 'Guía de Sueños Lúcidos';

  @override
  String get guideIntroTitle1 => '¿Qué son los Sueños Lúcidos?';

  @override
  String get guideIntroContent1 =>
      'Los sueños lúcidos son una experiencia de sueño única donde te das cuenta de que estás soñando y puedes guiar conscientemente el sueño.';

  @override
  String get guideIntroListTitle => 'En un estado de Sueño Lúcido:';

  @override
  String get guideIntroBullet1 => 'Eres consciente durante el sueño.';

  @override
  String get guideIntroBullet2 => 'Puedes evaluar tu entorno.';

  @override
  String get guideIntroBullet3 => 'Tu capacidad de toma de decisiones aumenta.';

  @override
  String get guideIntroBullet4 => 'Puedes cambiar el flujo del sueño.';

  @override
  String get guideIntroFooter =>
      'Los sueños lúcidos son una habilidad que algunos experimentamos por casualidad en algún momento de nuestras vidas, pero que se puede aprender con las técnicas adecuadas.';

  @override
  String get guideIntroTitle2 => '¿Para qué Sirven los Sueños Lúcidos?';

  @override
  String get guideBenefit1 => 'Gestionar Tus Sueños';

  @override
  String get guideBenefit2 => 'Explorar el Subconsciente';

  @override
  String get guideBenefit3 => 'Dominar el Sueño';

  @override
  String get guideBenefit4 => 'Manejar el Estrés';

  @override
  String get guideIntroContent2 =>
      'Los sueños lúcidos abren las puertas del subconsciente, llevándote a un nivel más alto de conciencia. Esta experiencia eventualmente se refleja en tu vida diaria.';

  @override
  String get guideIntroTitle3 => '¿Cómo Usar Esta Guía?';

  @override
  String get guideIntroContent3 =>
      'Esta guía está construida sobre un sistema especial de sueños lúcidos de 7 etapas. En cada etapa, adquirirás un hábito poderoso que afectará directamente tus sueños.';

  @override
  String get guideIntroGainTitle => 'Lo Que Ganarás a Medida que Avances:';

  @override
  String get guideIntroGain1 => 'Gestionar Sueños';

  @override
  String get guideIntroGain2 => 'Explorar Subconsciente';

  @override
  String get guideIntroGain3 => 'Dominar el Sueño';

  @override
  String get guideIntroGain4 => 'Manejar el Estrés';

  @override
  String get guideBuyButton => 'Desbloquear Guía Completa';

  @override
  String get guideNo => 'No';

  @override
  String get guideYes => 'Sí';

  @override
  String get guideDebugResetTitle => '¿Reiniciar Guía?';

  @override
  String get guideDebugResetContent =>
      'Esto bloqueará todas las etapas excepto la primera. (Depuración)';

  @override
  String get journalDeleteTitle => '¿Eliminar Sueño?';

  @override
  String get journalDeleteContent =>
      '¿Estás seguro de que quieres eliminar este sueño? Esta acción no se puede deshacer.';

  @override
  String get journalDeleteConfirm => 'Eliminar';

  @override
  String get journalDeleteCancel => 'Cancelar';

  @override
  String get proVersion => 'PRO';

  @override
  String get standardVersion => 'Estándar';

  @override
  String get upgradeTitle => 'Actualizar a DreamBoat PRO';

  @override
  String get upgradeBenefits =>
      'Experiencia Sin Anuncios\nAnálisis Completo de Sueños\nInterpretación Ilimitada de Sueños\nAcceso Exclusivo a la Guía';

  @override
  String get upgradeBtn => 'Desbloquear DreamBoat PRO (88,99 ₺)';

  @override
  String get upgradeCancel => 'Quizás después';

  @override
  String get privacyPolicyLink => 'Política de Privacidad';

  @override
  String get termsOfUseLink => 'Términos de Uso';

  @override
  String get upgradeSuccess => '¡Bienvenido a DreamBoat PRO!';

  @override
  String get upgradeStart => 'Empezar';

  @override
  String get proRequired => 'Se Requiere Versión PRO';

  @override
  String get proRequiredDetail =>
      'Se Requiere Versión PRO y Al Menos 5 Sueños Registrados';

  @override
  String get guideUnlockPro => 'Desbloquear Versión PRO';

  @override
  String get guideUnlockHint =>
      'Debes actualizar a PRO para desbloquear la guía.';

  @override
  String get guideContent => 'Contenido';

  @override
  String get guideImportance => '¿Por qué es Importante?';

  @override
  String get guideSteps => 'Pasos';

  @override
  String get guideCriteria => 'Criterios de Completación';

  @override
  String get guideBrainNoteTitle => 'Nota al Cerebro';

  @override
  String get guideNextStep => 'Siguiente Paso';

  @override
  String get guideDialogTitle => '¿Estás seguro de que quieres avanzar?';

  @override
  String get guideDialogContent =>
      'Pasar a la siguiente etapa sin completar el paso actual puede perjudicar tu viaje. ¿Estás seguro de que quieres continuar?';

  @override
  String get guideDialogCancel => 'Esperar';

  @override
  String get guideDialogConfirm => 'Estoy Listo';

  @override
  String get guideStart => 'Iniciar Guía';

  @override
  String get privacyTitle => 'Privacidad y RGPD';

  @override
  String get privacyNoticeTitle => 'Aviso de Privacidad de NovaBloom Studio';

  @override
  String get privacyNoticeContent =>
      'DreamBoat es desarrollado por el desarrollador independiente Guney Yilmazer bajo la marca NovaBloom Studio. Tu privacidad es nuestra máxima prioridad. DreamBoat está diseñado para que registres y analices tus sueños de forma segura para la conciencia personal.';

  @override
  String get privacySection1Title => '1. Seguridad y Procesamiento de Datos';

  @override
  String get privacySection1Content =>
      'Tus registros de sueños y datos en la aplicación se almacenan de forma segura.\nTus sueños se procesan solo para operar las funciones ofrecidas por la aplicación.\n\nLos contenidos de los sueños nunca se comparten con terceros\n\nLos datos no se utilizan para fines de publicidad, marketing o elaboración de perfiles de usuario\n\nLos análisis impulsados por IA se realizan únicamente para mejorar la experiencia del usuario\n\nLos textos de los sueños no se utilizan para entrenar modelos de IA\n\nTodas las operaciones se llevan a cabo de acuerdo con los estándares KVKK y RGPD';

  @override
  String get privacySection2Title => '2. Cuenta y Uso';

  @override
  String get privacySection2Content =>
      'DreamBoat funciona sin necesidad de crear una cuenta.\n\nLa aplicación se puede utilizar de forma anónima\n\nTus sueños y configuraciones se almacenan solo en tu dispositivo o en áreas seguras pertenecientes a la aplicación\n\nLa información de identidad personal (nombre, correo electrónico, etc.) no se recopila obligatoriamente';

  @override
  String get privacySection3Title => '3. Privacidad y Funciones de Bloqueo';

  @override
  String get privacySection3Content =>
      'DreamBoat ofrece opciones de seguridad adicionales para proteger la privacidad:\n\nEl diario de sueños se puede bloquear con Face ID o huella digital\n\nLos sueños son completamente privados por defecto\n\nLa función de compartir es opcional y solo funciona cuando el usuario elige explícitamente compartir\n\nLos sueños nunca se comparten automáticamente ni con terceros';

  @override
  String get privacySection4Title =>
      '4. Descargo de Responsabilidad Médica (IMPORTANTE)';

  @override
  String get privacySection4Content =>
      'DreamBoat no es una aplicación de salud o médica.\n\nLas interpretaciones y análisis de sueños proporcionados son únicamente para fines de entretenimiento y conciencia personal\n\nNo constituye consejo médico, psicológico o profesional\n\nLa aplicación no recopila ni procesa datos biométricos o de salud\n\n5. Contacto\n\nTambién puedes acceder a nuestra política de privacidad detallada en nuestro sitio web:\nhttps://www.novabloomstudio.com/es/privacy';

  @override
  String get supportTitle => 'Contáctanos';

  @override
  String get supportContent =>
      'Tus comentarios son muy valiosos para NovaBloom Studio.\n\nPuedes enviarnos un correo electrónico para sugerencias, informes de errores o solicitudes de colaboración.';

  @override
  String get supportSendEmail => 'Enviar Correo';

  @override
  String get supportEmailNotFound => 'Aplicación de correo no encontrada.';

  @override
  String get supportEmailSubject => 'Solicitud de soporte de DreamBoat';

  @override
  String get debugResetTitle => 'Reinicio de Depuración';

  @override
  String get debugResetContent =>
      '¿Quieres restaurar la aplicación a la versión Estándar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get standard => 'ESTÁNDAR';

  @override
  String get save => 'Guardar';

  @override
  String get timeFormat24h => 'Formato 24 Horas';

  @override
  String get languageTurkish => 'Turco';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get guideSlide1Title => 'La Sabiduría del Antiguo Egipto';

  @override
  String get guideSlide1Subtitle => 'Puerta al Viaje del Alma';

  @override
  String get guideSlide1Content1 =>
      'Los rastros de lo que hoy llamamos sueño lúcido se podían ver en el Antiguo Egipto. Los egipcios interpretaban el sueño como una experiencia consciente dentro del marco de las creencias culturales y espirituales de la época.\n\nDe hecho, existen narrativas simbólicas que describen a los faraones interactuando con figuras divinas en el reino de los sueños a través de sacerdotes.';

  @override
  String get guideSlide1Content2 =>
      'En la medicina moderna, en la investigación del sueño en el campo de la somnología, se ha observado que la corteza frontal está activa durante el sueño REM, lo que significa que las áreas del cerebro asociadas con la conciencia y la percepción funcionan de manera similar a cuando se está despierto. Estos hallazgos se interpretan como similitudes conceptuales con las narrativas de experiencias conscientes atribuidas al sueño en el Antiguo Egipto.';

  @override
  String get guideSlide2Title => 'Meditaciones de los Monjes Tibetanos';

  @override
  String get guideSlide2Subtitle => 'Trascendiendo los Límites de la Mente';

  @override
  String get guideSlide2Content1 =>
      'Los monjes tibetanos, a través de prácticas de meditación profunda de toda la vida, trataron el sueño lúcido como una experiencia interna destinada a aumentar la conciencia mental.\n\nEn las altas cumbres de los Himalayas, los monjes que exploran las capas de la mente apoyaron las experiencias de sueños conscientes con disciplina mental y prácticas tradicionales.';

  @override
  String get guideSlide2Content2 =>
      'En estudios neurológicos recientes, se ha examinado la relación entre las prácticas de meditación y la conciencia del sueño.\n\nA la luz de estas antiguas tradiciones, esta guía especial que preparamos tiene como objetivo despertar este potencial en las profundidades de tu mente y llevar tu conciencia al reino de los sueños. Puedes comenzar el viaje de convertirte en el arquitecto consciente de tu propio mundo interior, dejando de ser solo un espectador en tus sueños.';

  @override
  String get guideSlide3Title => 'El Secreto de los Atrapasueños';

  @override
  String get guideSlide3Subtitle => 'Guardián de los Sueños Conscientes';

  @override
  String get guideSlide3Content1 =>
      'En las culturas nativas americanas, el atrapasueños era visto como un objeto simbólico asociado con los sueños lúcidos.\n\nEsta práctica, transmitida de generación en generación, se interpretó como un símbolo cultural que representa las experiencias oníricas. Bajo la guía de los chamanes, el atrapasueños fue valorado como un símbolo asociado con la conciencia consciente y que simboliza las conexiones espirituales.';

  @override
  String get guideSlide3Content2 =>
      'En la era de la información moderna, el sueño lúcido no solo se trata como una experiencia mística de culturas antiguas, sino también como una experiencia de conciencia estudiada en la investigación científica moderna.\n\nEn esta guía de sueños lúcidos, creada compilando las investigaciones y enseñanzas más actuales transmitidas de generación en generación, es posible que descubras diferentes experiencias profundizando tu conciencia mental.';

  @override
  String get guideSlide4Title => 'Guía de Sueños Lúcidos';

  @override
  String get guideSlide4Content =>
      '¿Cómo usar esta guía?\n\nEsta guía está construida sobre un sistema especial de sueños lúcidos de 7 etapas.\nEn cada etapa, desarrollarás hábitos poderosos que apoyan la conciencia del sueño.';

  @override
  String get guideSlide4GainsTitle => 'Lo Que Ganarás a Medida que Avances';

  @override
  String get guideSlide4Gain1 => 'Accedes a las capas profundas de tus sueños';

  @override
  String get guideSlide4Gain2 => 'Tu conciencia comienza a guiar los sueños';

  @override
  String get guideSlide4Gain3 => 'Lugares y personas toman forma según tú';

  @override
  String get guideSlide4Gain4 => 'Ganas más conciencia sobre tus sueños';

  @override
  String get guideSlide4ProRequired =>
      'Debes tener la versión PRO para acceder a la guía.';

  @override
  String get guideSlide4UnlockButton => 'Desbloquear Versión PRO';

  @override
  String get guideCompleted => '¡Felicidades! Has completado toda la guía.';

  @override
  String get delete => 'Eliminar';

  @override
  String get actionFavorite => 'Favorito';

  @override
  String get understand => 'Entiendo, Continuar';

  @override
  String get error => 'Error';

  @override
  String get testNotification => 'Enviar Notificación de Prueba';

  @override
  String get testNotificationSent => '¡Notificación de prueba enviada!';

  @override
  String get journalSearchHint => 'Buscar en tus sueños...';

  @override
  String get newDreamLoadingText => 'Preparando tu interpretación de sueño...';

  @override
  String get dreamInterpretationTitle => 'Interpretación del Sueño';

  @override
  String get dreamInterpretationReadMore => 'Leer Más';

  @override
  String get dreamTooShort => 'El sueño fue demasiado corto para interpretar.';

  @override
  String get dailyLimitReached =>
      'Has alcanzado el límite diario de interpretación de sueños (100/100).';

  @override
  String get settingsRestorePurchases => 'Restaurar Compras';

  @override
  String get restoreSuccess => '¡Versión PRO restaurada con éxito!';

  @override
  String get restoreNotFound => 'No se encontraron compras anteriores.';

  @override
  String get restoreError =>
      'Error al restaurar compras. Por favor, inténtalo de nuevo.';

  @override
  String get restoreUnavailable =>
      'La tienda no está disponible actualmente. Por favor, inténtalo más tarde.';

  @override
  String get restoring => 'Restaurando...';

  @override
  String get offlineInterpretation =>
      'El sueño no pudo ser interpretado debido a falta de internet.';

  @override
  String get offlinePurchase =>
      'Se requiere conexión a internet para realizar la compra.';

  @override
  String get offlineAnalysis =>
      'Se requiere conexión a internet para el análisis.';

  @override
  String get proUpgradeSubtitle =>
      'Sin suscripción. Compra única, acceso de por vida.';

  @override
  String get proFeatureAdsTitle => 'Experiencia Sin Anuncios';

  @override
  String get proFeatureAdsSubtitle =>
      'Sin anuncios al interpretar sueños.\nEnfócate solo en tus sueños y lo que quieren contarte.';

  @override
  String get proFeatureCosmicTitle => 'Desbloquea Conexiones Cósmicas';

  @override
  String get proFeatureCosmicSubtitle =>
      'Revela conexiones cósmicas adicionales en las interpretaciones.\nInterpreta tus sueños junto con las fases lunares e influencias planetarias.';

  @override
  String get proFeatureAnalysisTitle =>
      'Análisis Semanal de Patrones de Sueños';

  @override
  String get proFeatureAnalysisSubtitle =>
      'Revela conexiones ocultas entre tus sueños.\nDescubre temas recurrentes, emociones y mensajes del subconsciente con el tiempo.';

  @override
  String get proFeatureGuideTitle => 'Guía de Sueños Lúcidos';

  @override
  String get proFeatureGuideSubtitle =>
      'Toma el control de tus sueños.\nTécnicas guiadas paso a paso desde principiante hasta avanzado.';

  @override
  String get proProcessing => 'Procesando...';

  @override
  String get notifDialogTitle => 'Activar Notificaciones';

  @override
  String get notifDialogBody =>
      'Permite que DreamBoat te recuerde registrar tus sueños cada mañana.';

  @override
  String get notifPermissionDenied => 'Permiso de Notificación Denegado';

  @override
  String get notifOpenSettings => 'Abrir Ajustes';

  @override
  String get notifOpenSettingsHint =>
      'Debes activar las notificaciones en los ajustes.';

  @override
  String get allow => 'Permitir';

  @override
  String get notifReminderBody => '¡No olvides registrar tu sueño! 📝';

  @override
  String get notifReminder1 => '¿Qué te susurró el universo esta noche? ✨';

  @override
  String get notifReminder2 =>
      '¡Atrapa tus sueños antes de que se desvanezcan! 📓';

  @override
  String get notifReminder3 => 'Tu subconsciente te dejó un mensaje... 🌙';

  @override
  String get notifReminder4 =>
      '¿No tienes curiosidad por lo que significan esos símbolos? 🔮';

  @override
  String get notifReminder5 => 'Tu diario de sueños te espera ✍️';

  @override
  String get pressBackToExit => 'Pulsa atrás de nuevo para salir';

  @override
  String get moonSyncTitle => 'Sincronización Mensual de Luna y Planeta';

  @override
  String get moonSyncSubtitle => 'Se puede realizar una vez al mes';

  @override
  String get moonSyncDescription =>
      'La Sincronización de Luna y Planetas analiza tus sueños del último mes junto con la fase lunar del día que los tuviste y los eventos cósmicos de ese período (como Luna de Sangre, eclipses). Al relacionar las emociones, intensidad y estado de ánimo de tus sueños con el ciclo lunar, revela la armonía entre tu estado interior y los ritmos cósmicos y a qué debes prestar atención durante fases lunares específicas (luna llena, cuarto, etc.). Como se centra en el ciclo lunar, se genera una vez al mes.';

  @override
  String get moonSyncDescriptionShort =>
      'Interpreta tus sueños junto con los ciclos lunares y eventos cósmicos. Aprende qué te influyó este mes y a qué debes prestar atención.';

  @override
  String get moonSyncBtn => 'Iniciar Análisis Cósmico';

  @override
  String moonSyncWait(int days) {
    return 'Debes esperar $days días para un nuevo análisis.';
  }

  @override
  String get moonSyncMinDreams => 'Se Requieren Al Menos 5 Sueños Registrados';

  @override
  String get moonSyncDone => 'Análisis Cósmico Mensual Completado';

  @override
  String get moonSyncProcessing =>
      'El Análisis Cósmico se está preparando,\npor favor espera.';

  @override
  String get moonPhaseNewMoon => 'Luna Nueva';

  @override
  String get moonPhaseWaxingCrescent => 'Luna Creciente';

  @override
  String get moonPhaseFirstQuarter => 'Cuarto Creciente';

  @override
  String get moonPhaseWaxingGibbous => 'Gibosa Creciente';

  @override
  String get moonPhaseFullMoon => 'Luna Llena';

  @override
  String get moonPhaseWaningGibbous => 'Gibosa Menguante';

  @override
  String get moonPhaseThirdQuarter => 'Cuarto Menguante';

  @override
  String get moonPhaseWaningCrescent => 'Luna Menguante';

  @override
  String get actionShareInterpretation => 'Compartir\nInterpretación';

  @override
  String get shareImage => 'Compartir\nImagen';

  @override
  String get sharePrivacyHint =>
      'Nota: El botón Compartir Interpretación solo comparte la interpretación. Tus sueños te pertenecen y nunca se comparten con terceros.';

  @override
  String get moonPhaseLabel => 'Fase Lunar:';

  @override
  String get readMore => 'Leer más...';

  @override
  String get tapForDetails => 'Toca para más detalles...';

  @override
  String nSelected(int count) {
    return '$count Seleccionados';
  }

  @override
  String get shareCardHeader => 'MI INTERPRETACIÓN DE SUEÑOS DIARIA';

  @override
  String get shareCardWatermark => 'Interpretado con DreamBoat App';

  @override
  String get subscriptionComingSoon =>
      '¡El sistema de suscripción llegará muy pronto!';

  @override
  String get subscribeMonthly => 'Suscribirse Mensual';

  @override
  String get subscribeYearly => 'Suscribirse Anual';

  @override
  String get planMonthly => 'MENSUAL';

  @override
  String get planAnnual => 'ANUAL';

  @override
  String get mostPopular => 'MÁS POPULAR';

  @override
  String get discountPercent => '-30% DESCUENTO';

  @override
  String get subscribeNow => 'Suscribirse';

  @override
  String get billingMonthly =>
      'Suscripción mensual con renovación automática.\nCancela cuando quieras.';

  @override
  String get billingAnnual =>
      'Suscripción anual con renovación automática.\nSe factura una vez al año.';

  @override
  String get proFeatureAds => 'Experiencia Sin Anuncios';

  @override
  String get proFeatureAnalysis => 'Análisis Semanal de Patrones';

  @override
  String get proFeatureGuide => 'Guía de Sueños Lúcidos';

  @override
  String get proFeatureMoonSync => 'Sincronización Lunar y Planetaria';

  @override
  String get freeTrialDays => 'Días de Prueba Gratis';

  @override
  String get freeTrialBadge => 'Primeros 7 días gratis';

  @override
  String get priceLoading => 'Cargando...';

  @override
  String get priceLoadError => 'Precio no disponible';

  @override
  String get priceRetryButton => 'Reintentar';

  @override
  String get then => 'Luego';

  @override
  String get reviewSatisfactionTitle => '¿Te gusta DreamBoat?';

  @override
  String get reviewSatisfactionContent =>
      '¡Comparte tu experiencia con nosotros!';

  @override
  String get reviewOptionYes => '¡Sí, me encanta!';

  @override
  String get reviewOptionNeutral => 'Más o menos';

  @override
  String get reviewOptionNo => 'No, no mucho';

  @override
  String get reviewFeedbackTitle => 'Tu opinión importa';

  @override
  String get reviewFeedbackContent =>
      '¿Cómo podemos mejorar? No dudes en escribirnos.';

  @override
  String get reviewFeedbackButton => 'Escríbenos';

  @override
  String get reviewCancel => 'Cancelar';

  @override
  String get adConsentTitle => 'Una Interpretación de Sueño Más ✨';

  @override
  String get adConsentBody =>
      'Para mantener DreamBoat gratis, puedes ver un anuncio corto para interpretar este sueño o actualizar a PRO para eliminar los límites.';

  @override
  String get adConsentWatch => 'Ver Anuncio e Interpretar';

  @override
  String get adConsentPro => 'Actualizar a PRO (Sin Anuncios)';

  @override
  String get adLoadError =>
      'El anuncio no está listo. Por favor intenta de nuevo o actualiza a PRO.';

  @override
  String get adRetry => 'Reintentar Anuncio';

  @override
  String get adSkipThisTime => 'Bu sefer reklamsız devam';

  @override
  String get intensityFeltLight => 'Se siente levemente';

  @override
  String get intensityFeltMedium => 'Se siente moderadamente';

  @override
  String get intensityFeltIntense => 'Se siente intensamente';

  @override
  String get statsDreamLabel => 'Sueños';

  @override
  String statsRecordedDreams(Object count) {
    return 'Sueños registrados: $count';
  }

  @override
  String get settingsSupportId => 'ID de Soporte';

  @override
  String get settingsSupportIdCopied =>
      '¡ID copiado! Puedes enviar este código a nuestro equipo de soporte.';

  @override
  String get guideIntentExerciseTitle => 'Repitamos juntos antes de dormir';

  @override
  String get guideIntentPhrase =>
      'En mi próximo sueño, me daré cuenta de que estoy soñando.';

  @override
  String get guideIntentRepeatButton => 'Repetir';

  @override
  String guideIntentProgress(Object count) {
    return '$count / 10 repeticiones';
  }

  @override
  String get guideIntentComplete =>
      '¡Estás listo! Ahora puedes dormir con esta intención. 🌙';

  @override
  String get wildBreathTitle => 'Modo de Respiración y Relajación';

  @override
  String get wildBreathStart => 'Iniciar Modo de Respiración y Relajación';

  @override
  String get wildBreathInhale => 'Inhala';

  @override
  String get wildBreathHold => 'Mantén';

  @override
  String get wildBreathExhale => 'Exhala';

  @override
  String get wildBreathFocus => 'Concéntrate solo en tu respiración';

  @override
  String get wildBreathTapToExit => 'Toca para salir';

  @override
  String get wbtbDreamsTitle => 'Tus sueños WBTB';

  @override
  String get wbtbDreamsDesc =>
      'Ve los sueños registrados en las noches que practicaste esta técnica.';

  @override
  String get wbtbDreamsButton => 'Ver sueños WBTB';

  @override
  String get wbtbNoDreamsTitle => 'Aún no hay sueños de esta etapa';

  @override
  String get wbtbNoDreamsDesc =>
      'Registra tus sueños después de practicar esta técnica.';

  @override
  String get wbtbAddFirstDream => 'Agregar mi primer sueño';

  @override
  String get timeAwarenessTitle => 'Ejercicio de Comprobación de Realidad';

  @override
  String get timeAwarenessInstruction => 'Responde en voz alta antes de dormir';

  @override
  String get timeAwarenessQ1 => '¿Cuál es la fecha de hoy?';

  @override
  String get timeAwarenessQ2 => '¿Qué día de la semana es?';

  @override
  String get timeAwarenessQ3 => 'REMOVED';

  @override
  String get timeAwarenessQ4 => '¿Qué hora es exactamente?';

  @override
  String get timeAwarenessQ5 => 'Mira a tu alrededor y nombra 3 objetos.';

  @override
  String get timeAwarenessQ6 => '¿De qué color es tu ropa?';

  @override
  String get timeAwarenessQ11 => '¿Qué sonidos escuchas ahora?';

  @override
  String get timeAwarenessQ7 =>
      '¿Quién fue la primera persona con la que hablaste hoy?';

  @override
  String get timeAwarenessQ8 => 'Mira tus manos y cuenta tus dedos.';

  @override
  String get timeAwarenessQ9 => 'Respira y pregunta \'¿Estoy soñando?\'';

  @override
  String get timeAwarenessQ10 => 'Ahora cierra los ojos e imagina que duermes.';

  @override
  String get stage5Task1 => 'Mantuve un Diario de Sueños';

  @override
  String get stage5Task2 => 'Experimenté Señal de Conciencia en Sueño';

  @override
  String get stage5Hint =>
      'Toca las estrellas al cumplir las condiciones. El progreso se desbloquea al completar todo.';

  @override
  String get stage6Task1 => 'Pude manipular conscientemente mi sueño';

  @override
  String get stage6Hint =>
      'Toca las estrellas al cumplir las condiciones. El progreso se desbloquea cuando las 3 estrellas están marcadas.';

  @override
  String get guideCriteriaNotMet =>
      'Debes completar los criterios de esta etapa para continuar.';

  @override
  String rateLimitWait(int minutes) {
    return 'Demasiadas solicitudes. Por favor, intenta de nuevo en $minutes minuto(s).';
  }

  @override
  String get analysisStep1 => 'Escaneando símbolos del sueño...';

  @override
  String get analysisStep2 => 'Mapeando el subconsciente...';

  @override
  String get analysisStep3 => 'Conectando arquetipos...';

  @override
  String get analysisStep4 => 'Analizando profundidad psicológica...';

  @override
  String get analysisStep5 => 'La interpretación se está preparando...';

  @override
  String get analysisLongWait =>
      'Tu sueño está siendo analizado detalladamente...';

  @override
  String get newDreamSaveShort => 'Guardar Sueño';

  @override
  String get supportTechInfoNote =>
      'La siguiente información técnica nos ayuda a resolver su problema más rápido. Por favor no la borre.';

  @override
  String get onboardingWelcomeTitle => 'Es posible que aún no hayas soñado';

  @override
  String get onboardingWelcomeSubtitle =>
      'Mientras tanto, descubramos tu perfil de sueño general.';

  @override
  String get surveyQ1 => '¿Con qué frecuencia recuerdas tus sueños?';

  @override
  String get surveyQ1Option1 => 'Nunca';

  @override
  String get surveyQ1Option2 => '1-2 veces al mes';

  @override
  String get surveyQ1Option3 => '1-2 veces a la semana';

  @override
  String get surveyQ1Option4 => 'Casi todos los días';

  @override
  String get surveyQ2 => '¿Cuál describe mejor tu horario de sueño?';

  @override
  String get surveyQ2Option1 => 'Muy irregular';

  @override
  String get surveyQ2Option2 => 'Algo irregular';

  @override
  String get surveyQ2Option3 => 'Generalmente regular';

  @override
  String get surveyQ2Option4 => 'Muy regular';

  @override
  String get surveyQ3 => '¿Cuál es el tono general de tus sueños?';

  @override
  String get surveyQ3Option1 => 'Pacífico';

  @override
  String get surveyQ3Option2 => 'Mixto';

  @override
  String get surveyQ3Option3 => 'Tenso';

  @override
  String get surveyQ3Option4 => 'Aterrador';

  @override
  String get surveyQ4 => '¿Cómo te sientes generalmente en tus sueños?';

  @override
  String get surveyQ4Option1 => 'En control';

  @override
  String get surveyQ4Option2 => 'Como un observador';

  @override
  String get surveyQ4Option3 => 'Huyendo';

  @override
  String get surveyQ4Option4 => 'Explorando';

  @override
  String get profile1Name => 'Viajero Soñador';

  @override
  String get profile1Desc =>
      'La exploración, la búsqueda de significado y la conciencia emocional destacan en tus sueños.\n\nTu subconsciente a menudo te habla con símbolos. Sientes que los pequeños detalles de la vida en realidad tienen un gran significado.\n\nA medida que registres tus sueños, comenzarás a ver tu mundo interior con mayor claridad.';

  @override
  String get profile2Name => 'Observador Silencioso';

  @override
  String get profile2Desc =>
      'Estás dentro de los eventos en tus sueños, pero sientes que no tienes el control.\n\nTu subconsciente está tratando de digerir lo que has vivido. Los pensamientos de la vida diaria se filtran en tus sueños con transiciones suaves.\n\nEscribir tus sueños puede aligerar la carga de tu mente.';

  @override
  String get profile3Name => 'Explorador Emocional';

  @override
  String get profile3Desc =>
      'Tus sueños son intensos, detallados y emocionalmente fuertes.\n\nTu subconsciente te ofrece escenas para conocerte a ti mismo. Tienes un vínculo fuerte con tu mundo interior.\n\nSeguir tus sueños puede darte serias ideas.';

  @override
  String get profile4Name => 'Guerrero Mental';

  @override
  String get profile4Desc =>
      'Los temas de presión, escape y lucha destacan en tus sueños.\n\nEl estrés diario puede reflejarse en tus sueños. Tu subconsciente te está indicando que \'bajes la velocidad\'.\n\nEscribir tus sueños puede proporcionar alivio mental.';

  @override
  String get profile5Name => 'Arquitecto Controlador';

  @override
  String get profile5Desc =>
      'Hay un sentido de dirección y dominio consciente en tus sueños.\n\nPuedes tener una estructura planificada, organizada y consciente en tu vida. Los sueños funcionan como un patio de recreo para ti.\n\nTu potencial de sueño lúcido es alto.';

  @override
  String get profile6Name => 'Buzo Profundo';

  @override
  String get profile6Desc =>
      'Tus sueños pueden ser intensos y a veces perturbadores.\n\nTu subconsciente lleva al escenario emociones reprimidas. Esto no es algo malo; piénsalo como un proceso de limpieza.\n\nEscribir tus sueños puede aligerar tus cargas internas.';

  @override
  String get profile7Name => 'Viajero de Sueños';

  @override
  String get profile7Desc =>
      'Hay un estado de calma y fluidez en tus sueños.\n\nPuedes ser alguien que observa la vida desde la distancia y experimenta emociones profundamente. Los sueños funcionan como un área de descanso mental para ti.\n\nUn diario de sueños te fortalece aún más.';

  @override
  String get profile8Name => 'Pasajero del Umbral Consciente';

  @override
  String get profile8Desc =>
      'Tus sueños son muy vívidos pero a veces agotadores.\n\nVas y vienes entre la conciencia y el subconsciente. Eres uno de los perfiles más cercanos al sueño lúcido.\n\nPuedes gestionar tus sueños conscientemente con un poco de equilibrio.';

  @override
  String get surveyDisclaimer =>
      'Este análisis no es una evaluación científica o médica.\nEs solo para fines de entretenimiento y concientización.';

  @override
  String get surveyResultTitle => 'Tu Perfil de Sueño';

  @override
  String get surveyContinue => 'Comenzar DreamBoat';

  @override
  String get welcomeHeader => 'Bienvenido a DreamBoat';

  @override
  String stepProgress(Object current, Object total) {
    return 'Paso $current / $total';
  }

  @override
  String get emailLabelSupportId => 'ID de Soporte (ID de Usuario)';

  @override
  String get emailLabelAppVersion => 'Versión de la App';

  @override
  String get emailLabelPlatform => 'Plataforma';

  @override
  String get emailLabelLanguage => 'Idioma';

  @override
  String get biometricLockTitle => '¿Te gustaría bloquear tu Diario de Sueños?';

  @override
  String get biometricLockMessage =>
      'Tus sueños pueden ser muy personales.\nPuedes proteger tu Diario de Sueños con huella digital / Face ID.';

  @override
  String get biometricLockYes => 'Sí, Proteger';

  @override
  String get biometricLockNo => 'Ahora No';

  @override
  String get biometricLockReason =>
      'Autentícate para acceder al Diario de Sueños';

  @override
  String get biometricLockSettingsTitle => 'Bloqueo del Diario de Sueños';

  @override
  String get biometricLockSettingsSubtitle =>
      'Proteger con huella digital / Face ID';

  @override
  String get biometricNotAvailable =>
      'Función biométrica no encontrada en tu dispositivo. Puedes agregar datos biométricos en Ajustes > Seguridad.';

  @override
  String get biometricAuthFailed => 'Autenticación fallida';

  @override
  String get offlineSaveTitle => 'Sin Conexión a Internet';

  @override
  String get offlineSaveContent =>
      'Puedes guardar tu sueño en el diario, pero no se puede interpretar sin internet.';

  @override
  String get offlineSaveConfirm => 'Guardar Sin Interpretación';

  @override
  String get offlineSaveCancel => 'Cancelar';

  @override
  String get errorNoInternet => 'No hay conexión a internet.';

  @override
  String get errorGeneric => 'Ocurrió un error inesperado.';

  @override
  String get dreamSavedNoInterpretation => 'Sueño guardado en el diario.';

  @override
  String get watchAdForInterpretation =>
      'Mejora a PRO o mira un anuncio para la interpretación de IA.';

  @override
  String get interpretationSkipped =>
      'El anuncio no fue visto, sueño guardado sin interpretación.';

  @override
  String weeklyLimitLeft(int count) {
    return 'Te quedan $count interpretaciones gratuitas esta semana';
  }

  @override
  String get specialOffer => '🔥 OFERTA ESPECIAL';

  @override
  String get welcomeOfferFirstTime => 'Oferta para nuevos suscriptores';

  @override
  String welcomeOfferExpires(String time) {
    return 'Oferta expira en: $time';
  }

  @override
  String streakDays(int count) {
    return '$count días seguidos';
  }

  @override
  String get streakSubtitle => 'Tu viaje de sueños continúa';

  @override
  String get proFeatureImageGenTitle => 'Generar Imagen de Sueño Diaria';

  @override
  String get proFeatureImageGenSubtitle =>
      'Transforma tus sueños en arte vívido. Da vida a un sueño cada día.';

  @override
  String get visualizeDream => 'Visualizar Sueño';

  @override
  String get visualizingDream => 'Visualizando...';

  @override
  String get imageGenLimitReached => 'Límite Diario Alcanzado';

  @override
  String get imageGenLimitDesc =>
      'Puedes generar 1 imagen de sueño al día. ¡Vuelve mañana!';

  @override
  String get imageGenLimitTrial => 'Límite de Prueba Alcanzado';

  @override
  String get imageGenLimitTrialDesc =>
      'La prueba incluye 1 imagen gratis. Mejora a PRO para imágenes diarias.';

  @override
  String get shareVisualizedBy => 'Visualizado con DreamBoat App';

  @override
  String get shareVisualSubject => 'Rüya Görselleştirmem';

  @override
  String get offlineImageGenTitle => 'Error de Conexión';

  @override
  String get offlineImageGenContent =>
      'No se pudo generar la imagen. Verifica tu conexión. No se consumió el límite.';

  @override
  String get limitReachedTitle => 'Límite Alcanzado';

  @override
  String get trialImageLimitReached =>
      'Has usado tu visualización de prueba gratuita. Después del período de prueba, puedes crear una imagen nueva diaria con PRO!';

  @override
  String get dailyImageLimitReached =>
      'Has usado tu visualización diaria. ¡Vuelve mañana para una nueva imagen!';

  @override
  String get visualizeDreamSubtitle =>
      'Interpretación visual de tu sueño con IA';

  @override
  String get cosmicConnectionTitle => 'Conexión Cósmica';

  @override
  String get unlockProConnection => 'Ver Todo';
}
