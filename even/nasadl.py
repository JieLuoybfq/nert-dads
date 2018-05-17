import sys
import requests
from bs4 import BeautifulSoup

url = str(sys.argv[1])    # to download from
path = str(sys.argv[2])   # to save the img urls

#print url
#print path

soup = BeautifulSoup(requests.get(url).content, 'html5lib')
resultFile = open(path, 'w')
for x in soup.findAll('img'):
    #print x['src']
    resultFile.write('https://lance-modis.eosdis.nasa.gov' + x['src'] + '\n')

resultFile.close()
