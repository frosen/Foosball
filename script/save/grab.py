#coding:utf8

import httplib2

class Grab(object):

    def run(self):

        # conn = httplib.HTTPConnection("www.baolite.com")
        # conn.request("GET", "/index.asp")
        # r1 = conn.getresponse()
        # print r1.status, r1.reason
        # print r1.read()
        # conn.close()
        for i in range(3000, 500000):
            string = str(i + 1)
            strWith0 = string.zfill(7)
            self.grab(strWith0)
            pass

    def grab(self, key):
        url = "http://www.cdgdc.edu.cn/rzgl/attestationInfoManageAction.do?actionType=3&key=" + key
        savePath = "./save" + key + ".html"

        h = httplib2.Http()
        headers = {'Cookie': "JSESSIONID=t6TRYh4TyvRTvyGhXF5srWp9hZjlhfy8MyG7SpFyMypQ5hTnG9V5!122296669; sto-id-20480-web_80=CBAKBAKMJABP; sto-id-20480-rzgl=CMAKBAKMFJBL"}
        resp, content = h.request(url, headers=headers)
        print key, resp.status

        fp = None
        try:
            fp = open(savePath, "w")
            fp.write(content)

        except Exception, e:
            print(savePath + " save exception! " + str(Exception) + ":" + str(e))

        finally:
            if fp: fp.close()


############| main |############
if '__main__' == __name__:
    Grab().run()