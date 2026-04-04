class Noticia {
  final String titulo;
  final String descricaoCompleta;
  final String imagemUrl;
  final String categoria; // Ex: 'Alerta', 'Vacinação', 'Doação'
  final String data;
  final String local;
  final String publicoAlvo;
  final String textoBotaoAcao;

  Noticia({
    required this.titulo,
    required this.descricaoCompleta,
    required this.imagemUrl,
    required this.categoria,
    required this.data,
    required this.local,
    required this.publicoAlvo,
    required this.textoBotaoAcao,
  });
}