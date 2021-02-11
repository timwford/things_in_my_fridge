import asyncio
import time
from pprint import pprint

from motor.motor_asyncio import AsyncIOMotorClient
from odmantic import AIOEngine

from config import DATABASE_URL, DATABASE_PORT, DATABASE_NAME


async def make_instances():
    motor = AsyncIOMotorClient(host=DATABASE_URL, port=DATABASE_PORT)
    engine = AIOEngine(motor_client=motor, database=DATABASE_NAME)
    await engine.save_all(instances)
    results = await engine.find(Food)
    pprint(results)


if __name__ == "__main__":
    asyncio.run(make_instances())
