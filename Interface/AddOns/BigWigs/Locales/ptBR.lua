local L = BigWigsAPI:NewLocale("BigWigs", "ptBR")
if not L then return end

-- Core.lua
L.berserk = "Frenesi"
L.berserk_desc = "Mostra uma barra e um contador para quando o chefe entrar em Frenesi."
L.altpower = "Alterar como o poder é mostrado"
L.altpower_desc = "Mostra a janela alternativa de poder, que mostra o quanto de poder alternativo os membros do grupo têm."
L.infobox = "Caixa de informações"
L.infobox_desc = "Exibe uma caixa com informações relacionadas ao encontro."
L.stages = "Estágios"
L.stages_desc = "Ativa funções relacionadas a vários estágios/fases do chefe, como proximidade, barras, etc."
L.warmup = "Preparar"
L.warmup_desc = "Tempo até o combate com o chefe começar."

L.already_registered = "|cffff0000ATENÇÃO:|r |cff00ff00%s|r (|cffffff00%s|r) já existe como um módulo do BigWigs, mas as vezes ele tenta registra-lo novamente. Isso normalmente significa que você tem duas cópias deste módulo na sua pasta de addOns devido a alguma falha ao atualizar um addOn. É recomendado que você delete todas as pastas do BigWigs existentes e reinstale-o novamente."

-- Loader / Options.lua
L.officialRelease = "Você está executando uma versão oficial do BigWigs %s (%s)"
L.alphaRelease = "Você está executando uma versão ALPHA do BigWigs %s (%s)"
L.sourceCheckout = "Você está executando uma cópia de código do BigWigs %s diretamente do repositório."
L.getNewRelease = "Seu BigWigs está desatualizado (/bwv) mas você pode facilmente atualizá-lo usando o Curse Client. Como alternativa, você pode atualizar manualmente em curse.com ou wowinterface.com."
L.warnTwoReleases = "Seu BigWigs está 2 versões desatualizado! Sua versão provavelmente contém bugs, faltam funcionalidades, ou possui contadores incorretos. É extremamente recomendado uma atualização."
L.warnSeveralReleases = "|cffff0000Seu BigWigs está várias versões desatualizado!! Nós recomendamos EXTREMAMENTE a atualização para prevenir problemas de sincronização com outros jogadores!|r"

L.tooltipHint = "|cffeda55fClique|r para resetar todos os módulos executando.\n|cffeda55fAlt-Clique|r para desativá-los.\n|cffeda55fClique-Direito|r para acessar as opções."
L.activeBossModules = "Módulos de chefes ativos:"
L.modulesReset = "Todos os módulos executando foram resetados."
L.modulesDisabled = "Todos os módulos executando foram desativados."

L.oldVersionsInGroup = "Existem pessoas no seu grupo com uma versão antiga ou sem o BigWigs. Você pode ver mais detalhes com /bwv."
L.upToDate = "Atualizado:"
L.outOfDate = "Desatualizado:"
L.dbmUsers = "Usuários do DBM:"
L.noBossMod = "Sem mod de chefes:"
L.offline = "Desconectado"

L.blizzRestrictionsZone = "Esperando até o combate terminar para carregar, devido algumas restrições de combate da Blizzard."
L.finishedLoading = "Combate terminou, BigWigs acabou de carregar."
L.blizzRestrictionsConfig = "Devido as restrições da Blizzard, as configurações precisam ser abertas fora de combate antes de poder ser acessadas em combate."

L.missingAddOn = "Por favor, note que esta zona requer o |cFF436EEE%s|r plugin para os contadores serem exibidos."
L.disabledAddOn = "Você desabilitou o addOn |cFF436EEE%s|r, contadores não serão exibidos."

L.coreAddonDisabled = "BigWigs não irá funcionar corretamente com o addOn %s desativado. Você pode ativa-lo pelo painel de controle de addOn na aba de seleção de personagem."

L.removeAddon = "Por favor remova '|cFF436EEE%s|r' porque este foi substituído por '|cFF436EEE%s|r'."

-- Options.lua
L.options = "Opções"
L.raidBosses = "Chefes de Raid"
L.dungeonBosses = "Chefes de Masmorras"
L.introduction = "Bem-vindo ao BigWigs, onde os encontros com chefes andam. Por favor, aperte o cinto, coma um amendoim e desfrute o passeio. Ele não vai comer os seus filhos, mas vai ajudá-lo a se preparar para esse novo encontro com o chefe como um jantar chique para o seu grupo de raide."
L.toggleAnchorsBtn = "Alterar Âncoras"
L.toggleAnchorsBtn_desc = "Alterar entre mostrar ou ocultar todas as âncoras."
L.testBarsBtn = "Criar Barra de Teste"
L.testBarsBtn_desc = "Criar uma barra para você testar suas configurações de exibição atuais"
L.sound = "Som"
L.flashScreen = "Piscar a tela"
L.flashScreenDesc = "Certas habilidades são importantes o suficiente para precisar de atenção total. Quando essas habilidades afetam você, BigWigs pode piscar a tela."
L.minimapIcon = "Ícone do Mini mapa"
L.minimapToggle = "Altera mostrar/ocultar o ícone do mini mapa."
L.configure = "Configurar"
L.test = "Teste"
L.resetPositions = "Resetar posições"
L.colors = "Cores"
L.selectEncounter = "Selecionar Encontro"
L.listAbilities = "Listar habilidades no chat do grupo"

L.dbmFaker = "Faz de conta que eu estou usando DBM"
L.dbmFakerDesc = "Se um usuário do DBM tem uma versão que verifica quem está usando DBM, ele irá vê-lo na lista. Útil para guildas que forçam usar o DBM."
L.chatMessages = "Mensagens no chat"
L.chatMessagesDesc = "Mostra todas as mensagens na janela de chat padrão além da tela de configuração."
L.zoneMessages = "Mostrar mensagens da zona atual"
L.zoneMessagesDesc = "Desativar isso irá parar de mostrar mensagens quando você entra em uma zona que BigWigs possui contadores, mas você não o instalou. Nós recomendamos que você deixe ligado, pois é a única notificação que você vai receber se nós criarmos contadores para uma nova zona que você ache útil."
L.slashDescTitle = "|cFFFED000Comandos com barra:|r"
L.slashDescPull = "|cFFFED000/pull:|r Envia uma contagem regressiva do pull para a raide."
L.slashDescBreak = "|cFFFED000/break:|r Envia uma pausa dos contadores para a raide."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Envia uma barra personalizada para a raide."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Cria uma barra personalizada que apenas você pode ver."
L.slashDescRange = "|cFFFED000/range:|r Abre o indicador de distância."
L.slashDescVersion = "|cFFFED000/bwv:|r Realiza uma verificação da versão do BigWigs."
L.slashDescConfig = "|cFFFED000/bw:|r Abre a configuração do BigWigs."

L.gitHubTitle = "BigWigs está no GitHub"
L.gitHubDesc = "BigWiggs é um software de código aberto hospedado no GitHub. Nós sempre estamos procurando por novas pessoas para ajudar e todos são bem-vindos para dar uma olhada no nosso código, fazer contribuições e reportar erros. BigWigs é incrível como é hoje na maioria das vezes devido a toda comunidade do WoW que nos ajuda.\n\n|cFF33FF99Nossa API agora é documentada e aberta para leitura na wiki do GitHub.|r"

L.BAR = "Barras"
L.MESSAGE = "Mensagens"
L.ICON = "Ícone"
L.SAY = "Falar"
L.FLASH = "Piscar"
L.EMPHASIZE = "Enfatizar"
L.ME_ONLY = "Apenas quando em mim"
L.ME_ONLY_desc = "Quando você ativar esta opção, mensagens para esta habilidade serão exibidas somente quando afetar você. Por exemplo: 'Bomba: Jogador' só será mostrado se for em você."
L.PULSE = "Pulso"
L.PULSE_desc = "Além de piscar na tela, você também pode ter um ícone relacionado com esta habilidade específica exibido momentaneamente no centro da tela para tentar chamar a sua atenção."
L.MESSAGE_desc = "A maioria das habilidades de encontro vem com uma ou mais mensagens que BigWigs irá mostrar na tela. Se você desativar esta opção, nenhuma das mensagens anexadas a esta opção, se houverem, serão exibidas."
L.BAR_desc = "Quando apropriado, barras são exibidas para algumas habilidades de encontro. Se essa habilidade é acompanhada por uma barra que você deseja ocultar, desabilite esta opção."
L.FLASH_desc = "Algumas habilidades podem ser mais importantes do que outras. Se você quiser que sua tela pisque quando essa habilidade está próxima ou for usada, marque esta opção."
L.ICON_desc = "BigWigs pode marcar os personagens afetados pelas habilidades com um ícone. Isso os torna mais fáceis de detectar."
L.SAY_desc = "Balões de mensagem são fáceis de detectar. BigWigs mostrará uma mensagem de /falar para anunciar as pessoas próximas sobre um efeito em você."
L.EMPHASIZE_desc = "Ativando esta opção, irá enfatizar quaisquer mensagens associadas a esta habilidade, fazendo-a maior e mais visível. Você pode ajustar o tamanho e a fonte da mensagem enfatizada nas opções principais em \"Mensagens\""
L.PROXIMITY = "Exibição de proximidade"
L.PROXIMITY_desc = "Habilidades as vezes requerem que vocês se espalhem. A exibição de proximidade será criada especialmente para essa habilidade, assim você pode ver rapidamente se está seguro ou não."
L.ALTPOWER = "Exibição de poder alternativo"
L.ALTPOWER_desc = "Alguns encontros usarão a mecânica de poder alternativo em jogadores em seu grupo. A exibição de poder alternativo fornece uma visão geral de quem tem o menor/maior poder, podendo ser útil para táticas ou atribuições específicas."
L.TANK = "Apenas Tank"
L.TANK_desc = "Algumas habilidades são importantes apenas para tanks. Se você quiser ver avisos para essa habilidade, independentemente do seu papel, desative esta opção."
L.HEALER = "Apenas Healer"
L.HEALER_desc = "Algumas habilidades são importantes apenas para os healers. Se você quiser ver avisos para essa habilidade, independentemente do seu papel, desative esta opção."
L.TANK_HEALER = "Apenas Tank e Healer"
L.TANK_HEALER_desc = "Algumas habilidades são importantes apenas para os tanks e healers. Se você quiser ver avisos para essa habilidade, independentemente do seu papel, desative esta opção."
L.DISPEL = "Apenas Dispellers"
L.DISPEL_desc = "Se você quiser ver avisos para essa habilidade, mesmo quando você não pode dissipa-lo, desative esta opção."
L.VOICE = "Voz"
L.VOICE_desc = "Se você tiver um plugin de voz instalado, esta opção lhe permitirá reproduzir um arquivo de som que fala este aviso em voz alta para você."
L.COUNTDOWN = "Contagem Regressiva"
L.COUNTDOWN_desc = "Se ativado, uma contagem regressiva sonora e visual será adicionado para os últimos 5 segundos. Imagine alguém contando regressivamente \"5... 4... 3... 2... 1...\" com um número grande no meio da tela."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc

L.advanced = "Opções Avançadas"
L.back = "<< Voltar"

L.tank = "|cFFFF0000Alertas para Tank apenas.|r "
L.healer = "|cFFFF0000Alertas para Healer apenas.|r "
L.tankhealer = "|cFFFF0000Alertas para Tank e Healer.|r "
L.dispeller = "|cFFFF0000Alerta para Dispellers apenas.|r "

-- Statistics
L.statistics = "Estatísticas"
L.norm25 = "25"
L.heroic25 = "25h"
L.norm10 = "10"
L.heroic10 = "10h"
L.lfr = "LFR"
L.flex = "Flex"
L.normal = "Normal"
L.heroic = "Heroico"
L.mythic = "Mítico"
L.wipes = "Derrotas:"
L.kills = "Mortes:"
L.best = "Melhor:"