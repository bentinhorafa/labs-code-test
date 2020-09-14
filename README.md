# 87labs - Code challenge
Este repositório foi criado para propor a solução do seguinte desafio: [Desafio Caixa ATM - 87Labs](https://gist.github.com/macedo/941b25a7be92d058b95b73cdc2e9643d).

## <a name="tech_info"></a>Informações técnicas
- Linguagem: Ruby (v `2.7.0`)
- Framework: Rails (v `6.0.3.2`)
- Banco de Dados: PostgreSQL (v `10.14 (Ubuntu 10.14-0ubuntu0.18.04.1)`)
---

## Para conseguir executar este projeto, você deve:
1. Possuir o Ruby instalado na sua máquina (versão utilizada neste projeto, de preferência), assim como as outras dependências citadas em [Informações técnicas](https://github.com/bentinhorafa/labs-code-test#tech_info);
2. Baixar este repositório com o comando abaixo:
- `git clone git@github.com:bentinhorafa/labs-code-test.git`
3. Na pasta raiz do projeto há o arquivo `.env.yml.sample`. Este sample é um modelo das variáveis de ambiente que você usará em seu projeto, portanto você deve:
- Copiar este arquivo e colar no mesmo local onde o sample está (`labs-code-test/.env.yml.sample` - raiz do projeto);
- Na cópia criada, renomeá-la para `.env.yml`;
- Dentro de `.env.yml`, alterar as informações de DATABASE_USER e DATABASE_PASSWORD para as de seu PostgreSQL local.
4. Executar `bundle install` em seu terminal para que as dependências do projeto sejam instaladas;
5. Executar `bundle exec rails db:create` em seu terminal para que o banco de desenvolvimento seja criado.

### Extra (caso deseje rodar a suite de testes do projeto)
6. Executar `bundle exec rails db:create RAILS_ENV=test` em seu terminal para que o banco de teste seja criado;
7. Executar `bundle exec rspec` em seu terminal para que os testes sejam executados e você veja seu retorno.
---

## Como testar as features localmente
**Antes de executar os passos a seguir, após fazer o mencionado acima, deve entrar na raiz do projeto e executar o seguinte comando para que seja iniciado um "servidor local" e a aplicação fique disponível para os testes:** `rails server`

No seu terminal você deve executar o comando `curl` passando pos parâmetros necessários para que o seu computador faça uma requisição em uma URI que você vai informar também como parâmetro do `curl`. Abaixo, exemplos para que todas as features sejam testadas.

1. Criar uma conta:
```
curl --location --request POST 'http://localhost:3000/api/v1/users' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
  "full_name": "Fausto Silva",
  "document": "12345678910",
  "address": "Rua da Minha Casa, 1000",
  "birthday": "02/05/1950",
  "gender": "M",
  "password": "olocomeu"
}'
```

**OBS: para as requisições abaixo, deve alterar "TOKEN_DA_CONTA" para o token que retornou como resposta da criação de conta.**

2. Atualizar o limite (sucesso somente após 10 minutos):
```
curl --location --request PUT 'http://localhost:3000/api/v1/accounts/update_limit' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: TOKEN_DA_CONTA' \
--data-raw '{
  "limit": 2500.0
}'
```

3. Depósito:
```
curl --location --request POST 'http://localhost:3000/api/v1/accounts/deposit' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: 3374c2b422c535286104a047243752f6' \
--data-raw '{
  "amount": 300.0
}'
```

4. Requisição de saque:
```
curl --location --request POST 'http://localhost:3000/api/v1/accounts/withdraw_request' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: TOKEN_DA_CONTA' \
--data-raw '{
  "amount": 50.0
}'
```

5. Confirmação de saque:
```
curl --location --request POST 'http://localhost:3000/api/v1/accounts/withdraw_confirm' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: 3374c2b422c535286104a047243752f6' \
--data-raw '{
  "account_withdraw_request_id": 1,
  "possibility": 2
}'
```

**Para fazer a transferência, deve antes criar uma outra conta e anotar sua agência e conta.**

6. Transferência:
```
curl --location --request POST 'http://localhost:3000/api/v1/accounts/transfer' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: TOKEN_DA_CONTA' \
--data-raw '{
  "destiny_branch": AGENCIA_CONTA_DESTINO,
  "destiny_account_number": NUMERO_CONTA_DESTINO,
  "amount": 500.0
}'
```

7. Extrato:
```
curl --location --request GET 'http://localhost:3000/api/v1/accounts/statement' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: TOKEN_DA_CONTA'
```

8. Saldo:
```
curl --location --request GET 'http://localhost:3000/api/v1/accounts/balance' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: TOKEN_DA_CONTA'
```
---

## Gems
No arquivo `Gemfile` você consegue visualizar as gems utilizadas para o projeto.
Nenhuma destas gems está relacionada à performance ou segurança, que são atributos essenciais para qualquer sistema de transações monetárias ou similares.

Por ser um projeto de teste de funcionalidades, não foquei na segurança destes dados, como, por exemplo, encriptação do Token, um login mais seguro para o usuário, com uma senha também encriptada (creio que o Devise seria a melhor opção, pois tem inclusive gems de token vinculadas).

As gems utilizadas são especificamente para melhoria do desenvolvimento em si, sendo elas:
- Factory Bot (gerar objetos para os testes automatizados de forma pré-definida, alterando uma informação do obejto somente se necessário);
- RSpec (um dos métodos possíveis dentro do Ruby/Rails para desenvolver as classes de testes. Gosto muito do padrão do RSpec);
- Rubocop (responsável por checar se o desenvolvedor está seguindo boas práticas de desenvolvimento em identação, atribuição de variáveis, definição de métodos, entre outros. Possui um arquivo onde o desenvolvedor pode escolher o que será checado pela gem, no meu caso configurei para que não visualizasse em aluns pontos de todo o projeto);
- Shoulda-Matchers (creio que seja a melhor opção para testar Models! Tem uma sintaxe extramemente simples e deixa o código do teste bem enxuto);
- Simplecov (indica o percentual de cobertura de testes do seu projeto. Usei para conseguir atingir os 100% de cobertura).

## Tópicos relevantes (minhas considerações)
- Ainda não estou, de fato, utilizando a opção de saque informada pelo usuário para nada. Creio que deva ter uma tratativa para armazenar de alguma forma a opção escolhida para que o caixa possa subtrair estas notas;
- O Rubocop aponta AccountsController com um problema de possuir mais de 100 linhas, o que concordo. Creio que o controller pode ser dividudo, assim como faço em Withdraws;
- Em CRUDs creio que seja mais fácil manter os nomes das ações em seus controllers. Tais como index, show, update, create, etc. Em APIs eu acreidto que possam atrapalhar semânticamente. Por exemplo.: `accounts/update_limit` faz um update na conta, assim como `accounts/update` também faria, mas em um deixo bem claro que se trata de uma atualização de limite. Mas isso, claro, é uma opnião totalmente pessoal e que foge (E MUITO) do padrão da comunidade;
- Mesmo com o citado acima, acho que as rotas ainda podem ficar "mais RESTs".
