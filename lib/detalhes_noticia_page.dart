import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pacote novo para abrir Mapas
import 'modelo_noticia.dart';

class DetalhesNoticiaPage extends StatelessWidget {
  final Noticia noticia;

  const DetalhesNoticiaPage({super.key, required this.noticia});

  Color _corDaCategoria(String categoria) {
    if (categoria.toLowerCase().contains('alerta')) return Colors.red;
    if (categoria.toLowerCase().contains('vacina')) return Colors.teal;
    if (categoria.toLowerCase().contains('doação')) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      
      bottomNavigationBar: _construirBarraNavegacao(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 320,
              child: Image.network(
                noticia.imagemUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.blueGrey));
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _corDaCategoria(noticia.categoria).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      noticia.categoria.toUpperCase(),
                      style: TextStyle(color: _corDaCategoria(noticia.categoria), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    noticia.titulo,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.2),
                  ),
                  const SizedBox(height: 24),

                  // CAIXA DE INFORMAÇÕES INTERATIVAS
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        // BOTÃO DE CALENDÁRIO
                        _infoInterativa(
                          context,
                          icone: Icons.calendar_month, 
                          titulo: 'Data e Hora', 
                          valor: noticia.data,
                          iconeAcao: Icons.add_alarm,
                          corAcao: Colors.orange,
                          aoClicar: () {
                            // TODO: integrar com o calendário do aparelho (ex.: pacote "add_2_calendar").
                            // Por enquanto nada é salvo, então a mensagem não afirma que foi.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Em breve: salvar lembrete da campanha no calendário.'),
                              ),
                            );
                          }
                        ),
                        const Divider(height: 1),
                        // BOTÃO DE MAPAS
                        _infoInterativa(
                          context,
                          icone: Icons.location_on, 
                          titulo: 'Local (Toque para abrir o GPS)', 
                          valor: noticia.local,
                          iconeAcao: Icons.map_outlined,
                          corAcao: Colors.blue,
                          aoClicar: () async {
                            // Codifica o nome do lugar e cria a URL do Google Maps
                            final query = Uri.encodeComponent(noticia.local);
                            final url = Uri.parse('https://maps.google.com/?q=$query');
                            
                            bool abriu;
                            try {
                              abriu = await launchUrl(url, mode: LaunchMode.externalApplication);
                            } catch (_) {
                              abriu = false;
                            }
                            if (!abriu && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Não foi possível abrir o mapa.')),
                              );
                            }
                          }
                        ),
                        const Divider(height: 1),
                        // PÚBLICO-ALVO (Apenas informativo)
                        _infoInterativa(
                          context,
                          icone: Icons.people, 
                          titulo: 'Público-Alvo', 
                          valor: noticia.publicoAlvo,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('Detalhes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 12),
                  
                  Text(
                    noticia.descricaoCompleta,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _corDaCategoria(noticia.categoria),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        noticia.textoBotaoAcao,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _construirSecaoMaisNoticias(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR INTERATIVO (NOVO) ---
  // Esse widget transforma a linha de informação num botão gigante com efeito de clique
  Widget _infoInterativa(BuildContext context, {required IconData icone, required String titulo, required String valor, IconData? iconeAcao, Color? corAcao, VoidCallback? aoClicar}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: aoClicar,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icone, color: Colors.blueGrey, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(valor, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  ],
                ),
              ),
              if (iconeAcao != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: (corAcao ?? Colors.blueGrey).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(iconeAcao, color: corAcao ?? Colors.blueGrey, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirBarraNavegacao() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.home_outlined, color: Color(0xFF3B5998), size: 28), onPressed: () {}),
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_none, color: Colors.grey, size: 28), onPressed: () {}),
              Positioned(right: 12, top: 12, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)))
            ],
          ),
          Container(
            decoration: BoxDecoration(color: const Color(0xFF4A65FF), borderRadius: BorderRadius.circular(12)),
            child: IconButton(icon: const Icon(Icons.add_box_outlined, color: Colors.white), onPressed: () {}),
          ),
          IconButton(icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 24), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.grey, size: 28), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _construirSecaoMaisNoticias(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Outras Campanhas Ativas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.65),
          itemCount: 2, // Mostrando 2 para focar nas reais
          itemBuilder: (context, index) {
            return _construirCardNoticiaReal(context, index);
          },
        ),
      ],
    );
  }

  // Card atualizado com o caso REAL de doação de sangue do HUSF!
  Widget _construirCardNoticiaReal(BuildContext context, int index) {
    bool ehDoacao = index == 0;

    return GestureDetector(
      onTap: () {
        Noticia noticiaRelacionada = ehDoacao ? Noticia(
          titulo: 'Doação de Sangue no HUSF chega em momento crítico',
          descricaoCompleta: 'A Secretaria de Saúde alerta que os estoques do Hemocentro do Hospital Universitário São Francisco (HUSF) estão operando abaixo do limite de segurança. A doação é um ato rápido e seguro. Para doar, é necessário ter entre 16 e 69 anos.',
          imagemUrl: 'https://picsum.photos/800/500?random=15',
          categoria: 'Doação de Sangue',
          data: 'Seg a Sáb - 07h30 às 13h',
          local: 'Hemonúcleo Regional HUSF, Bragança Paulista',
          publicoAlvo: 'Pessoas Saudáveis (16 a 69 anos)',
          textoBotaoAcao: 'Agendar Doação',
        ) : Noticia(
          titulo: 'Prefeitura projeta entrega de 40 novas unidades de saúde',
          descricaoCompleta: 'Com investimento histórico, a cidade modernizará UBSs e ambulatórios, facilitando o acesso da população à saúde básica e preventiva em todas as regiões do município.',
          imagemUrl: 'https://picsum.photos/800/500?random=18',
          categoria: 'Infraestrutura',
          data: 'Projeção para 2026/2027',
          local: 'Município de Bragança Paulista',
          publicoAlvo: 'Toda a População',
          textoBotaoAcao: 'Ver Plano de Obras',
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetalhesNoticiaPage(noticia: noticiaRelacionada)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(color: Color(0xFFF3F4F6), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: Center(child: Icon(ehDoacao ? Icons.bloodtype : Icons.apartment, size: 50, color: ehDoacao ? Colors.red : Colors.blueGrey)), 
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(ehDoacao ? 'Sangue Urgente HUSF' : 'Novos Postos de Saúde', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(ehDoacao ? 'Hemonúcleo Regional' : 'Infraestrutura', style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ehDoacao ? 'Crítico' : 'Breve', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: ehDoacao ? Colors.red : const Color(0xFF1E293B))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}