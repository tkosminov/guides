import logging
import os
import sys

from celery.schedules import crontab
from flask_caching.backends.filesystemcache import FileSystemCache

logger = logging.getLogger()

DATABASE_DIALECT = os.getenv("DATABASE_DIALECT")
DATABASE_USER = os.getenv("DATABASE_USER")
DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")
DATABASE_HOST = os.getenv("DATABASE_HOST")
DATABASE_PORT = os.getenv("DATABASE_PORT")
DATABASE_DB = os.getenv("DATABASE_DB")

# The SQLAlchemy connection string.
SQLALCHEMY_DATABASE_URI = (
    f"{DATABASE_DIALECT}://"
    f"{DATABASE_USER}:{DATABASE_PASSWORD}@"
    f"{DATABASE_HOST}:{DATABASE_PORT}/{DATABASE_DB}"
)

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = os.getenv("REDIS_PORT", "6379")
REDIS_CELERY_DB = os.getenv("REDIS_CELERY_DB", "0")
REDIS_RESULTS_DB = os.getenv("REDIS_RESULTS_DB", "1")

RESULTS_BACKEND = FileSystemCache("/app/superset_home/sqllab")

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_DB": REDIS_RESULTS_DB,
}
DATA_CACHE_CONFIG = CACHE_CONFIG


class CeleryConfig:
    broker_url = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_CELERY_DB}"
    imports = (
        "superset.sql_lab",
        "superset.tasks.scheduler",
        "superset.tasks.thumbnails",
        "superset.tasks.cache",
    )
    result_backend = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_RESULTS_DB}"
    worker_prefetch_multiplier = 1
    task_acks_late = False
    beat_schedule = {
        "reports.scheduler": {
            "task": "reports.scheduler",
            "schedule": crontab(minute="*", hour="*"),
        },
        "reports.prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=10, hour=0),
        },
    }


CELERY_CONFIG = CeleryConfig

FEATURE_FLAGS = {"ALERT_REPORTS": True}
ALERT_REPORTS_NOTIFICATION_DRY_RUN = True
WEBDRIVER_BASEURL = "http://superset:8088/"
WEBDRIVER_BASEURL_USER_FRIENDLY = WEBDRIVER_BASEURL
SQLLAB_CTAS_NO_LIMIT = True

log_level_text = os.getenv("SUPERSET_LOG_LEVEL", "INFO")
LOG_LEVEL = getattr(logging, log_level_text.upper(), logging.INFO)
