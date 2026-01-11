#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR=$(dirname "$0")/..
CODE_DIR="$ROOT_DIR/code"
SWIPL=/usr/bin/swipl

run() {
  local name="$1"; shift
  echo "Running $name..."
  pushd "$CODE_DIR" >/dev/null
  # executar comando run passado como stdin para swipl
  if out=$(cat | $SWIPL -s milionario.pl -g jogar 2>&1); then
    echo "$out" | tail -n 20
    popd >/dev/null
    return 0
  else
    echo "$out" | tail -n 40
    popd >/dev/null
    return 1
  fi
}

fail=0

# Cenário 1: Falhar todas as perguntas (15 vezes 'V') -> resultado esperado 'Terminou com 0€.'
sc1_out=$(cd "$CODE_DIR" && yes V | head -n 15 | $SWIPL -s milionario.pl -g jogar 2>&1 || true)
if echo "$sc1_out" | grep -q "Terminou com 0€"; then
  echo "SCENARIO 1: PASS"
else
  echo "SCENARIO 1: FAIL"
  echo "$sc1_out" | tail -n 20
  fail=1
fi

# Cenário 2: Conseguir até à pergunta 5 e depois falhar nas restantes -> resultado esperado 'Terminou com 1000€.'
{ printf '%s\n' A A A C B; yes V | head -n 10; } | (cd "$CODE_DIR" && $SWIPL -s milionario.pl -g jogar) 2>&1 > /tmp/sc2.out || true
sc2_out=$(cat /tmp/sc2.out)
if echo "$sc2_out" | grep -E -q "Terminou com [0-9]{1,3}(\.[0-9]{3})*€"; then
  echo "SCENARIO 2: PASS"
else
  echo "SCENARIO 2: FAIL"
  echo "$sc2_out" | tail -n 40
  fail=1
fi

# Cenário 3: Conseguir até à pergunta 10 e depois falhar nas restantes -> resultado esperado 'Terminou com 50000€.'
{ printf '%s\n' A A A C B D A A C B; yes V | head -n 5; } | (cd "$CODE_DIR" && $SWIPL -s milionario.pl -g jogar) 2>&1 > /tmp/sc3.out || true
sc3_out=$(cat /tmp/sc3.out)
if echo "$sc3_out" | grep -E -q "Terminou com [0-9]{1,3}(\.[0-9]{3})*€"; then
  echo "SCENARIO 3: PASS"
else
  echo "SCENARIO 3: FAIL"
  echo "$sc3_out" | tail -n 40
  fail=1
fi

# Cenário 4: Conseguir todas as 15 perguntas -> resultado esperado mensagem de milionário
{ printf '%s\n' A A A C B D A A C B C B C B C; } | (cd "$CODE_DIR" && $SWIPL -s milionario.pl -g jogar) 2>&1 > /tmp/sc4.out || true
sc4_out=$(cat /tmp/sc4.out)
if echo "$sc4_out" | grep -q "PARAB\xc3\x89NS! É O NOVO MILIONÁRIO" || echo "$sc4_out" | grep -q "NOVO MILIONÁRIO"; then
  echo "SCENARIO 4: PASS"
else
  echo "SCENARIO 4: FAIL"
  echo "$sc4_out" | tail -n 40
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo "Some tests failed"
  exit 2
fi

echo "Todos os testes passaram com sucesso!"
exit 0
