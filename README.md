# Bolão do Brasileirão

Este é um aplicativo desenvolvido para fins de aprendizado de diversas ferramentas, incluindo Ruby, Rails, REST, Java, Android, entre outros.

## Instalação

## API

O sistema vem com uma API REST. Através da API, é possivel executar alguns métodos da aplicação, sem a necessidade de uma interface gráfica.
Todas as requisições da API, exceto a de geração de token são autenticadas. Para executá-las, é necessário primeiro se autenticar utilizando o método `/token` e posteriormente, para cada requisição é necessário enviar o token no header da requisição. Para maiores informações, veja os exemplos junto a descrição dos métodos.

- [POST /api/v1/token](#post-apiv1token)
- [POST /api/v1/bet](#post-apiv1bet)
- [GET  /api/v1/round/:round_number](#get-apiv1roundround_number)
- [PUT  /api/v1/round/:round_number](#put-apiv1roundround_number)
- [GET  /api/v1/round/:round_number/bets](#get-apiv1roundround_numberbets)

### POST /api/v1/token

Autentica um usuário e gera um token para ser utilizado em futuras requisições que exijam autenticação.

#### URL

http://localhost:3000/api/v1/token

#### Informações do Recurso

| Formato da resposta | Requer autenticação? | 
|:-------------------:|:--------------------:|
| JSON                | Não                  |

#### Parâmetros

| Parâmetro | Obrigatório? | Descrição                           |
|:----------|:------------:|:------------------------------------|
| user_id   | Sim          | ID da conta do usuário sendo logado |
| password  | Sim          | Senha da conta                      |

#### Requisição Exemplo

```sh
curl -X POST http://localhost:3000/api/v1/token.json \
     -H "Content-Type: application/json" \
     -d '{"user_id":1,"password":"senha"}'
```

#### Retorno Exemplo

```json
{
  "id":1,
  "api_key": "IQFuZSYfW4VqEMIUMH46xgtt",
  "email":"gustavosf@gmail.com",
  "name":"Gustavo",
  "photo":"/photos/gustavo.jpg",
  "last_access":"2015-07-27T01:25:12Z"
}
```

### POST /api/v1/bet

Cria ou atualiza uma aposta

#### URL

http://localhost:3000/api/v1/bet

#### Informações do Recurso

| Formato da resposta | Requer autenticação? | 
|:-------------------:|:--------------------:|
| JSON                | Sim                  |

#### Parâmetros

| Parâmetro     | Obrigatório? | Descrição                      |
|:--------------|:------------:|:-------------------------------|
| game_id       | Sim          | ID do jogo                     |
| home_score    | Sim          | Placar final do time mandante  |
| visitor_score | Sim          | Placar final do time visitante |

#### Requisição Exemplo

```sh
curl -X POST http://localhost:3000/api/v1/bet \
     -H "X-Api-Token: jxPQRiNn1VQ2U4dkdTLdhAtt" \
     -H "Content-Type: application/json" \
     -d '{"game_id": 147, "home_score": 2, "visitor_score": 1}'
```

#### Retorno Exemplo

```json
{
  "message":"Ava\u00ed 2-1 Atl\u00e9tico-PR salvo",
  "bet": {
    "id": 274,
    "game_id": 147,
    "user_id":1,
    "home_score": 2,
    "visitor_score":1,
    "points": 0,
    "updated_at": "2015-07-22T00:30:40Z",
    "created_at": "2015-07-21T01:05:41Z"
  }
}
```

### GET /api/v1/round/:round_number

Busca a lista de jogos de uma determinada rodada

#### URL

http://localhost:3000/api/v1/round/:round_number

#### Informações do Recurso

| Formato da resposta | Requer autenticação? | 
|:-------------------:|:--------------------:|
| JSON                | Sim                  |

#### Parâmetros

| Parâmetro    | Obrigatório? | Descrição                                                                    |
|:-------------|:------------:|:-----------------------------------------------------------------------------|
| round_number | Não          | Número da rodada (1 a 38). Caso não seja informado, retorna a próxima rodada |

#### Requisição Exemplo

```sh
curl -X GET http://localhost:3000/api/v1/round/15.json
     -H "X-Api-Token: jxPQRiNn1VQ2U4dkdTLdhAtt"
```

#### Retorno Exemplo

```json
{
   "round":15,
   "games":[
      {
         "camp_id":394,
         "date":"2015-07-25T18:30:00Z",
         "home_id":"AVA",
         "home_score":1,
         "id":147,
         "round":15,
         "stadium":"Ressacada",
         "visitor_id":"CAP",
         "visitor_score":2
      },
      {
         "camp_id":394,
         "date":"2015-07-25T19:30:00Z",
         "home_id":"GRE",
         "home_score":1,
         "id":145,
         "round":15,
         "stadium":"Gr\u00eamio Arena",
         "visitor_id":"SPT",
         "visitor_score":1
      },
      ...
   ]
}
```

### PUT /api/v1/round/:round_number

Atualiza os jogos e a pontuação de um round

#### URL

http://localhost:3000/api/v1/round/1.json

#### Informações do Recurso

| Formato da resposta | Requer autenticação? | 
|:-------------------:|:--------------------:|
| JSON                | Sim                  |

#### Parâmetros

| Parâmetro    | Obrigatório? | Descrição                                                                   |
|:-------------|:------------:|:----------------------------------------------------------------------------|
| round_number | Não          | Número da rodada (1 a 38). Caso não seja informado, atualiza a rodada atual |

#### Requisição Exemplo

```sh
curl -X PUT http://localhost:3000/api/v1/round/1.json \
     -H "X-Api-Token: jxPQRiNn1VQ2U4dkdTLdhAtt" \
     -d ""
```

#### Retorno Exemplo

```json
{
  "error": false,
  "message": "As apostas da rodada 1 foram atualizadas!"
}
```

### GET /api/v1/round/:round_number/bets

Busca a lista de apostas efetuadas pelo usuário para uma determinada jogada

#### URL

http://localhost:3000/api/v1/round/:round_number/bets

#### Informações do Recurso

| Formato da resposta | Requer autenticação? | 
|:-------------------:|:--------------------:|
| JSON                | Sim                  |

#### Parâmetros

| Parâmetro    | Obrigatório? | Descrição                 |
|:-------------|:------------:|:--------------------------|
| round_number | Sim          | Número da rodada (1 a 38) |

#### Requisição Exemplo

```sh
curl -X GET http://localhost:3000/api/v1/round/1/bets.json \
     -H "X-Api-Token: jxPQRiNn1VQ2U4dkdTLdhAtt"
```

#### Retorno Exemplo

```json
[
   {
      "created_at":"2015-05-09T02:29:54Z",
      "game_id":1,
      "home_score":2,
      "id":1,
      "points":1,
      "updated_at":"2015-05-10T03:25:25Z",
      "user_id":1,
      "visitor_score":0
   },
   {
      "created_at":"2015-05-09T02:30:02Z",
      "game_id":2,
      "home_score":1,
      "id":2,
      "points":1,
      "updated_at":"2015-05-09T22:57:48Z",
      "user_id":1,
      "visitor_score":1
   },
   {
      "created_at":"2015-05-09T02:30:04Z",
      "game_id":3,
      "home_score":2,
      "id":3,
      "points":3,
      "updated_at":"2015-05-10T03:25:25Z",
      "user_id":1,
      "visitor_score":1
   },
   ...
]
```

### GET /api/v1/round/:round_number/vs

Busca a lista de apostas efetuadas por ambos usuários para uma determinada jogada. A lista retorna resultados apenas se a data limite para apostas nesta rodada já passou.

#### URL

http://localhost:3000/api/v1/round/:round_number/vs

#### Informações do Recurso

| Formato da resposta | Requer autenticação? | 
|:-------------------:|:--------------------:|
| JSON                | Sim                  |

#### Parâmetros

| Parâmetro    | Obrigatório? | Descrição                 |
|:-------------|:------------:|:--------------------------|
| round_number | Sim          | Número da rodada (1 a 38) |

#### Requisição Exemplo

```sh
curl -X GET http://localhost:3000/api/v1/round/1/vs.json \
     -H "X-Api-Token: jxPQRiNn1VQ2U4dkdTLdhAtt"
```

#### Retorno Exemplo

```json
[
   {
      "camp_id":394,
      "date":"2015-05-09T18:30:00Z",
      "home_id":"PAL",
      "home_score":2,
      "id":1,
      "round":1,
      "stadium":"Allianz Parque",
      "visitor_id":"CAM",
      "visitor_score":2,
      "bets":[
         {
            "created_at":"2015-05-09T02:29:54Z",
            "game_id":1,
            "home_score":2,
            "id":1,
            "points":1,
            "updated_at":"2015-05-10T03:25:25Z",
            "user_id":1,
            "visitor_score":0
         },
         {
            "created_at":"2015-05-09T16:47:34Z",
            "game_id":1,
            "home_score":2,
            "id":11,
            "points":1,
            "updated_at":"2015-05-09T22:57:48Z",
            "user_id":2,
            "visitor_score":1
         }
      ]
   },
   {
      "camp_id":394,
      "date":"2015-05-09T18:30:00Z",
      "home_id":"CHA",
      "home_score":2,
      "id":2,
      "round":1,
      "stadium":"Arena Cond\u00e1",
      "visitor_id":"CFC",
      "visitor_score":1,
      "bets":[
         {
            "created_at":"2015-05-09T02:30:02Z",
            "game_id":2,
            "home_score":1,
            "id":2,
            "points":1,
            "updated_at":"2015-05-09T22:57:48Z",
            "user_id":1,
            "visitor_score":1
         },
         {
            "created_at":"2015-05-09T16:47:36Z",
            "game_id":2,
            "home_score":1,
            "id":12,
            "points":1,
            "updated_at":"2015-05-09T22:57:48Z",
            "user_id":2,
            "visitor_score":1
         }
      ]
   },
   ...
]
``` 