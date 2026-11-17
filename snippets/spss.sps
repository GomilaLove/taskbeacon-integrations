* --- TaskBeacon: SPSS Statistics with the Python 3 integration ---.
BEGIN PROGRAM PYTHON3.
import json, urllib.request
import spss
TB = "https://taskbeacon.io/ping/YOUR-JOB-ADDRESS"
def tb_ping(path="", data=None):
    body = json.dumps(data).encode() if data else None
    req = urllib.request.Request(TB + path, data=body, headers={"Content-Type": "application/json"})
    try:
        urllib.request.urlopen(req, timeout=10)
    except Exception as e:
        print("TaskBeacon ping failed:", e)
tb_ping("/start")
try:
    spss.Submit(r"""
* --- your syntax here (the example data: replace it, e.g. GET FILE='C:\data\sales.sav'.) ---.
DATA LIST FREE / amount.
BEGIN DATA
12.5 7 3
END DATA.
""")
except spss.SpssError as e:
    tb_ping("/fail", {"error": str(e)[:200]})
    raise
tb_ping("", {"rows": spss.GetCaseCount()})
END PROGRAM.
