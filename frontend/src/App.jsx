import "./style.css";
import { useWallet } from "./useWallet";
import WalletCard from "./components/WalletCard";
import DelegateCard from "./components/DelegateCard";
import ProposalsCard from "./components/ProposalsCard";
import ProposeCard from "./components/ProposeCard";
import StakeCard from "./components/StakeCard";
import LootboxCard from "./components/LootboxCard";
import CraftCard from "./components/CraftCard";
import SwapCard from "./components/SwapCard";

export default function App() {
  const wallet = useWallet();
  const { contracts } = wallet;

  return (
    <>
      <h1>🎮 GameFi DAO</h1>

      <WalletCard wallet={wallet} />

      <h2>🗳️ Delegate Votes</h2>
      <DelegateCard contracts={contracts} />

      <h2>📋 Proposals</h2>
      <ProposalsCard contracts={contracts} />

      <h2>➕ Create Proposal</h2>
      <ProposeCard contracts={contracts} />

      <h2>💰 Stake</h2>
      <StakeCard contracts={contracts} />

      <h2>🎁 Open Lootbox</h2>
      <LootboxCard contracts={contracts} />

      <h2>🔨 Craft Item</h2>
      <CraftCard contracts={contracts} />

      <h2>🔄 Swap</h2>
      <SwapCard contracts={contracts} />
    </>
  );
}
