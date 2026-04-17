#!/usr/bin/env npx tsx
/**
 * Enable sBTC as collateral on Zest Protocol
 * Fetches fresh Pyth price data and broadcasts in one shot to avoid staleness.
 */

import {
  makeContractCall,
  broadcastTransaction,
  principalCV,
  contractPrincipalCV,
  boolCV,
  listCV,
  tupleCV,
  someCV,
  bufferCV,
  AnchorMode,
  PostConditionMode,
} from "@stacks/transactions";
import { STACKS_MAINNET } from "@stacks/network";

const BORROW_HELPER = "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.borrow-helper-v2-1-7";
const ZSBTC = "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zsbtc-v2-0";
const SBTC_TOKEN = "SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token";
const ORACLE = "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.stx-btc-oracle-v1-4";

// Pyth price feed IDs: BTC/USD, STX/BTC, USDC/USD
const PYTH_FEED_IDS = [
  "e62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43",
  "ec7a775f46379b5e943c3526b1c8d54cd49749176b0b98e02dde68d1bd335c17",
  "eaa020c61cc479712813461ce153894a96a6c00b21ed0cfc2798d1f9a9e9c94a",
];

const SENDER = "SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE";

function splitContract(id: string) {
  const [address, name] = id.split(".");
  return { address, name };
}

async function fetchPythData(): Promise<Buffer> {
  const params = PYTH_FEED_IDS.map((id) => `ids[]=${id}`).join("&");
  const res = await fetch(
    `https://hermes.pyth.network/v2/updates/price/latest?${params}`
  );
  if (!res.ok) throw new Error(`Pyth fetch failed: ${res.status}`);
  const data = await res.json();
  const hexParts = data.binary?.data || [];
  const combined = hexParts.join("");
  return Buffer.from(combined, "hex");
}

async function getNonce(address: string): Promise<bigint> {
  const res = await fetch(
    `https://api.hiro.so/extended/v1/address/${address}/nonces`
  );
  const data = await res.json();
  return BigInt(data.possible_next_nonce);
}

async function main() {
  const mnemonic = process.env.CLIENT_MNEMONIC;
  if (!mnemonic) {
    console.error("Set CLIENT_MNEMONIC env var");
    process.exit(1);
  }

  // Dynamic import for key derivation
  const { generateWallet } = await import("@stacks/wallet-sdk");
  const wallet = await generateWallet({ secretKey: mnemonic, password: "" });
  const account = wallet.accounts[0];

  console.log("Fetching Pyth price data...");
  const pythBuffer = await fetchPythData();
  console.log(`Pyth data: ${pythBuffer.length} bytes`);

  const nonce = await getNonce(SENDER);
  console.log(`Nonce: ${nonce}`);

  const helper = splitContract(BORROW_HELPER);
  const zsbtc = splitContract(ZSBTC);
  const sbtc = splitContract(SBTC_TOKEN);
  const oracle = splitContract(ORACLE);

  // Full asset list required by the contract for position calculation
  const allAssets = [
    { asset: "SP4SZE494VC2YC5JYG7AYFQ44F5Q4PYV7DVMDPBG.ststx-token", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zststx-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.stx-btc-oracle-v1-4" },
    { asset: "SP3Y2ZSH8P7D50B0VBTSX11S7XSG24M1VB9YFQA4K.token-aeusdc", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zaeusdc-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.aeusdc-oracle-v1-0" },
    { asset: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.wstx", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zwstx-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.stx-btc-oracle-v1-4" },
    { asset: "SP2C2YFP12AJZB4MABJBAJ55XECVS7E4PMMZ89YZR.arkadiko-token", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zdiko-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.diko-oracle-v1-1" },
    { asset: "SPN5AKG35QZSK2M8GAMR4AFX45659RJHDW353HSG.usdh-token-v1", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zusdh-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.usdh-oracle-v1-0" },
    { asset: "SP2XD7417HGPRTREMKF748VNEQPDRR0RMANB7X1NK.token-susdt", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zsusdt-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.susdt-oracle-v1-0" },
    { asset: "SP2C2YFP12AJZB4MABJBAJ55XECVS7E4PMMZ89YZR.usda-token", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zusda-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.usda-oracle-v1-1" },
    { asset: "SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zsbtc-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.stx-btc-oracle-v1-4" },
    { asset: "SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.token-alex", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zalex-v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.alex-oracle-v1-1" },
    { asset: "SP4SZE494VC2YC5JYG7AYFQ44F5Q4PYV7DVMDPBG.ststxbtc-token-v2", lp: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.zststxbtc-v2_v2-0", orc: "SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.stx-btc-oracle-v1-4" },
  ];

  const assetTuples = allAssets.map((a) => {
    const [aAddr, aName] = a.asset.split(".");
    const [lpAddr, lpName] = a.lp.split(".");
    const [oAddr, oName] = a.orc.split(".");
    return tupleCV({
      asset: contractPrincipalCV(aAddr, aName),
      "lp-token": contractPrincipalCV(lpAddr, lpName),
      oracle: contractPrincipalCV(oAddr, oName),
    });
  });

  console.log("Building tx...");
  const tx = await makeContractCall({
    network: STACKS_MAINNET,
    contractAddress: helper.address,
    contractName: helper.name,
    functionName: "set-user-use-reserve-as-collateral",
    functionArgs: [
      principalCV(SENDER),
      contractPrincipalCV(zsbtc.address, zsbtc.name),
      contractPrincipalCV(sbtc.address, sbtc.name),
      boolCV(true),
      contractPrincipalCV(oracle.address, oracle.name),
      listCV(assetTuples),
      someCV(bufferCV(pythBuffer)),
    ],
    senderKey: account.stxPrivateKey,
    nonce,
    fee: 150000n, // 0.15 STX - generous to ensure inclusion
    anchorMode: AnchorMode.Any,
    postConditionMode: PostConditionMode.Allow,
  });

  console.log("Broadcasting immediately...");
  const result = await broadcastTransaction({ transaction: tx, network: STACKS_MAINNET });

  if (typeof result === "string") {
    console.log(`ERROR: ${result}`);
  } else if ("txid" in result) {
    console.log(`SUCCESS: txid = ${result.txid}`);
    console.log(`Explorer: https://explorer.hiro.so/txid/${result.txid}?chain=mainnet`);
  } else if ("error" in result) {
    console.log(`REJECTED: ${result.error} - ${result.reason}`);
  } else {
    console.log("Result:", JSON.stringify(result));
  }
}

main().catch((e) => {
  console.error("Fatal:", e.message);
  process.exit(1);
});
