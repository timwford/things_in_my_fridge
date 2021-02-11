import asyncio
import time
from pprint import pprint

from motor.motor_asyncio import AsyncIOMotorClient
from odmantic import AIOEngine

from app.app import Food
from app import DATABASE_URL, DATABASE_PORT, DATABASE_NAME

instances: list[Food] = [
    Food(name="Veggie soup", expire_days=3, created=int(time.time()), active=True),
    Food(name="Hummus", expire_days=4, created=int(time.time()), active=True)
]


async def make_instances():
    motor = AsyncIOMotorClient(host=DATABASE_URL, port=DATABASE_PORT)
    engine = AIOEngine(motor_client=motor, database=DATABASE_NAME)
    await engine.save_all(instances)
    results = await engine.find(Food)
    pprint(results)


if __name__ == "__main__":
    asyncio.run(make_instances())
