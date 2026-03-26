# PayBySquareDemo (Delphi XE2, VCL)

Demo desktop aplikácia pre lokálne generovanie textového reťazca Pay by Square.

## Architektúra
- `uMainForm.*` – UI vrstva (formulár, tlačidlá, práca so schránkou).
- `uPaymentData.pas` – dátový model platby (`TPaymentData`) + demo dáta.
- `uPayBySquareValidation.pas` – normalizácia a validácia vstupov.
- `uPayBySquareGenerator.pas` – jadro generovania výsledného stringu.
- `uPayBySquareSelfTest.pas` – jednoduchý deterministický interný test.

## Implementované kroky algoritmu
1. Zostavenie tab-delimited payloadu podľa open-source referencií.
2. Výpočet CRC32 (little-endian) a prefix pred payload.
3. Kompresia payloadu.
4. Prefix dĺžky dát.
5. 5-bit mapovanie cez abecedu `0-9A-V`.

## Dôležitá poznámka ku kompresii
Oficiálne Pay by Square referencie používajú **LZMA1 RAW** parametre (`lc=3, lp=0, pb=2, dict=128k`).

Delphi XE2 nemá vstavaný LZMA encoder, preto demo používa čistú XE2 alternatívu cez `System.ZLib`.
Kód je zámerne navrhnutý tak, aby bolo možné metódu `CompressPayload` nahradiť LZMA implementáciou 1:1.

## Obmedzenia
- UI aj validácia explicitne podporujú iba menu EUR.
- SWIFT/BIC je povinný.
- Poznámka limit 140 znakov.

## Demo vstup
- IBAN: `SK3112000000198742637541`
- SWIFT: `TATRSKBX`
- Suma: `123.45`
- Mena: `EUR`
- VS: `20260001`
- SS: `1234`
- KS: `0308`
- Poznámka: `Demo platba Pay by Square`
- Príjemca: `Demo Prijemca s.r.o.`
- Splatnosť: `2026-04-15`

## Demo výstup
Výstup sa po kliknutí na **Generovať** zobrazí v `TMemo`; rovnaký vstup vždy vracia rovnaký string
(overené v `RunDeterminismSelfTest`).
