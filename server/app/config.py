from enum import Enum

DATABASE_NAME = 'fridge'

DATABASE_URL = '209.159.204.189'
DATABASE_PORT = 5433

class AutoNameEnum(Enum):
    def _generate_next_value_(name, start, count, last_values):
        return name.lower()