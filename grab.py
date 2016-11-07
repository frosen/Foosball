#coding:utf8

import httplib

class Grab(object):

    def run(self):
        conn = httplib.HTTPConnection("www.baolite.com")
        conn.request("GET", "/index.asp")
        r1 = conn.getresponse()
        print r1.status, r1.reason
        print r1.read()
        conn.close()

############| main |############
if '__main__' == __name__:
    Grab().run()