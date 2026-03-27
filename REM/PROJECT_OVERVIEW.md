# Sleep Records (REM)

## Introdução

A paralisia do sono é uma condição que afeta milhões de pessoas ao redor do mundo. Durante um episódio, a pessoa acorda — ou está prestes a adormecer — e percebe que não consegue se mover nem falar, frequentemente acompanhada de alucinações visuais, auditivas e sensações corporais intensas. Apesar de ser relativamente comum, muitas pessoas vivem esses episódios de forma isolada, sem ferramentas adequadas para registrar o que sentiram, quando aconteceu ou em quais circunstâncias.

O **Sleep Records** nasceu para preencher essa lacuna. A proposta é simples: oferecer um espaço dedicado para que o usuário registre cada episódio de paralisia do sono com detalhes — data, horário, sensações, emoções e alucinações — criando um histórico organizado que pode revelar padrões e gatilhos que, de outra forma, passariam despercebidos. Esse registro também pode ser compartilhado com profissionais de saúde para auxiliar em acompanhamentos clínicos.

---

## O que o app faz

O Sleep Records permite ao usuário:

- **Registrar episódios** de paralisia do sono com data, horário e nome personalizado
- **Descrever experiências** vividas durante o episódio, escolhendo entre 27 tipos de sensações catalogadas (alucinações visuais, presença falsa, pânico, formigamento, distorção temporal, entre outras)
- **Informar a duração** estimada da paralisia
- **Adicionar anotações** pessoais sobre o episódio
- **Registrar o horário** em que o sono começou
- **Consultar o histórico** completo, organizado por mês e com opção de ordenação
- **Editar ou excluir** registros existentes

O app funciona inteiramente offline, sem necessidade de conta ou conexão com a internet. Todos os dados ficam armazenados localmente no dispositivo do usuário.

---

## Funcionalidades disponíveis

| Funcionalidade | Descrição |
|---|---|
| Criação de registro | Gesto de deslizar para criar um novo episódio |
| Lista de registros | Todos os episódios organizados por mês |
| Edição completa | Todos os campos do registro são editáveis |
| Exclusão com confirmação | Proteção contra exclusão acidental |
| Nome automático | O app gera um nome baseado no dia e horário, mas o usuário pode personalizar |
| Seleção de experiências | 27 tipos de sensações e alucinações para escolher |
| Duração da paralisia | 5 categorias: até 10s, 20-30s, 30-60s, mais de 1 minuto, ou não tenho certeza |
| Anotações | Campo de texto livre com limite de 500 caracteres |
| Idiomas | Português (BR) e Inglês, detectados automaticamente pelo idioma do dispositivo |
| Tela de boas-vindas | Apresentação do app na primeira abertura |

Existem também funcionalidades planejadas para versões futuras, como métricas de qualidade do sono (nível de ruído, luminosidade, temperatura do ambiente) e métricas de rotina pré-sono (nível de estresse, consumo de cafeína, atividade física, uso de tela). Essas estruturas já existem internamente, mas ainda não estão visíveis para o usuário.

---

## Metodologia e arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)**, uma abordagem de organização de código amplamente adotada no desenvolvimento de apps para iOS. A ideia central é separar as responsabilidades em três camadas:

- **Model (Modelo):** representa os dados do app — o que é um registro, o que é uma experiência, quais são as durações possíveis. É a "verdade" do sistema.
- **View (Tela):** é o que o usuário vê e interage. Cada tela é composta por componentes visuais menores e reutilizáveis.
- **ViewModel (Lógica da tela):** faz a ponte entre os dados e a tela. É responsável por validar entradas, preparar informações para exibição e coordenar as ações do usuário.

Essa separação traz benefícios práticos: facilita a manutenção do código, permite que diferentes partes do app evoluam de forma independente e torna mais fácil adicionar novas funcionalidades sem comprometer o que já existe.

### Organização por funcionalidades

O código é organizado por **funcionalidades** (features), não por tipo de arquivo. Isso significa que tudo relacionado ao feed de registros fica junto, tudo relacionado à edição de um registro fica junto, e assim por diante. Essa abordagem facilita a navegação pelo projeto e deixa claro onde cada parte do app vive.

### Tecnologias utilizadas

O app é construído com as ferramentas mais recentes da Apple:

- **SwiftUI** para a construção das telas de forma declarativa
- **SwiftData** para o armazenamento local dos dados no dispositivo
- **Localização nativa** para suporte a múltiplos idiomas

---

## Idiomas suportados

- Português (Brasil)
- Inglês

O idioma é detectado automaticamente com base na configuração do dispositivo.

---

## Estado atual

O app está em desenvolvimento ativo, com todas as funcionalidades principais já implementadas e funcionais. O foco recente tem sido no refinamento da interface (animações, textos) e na reorganização interna do código para melhor manutenção futura.
