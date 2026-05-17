import { useState } from "react";
import { ethers } from "ethers";

export default function SwapCard({ contracts }) {
  const [amountIn, setAmountIn] = useState("");
  const [status, setStatus] = useState(null);

  async function swap() {
    if (!amountIn || amountIn <= 0) { setStatus({ msg: "Enter amount.", type: "error" }); return; }
    try {
      setStatus({ msg: "Swapping...", type: "info" });
      const parsed = ethers.parseEther(amountIn);
      const tx = await contracts.amm.swap(parsed, 0, true);
      await tx.wait();
      setStatus({ msg: "Swap done!", type: "success" });
      setAmountIn("");
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <div className="row">
        <input
          placeholder="Amount in"
          type="number"
          style={{ width: "150px" }}
          value={amountIn}
          onChange={e => setAmountIn(e.target.value)}
        />
        <button onClick={swap} disabled={!contracts}>Swap</button>
      </div>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
    </div>
  );
}
