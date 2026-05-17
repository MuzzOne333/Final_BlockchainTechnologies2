import { useState } from "react";

export default function DelegateCard({ contracts }) {
  const [addr, setAddr] = useState("");
  const [status, setStatus] = useState(null);

  async function delegate() {
    if (!addr) { setStatus({ msg: "Enter an address.", type: "error" }); return; }
    try {
      setStatus({ msg: "Sending transaction...", type: "info" });
      const tx = await contracts.token.delegate(addr);
      await tx.wait();
      setStatus({ msg: "Delegated successfully.", type: "success" });
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <div className="row">
        <input
          placeholder="Address to delegate to"
          value={addr}
          onChange={e => setAddr(e.target.value)}
        />
        <button onClick={delegate} disabled={!contracts}>Delegate</button>
      </div>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
    </div>
  );
}
