export const REQUIRED_CHAIN_ID = "0xaa36a7";

export const TOKEN_ADDRESS = "0x349eeF8B13384cE95edDf869928Adbb9ffA93127";
export const GOVERNOR_ADDRESS = "0x7C5Eb67849Fb6FC947bE3678DFB2f9ff10D75e6F";
export const VAULT_ADDRESS = "0xc4b6982964BE4A688987dE54786bC7007457c192";
export const LOOTBOX_ADDRESS = "0x57a43C3829402d64fA2Cb192F19Be164Cd63f6dA";
export const CRAFTING_ADDRESS = "0x22836F2807cCD5A9DA832f0C31382d220e6B4b4a";
export const AMM_ADDRESS = "0x67D75704f2F3d863beA7DE5a6A6d7AfF63158070";

export const SUBGRAPH_URL = "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3";

export const TOKEN_ABI = [
  "function balanceOf(address) view returns (uint256)",
  "function getVotes(address) view returns (uint256)",
  "function delegate(address delegatee)",
  "function approve(address spender, uint256 amount) returns (bool)",
];

export const GOVERNOR_ABI = [
  "function propose(address[] targets, uint256[] values, bytes[] calldatas, string description) returns (uint256)",
  "function castVote(uint256 proposalId, uint8 support) returns (uint256)",
  "function state(uint256 proposalId) view returns (uint8)",
];

export const VAULT_ABI = [
  "function deposit(uint256 assets, address receiver) returns (uint256)",
];

export const LOOTBOX_ABI = [
  "function openLootBox() external payable returns (uint256)",
];

export const CRAFTING_ABI = [
  "function craft(uint256 recipeId) external",
];

export const AMM_ABI = [
  "function swap(uint256 amountIn, uint256 minAmountOut, bool zeroForOne) external returns (uint256)",
];