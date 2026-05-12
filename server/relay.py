#!/usr/bin/env python3
import asyncio, websockets

connections = set()

async def handler(ws):
    global connections
    connections.add(ws)
    print(f"Connected  ({len(connections)} total)")
    try:
        async for msg in ws:
            dead = set()
            for c in connections:
                if c is not ws:
                    try: await c.send(msg)
                    except: dead.add(c)
            connections -= dead
    finally:
        connections.discard(ws)
        print(f"Disconnected  ({len(connections)} remaining)")

async def main():
    async with websockets.serve(handler, "0.0.0.0", 8765):
        print("Relay running on :8765  —  Ctrl+C to stop")
        await asyncio.Future()

asyncio.run(main())
