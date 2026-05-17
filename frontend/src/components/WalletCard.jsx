import { useWallet } from "../useWallet";

export default function WalletCard({ wallet }) {
  const { address, walletInfo, status, connect } = wallet;

  return (
    <div className="card">
      <button onClick={connect} disabled={!!address}>
        {address ? "Connected ✓" : "Connect MetaMask"}
      </button>
      {status && <div className={`status ${status.type}`}>{status.msg}</div>}
      {walletInfo && (
        <>
          <div className="row">
            <span className="label">Address</span>
            <span className="value">{walletInfo.address}</span>
          </div>
          <div className="row">
            <span className="label">ETH Balance</span>
            <span className="value">{walletInfo.eth} ETH</span>
          </div>
          <div className="row">
            <span className="label">GAME Balance</span>
            <span className="value">{walletInfo.game} GAME</span>
          </div>
          <div className="row">
            <span className="label">Voting Power</span>
            <span className="value">{walletInfo.votes} GAME</span>
          </div>
        </>
      )}
    </div>
  );
}
