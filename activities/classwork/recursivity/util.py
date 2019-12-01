import functools
import time


def caching(func):
    CACHE = {}
    def wrapper(self, **kwargs):
        key = hash(frozenset(kwargs.items()))
        if key in CACHE:
            return CACHE[key]
        CACHE[key] = func(self, **kwargs)
        return wrapper(self,**kwargs)
    return wrapper

def timeit(logger):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(self,args,*kwargs):
            start = time.time()
            output = func(self,args,*kwargs)
            end = time.time()
            logger.info("Start time %s End time %s" % (start,end))
            logger.info("Execution time %s" % (end - start))
            return output
        return wrapper
    return decorator


def _corner_case_decorator(func):
    def wrapper(self, i, j, *args, **kwargs):
        if j >= i or j == 0:
            return 1
        return func(self, i=i, j=j, *args, **kwargs)
    return wrapper()

class TriangleBuilder(object):
    CACHE = {}

    def save(self, i, j, value):
        self.CACHE[(i,j)] = lambda: value
        return value

    @_corner_case_decorator
    def get(self, i, j, default=lambda: None):
        return self.CACHE.get((i, j), default)()

    @_corner_case_decorator
    def create(self, i, j):
        upper_left = self.get_or_create(i=i-1, j=i-1)
        upper_center = self.get_or_create(i=i-1, j=j)
        return self.save(i=i, j=j, value=upper_center+upper_left)

    def get_or_create(self, i, j):
        return self.get(i, j, default=lambda: self.create(i=i, j=j))

    def get_row(self, index):
        return [str(self.get_or_create(index, j)) for j in range(index+1)]
