import functools
import time
import logging
from util import TriangleBuilder, caching, timeit

logger = logging.getLogger(__name__)



def caching(func):
    CACHE = {}

    def wrapper(self, **kwargs):
        key = hash(frozenset(kwargs.items())) ## generas un hash para generar un id unico porque ya tenia esos argumentos.
        if key in CACHE:
            return CACHE[key]
        CACHE[key] = func(self, **kwargs)
        return wrapper(self, **kwargs)

    return wrapper


def timeit(logger):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(self, args, *kwargs):
            start = time.time()
            output = func(self, args, *kwargs)
            logger.info("Execution time %s" % (time.time() - start))
            return output

        return wrapper

    return decorator


def _corner_case_decorator(func):
    def wrapper(self, i, j, *args, **kwargs):
        if j >= i or j == 0:
            return 1
        return func(self, i=i, j=j, *args, **kwargs)

    return wrapper


class TriangleBuilder(object):
    CACHE = {}

    def save(self, i, j, value):
        pass

    def get(self, i, j, default=None):
        pass

    def create(self, i, j):
        pass

    def get_or_create(self, i, j):
        pass

    def get_row(self, index):
        pass
 exit()
