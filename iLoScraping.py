# iLo Scraping
# iLo 100 / LO100 / HP Proliant
# Virtual Power Switch

# module Imports
import requests as r
from requests.auth import HTTPDigestAuth

# defining PowerUp function


def iloPowerUp(hostname, username, password):
         # using the GET method on the form action
    try:  # trying code
         # executing requests get, using the hostname provided along with the
         # authentication.
        r.get("http://" + hostname + "/chassis.html?PwrCtrl=PowerUp&Button1=Apply",
              auth=HTTPDigestAuth(username, password))
        # looking for connection error exception.
    except r.exceptions.ConnectionError as e:
        # advising network issues seen.
        print("Networks Isssues Encountered")
        print()
        # print(str(e[0])

# defining PowerDown function


def iloPowerDown(hostname, username, password):
        # using the GET method on the form action
    try:  # trying code
        # executing requests get, using the hostname provided along with the
        # authentication.
        r.get("http://" + hostname + "/chassis.html?PwrCtrl=PowerDown&Button1=Apply",
              auth=HTTPDigestAuth(username, password))
        # looking for connection error exception.
    except r.exceptions.ConnectionError as e:
        # advising network issues seen.
        print("Networks Isssues Encountered")
        print()
        # print(str(e[0])
