# Conecta Vida – Página de Detalhes de Notícias

Tela de **detalhes de notícias e campanhas de saúde** feita em **Flutter**, desenvolvida como parte do aplicativo *Conecta Vida*, um projeto em equipe. Neste repositório está a parte que eu desenvolvi: a página que exibe uma notícia completa a partir de um objeto `Noticia` recebido de outra tela do app.

Os conteúdos de exemplo (vacinação contra dengue, doação de sangue, novas unidades de saúde) usam como contexto o município de Bragança Paulista/SP. As imagens são ilustrativas (`picsum.photos`).

## Funcionalidades

- Imagem de capa com indicador de carregamento.
- Selo de categoria com cor automática (alerta, vacina, doação ou padrão).
- Caixa de informações interativas:
  - **Data e hora**: botão de lembrete (por enquanto mostra apenas um aviso; a integração com o calendário ainda não foi implementada).
  - **Local**: abre o endereço no Google Maps via `url_launcher`.
  - **Público-alvo**.
- Descrição completa e botão de ação com texto configurável.
- Seção "Outras Campanhas Ativas" com cards que abrem outra página de detalhes.
- Barra de navegação inferior (visual; os botões ainda não têm ação).

## Tecnologias

- [Flutter](https://flutter.dev) / Dart (SDK `^3.11.4`)
- [`url_launcher`](https://pub.dev/packages/url_launcher) para abrir o mapa
- Plataformas configuradas no repositório: Android e Windows

## Como rodar

Pré-requisito: Flutter SDK instalado (`flutter doctor` sem erros).

```sh
git clone https://github.com/gustavotenorio26062005/pagina-mais-detalhes-dart.git
cd pagina-mais-detalhes-dart
flutter pub get
flutter run            # escolha um emulador/dispositivo Android ou Windows
```

O `android/local.properties` é gerado automaticamente pelo Flutter na primeira execução.

## Estrutura

```
lib/
├── main.dart                  # Ponto de entrada: abre a página com uma notícia de exemplo
├── modelo_noticia.dart        # Classe Noticia (título, descrição, imagem, categoria, data, local...)
└── detalhes_noticia_page.dart # Página de detalhes e widgets auxiliares
android/  windows/             # Projetos nativos gerados pelo Flutter
```

## Como integrar a página em outra tela

Quem tem a lista de notícias cria o objeto e navega para a página:

```dart
onTap: () {
  final noticiaSelecionada = Noticia(
    titulo: 'Mutirão de Vacinação contra Dengue',
    descricaoCompleta: 'A prefeitura de Bragança inicia a fase 2...',
    imagemUrl: 'https://link-da-imagem.jpg',
    categoria: 'Vacinação',
    data: 'Sábado, 12 de Abril',
    local: 'UBS Parque dos Estados',
    publicoAlvo: 'Crianças de 10 a 14 anos',
    textoBotaoAcao: 'Ver Postos no Mapa',
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetalhesNoticiaPage(noticia: noticiaSelecionada),
    ),
  );
},
```

## Aprendizados

- Separar modelo de dados (`Noticia`) e interface, passando dados entre telas pelo construtor.
- Navegação com `Navigator.push` / `MaterialPageRoute`.
- Composição de layouts com `Column`, `Row`, `GridView` e widgets auxiliares reutilizáveis.
- Abertura de aplicativos externos (mapas) com `url_launcher` e tratamento de falhas.
- Trabalho em equipe: desenvolver uma tela isolada com uma interface clara para integração.

## Próximos passos

- Salvar o lembrete no calendário do aparelho.
- Dar ação ao botão principal e à barra de navegação.
- Carregar as notícias de uma fonte de dados real em vez de dados fixos.
