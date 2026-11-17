// --- TaskBeacon: top of the script (Node 18+, no packages) ---
const TB = "https://taskbeacon.io/ping/YOUR-JOB-ADDRESS";
async function tbPing(path = "", data) {
  const opts = data ? { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) } : {};
  try { await fetch(TB + path, { ...opts, signal: AbortSignal.timeout(10000) }); }
  catch (e) { console.error("TaskBeacon ping failed:", e.message); }
}

async function main() {
  await tbPing("/start");
  let data;
  try {
    // --- your code here ---
    data = [{ amount: 12.5 }];  // example data: replace with your rows
  } catch (e) {
    await tbPing("/fail", { error: `${e.name}: ${e.message}`.slice(0, 200), log: String(e.stack).split("\n").slice(-20).join("\n") });
    throw e;
  }
  // --- TaskBeacon: end of the script ---
  await tbPing("", { rows: data.length });
}
main().catch((e) => { console.error(e); process.exit(1); });
