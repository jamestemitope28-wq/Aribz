# ARIBZ

ARIBZ is a cross-platform mobile trading-bot project.

## V1 starting point
- Android + iPhone
- XAUUSD focus
- M5/M1 sniper workflow
- Liquidity + support/resistance + CHOCH confirmation
- Risk-per-trade control
- Signal dashboard
- Trade history
- Auto-trading toggle (UI only in this first build)

## Architecture planned
Mobile App (Flutter)
        |
        v
ARIBZ API / Trading Server
        |
        v
MT5 Expert Advisor / Broker

## Important
This starter app does NOT place live trades yet. The next stage is the secure API + MT5 bridge, followed by demo-account testing before live execution.
