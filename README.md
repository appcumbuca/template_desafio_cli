# Template para Desafio CLI

Este template tem o objetivo de servir como 
ponto de partida para a implementação de desafios
de contratação da Cumbuca que envolvam implementar
uma interface de linha de comando em Elixir.

## Pré-requisitos

Primeiro, será necessário [instalar o Elixir](https://elixir-lang.org/install.html)
em versão igual ou superior a 1.16.
Com o Elixir instalado, você terá a ferramenta de build `mix`.

Para buildar o projeto, use o comando `mix escript.build` nesta pasta.
Isso irá gerar um binário com o mesmo nome do projeto na pasta.
Executando o binário, sua CLI será executada.

# Raciocínio

- Criar uma função para converter número inteiro para número romano;
- Adicionar uma função para inserir os nomes dos reis e rainhas;
- Criar um hashmap (chave, valor) que armazena o nome do rei/rainha na chave e um número no valor;
- Percorrer todos os nomes inseridos e analisar se o nome já existe no hashmap. 
Se o nome não existir, devo adicionar ele no hashmap (chave: nome_do_rei, valor: 1).  
Se o nome existir, devo incrementar o número referente à chave (chave: nome_do_rei, valor: x + 1).
No final, devo retornar o nome do rei concatenado com o número romano.