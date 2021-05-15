# iOS-marvelHeroes

### Steps to build
1. Clone repo 
```
git clone https://github.com/cesar-ferreira/iOS-marvelHeroes.git
```
2. Install dependences (**CocoaPods needed**)
```
pod install
```

## Descrição
O objetivo é construir a primeira versão de um *app* onde possamos obter a lista de personagens da Marvel.

### Funcionalidades requeridas

O aplicativo deverá:

- [ ] Apresentar uma lista com todos os personagens disponíveis com a opção de busca por nome;
- [ ] Permitir a navegação para os detalhes de cada personagem;
- [ ] Conter uma seção própria com os personagens favoritos, onde os personagens possam ser marcados tanto na lista quanto nos detalhes;
- [ ] Persistir no dispositivo os personagens favoritos para que possam ser acessados em modo *offline*; 

## API
Para desenvolver o app foi usado o endpoint de "Characters" da API Marvel. Para mais informações acesse [https://developer.marvel.com/docs](https://developer.marvel.com/docs).

## Interface
A interface do app é dividida em 3 partes e deve ser desenvolvida conforme os pontos abaixo.

### Home - Characters
* Listagem dos personagens.
* Botão para marcar como favorito nas células.
* Barra de busca para filtrar a lista de personagens por nome.
* Interface de lista vazia, erro.

### Detalhes do personagem
* Botão de favorito.
* Foto em tamanho maior
* Descrição (se houver).

### Favoritos
* Listagem dos personagens marcados como favorito pelo usuário.
* Interface de lista vazia.

