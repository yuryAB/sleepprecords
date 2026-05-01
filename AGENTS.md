# AGENTS.md

## Regras gerais

- **Nunca executar builds** (`xcodebuild`, etc.). O usuário faz isso manualmente.
- **Nunca criar worktrees**.
- **Trabalhar sempre na branch indicada pelo usuário**.
- **Não criar, trocar ou decidir branches por conta própria**. Se for necessário usar outra branch, aguardar instrução explícita do usuário.

## Commits

- Quando o usuário digitar `cap`, isso significa: criar um commit e fazer push.
- Antes de qualquer solicitação de commit, incluindo `cap`, resumir as mudanças da branch descrevendo comportamento de produto, regras de negócio e decisões de UX.
- Esse resumo de produto/UX é o padrão para todas as respostas relacionadas a commit, não um caso especial apenas para `cap`.
- Não focar o resumo em detalhes técnicos de baixo nível, exceto quando forem necessários para explicar comportamento visível ao usuário, impacto de negócio ou impacto de UX.
- Títulos e mensagens de commit devem seguir a convenção de idioma do projeto, ser imperativos e ter escopo.
- Títulos de commit devem ser concisos, mas a clareza sobre o impacto de produto importa mais do que serem curtos a qualquer custo.
- Preservar a linguagem de produto do projeto para textos visíveis ao usuário, nomes de telas e termos de domínio.
