# --- TaskBeacon: top of the script (standard library only) ---
import json, traceback, urllib.request

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
    # --- your code here ---
    df = [1, 2, 3]  # example data: replace with your own (e.g. pandas.read_csv)
except Exception as e:
    # the error and the last 20 lines of the traceback go with the failure
    tb_ping("/fail", {"error": f"{type(e).__name__}: {e}"[:200],
                       "log": "\n".join(traceback.format_exc().splitlines()[-20:])[-4000:]})
    raise

# --- TaskBeacon: end of the script ---
tb_ping("", {"rows": len(df)})
