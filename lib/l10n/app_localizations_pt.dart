// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get homeTitle => 'DreamBoat';

  @override
  String get homeSubtitle => 'Embarque numa Jornada no Seu Mundo dos Sonhos';

  @override
  String get homeNewDream => 'Adicionar Novo Sonho';

  @override
  String get homeJournal => 'Diário de Sonhos';

  @override
  String get homeStats => 'Meu Mundo dos Sonhos';

  @override
  String get homeGuide => 'Guia de Sonhos Lúcidos';

  @override
  String get homeSettings => 'Configurações';

  @override
  String get statsTitle => 'Meu Mundo dos Sonhos';

  @override
  String get statsTipTitle => 'Dica do Dia';

  @override
  String get statsTipContent =>
      'Hoje, tente manter um diário para aprofundar sua jornada interior. Conecte-se com seu eu infantil visto nos sonhos, reserve alguns minutos para redescobrir aquele amor puro e escreva seus sentimentos.';

  @override
  String get statsAnalysisTitle => 'Distribuição Emocional Mensal';

  @override
  String get statsAnalysisResult => 'Análise de Padrões de Sonhos';

  @override
  String get statsAnalyzeBtn => 'Ver Padrão de Sonhos';

  @override
  String get statsAnalysisIntroTitle => 'Análise de Padrões de Sonhos';

  @override
  String get statsAnalysisIntroSubtitle => 'Pode ser feito uma vez por semana';

  @override
  String get statsAnalysisIntroContent =>
      'A Análise de Padrões de Sonhos examina seus sonhos semanais registrados coletivamente para revelar temas recorrentes, ciclos emocionais e tendências simbólicas do seu subconsciente. Diferente das interpretações individuais, este sistema mostra os padrões formados ao longo do tempo, a visão geral que sua mente está tentando lhe transmitir. Pode ser realizada apenas uma vez por semana para permitir que você acompanhe os elementos em mudança com mais regularidade ao longo do tempo.';

  @override
  String statsAnalysisWait(Object days) {
    return 'Você deve esperar $days dias para uma nova análise.';
  }

  @override
  String get statsAnalysisMinDreams =>
      'Necessário Pelo Menos 5 Sonhos Registrados';

  @override
  String get statsAnalysisDone => 'Análise Semanal Concluída';

  @override
  String get statsAnalyzing => 'Analisando...';

  @override
  String get statsOffline => 'Internet necessária';

  @override
  String get statsNoData => 'Dados insuficientes';

  @override
  String get statsProcessing =>
      'O Padrão de Sonho está sendo preparado, por favor aguarde um momento.';

  @override
  String get analysisConfirmBody =>
      'A Análise de Padrões de Sonhos pode ser feita uma vez por semana para que você possa ver claramente como seus padrões mudam ao longo do tempo.\n\nDeseja continuar?';

  @override
  String get moonSyncConfirmBody =>
      'A Sincronização Lunar e Planetária pode ser feita uma vez por mês para acompanhar com precisão as mudanças nos ciclos cósmicos.\n\nDeseja continuar?';

  @override
  String get confirmContinue => 'Continuar';

  @override
  String get guideTitle => 'Guia de Sonhos Lúcidos';

  @override
  String get guideIntroTitle => 'O que é Sonho Lúcido?';

  @override
  String get guideIntroContent =>
      'Sonho lúcido é a experiência única de se tornar consciente de que está sonhando e potencialmente controlar seu sonho.';

  @override
  String get moodLove => 'Amor';

  @override
  String get moodHappy => 'Felicidade';

  @override
  String get moodSad => 'Tristeza';

  @override
  String get moodScared => 'Medo';

  @override
  String get moodAnger => 'Raiva';

  @override
  String get moodNeutral => 'Neutro';

  @override
  String get moodPeace => 'Paz';

  @override
  String get moodAwe => 'Admiração';

  @override
  String get moodAnxiety => 'Ansiedade';

  @override
  String get moodConfusion => 'Confusão';

  @override
  String get moodEmpowered => 'Empoderado';

  @override
  String get moodLonging => 'Saudade';

  @override
  String get feltMood => 'Emoção:';

  @override
  String get moodSelectPrompt =>
      'Qual é a primeira sensação ao pensar neste sonho?';

  @override
  String get moodIntensityLabel => 'Intensidade';

  @override
  String get moodIntensityLow => 'Baixa';

  @override
  String get moodIntensityMedium => 'Média';

  @override
  String get moodIntensityHigh => 'Alta';

  @override
  String get moodVividnessLabel => 'Vivacidade';

  @override
  String get moodVividnessQuestion => 'Quão claramente você se lembra?';

  @override
  String get moodVividnessLow => 'Vago';

  @override
  String get moodVividnessMedium => 'Parcial';

  @override
  String get moodVividnessHigh => 'Muito Claro';

  @override
  String get moodNotSure => 'Não Tenho Certeza';

  @override
  String get moodSaving => 'Salvando seu sonho...';

  @override
  String get newDreamModalTitle => 'Qual Emoção Dominou\nEste Sonho?';

  @override
  String get close => 'Fechar';

  @override
  String get journalTitle => 'Diário de Sonhos';

  @override
  String get journalAll => 'Todos';

  @override
  String get journalFavorites => 'Favoritos';

  @override
  String get journalNoDreams => 'Nenhum sonho registrado ainda.';

  @override
  String get journalNoFavorites => 'Nenhum sonho favorito ainda.';

  @override
  String get journalAnalysis => 'Interpretação do Sonho';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsPrivacy => 'Política de Privacidade';

  @override
  String get settingsSupport => 'Suporte';

  @override
  String get settingsVersion => 'Versão:';

  @override
  String get settingsNotifOpen => 'Ativar Notificações';

  @override
  String get settingsNotifTime => 'Lembrete Diário';

  @override
  String get settingsNotifDesc =>
      'Receba um lembrete suave para registrar seus sonhos todas as manhãs.';

  @override
  String get settingsPrivacyTitle => 'Política de Privacidade';

  @override
  String get settingsSupportTitle => 'Suporte';

  @override
  String get settingsAppStatus => 'Status do Aplicativo';

  @override
  String get settingsSupportDesc => 'Tem uma dúvida ou feedback? Conte-nos!';

  @override
  String get settingsSend => 'Enviar Mensagem';

  @override
  String get settingsSending => 'Mensagem enviada!';

  @override
  String get newDreamMinCharHint =>
      'Você deve inserir pelo menos 50 caracteres para seu sonho ser interpretado.';

  @override
  String get homeSpecialBadge => 'PRO';

  @override
  String get newDreamTitle => 'Novo Sonho';

  @override
  String get newDreamSubtitle =>
      'Não se esqueça de registrar seus sonhos todos os dias...';

  @override
  String get newDreamSave => 'Salvar e Interpretar Meu Sonho';

  @override
  String get newDreamPlaceholderDetail =>
      'Detalhe seu sonho aqui...\n\nExemplo: Eu estava caminhando em um jardim tranquilo cheio de flores. Uma luz suave filtrava-se através das folhas. A água ondulava suavemente em uma pequena banheira de pássaros próxima.';

  @override
  String get newDreamPlaceholder => 'Detalhe seu sonho aqui...';

  @override
  String get guideCompletionTitle => 'Parabéns!';

  @override
  String get guideCompletionContent =>
      'Você completou todas as etapas do Guia de Sonhos Lúcidos.\n\nAgora, dominando todas as técnicas, você pode se mover livremente no mundo dos Sonhos Lúcidos!';

  @override
  String get guideStage1Title =>
      '1. Técnica MILD (Indução Mnemônica de Sonhos Lúcidos)';

  @override
  String get guideStage1Subtitle =>
      'Plantando a Semente do Despertar em Seus Sonhos';

  @override
  String get guideStage1Content =>
      'Este é o ponto de partida da jornada dos sonhos lúcidos. MILD, ou \"Indução Mnemônica de Sonhos Lúcidos\", é uma técnica de plantar uma intenção clara no subconsciente antes de adormecer. Esta intenção permite que você capture a consciência de \"Estou sonhando\" durante um sonho. Abriremos a primeira porta para o sonho consciente nesta fase.';

  @override
  String get guideStage1Importance =>
      'MILD usa a capacidade da mente de recordar e formar intenções para preparar um terreno mental para sonhos lúcidos. Ao ativar o hipocampo e o córtex pré-frontal, aumenta a probabilidade de estar consciente num sonho.';

  @override
  String get guideStage1Steps =>
      'Depois de acordar de um sonho à noite, tente lembrar o seu último sonho em detalhes.\nRepita esta frase para si mesmo: \"No meu próximo sonho, vou perceber que estou sonhando.\"\nVisualize esta cena na sua mente. Imagine-se consciente no sonho.\nFeche os olhos e volte a dormir com esta intenção.\nEscreva em detalhes no seu diário de sonhos quando acordar de manhã.';

  @override
  String get guideStage1Criteria =>
      'Se você percebeu que estava sonhando pelo menos uma vez numa semana, pode avançar para a próxima fase.';

  @override
  String get guideStage1BrainNote =>
      'Esta é uma jornada de despertar. No primeiro passo, você começa a treinar sua mente. Cada repetição significa que os sonhos conscientes estão um passo mais perto. Lembre-se, paciência e repetição são seus maiores aliados.';

  @override
  String get guideStage2Title => '2. WBTB (Acordar e Voltar para a Cama)';

  @override
  String get guideStage2Subtitle => 'Abrindo a Porta para o Sonho Consciente';

  @override
  String get guideStage2Content =>
      'Você formou sua intenção mental. Agora, aprenderemos a reentrar conscientemente na fase REM onde os sonhos são mais intensos. A técnica WBTB pode apoiar a consciência de sonho lúcido permitindo que você volte a dormir em um estado semi-acordado.';

  @override
  String get guideStage2Importance =>
      'Com WBTB, seu cérebro fica entre a vigília e o sono. Este ponto de transição fornece o ambiente mental mais adequado para sonhos lúcidos.';

  @override
  String get guideStage2Steps =>
      'Defina um alarme para acordar 4–6 horas após adormecer.\nLeia um livro com pouca luz, medite ou repita MILD por 15–30 minutos.\nAo final deste tempo, deite-se novamente e adormeça com a intenção MILD.';

  @override
  String get guideStage2Criteria =>
      'Se você ganhou consciência do ambiente em seu sonho pelo menos 2 noites em uma semana, pode avançar para a próxima fase.';

  @override
  String get guideStage2BrainNote =>
      'Você está abrindo sua mente um pouco mais. O véu entre sonho e realidade está diminuindo. Você está prestes a encontrar o sonho com a vigília.';

  @override
  String get guideStage3Title => '3. WILD (Sonho Lúcido Iniciado Acordado)';

  @override
  String get guideStage3Subtitle => 'Entrada Direta no Sonho com Consciência';

  @override
  String get guideStage3Content =>
      'Uma das técnicas mais impressionantes de sonhos lúcidos, WILD leva você diretamente ao reino dos sonhos conscientemente. Você permite que seu corpo durma enquanto sua mente permanece acordada antes de dormir, e você pode notar mais claramente quando o sonho começa.';

  @override
  String get guideStage3Importance =>
      'WILD requer execução simultânea de clareza mental e relaxamento físico. Esta técnica é diferente de outras pois você entra no sonho diretamente e requer um alto nível de prática.';

  @override
  String get guideStage3Steps =>
      'Aplique após WBTB.\nDeite-se, relaxe todo o corpo.\nConcentre-se na respiração, mantenha a mente ativa.\nVocê pode ver luzes, padrões enquanto seus olhos estão fechados — observe calmamente.\nAssuma o controle quando perceber que o sonho começou.';

  @override
  String get guideStage3Criteria =>
      'Se você transitou diretamente para um sonho conscientemente pelo menos uma vez em 2 semanas, está pronto para a fase 4.';

  @override
  String get guideStage3BrainNote =>
      'Agora você está no limiar da maestria. Você está aprendendo a fechar os olhos e abri-los em outro mundo. Lembre-se, esta técnica requer muita prática e paciência é seu maior aliado.';

  @override
  String get guideStage4Title =>
      '4. Consciência do Tempo e Verificações de Realidade';

  @override
  String get guideStage4Subtitle => 'Dominando Nossa Percepção da Realidade';

  @override
  String get guideStage4Content =>
      'A consciência dos sonhos lúcidos começou. Agora é hora de aprofundar essa consciência e usar o conceito de tempo-espaço no sonho. O objetivo nesta fase: lembrar conceitos como ano, idade, data enquanto sonha.';

  @override
  String get guideStage4Importance =>
      'Verificações de realidade facilitam perceber que você está sonhando. A percepção do tempo mostra a profundidade da consciência mental.';

  @override
  String get guideStage4Steps =>
      'Pergunte \"Estou sonhando agora?\" pelo menos 5–10 vezes por dia.\nFaça testes como contar dedos, reler texto.\nAntes de dormir, repita a intenção: \"Vou notar em que ano estou no meu sonho.\"';

  @override
  String get guideStage4Criteria =>
      'Se você experimentou consciência relacionada ao tempo em seu sonho 3 noites numa semana (ex: ano, aniversário, calendário) → pode avançar para a próxima fase.';

  @override
  String get guideStage4BrainNote =>
      'Você está ciente não apenas de que está num sonho, mas também do tempo no sonho. Sua mente começou a mover-se para uma nova dimensão.';

  @override
  String get guideStage5Title => '5. Otimização da Rotina de Sono';

  @override
  String get guideStage5Subtitle => 'Preparando o Terreno para Sonhos Lúcidos';

  @override
  String get guideStage5Content =>
      'Nesta fase, fazemos uma pausa nas tentativas diretas de sonhos lúcidos. É hora de construir uma rotina regular de sono para apoiar o mecanismo básico do cérebro e aprofundar a clareza mental.';

  @override
  String get guideStage5Importance =>
      'Sono regular e um ambiente ideal afetam diretamente o sucesso nos sonhos lúcidos. Um ritmo regular é necessário para a progressão saudável da duração do REM.';

  @override
  String get guideStage5Steps =>
      'Crie um horário de dormir-acordar na mesma hora todos os dias.\nFaça um detox digital 1 hora antes de dormir.\nCuide para dormir num quarto silencioso, escuro e fresco.\nAcalme a mente com meditações curtas.';

  @override
  String get guideStage5Criteria =>
      'Se você manteve um diário de sonhos por 7 noites em 10 dias e experimentou sinais de consciência em 3 dos seus sonhos → pode avançar para a próxima fase.';

  @override
  String get guideStage5BrainNote =>
      'Um prédio não pode existir sem alicerces. Esta fase estabelece uma base sólida para seus sonhos conscientes. Lembre-se, uma mente descansada significa uma mente consciente.';

  @override
  String get guideStage6Title => '6. Equilíbrio de Dopamina';

  @override
  String get guideStage6Subtitle => 'Equilibrando a Química Mental';

  @override
  String get guideStage6Content =>
      'Sua mente agora conheceu o sonho lúcido. Nesta fase, damos um passo atrás da prática de sonhos e buscamos criar um ambiente mental mais saudável para os sonhos lúcidos apoiando o equilíbrio mental.';

  @override
  String get guideStage6Importance =>
      'Dopamina é um neurotransmissor que desempenha um papel nos processos de motivação e atenção. Estímulos excessivos podem dificultar o foco mental. Este conteúdo não é aconselhamento médico; oferece apenas sugestões de consciência e estilo de vida.';

  @override
  String get guideStage6Steps =>
      'Limite seu tempo de mídia social para 1 hora por 5 dias.\nFaça exercício leve, caminhe e tome sol.\nComa rico em Omega-3, fique longe de açúcar.\nFaça exercícios de foco antes de dormir.';

  @override
  String get guideStage6Criteria =>
      'Se você manipulou conscientemente o ambiente, luz ou um objeto 3 vezes em sonhos lúcidos numa semana, pode avançar para a fase final.';

  @override
  String get guideStage6BrainNote =>
      'Você não apenas treinou sua mente, otimizou sua estrutura biológica. Agora sonhos conscientes não são apenas possíveis; estão se tornando sua natureza.';

  @override
  String get guideStage7Title =>
      '7. Consciência Avançada e Orientação Criativa';

  @override
  String get guideStage7Subtitle => 'Tornando-se o Mestre do Sonho';

  @override
  String get guideStage7Content =>
      'Chegamos ao fim da jornada. Neste ponto, você não será apenas lúcido, mas alcançará um nível onde pode explorar a experiência do sonho de forma mais consciente. É hora de criar livremente seu mundo dos sonhos.';

  @override
  String get guideStage7Importance =>
      'Com esta técnica, você pode desenvolver a consciência dos símbolos dos sonhos e da imagética mental, e testar tudo o que imaginar. Este é um passo significativo em termos de consciência mental e pessoal.';

  @override
  String get guideStage7Steps =>
      'Escreva e imagine o cenário que deseja fazer no sonho em detalhes.\nMude conscientemente o lugar, o tempo, o personagem ou o resultado no sonho.\nAdicione meditações de atenção plena à sua rotina diária.';

  @override
  String get guideStage7Criteria =>
      'Se você realizou manipulação ativa em pelo menos 2 sonhos em 2 semanas (voar, mudar o ambiente, invocar algo), bem-vindo ao mundo dos sonhos lúcidos.';

  @override
  String get guideStage7BrainNote =>
      'No final desta jornada, não apenas sonhos conscientes, mas o potencial ilimitado da sua imaginação o aguarda. Agora você está criando vida não apenas quando acordado, mas também quando dorme.';

  @override
  String get guideAppBarTitle => 'Guia de Sonhos Lúcidos';

  @override
  String get guideIntroTitle1 => 'O que é Sonho Lúcido?';

  @override
  String get guideIntroContent1 =>
      'Sonho lúcido é uma experiência de sono única onde você se torna consciente de que está sonhando e pode guiar conscientemente o sonho.';

  @override
  String get guideIntroListTitle => 'Num estado de Sonho Lúcido:';

  @override
  String get guideIntroBullet1 => 'Você está consciente durante o sonho.';

  @override
  String get guideIntroBullet2 => 'Você pode avaliar seus arredores.';

  @override
  String get guideIntroBullet3 =>
      'Sua capacidade de tomada de decisão aumenta.';

  @override
  String get guideIntroBullet4 => 'Você pode mudar o fluxo do sonho.';

  @override
  String get guideIntroFooter =>
      'Sonho lúcido é uma habilidade que alguns de nós experimentam por acaso em algum momento da vida, mas pode ser aprendida com as técnicas certas.';

  @override
  String get guideIntroTitle2 => 'Para Que Serve o Sonho Lúcido?';

  @override
  String get guideBenefit1 => 'Gerenciar Seus Sonhos';

  @override
  String get guideBenefit2 => 'Explorar o Subconsciente';

  @override
  String get guideBenefit3 => 'Dominar o Sono';

  @override
  String get guideBenefit4 => 'Lidar com o Estresse';

  @override
  String get guideIntroContent2 =>
      'Sonhos lúcidos abrem as portas do subconsciente, levando você a um nível mais alto de consciência. Esta experiência eventualmente reflete na sua vida diária.';

  @override
  String get guideIntroTitle3 => 'Como Usar Este Guia?';

  @override
  String get guideIntroContent3 =>
      'Este guia é construído sobre um sistema especial de sonhos lúcidos de 7 fases. Em cada fase, você adquirirá um hábito poderoso que afetará diretamente seus sonhos.';

  @override
  String get guideIntroGainTitle => 'O Que Ganhará Ao Progredir:';

  @override
  String get guideIntroGain1 => 'Gerenciar Sonhos';

  @override
  String get guideIntroGain2 => 'Explorar Subconsciente';

  @override
  String get guideIntroGain3 => 'Dominar o Sono';

  @override
  String get guideIntroGain4 => 'Lidar com Estresse';

  @override
  String get guideBuyButton => 'Desbloquear Guia Completo';

  @override
  String get guideNo => 'Não';

  @override
  String get guideYes => 'Sim';

  @override
  String get guideDebugResetTitle => 'Reiniciar Guia?';

  @override
  String get guideDebugResetContent =>
      'Isso bloqueará todas as fases exceto a primeira. (Debug)';

  @override
  String get journalDeleteTitle => 'Excluir Sonho?';

  @override
  String get journalDeleteContent =>
      'Tem certeza de que deseja excluir este sonho? Esta ação não pode ser desfeita.';

  @override
  String get journalDeleteConfirm => 'Excluir';

  @override
  String get journalDeleteCancel => 'Cancelar';

  @override
  String journalDeleteMultiTitle(int count) {
    return 'Excluir $count Sonhos?';
  }

  @override
  String get journalDeleteMultiContent =>
      'Tem certeza de que deseja excluir os sonhos selecionados? Esta ação não pode ser desfeita.';

  @override
  String get proVersion => 'PRO';

  @override
  String get standardVersion => 'Padrão';

  @override
  String get upgradeTitle => 'Atualizar para DreamBoat PRO';

  @override
  String get upgradeBenefits =>
      'Experiência Sem Anúncios\nAnálise Completa de Sonhos\nInterpretação Ilimitada de Sonhos\nAcesso Exclusivo ao Guia';

  @override
  String get upgradeBtn => 'Desbloquear DreamBoat PRO (88,99 ₺)';

  @override
  String get upgradeCancel => 'Talvez depois';

  @override
  String get privacyPolicyLink => 'Política de Privacidade';

  @override
  String get termsOfUseLink => 'Termos de Uso';

  @override
  String get upgradeSuccess => 'Bem-vindo ao DreamBoat PRO!';

  @override
  String get upgradeStart => 'Começar';

  @override
  String get proRequired => 'Versão PRO Necessária';

  @override
  String get proRequiredDetail =>
      'Versão PRO e Pelo Menos 5 Sonhos Registrados Necessários';

  @override
  String get guideUnlockPro => 'Desbloquear Versão PRO';

  @override
  String get guideUnlockHint =>
      'Você deve atualizar para PRO para desbloquear o guia.';

  @override
  String get guideContent => 'Conteúdo';

  @override
  String get guideImportance => 'Por que é Importante?';

  @override
  String get guideSteps => 'Passos';

  @override
  String get guideCriteria => 'Critérios de Conclusão';

  @override
  String get guideBrainNoteTitle => 'Nota ao Cérebro';

  @override
  String get guideNextStep => 'Próximo Passo';

  @override
  String get guideDialogTitle => 'Tem certeza de que deseja avançar?';

  @override
  String get guideDialogContent =>
      'Avançar para a próxima etapa sem concluir o passo atual pode prejudicar sua jornada. Tem certeza de que deseja continuar?';

  @override
  String get guideDialogCancel => 'Esperar';

  @override
  String get guideDialogConfirm => 'Estou Pronto';

  @override
  String get guideStart => 'Iniciar Guia';

  @override
  String get privacyTitle => 'Privacidade e GDPR';

  @override
  String get privacyNoticeTitle => 'Aviso de Privacidade NovaBloom Studio';

  @override
  String get privacyNoticeContent =>
      'O DreamBoat é desenvolvido pelo desenvolvedor independente Guney Yilmazer sob a marca NovaBloom Studio. Sua privacidade é nossa maior prioridade. O DreamBoat foi projetado para que você registre e analise seus sonhos com segurança para conscientização pessoal.';

  @override
  String get privacySection1Title => '1. Segurança de Dados e Processamento';

  @override
  String get privacySection1Content =>
      'Seus registros de sonhos e dados no aplicativo são armazenados com segurança.\nSeus sonhos são processados apenas para operar os recursos oferecidos pelo aplicativo.\n\nConteúdos de sonhos nunca são compartilhados com terceiros\n\nDados não são usados para fins de publicidade, marketing ou perfil de usuário\n\nAnálises impulsionadas por IA são realizadas exclusivamente para melhorar a experiência do usuário\n\nTextos de sonhos não são usados para treinar modelos de IA\n\nTodas as operações são realizadas de acordo com os padrões KVKK e GDPR';

  @override
  String get privacySection2Title => '2. Conta e Uso';

  @override
  String get privacySection2Content =>
      'O DreamBoat funciona sem a necessidade de criar uma conta.\n\nO aplicativo pode ser usado anonimamente\n\nSeus sonhos e configurações são armazenados apenas no seu dispositivo ou em áreas seguras pertencentes ao aplicativo\n\nInformações de identidade pessoal (nome, e-mail, etc.) não são coletadas obrigatoriamente';

  @override
  String get privacySection3Title => '3. Privacidade e Recursos de Bloqueio';

  @override
  String get privacySection3Content =>
      'O DreamBoat oferece opções adicionais de segurança para proteger a privacidade:\n\nO diário de sonhos pode ser bloqueado com Face ID ou impressão digital\n\nOs sonhos são completamente privados por padrão\n\nO recurso de compartilhamento é opcional e funciona apenas quando o usuário escolhe explicitamente compartilhar\n\nOs sonhos nunca são compartilhados automaticamente ou com terceiros';

  @override
  String get privacySection4Title =>
      '4. Aviso Legal de Saúde e Médico (IMPORTANTE)';

  @override
  String get privacySection4Content =>
      'Este aplicativo não é um dispositivo médico.\n\nInterpretações e análises de sonhos fornecidas são apenas para fins de entretenimento e conscientização pessoal\n\nNão constitui aconselhamento médico, psicológico ou profissional\n\nO aplicativo não coleta nem processa dados biométricos ou de saúde\n\n5. Contato\n\nVocê também pode acessar nossa política de privacidade detalhada em nosso site:\nhttps://www.novabloomstudio.com/pt/privacy';

  @override
  String get supportTitle => 'Fale Conosco';

  @override
  String get supportContent =>
      'Seu feedback é muito valioso para o NovaBloom Studio.\n\nVocê pode nos enviar um e-mail para sugestões, relatórios de bugs ou solicitações de colaboração.';

  @override
  String get supportSendEmail => 'Enviar E-mail';

  @override
  String get supportEmailNotFound => 'Aplicativo de e-mail não encontrado.';

  @override
  String get supportEmailSubject => 'Solicitação de Suporte DreamBoat';

  @override
  String get debugResetTitle => 'Reinício de Debug';

  @override
  String get debugResetContent =>
      'Deseja restaurar o aplicativo para a versão Padrão?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get standard => 'PADRÃO';

  @override
  String get save => 'Salvar';

  @override
  String get timeFormat24h => 'Formato 24 Horas';

  @override
  String get languageTurkish => 'Turco';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get guideSlide1Title => 'A Sabedoria do Antigo Egito';

  @override
  String get guideSlide1Subtitle => 'Portal para a Jornada da Alma';

  @override
  String get guideSlide1Content1 =>
      'Vestígios do que chamamos hoje de sonho lúcido podiam ser vistos no Antigo Egito. Os egípcios interpretavam o sonho como uma experiência consciente dentro do quadro das crenças culturais e espirituais da época.\n\nDe fato, existem narrativas simbólicas que descrevem faraós interagindo com figuras divinas no reino dos sonhos através de sacerdotes.';

  @override
  String get guideSlide1Content2 =>
      'Na medicina moderna, na pesquisa do sono no campo da somnologia, foi observado que o córtex frontal está ativo durante o sono REM, o que significa que as áreas do cérebro associadas à consciência e percepção funcionam de forma semelhante a quando se está acordado. Essas descobertas são interpretadas como semelhanças conceituais com as narrativas de experiências conscientes atribuídas aos sonhos no Antigo Egito.';

  @override
  String get guideSlide2Title => 'Meditações dos Monges Tibetanos';

  @override
  String get guideSlide2Subtitle => 'Transcendendo os Limites da Mente';

  @override
  String get guideSlide2Content1 =>
      'Monges tibetanos, através de práticas de meditação profunda de toda a vida, trataram o sonho lúcido como uma experiência interna destinada a aumentar a consciência mental.\n\nNo alto do Himalaia, monges explorando as camadas da mente apoiaram as experiências de sonhos conscientes com disciplina mental e práticas tradicionais.';

  @override
  String get guideSlide2Content2 =>
      'Em estudos neurológicos recentes, a relação entre práticas de meditação e consciência do sono foi examinada.\n\nÀ luz dessas tradições antigas, este guia especial que preparamos visa despertar este potencial nas profundezas da sua mente e levar a sua consciência para o reino dos sonhos. Você pode começar a jornada de se tornar o arquiteto consciente do seu próprio mundo interior, deixando de ser apenas um espectador em seus sonhos.';

  @override
  String get guideSlide3Title => 'O Segredo dos Filtros dos Sonhos';

  @override
  String get guideSlide3Subtitle => 'Guardião dos Sonhos Conscientes';

  @override
  String get guideSlide3Content1 =>
      'Nas culturas nativas americanas, o filtro dos sonhos era visto como um objeto simbólico associado aos sonhos lúcidos.\n\nEsta prática, passada de geração em geração, foi interpretada como um símbolo cultural representando experiências oníricas. Sob a orientação de xamãs, o filtro dos sonhos foi valorizado como um símbolo associado à consciência consciente e simbolizando conexões espirituais.';

  @override
  String get guideSlide3Content2 =>
      'Na era da informação moderna, o sonho lúcido não é tratado apenas como uma experiência mística de culturas antigas, mas também como uma experiência de consciência estudada na pesquisa científica moderna.\n\nNeste guia de sonhos lúcidos, criado compilando as pesquisas e ensinamentos mais atuais passados de geração em geração, é possível que você descubra diferentes experiências aprofundando a sua consciência mental.';

  @override
  String get guideSlide4Title => 'Guia de Sonhos Lúcidos';

  @override
  String get guideSlide4Content =>
      'Como usar este guia?\n\nEste guia é construído sobre um sistema especial de sonhos lúcidos de 7 fases.\nEm cada fase, você desenvolverá hábitos poderosos que apoiam a consciência do sonho.';

  @override
  String get guideSlide4GainsTitle => 'O Que Ganhará Ao Progredir';

  @override
  String get guideSlide4Gain1 => 'Acessa as camadas profundas dos seus sonhos';

  @override
  String get guideSlide4Gain2 => 'Sua consciência começa a guiar os sonhos';

  @override
  String get guideSlide4Gain3 =>
      'Lugares e pessoas tomam forma de acordo com você';

  @override
  String get guideSlide4Gain4 => 'Ganha mais consciência sobre os seus sonhos';

  @override
  String get guideSlide4ProRequired =>
      'Você deve ter a versão PRO para acessar o guia.';

  @override
  String get guideSlide4UnlockButton => 'Desbloquear Versão PRO';

  @override
  String get guideCompleted => 'Parabéns! Você completou o guia inteiro.';

  @override
  String get delete => 'Excluir';

  @override
  String get actionFavorite => 'Favorito';

  @override
  String get understand => 'Entendi, Continuar';

  @override
  String get error => 'Erro';

  @override
  String get testNotification => 'Enviar Notificação de Teste';

  @override
  String get testNotificationSent => 'Notificação de teste enviada!';

  @override
  String get journalSearchHint => 'Pesquisar seus sonhos...';

  @override
  String get newDreamLoadingText => 'Preparando sua interpretação do sonho...';

  @override
  String get dreamInterpretationTitle => 'Interpretação do Sonho';

  @override
  String get dreamInterpretationReadMore => 'Ler Mais';

  @override
  String get dreamTooShort => 'O sonho foi muito curto para interpretar.';

  @override
  String get dreamGibberish =>
      'Seu sonho não pôde ser interpretado porque não continha conteúdo significativo suficiente.';

  @override
  String get dailyLimitReached =>
      'Você atingiu o limite diário de interpretação de sonhos (100/100).';

  @override
  String get settingsRestorePurchases => 'Restaurar Compras';

  @override
  String get restoreSuccess => 'Versão PRO restaurada com sucesso!';

  @override
  String get restoreNotFound => 'Nenhuma compra anterior encontrada.';

  @override
  String get restoreError =>
      'Falha ao restaurar compras. Por favor, tente novamente.';

  @override
  String get restoreUnavailable =>
      'A loja está indisponível no momento. Por favor, tente mais tarde.';

  @override
  String get restoring => 'Restaurando...';

  @override
  String get offlineInterpretation =>
      'O sonho não pôde ser interpretado devido à falta de internet.';

  @override
  String get offlinePurchase =>
      'Conexão à internet necessária para realizar compras.';

  @override
  String get offlineAnalysis => 'Conexão à internet necessária para análise.';

  @override
  String get proUpgradeSubtitle =>
      'Sem assinatura. Compra única, acesso vitalício.';

  @override
  String get proFeatureAdsTitle => 'Experiência Sem Anúncios';

  @override
  String get proFeatureAdsSubtitle =>
      'Sem anúncios nas interpretações de sonhos.\nConcentre-se apenas nos seus sonhos e no que eles querem lhe dizer.';

  @override
  String get proFeatureCosmicTitle => 'Desbloqueie Conexões Cósmicas';

  @override
  String get proFeatureCosmicSubtitle =>
      'Revela conexões cósmicas adicionais nas interpretações.\nInterpreta seus sonhos junto com as fases da lua e influências planetárias.';

  @override
  String get proFeatureAnalysisTitle => 'Análise Semanal de Padrões de Sonhos';

  @override
  String get proFeatureAnalysisSubtitle =>
      'Revela conexões ocultas entre seus sonhos.\nDescubra temas recorrentes, emoções e mensagens do subconsciente ao longo do tempo.';

  @override
  String get proFeatureGuideTitle => 'Guia de Sonhos Lúcidos';

  @override
  String get proFeatureGuideSubtitle =>
      'Assuma o controle dos seus sonhos.\nTécnicas guiadas passo a passo do iniciante ao avançado.';

  @override
  String get proProcessing => 'Processando...';

  @override
  String get notifDialogTitle => 'Ativar Notificações';

  @override
  String get notifDialogBody =>
      'Permita que o DreamBoat o lembre de registrar seus sonhos todas as manhãs.';

  @override
  String get notifPermissionDenied => 'Permissão de Notificação Negada';

  @override
  String get notifOpenSettings => 'Abrir Configurações';

  @override
  String get notifOpenSettingsHint =>
      'Você precisa ativar as notificações nas configurações.';

  @override
  String get allow => 'Permitir';

  @override
  String get notifReminderBody => 'Não se esqueça de registrar seu sonho! 📝';

  @override
  String get notifReminder1 =>
      'O que o universo sussurrou para você esta noite? ✨';

  @override
  String get notifReminder2 => 'Capture seus sonhos antes que desapareçam! 📓';

  @override
  String get notifReminder3 =>
      'Seu subconsciente deixou uma mensagem para você... 🌙';

  @override
  String get notifReminder4 =>
      'Não está curioso sobre o que aqueles símbolos significam? 🔮';

  @override
  String get notifReminder5 => 'Seu diário de sonhos está esperando ✍️';

  @override
  String get pressBackToExit => 'Pressione voltar novamente para sair';

  @override
  String get moonSyncTitle => 'Sincronização Mensal de Lua e Planeta';

  @override
  String get moonSyncSubtitle => 'Pode ser feito uma vez por mês';

  @override
  String get moonSyncDescription =>
      'A Sincronização de Lua e Planetas analisa seus sonhos do último mês junto com a fase lunar do dia em que os teve e os eventos cósmicos desse período (como Lua de Sangue, eclipses). Ao relacionar as emoções, intensidade e estado de espírito dos seus sonhos com o ciclo lunar, revela a harmonia entre seu estado interior e os ritmos cósmicos e ao que deve prestar atenção durante fases lunares específicas (lua cheia, quarto, etc.). Como foca no ciclo lunar, é gerada uma vez por mês.';

  @override
  String get moonSyncDescriptionShort =>
      'Interpreta seus sonhos junto com os ciclos lunares e eventos cósmicos. Aprenda o que influenciou você este mês e ao que deve prestar atenção.';

  @override
  String get moonSyncBtn => 'Iniciar Análise Cósmica';

  @override
  String moonSyncWait(int days) {
    return 'Você deve esperar $days dias para uma nova análise.';
  }

  @override
  String get moonSyncMinDreams => 'Necessário Pelo Menos 5 Sonhos Registrados';

  @override
  String get moonSyncDone => 'Análise Cósmica Mensal Concluída';

  @override
  String get moonSyncProcessing =>
      'A Análise Cósmica está sendo preparada, por favor aguarde um momento.';

  @override
  String get moonPhaseNewMoon => 'Lua Nova';

  @override
  String get moonPhaseWaxingMoon => 'Lua Crescente';

  @override
  String get moonPhaseFullMoon => 'Lua Cheia';

  @override
  String get moonPhaseWaningMoon => 'Lua Minguante';

  @override
  String get actionShareInterpretation => 'Compartilhar\nInterpretação';

  @override
  String get shareImage => 'Compartilhar\nImagem';

  @override
  String get sharePrivacyHint =>
      'Nota: O botão Compartilhar Interpretação apenas compartilha a interpretação. Seus sonhos pertencem a você e nunca são compartilhados com terceiros.';

  @override
  String get moonPhaseLabel => 'Fase Lunar:';

  @override
  String get readMore => 'Ler mais...';

  @override
  String get tapForDetails => 'Toque para detalhes...';

  @override
  String nSelected(int count) {
    return '$count Selecionados';
  }

  @override
  String get shareCardHeader => 'MINHA INTERPRETAÇÃO DE SONHOS DIÁRIA';

  @override
  String get shareCardWatermark => 'Interpretado com DreamBoat App';

  @override
  String get subscriptionComingSoon =>
      'O sistema de assinatura chegará em breve!';

  @override
  String get subscribeMonthly => 'Assinar Mensal';

  @override
  String get subscribeYearly => 'Assinar Anual';

  @override
  String get planMonthly => 'MENSAL';

  @override
  String get planAnnual => 'ANUAL';

  @override
  String get mostPopular => 'MAIS POPULAR';

  @override
  String get discountPercent => '-30% DESCONTO';

  @override
  String get subscribeNow => 'Assinar Agora';

  @override
  String get billingMonthly =>
      'Assinatura mensal com renovação automática.\nCancele quando quiser.';

  @override
  String get billingAnnual =>
      'Assinatura anual com renovação automática. Cobrado uma vez por ano. Cancele a qualquer momento.';

  @override
  String get proFeatureAds => 'Experiência Sem Anúncios';

  @override
  String get proFeatureAnalysis => 'Análise Semanal de Padrões';

  @override
  String get proFeatureGuide => 'Guia de Sonhos Lúcidos';

  @override
  String get proFeatureMoonSync => 'Sincronização Lunar e Planetária';

  @override
  String get freeTrialDays => 'Dias de Teste Grátis';

  @override
  String get freeTrialBadge => 'Primeiros 7 dias grátis';

  @override
  String get priceLoading => 'Carregando...';

  @override
  String get priceLoadError => 'Preço indisponível';

  @override
  String get priceRetryButton => 'Tentar Novamente';

  @override
  String get then => 'Depois';

  @override
  String get reviewSatisfactionTitle => 'Gostando do DreamBoat?';

  @override
  String get reviewSatisfactionContent =>
      'Compartilhe sua experiência conosco!';

  @override
  String get reviewOptionYes => 'Sim, adorei!';

  @override
  String get reviewOptionNeutral => 'Mais ou menos';

  @override
  String get reviewOptionNo => 'Não muito';

  @override
  String get reviewFeedbackTitle => 'Sua opinião importa';

  @override
  String get reviewFeedbackContent =>
      'Como podemos melhorar? Sinta-se à vontade para nos escrever.';

  @override
  String get reviewFeedbackButton => 'Fale Conosco';

  @override
  String get reviewCancel => 'Cancelar';

  @override
  String get adConsentTitle => 'Mais Uma Interpretação de Sonho ✨';

  @override
  String get adConsentBody =>
      'Para manter o DreamBoat gratuito, você pode assistir a um breve anúncio para interpretar este sonho ou atualizar para o PRO para remover limites.';

  @override
  String get adConsentWatch => 'Assistir Anúncio e Interpretar';

  @override
  String get adConsentPro => 'Atualizar para PRO (Sem Anúncios)';

  @override
  String get adLoadError =>
      'O anúncio não está pronto. Por favor, tente novamente ou atualize para PRO.';

  @override
  String get adRetry => 'Tentar Anuncio Novamente';

  @override
  String get adSkipThisTime => 'Bu sefer reklamsız devam';

  @override
  String get intensityFeltLight => 'Sentido levemente';

  @override
  String get intensityFeltMedium => 'Sentido moderadamente';

  @override
  String get intensityFeltIntense => 'Sentido intensamente';

  @override
  String get statsDreamLabel => 'Sonhos';

  @override
  String statsRecordedDreams(Object count) {
    return 'Sonhos registrados: $count';
  }

  @override
  String get settingsSupportId => 'ID de Suporte';

  @override
  String get settingsSupportIdCopied =>
      'ID copiado! Você pode enviar este código para nossa equipe de suporte.';

  @override
  String get guideIntentExerciseTitle => 'Vamos repetir juntos antes de dormir';

  @override
  String get guideIntentPhrase =>
      'No meu próximo sonho, vou perceber que estou sonhando.';

  @override
  String get guideIntentRepeatButton => 'Repetir';

  @override
  String guideIntentProgress(Object count) {
    return '$count / 10 repetições';
  }

  @override
  String get guideIntentComplete =>
      'Você está pronto! Agora pode dormir com esta intenção. 🌙';

  @override
  String get wildBreathTitle => 'Modo de Respiração e Relaxamento';

  @override
  String get wildBreathStart => 'Iniciar Modo de Respiração e Relaxamento';

  @override
  String get wildBreathInhale => 'Inspire';

  @override
  String get wildBreathHold => 'Segure';

  @override
  String get wildBreathExhale => 'Expire';

  @override
  String get wildBreathFocus => 'Concentre-se apenas na sua respiração';

  @override
  String get wildBreathTapToExit => 'Toque para sair';

  @override
  String get wbtbDreamsTitle => 'Seus sonhos WBTB';

  @override
  String get wbtbDreamsDesc =>
      'Veja os sonhos registrados nas noites que praticou esta técnica.';

  @override
  String get wbtbDreamsButton => 'Ver sonhos WBTB';

  @override
  String get wbtbNoDreamsTitle => 'Ainda não há sonhos desta etapa';

  @override
  String get wbtbNoDreamsDesc =>
      'Registre seus sonhos após praticar esta técnica.';

  @override
  String get wbtbAddFirstDream => 'Adicionar meu primeiro sonho';

  @override
  String get timeAwarenessTitle => 'Exercício de Verificação de Realidade';

  @override
  String get timeAwarenessInstruction => 'Responda em voz alta antes de dormir';

  @override
  String get timeAwarenessQ1 => 'Qual é a data de hoje?';

  @override
  String get timeAwarenessQ2 => 'Que dia da semana é hoje?';

  @override
  String get timeAwarenessQ3 => 'REMOVED';

  @override
  String get timeAwarenessQ4 => 'Que horas são exatamente?';

  @override
  String get timeAwarenessQ5 => 'Olhe ao redor e nomeie 3 objetos.';

  @override
  String get timeAwarenessQ6 => 'Qual a cor da sua roupa?';

  @override
  String get timeAwarenessQ11 => 'Que sons você ouve agora?';

  @override
  String get timeAwarenessQ7 =>
      'Quem foi a primeira pessoa com quem você falou hoje?';

  @override
  String get timeAwarenessQ8 => 'Olhe para suas mãos e conte seus dedos.';

  @override
  String get timeAwarenessQ9 => 'Respire fundo e pergunte \'Estou sonhando?\'';

  @override
  String get timeAwarenessQ10 =>
      'Agora feche os olhos e imagine que está dormindo.';

  @override
  String get stage5Task1 => 'Mantive um Diário de Sonhos';

  @override
  String get stage5Task2 => 'Experimentei Sinal de Consciência no Sonho';

  @override
  String get stage5Hint =>
      'Toque nas estrelas ao cumprir. O progresso desbloqueia ao completar todas as tarefas.';

  @override
  String get stage6Task1 => 'Consegui manipular conscientemente meu sonho';

  @override
  String get stage6Hint =>
      'Toque nas estrelas ao cumprir as condições. O progresso desbloqueia quando todas as 3 estrelas estiverem marcadas.';

  @override
  String get guideCriteriaNotMet =>
      'Você deve completar os critérios desta etapa para prosseguir.';

  @override
  String rateLimitWait(int minutes) {
    return 'Muitas solicitações. Por favor, tente novamente em $minutes minuto(s).';
  }

  @override
  String get analysisStep1 => 'Escaneando símbolos do sonho...';

  @override
  String get analysisStep2 => 'Mapeando o subconsciente...';

  @override
  String get analysisStep3 => 'Conectando arquétipos...';

  @override
  String get analysisStep4 => 'Analisando profundidade psicológica...';

  @override
  String get analysisStep5 => 'A interpretação está sendo preparada...';

  @override
  String get analysisLongWait =>
      'Seu sonho está sendo analisado detalhadamente...';

  @override
  String get newDreamSaveShort => 'Salvar Sonho';

  @override
  String get supportTechInfoNote =>
      'As informações técnicas abaixo ajudam-nos a resolver o seu problema mais rapidamente. Por favor, não apague.';

  @override
  String get onboardingWelcomeTitle => 'Você pode não ter sonhado ainda';

  @override
  String get onboardingWelcomeSubtitle =>
      'Enquanto isso, vamos descobrir seu perfil geral de sonhos.';

  @override
  String get surveyQ1 =>
      'Com que frequência você costuma lembrar dos seus sonhos?';

  @override
  String get surveyQ1Option1 => 'Nunca';

  @override
  String get surveyQ1Option2 => '1-2 vezes por mês';

  @override
  String get surveyQ1Option3 => '1-2 vezes por semana';

  @override
  String get surveyQ1Option4 => 'Quase todos os dias';

  @override
  String get surveyQ2 => 'Qual melhor descreve seu horário de sono?';

  @override
  String get surveyQ2Option1 => 'Muito irregular';

  @override
  String get surveyQ2Option2 => 'Um pouco irregular';

  @override
  String get surveyQ2Option3 => 'Geralmente regular';

  @override
  String get surveyQ2Option4 => 'Muito regular';

  @override
  String get surveyQ3 => 'Qual o tom geral dos seus sonhos?';

  @override
  String get surveyQ3Option1 => 'Pacífico';

  @override
  String get surveyQ3Option2 => 'Misto';

  @override
  String get surveyQ3Option3 => 'Tenso';

  @override
  String get surveyQ3Option4 => 'Assustador';

  @override
  String get surveyQ4 => 'Como você costuma se sentir em seus sonhos?';

  @override
  String get surveyQ4Option1 => 'No controle';

  @override
  String get surveyQ4Option2 => 'Como um observador';

  @override
  String get surveyQ4Option3 => 'Fugindo';

  @override
  String get surveyQ4Option4 => 'Explorando';

  @override
  String get profile1Name => 'Viajante Sonhador';

  @override
  String get profile1Desc =>
      'A exploração, a busca por significado e a consciência emocional se destacam em seus sonhos.\n\nSeu subconsciente geralmente fala com você em símbolos. Você sente que pequenos detalhes na vida realmente têm um grande significado.\n\nÀ medida que registra seus sonhos, você começará a ver seu mundo interior com mais clareza.';

  @override
  String get profile2Name => 'Observador Silencioso';

  @override
  String get profile2Desc =>
      'Você está nos eventos em seus sonhos, mas sente que não está no controle.\n\nSeu subconsciente está tentando digerir o que você experimentou. Pensamentos da vida diária penetram em seus sonhos com transições suaves.\n\nEscrever seus sonhos pode aliviar o fardo em sua mente.';

  @override
  String get profile3Name => 'Explorador Emocional';

  @override
  String get profile3Desc =>
      'Seus sonhos são intensos, detalhados e emocionalmente fortes.\n\nSeu subconsciente oferece cenas para você se conhecer. Você tem um vínculo forte com seu mundo interior.\n\nAcompanhar seus sonhos pode lhe dar insights sérios.';

  @override
  String get profile4Name => 'Guerreiro Mental';

  @override
  String get profile4Desc =>
      'Temas de pressão, fuga e luta se destacam em seus sonhos.\n\nO estresse diário pode ser refletido em seus sonhos. Seu subconsciente está sinalizando para você \'desacelerar\'.\n\nEscrever seus sonhos pode proporcionar alívio mental.';

  @override
  String get profile5Name => 'Arquiteto Controlador';

  @override
  String get profile5Desc =>
      'Há um senso de direção e domínio consciente em seus sonhos.\n\nVocê pode ter uma estrutura planejada, organizada e consciente em sua vida. Os sonhos funcionam como um parquinho para você.\n\nSeu potencial de sonho lúcido é alto.';

  @override
  String get profile6Name => 'Mergulhador Profundo';

  @override
  String get profile6Desc =>
      'Seus sonhos podem ser intensos e às vezes perturbadores.\n\nSeu subconsciente traz emoções reprimidas ao palco. Isso não é uma coisa ruim; pense nisso como um processo de limpeza.\n\nEscrever seus sonhos pode aliviar seus fardos internos.';

  @override
  String get profile7Name => 'Viajante dos Sonhos';

  @override
  String get profile7Desc =>
      'Há um estado de calma e fluxo em seus sonhos.\n\nVocê pode ser alguém que observa a vida à distância e experimenta emoções profundamente. Os sonhos funcionam como uma área de descanso mental para você.\n\nUm diário de sonhos o fortalece ainda mais.';

  @override
  String get profile8Name => 'Passageiro do Limiar Consciente';

  @override
  String get profile8Desc =>
      'Seus sonhos são muito vívidos, mas às vezes cansativos.\n\nVocê vai e volta entre a consciência e o subconsciente. Você é um dos perfis mais próximos do sonho lúcido.\n\nVocê pode gerenciar seus sonhos conscientemente com um pouco de equilíbrio.';

  @override
  String get surveyDisclaimer =>
      'Esta análise não é uma avaliação científica ou médica.\nÉ apenas para fins de entretenimento e conscientização.';

  @override
  String get surveyResultTitle => 'Seu Perfil de Sonhos';

  @override
  String get surveyContinue => 'Iniciar DreamBoat';

  @override
  String get welcomeHeader => 'Bem-vindo ao DreamBoat';

  @override
  String stepProgress(Object current, Object total) {
    return 'Passo $current / $total';
  }

  @override
  String get emailLabelSupportId => 'ID de Suporte (ID do Usuário)';

  @override
  String get emailLabelAppVersion => 'Versão do App';

  @override
  String get emailLabelPlatform => 'Plataforma';

  @override
  String get emailLabelLanguage => 'Idioma';

  @override
  String get biometricLockTitle => 'Gostaria de bloquear seu Diário de Sonhos?';

  @override
  String get biometricLockMessage =>
      'Seus sonhos podem ser muito pessoais.\nVocê pode proteger seu Diário de Sonhos com impressão digital / Face ID.';

  @override
  String get biometricLockYes => 'Sim, Proteger';

  @override
  String get biometricLockNo => 'Agora Não';

  @override
  String get biometricLockReason =>
      'Autentique-se para acessar o Diário de Sonhos';

  @override
  String get biometricLockSettingsTitle => 'Bloqueio do Diário de Sonhos';

  @override
  String get biometricLockSettingsSubtitle =>
      'Proteger com impressão digital / Face ID';

  @override
  String get biometricNotAvailable =>
      'Recurso biométrico não encontrado no seu dispositivo. Você pode adicionar dados biométricos em Configurações > Segurança.';

  @override
  String get biometricAuthFailed => 'Autenticação falhou';

  @override
  String get offlineSaveTitle => 'Sem Conexão com a Internet';

  @override
  String get offlineSaveContent =>
      'Você pode salvar seu sonho no diário, mas ele não pode ser interpretado sem internet.';

  @override
  String get offlineSaveConfirm => 'Salvar Sem Interpretação';

  @override
  String get offlineSaveCancel => 'Cancelar';

  @override
  String get errorNoInternet => 'Sem conexão com a internet.';

  @override
  String get errorGeneric => 'Ocorreu um erro inesperado.';

  @override
  String get errorGenericRetry =>
      'Ocorreu um erro. Por favor, tente novamente.';

  @override
  String get dreamSavedNoInterpretation => 'Sonho salvo no diário.';

  @override
  String get watchAdForInterpretation =>
      'Torne-se PRO ou assista a um anúncio para a interpretação de IA.';

  @override
  String get interpretationSkipped =>
      'Anúncio não assistido, sonho salvo sem interpretação.';

  @override
  String weeklyLimitLeft(int count) {
    return 'Restam $count interpretações gratuitas esta semana';
  }

  @override
  String get specialOffer => '🔥 OFERTA ESPECIAL';

  @override
  String get welcomeOfferFirstTime => 'Oferta para novos assinantes';

  @override
  String welcomeOfferExpires(String time) {
    return 'Oferta expira em: $time';
  }

  @override
  String streakDays(int count) {
    return '$count dias seguidos';
  }

  @override
  String get streakSubtitle => 'Sua jornada de sonhos continua';

  @override
  String get proFeatureImageGenTitle => 'Gerar Imagem de Sonho Diária';

  @override
  String get proFeatureImageGenSubtitle =>
      'Transforme seus sonhos em arte vívida. Dê vida a um sonho todos os dias.';

  @override
  String get visualizeDream => 'Visualizar sonho';

  @override
  String get visualizingDream =>
      'A IA está transformando seu sonho em uma obra de arte única... Esse processo pode levar cerca de 30 a 45 segundos.';

  @override
  String get imageGenLimitReached => 'Limite Diário Atingido';

  @override
  String get imageGenLimitDesc =>
      'Você pode gerar 1 imagem de sonho por dia. Volte amanhã!';

  @override
  String get imageGenLimitTrial => 'Limite de Teste Atingido';

  @override
  String get imageGenLimitTrialDesc =>
      'O teste inclui 1 imagem grátis. Faça upgrade para PRO para imagens diárias.';

  @override
  String get shareVisualizedBy => 'Visualizado com DreamBoat App';

  @override
  String get shareVisualSubject => 'Rüya Görselleştirmem';

  @override
  String get offlineImageGenTitle => 'Erro de Conexão';

  @override
  String get offlineImageGenContent =>
      'Não foi possível gerar imagem. Verifique sua conexão. O limite não foi consumido.';

  @override
  String get limitReachedTitle => 'Limite Atingido';

  @override
  String get trialImageLimitReached =>
      'Você usou sua visualização de teste gratuita. Após o período de teste, você pode criar uma nova imagem diária com PRO!';

  @override
  String get dailyImageLimitReached =>
      'Você usou sua visualização diária. Volte amanhã para uma nova imagem!';

  @override
  String get visualizeDreamSubtitle =>
      'Um quadro inspirado no seu sonho, criado com IA.';

  @override
  String get cosmicConnectionTitle => 'Conexão Cósmica';

  @override
  String get unlockProConnection => 'Desbloquear';

  @override
  String dreamMoonPhasePrefix(Object phase) {
    return '(Fase da Lua do seu Sonho: $phase)';
  }
}
