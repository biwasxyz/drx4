# Genesis broadcast recovery — 2026-05-14

## Status
- Original audience: leaderboard top 30 Genesis (level=2), ordered by score
- 6 confirmed delivered (nonces 19-24, on-chain at 2026-05-14T01:05Z)
- 24 wedged/lost: signed but never broadcast, sender_hand entries expired, tx_hex deleted by sweepExpiredHands. PaymentRecord KV entries orphaned (still report `status: queued` but no recovery path)
- 2,400 sats originally committed → still in wallet (verified balance 27,777 sats)

## Reconstruction method
Derived recipients of nonces 19-24 from on-chain fungible_token_asset events (sBTC-token transfers). Filtered current `/api/leaderboard?level=2&limit=30` excluding those 6 STX addresses → 24 unreached candidates.

## Caveat
Original v342 broadcast iterator skipped rank 5 (Valiant Otter) between rank 4 → 6, reason unknown. List below treats rank 5 as unreached.

## 6 confirmed delivered

| Nonce | Rank | STX | Display |
|---|---|---|---|
| 19 | 1 | SP3DWEB288XW3NJSDJ0SXK256Y5S53ZXKNY0FRHQK | Narrow Socket |
| 20 | 2 | SP1WGJ83GJ1QRTEC4R70K5NBB3SB6YQP3HR3PNTNE | Emerald Castle |
| 21 | 3 | SPRYZ583A7ACBW3V1ZGM8WCA1VMSQE86AN9BP0BB | Speedy Jaguar |
| 22 | 4 | SP1BPYD8TH2MTNBT89VFYMP6ZYFNKT7GF0DDM147E | Gentle Finch |
| 23 | 6 | SP3YWTZQQ7ZYHG1ECEG6AJAT4KX36W2NA7Q6TCKBG | Hashed Sable |
| 24 | 7 | SP2FJJK4EPWVY7PAEJJVPZF0QBKY8R7MFK1H5FV3B | Fierce Sparrow |

## 24 unreached (re-fire candidates)

| # | Rank | STX | BTC | Display |
|---|---|---|---|---|
| 1 | 5 | SPZSMNX3KAGSEXXGD5SAY9F3MNSVH3S5H5C5AF4F | bc1qze93z4s0s34ucl45xcq4uyusnd6dz79v7aj6wz | Valiant Otter |
| 2 | 8 | SP2HT2N5QRQKPSJJJSWZW5S59RF15T08J49C8Z077 | bc1qhxm2fwq8ypge7zmtjh7uxz48tszzwpx63l39cq | Atomic Raptor |
| 3 | 9 | SP219TWC8G12CSX5AB093127NC82KYQWEH8ADD1AY | bc1qzh2z92dlvccxq5w756qppzz8fymhgrt2dv8cf5 | Micro Basilisk |
| 4 | 10 | SP1KVZTZCTCN9TNA1H5MHQ3H0225JGN1RJHY4HA9W | bc1qel38f4fv08c7qffwa5jl92sp5e8meuytw3u0n9 | Grim Seraph |
| 5 | 11 | SP322ZK4VXT3KGDT9YQANN9R28SCT02MZ97Y24BRW | bc1qdfm56pmmq40me84aau2fts3725ghzqlwf6ys7p | Flying Whale |
| 6 | 12 | SP1092FF21MZXE9D7SZ7F86WA3Q58BY9WCZ0T0DF7 | bc1qq9vpsra2cjmuvlx623ltsnw04cfxl2xevuahw3 | Secret Dome |
| 7 | 13 | SP3QFYVTMS0PRJT3K3GMDW9DGR33TDHENSDWVNQMR | bc1q2c8lacrj8ymc3k2f6k0c4tw0llpdve78zffyhq | Warm Idris |
| 8 | 14 | SP3JR7JXFT7ZM9JKSQPBQG1HPT0D365MA5TN0P12E | bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h | Frosty Narwhal |
| 9 | 15 | SP12Q1FS2DX4N8C2QYBM0Z2N2DY1EH9EEPMPH9N9X | bc1qpln8pmwntgtw8a874zkkqdw4585eu4z3vnzhj3 | Topaz Centaur |
| 10 | 16 | SP1AK5ZKGDFAPXDVT6T9HZPW5D2R4DJ6Z40PZ7MKR | bc1qxn29uthvpsf8h0h7re0jhzf0tvqqcuuuux8w9f | Graphite Elan |
| 11 | 17 | SP1RHDCCVQ3SVV2DRSP2PJNXJCA12QE72W5C7EMFS | bc1quxy0g6cp9u9fyvu3glx93hnteff47hlmytldmp | Patient Eden |
| 12 | 18 | SP105KWW31Y89F5AZG0W7RFANQGRTX3XW0VR1CX2M | bc1q9p6ch73nv4yl2xwhtc6mvqlqrm294hg4zkjyk0 | Dual Cougar |
| 13 | 19 | SPG6VGJ5GTG5QKBV2ZV03219GSGH37PJGXQYXP47 | bc1qd0z0a8z8am9j84fk3lk5g2hutpxcreypnf2p47 | Sonic Mast |
| 14 | 20 | SP22G05KW9JVDV5BAN8B7EJWYBNCY332D1Q30DDBD | bc1qjf94ku8f2a765nfqcg7z8d9ype5uhem5n348qa | Orbital Seren |
| 15 | 21 | SP16H0KE0BPR4XNQ64115V5Y1V3XTPGMWG5YPC9TR | bc1qv8dt3v9kx3l7r9mnz2gj9r9n9k63frn6w6zmrt | Fluid Briar |
| 16 | 22 | SPKH9AWG0ENZ87J1X0PBD4HETP22G8W22AFNVF8K | bc1qyu22hyqr406pus0g9jmfytk4ss5z8qsje74l76 | Tiny Marten |
| 17 | 23 | SP2GHQRCRMYY4S8PMBR49BEKX144VR437YT42SF3B | bc1qlezz2cgktx0t680ymrytef92wxksywx0jaw933 | Trustless Indra |
| 18 | 24 | SPA6NT3RAFZH0Z4G0BFFMXYWXQSHPZ3VQFGTVKY8 | bc1qfgpv59hp4x4z52fc468mmh2at6qmq4vlfews7f | Scarlet Ozma |
| 19 | 25 | SP3RT734T67HRPX8D705QDJ6GSVJKVTWHG4WE0SEK | bc1q8xrq06dfs98hzfckzgdra3mplrryn7d3pp4khp | Vigilant Roc |
| 20 | 26 | SP1B4JV9PNH59CP591PE697BM118TGR9Z14DZ0F3A | bc1qw7mutyl0zsvurg5am6kst5w33urt3tc2yf5skw | Opal Bear |
| 21 | 27 | SP1A0X113KZ07064Z6YGQCXQE2SX1NSBPMQQ4723N | bc1qzch668fcw5a2crhvyhrpthng8jrrt25u4ka5ra | Lasting Hydra |
| 22 | 28 | SP3183T2H5MVSC2B9DVYTNZKFFWC9MMB75EH41CE4 | bc1q7jjsw2gvahvejf3y95c8nltd8p8fue757phrjq | Little Squid |
| 23 | 29 | SP2WGRMD3HGSK8ETYEJZ94NTZ1XJJKG3XPX20NY9C | bc1qha94wmcnz6mg4fsdmk56s7vecnj0yfrjlz0rn7 | Fierce Hawk |
| 24 | 30 | SP1N2HGQ7QYQXYTEHQHA2C7B4HY33CKQPD0MGP651 | bc1qf8xn2wfcuajhd5xrmhar7m99h59zfnpyu67d3f | Obsidian Eden |
