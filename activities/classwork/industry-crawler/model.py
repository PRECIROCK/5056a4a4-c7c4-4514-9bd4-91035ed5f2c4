import logging

import json
import requests

from bs4 import BeautifulSoup ## para importar datos de fuentes de informacion dinamicas

logger = logging.getLogger(__name__)


class AbstractIndustry(object):

    def __init__(self, title, children):
        logger.info("Creating industry: {}".format(title))
        self.title = title
        self.children = children


    def level(self):
        raise NotImplementedError("Abstract industry doesn´t contains level.")

    def add_child(self, child):
        self.children.append(child)

    def to_dict(self):
        return {
            "title": self.title,
            "children": [
                child.to_dict() for child in self.children
            ]
        }

    def jsonify(self):
        return json.dumps(self.to_dict())

class Division(AbstractIndustry):
    level = "SIC Major Group"

class Group(AbstractIndustry):
    level = "SIC Group"

class MajorGroup(AbstractIndustry):
    level = "SIC Major Group"

    @staticmethod
    def from_url(url):
        response = requests.get(url)
        html = BeautifulSoup(response.text, "html.parser")
        return MajorGroup(
            title=[
                elm.text for elm in html.find_all("h2") if elm.text.lower().startswith("major group")
            ][0],
            children=[
                Group(
                    title=group.text,
                    children=[
                        Single(
                            title="",
                            children=[]
                        )
                        for inner in html.find_all("a")
                        if inner.attrs.get("href","").startswith("sic_manual")
                        and inner.parent.text.startswith(group.text.split(":")[0].split(" ")[-1])
                    ]
                )
                for group in html.find_all("strong") if group.text.lower().startswith("industry group")
            ]
        )


class Single(AbstractIndustry):
    level = "SIC Industry"


class SIC(AbstractIndustry):
    level = "Standard Industry Classification"

    @staticmethod
    def load_son(filename):
        with open(filename, "r") as file:
            sic_industries = json.loads(file.read())
        return sic_industries

    @staticmethod
    def from_url(url):
        response = requests.get(url)
        html = BeautifulSoup(response.text, "html.parser")
        divisions =[]
        for element in html.find_all("a"):
            href = element.attrs.get("href","")
            title = element.attrs.get("title","")
            if not href.startswith("sic_manual"):
                continue
            elif href.endswith("division"):
                divisions.append(Division(title=title, children=[]))
            elif href.endswith("group"):
                major_group_url = url.replace("sic_manual.html", href)
                divisions[-1].add_child(MajorGroup.from_url(major_group_url))
        return SIC(
            title="SIC",
            children=divisions
        )
