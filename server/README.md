# WebSocket Relay

Tiny broadcast relay: any message any client sends gets forwarded to all other connected clients. Lets the iPhone push hand-tracking coordinates to the browser without either of them having to act as a server.

## Setup

```bash
pip3 install websockets
python3 relay.py
```

Listens on `ws://0.0.0.0:8765`.

## How it's used

- The iPhone app connects out to your Mac on port 8765 and sends `{"x":...,"y":...,"z":...}` JSON frames at ~30Hz.
- The browser at `armctl.html` connects to `ws://localhost:8765` and receives the same frames.
- The relay just copies messages between connected sockets — it does not parse or validate anything.

## Why this exists

iOS doesn't allow apps to easily host TCP listeners that browsers can connect to. Reversing the connection direction (iPhone → Mac, Browser → Mac) sidesteps the problem entirely.
