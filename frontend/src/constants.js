export const REQUIRED_CHAIN_ID = "0xaa36a7";

export const TOKEN_ADDRESS = "0x0000000000000000000000000000000000000000";
export const GOVERNOR_ADDRESS = "0x0000000000000000000000000000000000000000";
export const VAULT_ADDRESS = "0x0000000000000000000000000000000000000000";
export const LOOTBOX_ADDRESS = "0x0000000000000000000000000000000000000000";
export const CRAFTING_ADDRESS = "0x0000000000000000000000000000000000000000";
export const AMM_ADDRESS = "0x0000000000000000000000000000000000000000";

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
  "function openLootbox() external",
];

export const CRAFTING_ABI = [
  "function craft(uint256 recipeId) external",
];

export const AMM_ABI = [
  "function swap(uint256 amountIn, uint256 minAmountOut, bool zeroForOne) external returns (uint256)",
];
