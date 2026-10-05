from datetime import datetime, timezone

from fastapi import FastAPI
from pydantic import BaseModel


app = FastAPI(title="ARIBZ API", version="2.0.0")

latest = {}
queue = []
reports = []


class Candle(BaseModel):
    time: int
    open: float
    high: float
    low: float
    close: float


class Scan(BaseModel):
    symbol: str = "XAUUSD"
    candles: list[Candle]


class Report(BaseModel):
    symbol: str
    side: str
    volume: float
    price: float
    sl: float
    tp: float
    ticket: int = 0
    status: str = "OPEN"


def detect(candles):
    if len(candles) < 20:
        return {
            "side": "NONE",
            "reason": "Need 20 M5 candles"
        }

    current = candles[-1]
    previous = candles[-2]
    lookback = candles[-11:-1]

    high = max(c.high for c in lookback)
    low = min(c.low for c in lookback)

    bullish_sweep = (
        current.low < low
        and current.close > low
        and current.close > current.open
        and current.close > previous.high
    )

    bearish_sweep = (
        current.high > high
        and current.close < high
        and current.close < current.open
        and current.close < previous.low
    )

    if bullish_sweep:
        sl = min(current.low, low)
        risk = current.close - sl

        if risk > 0:
            return {
                "side": "BUY",
                "entry": round(current.close, 2),
                "sl": round(sl, 2),
                "tp": round(current.close + (2 * risk), 2),
                "rr": 2.0,
                "reason": "Sell-side liquidity sweep + bullish CHOCH/BOS confirmation"
            }

    if bearish_sweep:
        sl = max(current.high, high)
        risk = sl - current.close

        if risk > 0:
            return {
                "side": "SELL",
                "entry": round(current.close, 2),
                "sl": round(sl, 2),
                "tp": round(current.close - (2 * risk), 2),
                "rr": 2.0,
                "reason": "Buy-side liquidity sweep + bearish CHOCH/BOS confirmation"
            }

    return {
        "side": "NONE",
        "reason": "No confirmed setup"
    }


@app.get("/health")
def health():
    return {
        "ok": True,
        "service": "ARIBZ",
        "time": datetime.now(timezone.utc).isoformat()
    }


@app.get("/api/v1/signal/{symbol}")
def signal(symbol: str):
    return latest.get(
        symbol.upper(),
        {
            "side": "NONE",
            "reason": "No scan received"
        }
    )


@app.post("/api/v1/scan")
def scan(data: Scan):
    result = detect(data.candles)
    symbol = data.symbol.upper()

    latest[symbol] = result

    if result["side"] in ("BUY", "SELL"):
        queue.append({
            **result,
            "symbol": symbol
        })

    return result


@app.get("/api/v1/execution/next")
def next_trade():
    if queue:
        return queue.pop(0)

    return {
        "side": "NONE"
    }


@app.post("/api/v1/execution/report")
def report(data: Report):
    reports.append(data.model_dump())

    return {
        "ok": True
    }
