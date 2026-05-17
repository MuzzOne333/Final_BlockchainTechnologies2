import { useState } from "react";
import { ethers } from "ethers";
import {
  REQUIRED_CHAIN_ID,
  TOKEN_ADDRESS, GOVERNOR_ADDRESS, VAULT_ADDRESS,
  LOOTBOX_ADDRESS, CRAFTING_ADDRESS, AMM_ADDRESS,
  TOKEN_ABI, GOVERNOR_ABI, VAULT_ABI,
  LOOTBOX_ABI, CRAFTING_ABI, AMM_ABI,
} from "./constants";

export function useWallet() {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [address, setAddress] = useState(null);
  const [contracts, setContracts] = useState(null);
  const [walletInfo, setWalletInfo] = useState(null);
  const [status, setStatus] = useState(null);

  async function switchNetwork() {
    const chainId = await window.ethereum.request({ method: "eth_chainId" });
    if (chainId === REQUIRED_CHAIN_ID) return true;
    try {
      await window.ethereum.request({
        method: "wallet_switchEthereumChain",
        params: [{ chainId: REQUIRED_CHAIN_ID }],
      });
      return true;
    } catch (e) {
      if (e.code === 4902) {
        await window.ethereum.request({
          method: "wallet_addEthereumChain",
          params: [{
            chainId: REQUIRED_CHAIN_ID,
            chainName: "Base Sepolia",
            nativeCurrency: { name: "ETH", symbol: "ETH", decimals: 18 },
            rpcUrls: ["https://ethereum-sepolia-rpc.publicnode.com"],
            blockExplorerUrls: ["https://sepolia.etherscan.io"],
          }],
        });
        return true;
      }
      return false;
    }
  }

  async function loadWalletInfo(addr, prov, token) {
    const balance = await prov.getBalance(addr);
    const gameBalance = await token.balanceOf(addr);
    const votes = await token.getVotes(addr);
    setWalletInfo({
      address: addr,
      eth: parseFloat(ethers.formatEther(balance)).toFixed(4),
      game: parseFloat(ethers.formatEther(gameBalance)).toFixed(2),
      votes: parseFloat(ethers.formatEther(votes)).toFixed(2),
    });
  }

  async function connect() {
    if (!window.ethereum) {
      setStatus({ msg: "MetaMask not found.", type: "error" });
      return;
    }
    try {
      const ok = await switchNetwork();
      if (!ok) { setStatus({ msg: "Switch to Base Sepolia.", type: "error" }); return; }

      await window.ethereum.request({ method: "eth_requestAccounts" });
      const prov = new ethers.BrowserProvider(window.ethereum);
      const sign = await prov.getSigner();
      const addr = await sign.getAddress();

      const token = new ethers.Contract(TOKEN_ADDRESS, TOKEN_ABI, sign);
      const c = {
        token,
        governor: new ethers.Contract(GOVERNOR_ADDRESS, GOVERNOR_ABI, sign),
        vault: new ethers.Contract(VAULT_ADDRESS, VAULT_ABI, sign),
        lootbox: new ethers.Contract(LOOTBOX_ADDRESS, LOOTBOX_ABI, sign),
        crafting: new ethers.Contract(CRAFTING_ADDRESS, CRAFTING_ABI, sign),
        amm: new ethers.Contract(AMM_ADDRESS, AMM_ABI, sign),
      };

      setProvider(prov);
      setSigner(sign);
      setAddress(addr);
      setContracts(c);
      await loadWalletInfo(addr, prov, token);
      setStatus({ msg: "Connected successfully.", type: "success" });

      window.ethereum.on("accountsChanged", () => window.location.reload());
      window.ethereum.on("chainChanged", () => window.location.reload());
    } catch (e) {
      setStatus({ msg: e.code === 4001 ? "Rejected by user." : e.message, type: "error" });
    }
  }

  return { address, contracts, walletInfo, status, connect, setStatus };
}
