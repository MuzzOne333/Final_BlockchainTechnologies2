import { useState } from "react";
import { ethers } from "ethers";
import { SUBGRAPH_URL } from "../constants";

const BADGE = {
  Active: "badge-active",
  Pending: "badge-pending",
  Executed: "badge-executed",
  Queued: "badge-queued",
};

export default function ProposalsCard({ contracts }) {
  const [proposals, setProposals] = useState([]);
  const [status, setStatus] = useState(null);

  async function load() {
    setStatus({ msg: "Loading from subgraph...", type: "info" });
    try {
      const query = `{
        proposals(first: 10, orderBy: createdAt, orderDirection: desc) {
          id proposalId description status forVotes againstVotes
        }
      }`;
      const res = await fetch(SUBGRAPH_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ query }),
      });
      const data = await res.json();
      setProposals(data.data?.proposals || []);
      setStatus({ msg: `Loaded ${data.data?.proposals?.length || 0} proposals.`, type: "success" });
    } catch (e) {
      setStatus({ msg: "Failed: " + e.message, type: "error" });
    }
  }

  async function vote(proposalId, support) {
    try {
      const tx = await contracts.governor.castVote(proposalId, support);
      await tx.wait();
      setStatus({ msg: "Vote cast!", type: "success" });
    } catch (e) {
      setStatus({ msg: e.message, type: "error" });
    }
  }

  return (
    <div className="card">
      <button onClick={load} disabled={!contracts}>Load Proposals from Subgraph</button>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
      {proposals.map(p => (
        <div key={p.id} className="proposal-item">
          <div>
            <strong>#{p.proposalId}</strong>
            <span className={`badge ${BADGE[p.status] || "badge-pending"}`}>{p.status}</span>
          </div>
          <div style={{ color: "#aaa", fontSize: "0.85rem", margin: "4px 0" }}>{p.description}</div>
          <div style={{ fontSize: "0.82rem", color: "#666" }}>
            For: {parseFloat(ethers.formatEther(p.forVotes || "0")).toFixed(0)} |
            Against: {parseFloat(ethers.formatEther(p.againstVotes || "0")).toFixed(0)}
          </div>
          <div className="vote-buttons">
            <button onClick={() => vote(p.proposalId, 1)} disabled={!contracts}>Vote For</button>
            <button className="btn-against" onClick={() => vote(p.proposalId, 0)} disabled={!contracts}>Vote Against</button>
          </div>
        </div>
      ))}
    </div>
  );
}
