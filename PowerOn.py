# module Imports
import iLoScraping
import sys

# Checks for command line parameter
if (len(sys.argv) > 1):  # if command line parameter more than
    if (str(sys.argv[1]) == "local"):  # and matches local
        hostname = "10.0.0.05"  # is set to string

else:  # anything other
    hostname = "iloLab.lgDns.co.uk"  # set as default string

# print(hostname)
# executing iloScraping.py function
iLoScraping.iloPowerUp(hostname=hostname,
                       username='username', password='password')
