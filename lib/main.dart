import 'package:flutter/material.dart';
import 'modelo_noticia.dart'; 
import 'detalhes_noticia_page.dart'; 

void main() {
  runApp(const MeuAppDeTeste());
}

class MeuAppDeTeste extends StatelessWidget {
  const MeuAppDeTeste({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DADO REAL: Campanha da Vacina Butantan-DV em Bragança
    Noticia noticiaDeTeste = Noticia(
      titulo: 'Chegada da Vacina Butantan-DV contra a Dengue fortalece combate em Bragança',
      descricaoCompleta: 'A Prefeitura de Bragança Paulista iniciou a vacinação com a Butantan-DV, imunizante inédito de dose única. \n\nNesta primeira fase, a imunização será destinada aos profissionais da Atenção Primária à Saúde que trabalham na linha de frente (médicos, enfermeiros, agentes comunitários e de endemias). A iniciativa visa proteger os trabalhadores e preparar as equipes para futuras etapas de vacinação ampliada para a população geral.',
      imagemUrl: 'https://picsum.photos/800/500?random=20', // Imagem ilustrativa
      categoria: 'Vacinação / Alerta',
      data: 'Fase Inicial - Horário Comercial',
      local: 'Secretaria Municipal de Saúde - Bragança Paulista',
      publicoAlvo: 'Profissionais da Atenção Primária',
      textoBotaoAcao: 'Ver Diretrizes da Campanha',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Conecta Vida',
      home: DetalhesNoticiaPage(noticia: noticiaDeTeste), 
    );
  }
}