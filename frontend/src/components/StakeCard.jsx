import { useState } from "react";
import { ethers } from "ethers";
import { VAULT_ADDRESS } from "../constants";

export default function StakeCard({ contracts }) {
  const [amount, setAmount] = useState("");
  const [status, setStatus] = useState(null);

  async function stake() {
    if (!amount || amount <= 0) { setStatus({ msg: "Enter amount.", type: "error" }); return; }
    try {
      const parsed = ethers.parseEther(amount);
      setStatus({ msg: "Approving...", type: "info" });
      const approveTx = await contracts.token.approve(VAULT_ADDRESS, parsed);
      await approveTx.wait();
      setStatus({ msg: "Staking...", type: "info" });
      const tx = await contracts.vault.deposit(parsed, await contracts.token.runner.getAddress());
      await tx.wait();
      setStatus({ msg: "Staked successfully.", type: "success" });
      setAmount("");
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <div className="row">
        <input
          placeholder="Amount to stake"
          type="number"
          value={amount}
          onChange={e => setAmount(e.target.value)}
        />
        <button onClick={stake} disabled={!contracts}>Stake</button>
      </div>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
    </div>
  );
}
