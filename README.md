# FinApp

App Flutter de controle financeiro pessoal focado em **quitar dívidas**. Mostra,
mês a mês, quanto entra, quanto sai e **quanto falta conseguir** para não fechar
no vermelho.

```
Receita do mês:   R$ 3.000,00
Despesas do mês:  R$ 4.500,00
Falta conseguir:  R$ 1.500,00
```

## Funcionalidades

- **Resumo mensal**: receitas, despesas (fixas + parcelas de dívidas + faturas),
  saldo, "Falta conseguir", quanto já foi pago e quanto falta pagar.
- **Receitas fixas** e **lançamentos avulsos** (receitas e despesas).
- **Despesas fixas** com valor padrão, ajuste do valor real em cada mês e
  vínculo opcional a um cartão (entra na fatura, sem somar duas vezes).
- **Dívidas** por valor da parcela ou valor total; parcelas restantes e data da
  última parcela sincronizadas nos dois sentidos.
- **Cartões de crédito** com compras à vista ou parceladas, fatura calculada
  automaticamente e atalho "valor total da fatura".
- **Lançamentos** do mês com filtro por tipo e status, marcar como pago/recebido
  (com data) e desfazer.

## Regras de negócio

| Regra | Onde |
|---|---|
| Divisão de parcelas: centavos restantes vão para a **última** parcela | `lib/core/domain/installments.dart` |
| Meses curtos: dia 31 vira o último dia do mês | `lib/core/domain/year_month.dart` |
| Parcelas restantes ↔ data da última parcela | `lib/features/debts/domain/debt_schedule.dart` |
| Fechamento de fatura: compra **no melhor dia ou depois** vai para a fatura seguinte | `lib/features/credit_cards/domain/invoice_rules.dart` |
| Montagem da fatura (compras + despesas fixas vinculadas + valor informado) | `lib/features/credit_cards/domain/invoice.dart` |
| Resumo mensal e "Falta conseguir" | `lib/features/summary/domain/monthly_summary.dart` |

Cada fatura é identificada pelo **mês de vencimento**. Exemplo com melhor dia 1
e vencimento dia 8: compra em 30/09 → fatura de 08/10; compra em 01/10 → fatura
de 08/11.

## Arquitetura

```
lib/
  core/          tema, rotas, banco (drift), utilitários e widgets compartilhados
  features/
    <feature>/
      domain/        entidades e regras puras (testadas)
      data/          repositórios sobre o drift
      presentation/  telas e widgets
```

- Estado: Riverpod. Navegação: go_router com bottom navigation bar.
- Banco: SQLite via drift, com migrations versionadas (`drift_schemas/`).
- Valores em centavos (`int`); datas em ISO 8601; meses como `yyyymm`.

## Requisitos

- Flutter estável (testado com 3.47) e Android SDK.

## Rodando

```bash
flutter pub get
flutter run
```

Código gerado do drift já está versionado. Após alterar tabelas:

```bash
dart run build_runner build
```

## Testes e análise

```bash
flutter analyze
flutter test
```

## Banco de dados: nova versão do schema

1. Altere as tabelas em `lib/core/database/tables/tables.dart`.
2. Incremente `schemaVersion` em `lib/core/database/app_database.dart`.
3. Rode `dart run build_runner build` e `dart run drift_dev make-migrations`.
4. Escreva o passo em `onUpgrade` e rode os testes gerados em `test/drift/`.

## Build para Android

### Assinatura

Crie uma chave uma única vez (guarde o arquivo e a senha: sem eles, novas
versões não instalam por cima da atual):

```bash
keytool -genkey -v -keystore ~/finapp-release.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias finapp
```

Copie `android/key.properties.example` para `android/key.properties` e preencha.
Sem esse arquivo, o release é assinado com a chave de debug.

### APK (instalar direto no celular)

```bash
flutter build apk --release
# build/app/outputs/flutter-apk/app-release.apk
```

Copie o APK para o celular e abra-o (permita "instalar apps desconhecidos"), ou
com o celular conectado via USB e depuração ativada:

```bash
flutter install --release
```

### App Bundle (Play Store)

```bash
flutter build appbundle --release
# build/app/outputs/bundle/release/app-release.aab
```

O `.aab` é o formato da Play Store e não instala direto no celular.
