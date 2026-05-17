import { useState } from "react";

export default function CraftCard({ contracts }) {
  const [recipeId, setRecipeId] = useState("");
  const [status, setStatus] = useState(null);

  async function craft() {
    if (!recipeId) { setStatus({ msg: "Enter recipe ID.", type: "error" }); return; }
    try {
      setStatus({ msg: "Crafting...", type: "info" });
      const tx = await contracts.crafting.craft(recipeId);
      await tx.wait();
      setStatus({ msg: "Item crafted!", type: "success" });
      setRecipeId("");
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <div className="row">
        <input
          placeholder="Recipe ID"
          type="number"
          style={{ width: "150px" }}
          value={recipeId}
          onChange={e => setRecipeId(e.target.value)}
        />
        <button onClick={craft} disabled={!contracts}>Craft</button>
      </div>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
    </div>
  );
}
