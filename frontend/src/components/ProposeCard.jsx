import { useState } from "react";
import { ethers } from "ethers";

export default function ProposeCard({ contracts }) {
  const [desc, setDesc] = useState("");
  const [status, setStatus] = useState(null);

  async function propose() {
    if (!desc) { setStatus({ msg: "Enter a description.", type: "error" }); return; }
    try {
      setStatus({ msg: "Creating proposal...", type: "info" });
      const tx = await contracts.governor.propose(
        [ethers.ZeroAddress], [0], ["0x"], desc
      );
      const receipt = await tx.wait();
      setStatus({ msg: "Proposal created! Tx: " + receipt.hash, type: "success" });
      setDesc("");
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <div className="row">
        <input
          placeholder="Proposal description"
          style={{ width: "400px" }}
          value={desc}
          onChange={e => setDesc(e.target.value)}
        />
      </div>
      <button onClick={propose} disabled={!contracts}>Create Proposal</button>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
    </div>
  );
}
