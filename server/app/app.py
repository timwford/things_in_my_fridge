from abc import ABC
from typing import List, Optional

import uvicorn
from fastapi import FastAPI, HTTPException
from motor.motor_asyncio import AsyncIOMotorClient

from odmantic import AIOEngine, Field, Model, ObjectId

from config import DATABASE_URL, DATABASE_PORT, DATABASE_NAME, AutoNameEnum

FoodType = AutoNameEnum('FoodType', 'MEAL INGREDIENT')


class Food(Model, ABC):
    name: str
    expire_days: int = Field(ge=0)
    created: int
    active: bool
    food_type: Optional[str]
    freezer: Optional[bool] = False
    pantry: Optional[bool] = False
    shopping_list: Optional[bool] = False


app = FastAPI()

motor = AsyncIOMotorClient(host=DATABASE_URL, port=DATABASE_PORT)
engine = AIOEngine(motor_client=motor, database=DATABASE_NAME)


@app.get("/food/", response_model=List[Food])
async def get_all_food(active: bool = False):
    if active:
        results = await engine.find(Food, Food.active == True, sort=Food.expire_days)
    else:
        results = await engine.find(Food, sort=Food.expire_days)

    return results


@app.get("/shopping/", response_model=List[Food])
async def get_shopping_list():
    results = await engine.find(Food, Food.shopping_list == True, sort=Food.expire_days)

    return results


@app.put("/food/", response_model=Food)
async def create_food(food: Food):
    db_food = await engine.find_one(Food, Food.id == food.id)

    if db_food is None:
        await engine.save(food)
        return food
    else:
        for object_field, _ in vars(food).items():
            if object_field != "id":
                new = getattr(food, object_field)
                setattr(db_food, object_field, new)

        await engine.save(db_food)
        return db_food


@app.delete("/food/{id}", response_model=Food)
async def delete_food_by_id(id: ObjectId):
    result = await engine.find_one(Food, Food.id == id)
    if result is None:
        raise HTTPException(404)
    await engine.delete(result)
    return result


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, log_level="info")
