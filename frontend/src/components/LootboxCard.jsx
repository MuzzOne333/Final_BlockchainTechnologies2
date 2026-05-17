import { useState } from "react";

export default function LootboxCard({ contracts }) {
  const [status, setStatus] = useState(null);

  async function open() {
    try {
      setStatus({ msg: "Opening lootbox...", type: "info" });
      const tx = await contracts.lootbox.openLootbox();
      await tx.wait();
      setStatus({ msg: "Lootbox opened!", type: "success" });
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <button onClick={open} disabled={!contracts}>Open Lootbox</button>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
    </div>
  );
}
