# QUEM QUER SER MILIONÁRIO? (PROLOG EDITION)

Bem-vindo à versão de terminal do famoso concurso "Quem Quer Ser Milionário?". Teste os seus conhecimentos, utilize as ajudas de forma estratégica e suba na árvore do dinheiro até chegar ao grande prémio de 1.000.000€.

---

## COMO JOGAR

1. Abra o terminal na pasta do projeto.
2. Inicie o SWI-Prolog com o ficheiro do jogo:
   swipl -l milionario.pl

3. Inicie o jogo executando o comando:
   jogar.

4. Pressione qualquer tecla após a mensagem de boas-vindas para começar o desafio.

---

## COMANDOS DO JOGADOR

Quando uma pergunta é apresentada, pode utilizar os seguintes comandos no prompt:

### 1. Respostas e Navegação
* A, B, C ou D: Submete a opção escolhida como "Resposta Final".
* AJUDA: Abre o menu interativo para escolher uma das ajudas disponíveis.
* STOP: Desiste do jogo e sai com o valor total acumulado até ao momento.

### 2. Linhas de Apoio (Ajudas)
Cada ajuda só pode ser utilizada UMA vez por jogo. Pode escrevê-las diretamente no prompt principal:

* 50/50: Elimina duas opções erradas, restando apenas uma errada e a correta.
* PUBLICO: Simula a votação da audiência em estúdio (mostra percentagens).
* TELEFONE: Simula uma chamada para um amigo que sugere uma resposta.

---

## VALORES E PATAMARES DE SEGURANÇA

Se responder incorretamente, não perde tudo. Ficará com o valor do último patamar de segurança atingido.

| Pergunta | Valor 
| :--- | :--- 
| 1 - 4 | 100€ a 500€ 
| 5 | 1.000€ <<patamar de segurança>>
| 6 - 9 | 2.000€ a 20.000€ 
| 10 | 50.000€ <<patamar de segurança>>
| 11 - 14 | 75.000€ a 500.000€ 
| 15 | 1.000.000€

---

## REQUISITOS DO SISTEMA

* SWI-Prolog instalado.
* Sistema de som funcional (suporta Mac, Linux e Windows).
* Pasta de áudio localiza em: ./music/