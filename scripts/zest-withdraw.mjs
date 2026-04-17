#!/usr/bin/env node
/**
 * Zest v0-4-market collateral-remove-redeem with fresh Pyth price feeds.
 *
 * Usage:
 *   node scripts/zest-withdraw.mjs [amount]
 *
 * amount = zToken shares (sats). Defaults to 102976 (our full position).
 * Fetches fresh Pyth VAAs, builds tx, broadcasts to mainnet.
 */

import { createRequire } from 'module';
const require = createRequire(import.meta.url);

// Use /tmp deps
const {
  makeContractCall,
  broadcastTransaction,
  contractPrincipalCV,
  uintCV,
  noneCV,
  someCV,
  listCV,
  bufferCV,
  AnchorMode,
  PostConditionMode,
  getNonce,
} = require('/tmp/node_modules/@stacks/transactions');
const { STACKS_MAINNET } = require('/tmp/node_modules/@stacks/network');
const bip39 = require('/tmp/node_modules/bip39');
const { HDKey } = require('/tmp/node_modules/@scure/bip32');

// --- Config ---
const MNEMONIC = 'cage arrive canal coconut obey private tilt bright sibling shed wrong era sheriff style stage carbon path prison soldier morning ticket acquire what kite';
const SENDER = 'SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE';
const MARKET = { addr: 'SP1A27KFY4XERQCCRCARCYD1CC5N7M6688BSYADJ7', name: 'v0-4-market' };
const VAULT_SBTC = { addr: 'SP1A27KFY4XERQCCRCARCYD1CC5N7M6688BSYADJ7', name: 'v0-vault-sbtc' };
const DEFAULT_AMOUNT = 102976;

// Pyth feed IDs (mainnet)
const PYTH_FEEDS = [
  'e62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43', // BTC/USD
  'ec7a775f46379b5e943c3526b1c8d54cd49749176b0b98e02dde68d1bd335c17', // STX/USD
  'eaa020c61cc479712813461ce153894a96a6c00b21ed0cfc2798d1f9a9e9c94a', // USDC/USD
];

async function fetchPythVAA() {
  const params = PYTH_FEEDS.map(id => `ids[]=${id}`).join('&');
  const url = `https://hermes.pyth.network/v2/updates/price/latest?${params}&encoding=hex&parsed=false`;
  console.log('Fetching Pyth price feeds...');
  const resp = await fetch(url);
  if (!resp.ok) throw new Error(`Pyth API ${resp.status}: ${await resp.text()}`);
  const data = await resp.json();

  // data.binary.data is an array of hex-encoded VAA buffers
  const vaaHex = data.binary.data[0]; // single accumulator update containing all feeds
  console.log(`  VAA length: ${vaaHex.length / 2} bytes`);
  return Buffer.from(vaaHex, 'hex');
}

async function derivePrivateKey() {
  const seed = await bip39.mnemonicToSeed(MNEMONIC);
  const master = HDKey.fromMasterSeed(seed);
  const child = master.derive("m/44'/5757'/0'/0/0");
  return Buffer.from(child.privateKey).toString('hex');
}

async function main() {
  const amount = parseInt(process.argv[2]) || DEFAULT_AMOUNT;
  console.log(`Withdrawing ${amount} zsBTC shares from v0-4-market\n`);

  const [privateKey, priceFeedBuf] = await Promise.all([
    derivePrivateKey(),
    fetchPythVAA(),
  ]);

  const network = STACKS_MAINNET;

  // Build the collateral-remove-redeem call
  const txOptions = {
    contractAddress: MARKET.addr,
    contractName: MARKET.name,
    functionName: 'collateral-remove-redeem',
    functionArgs: [
      // ft: trait_reference (vault contract)
      contractPrincipalCV(VAULT_SBTC.addr, VAULT_SBTC.name),
      // amount: uint (zToken shares)
      uintCV(amount),
      // min-underlying: uint (0 = no slippage check)
      uintCV(0),
      // receiver: optional principal (none = tx-sender)
      noneCV(),
      // price-feeds: optional (list 3 (buff 8192))
      someCV(listCV([bufferCV(priceFeedBuf)])),
    ],
    senderKey: privateKey,
    network,
    anchorMode: AnchorMode.Any,
    postConditionMode: PostConditionMode.Allow,
    fee: 50000, // 0.05 STX
  };

  // Fetch correct nonce
  const nonceResp = await fetch(`https://api.hiro.so/extended/v1/address/${SENDER}/nonces`);
  const nonceData = await nonceResp.json();
  const nonce = nonceData.possible_next_nonce;
  txOptions.nonce = nonce;
  console.log(`Nonce: ${nonce}`);

  console.log('Building transaction...');
  const tx = await makeContractCall(txOptions);
  console.log(`  Nonce: ${tx.auth.spendingCondition.nonce}`);
  console.log(`  Fee: ${tx.auth.spendingCondition.fee} uSTX`);

  // serialize() in v7 returns a hex string
  const serialized = tx.serialize();
  const txBytes = typeof serialized === 'string' ? Buffer.from(serialized, 'hex') : Buffer.from(serialized);
  console.log(`\nRaw tx first 40 hex: ${txBytes.slice(0, 20).toString('hex')}`);
  console.log(`Raw tx length: ${txBytes.length} bytes`);

  // Broadcast directly via Hiro to get full error response
  console.log('\nBroadcasting via Hiro API...');
  const broadcastResp = await fetch('https://api.hiro.so/v2/transactions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/octet-stream' },
    body: txBytes,
  });
  const broadcastText = await broadcastResp.text();
  console.log(`HTTP ${broadcastResp.status}: ${broadcastText.slice(0, 500)}`);
}

main().catch(e => {
  console.error('Fatal:', e.message || e);
  process.exit(1);
});
