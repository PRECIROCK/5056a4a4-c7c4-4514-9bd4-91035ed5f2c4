import logging
import json
import fire

from model import SIC
from util import StringWrapper, pretty_print, timeit


URL = "https://www.osha.gov/pls/imis/sic_manual.html"
DEFAULT_INDUSTRY_FILE = "industries.json"

logger = logging.getLogger(__name__)


class Main(object):

    def _recursive_search(self, node, string_wrapper, exact):
        title = node["title"]
        children = node["children"]
        new_children = []
        for child in children:
            is_child_valid = self._recursive_search(child, string_wrapper, exact=exact)
            if is_child_valid:
                new_children.append(child)
        node["children"] = new_children
        succesful_search = len(new_children) or string_wrapper.boolean_search(title, reverse=True, exact=exact)
        return (succesful_search)

    @timeit(logger)
    @pretty_print(logger)
    def search(self, title, exact=False, filename=DEFAULT_INDUSTRY_FILE):
        target_title = StringWrapper(value= title)
        sic_industries = SIC.load_json(filename)
        return []



if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    fire.Fire(Main)
