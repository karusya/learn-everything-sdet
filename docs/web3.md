---
title: WEB3 Guide
summary: 
---

<!-- markdownlint-disable MD025 MD003 MD022 MD026 MD024 MD012 -->

# WEB3 Guide

## What is WEB3

Web3 is focused more on data-driven development and machine-based interpretation of data. Web3 customizes and improves upon the user’s experience based on the behavior and history on that particular device. Some of these features include personalized searches, personal data control, the Metaverse, and AI. Web3 also incorporates the ideas of decentralization, blockchain technologies, and token economies.

## Core terms

- **EVM**: Ethereum Virtual Machine.
- **DeFi**: decentralized finance.
- **Solidity**: high-level, object- and contract-oriented language influenced by C++, JavaScript, and Python.
- **Smart Contracts**: self-executing contracts with the terms of the agreement directly written into code.
- **Token**: a digital asset that represents a unit of value on a blockchain.
- **Wallet**: a software program that stores private keys and allows users to interact with the blockchain.
- **Gas**: the amount of energy required to execute a transaction on the blockchain.
- **Gas Price**: the amount of gas required to execute a transaction on the blockchain.
- **Block**: a collection of transactions that are added to the blockchain.
- **Block Time**: the time it takes for a block to be added to the blockchain.
- **Block Reward**: the amount of tokens that are rewarded to the miner who successfully mines a block.
- **Miner**: a node that validates transactions and adds them to the blockchain.
- **Validator**: a node that validates transactions and adds them to the blockchain.
- **Staker**: a node that validates transactions and adds them to the blockchain.
- **Proof of Work (PoW)**: a consensus mechanism where nodes compete to solve complex mathematical puzzles to validate transactions and add them to the blockchain.
- **Proof of Stake (PoS)**: a consensus mechanism where nodes validate transactions and add them to the blockchain based on the amount of tokens they hold.
- **Consensus**: the process by which nodes agree on the state of the blockchain.
- **Decentralization**: the process by which nodes agree on the state of the blockchain.
- **Token Economy**: the process by which nodes agree on the state of the blockchain.
- **Smart Contracts**: self-executing contracts with the terms of the agreement directly written into code.
- **Decentralized Finance (DeFi)**: decentralized finance.
- **Decentralized Autonomous Organization (DAO)**: decentralized autonomous organization.
- **Decentralized Exchange (DEX)**: decentralized exchange.
- **Decentralized Identity (DID)**: decentralized identity.
- **Decentralized Storage (DStorage)**: decentralized storage.
- **Decentralized Application (DApp)**: decentralized application.
- **Decentralized Network (DNetwork)**: decentralized network.
- **Decentralized Platform (DPlatform)**: decentralized platform.
- **Decentralized System (DSystem)**: decentralized system.
- **Decentralized Technology (DTech)**: decentralized technology.
- **Decentralized Web (DWeb)**: decentralized web.
- **Decentralized World (DWorld)**: decentralized world.


## EVM (Ethereum Virtual Machine)

The runtime environment that executes smart-contract code.

Key traits:

Deterministic

Gas-metered execution

Executes bytecode from Solidity, Vyper, etc.

QA relevance:

Understanding what contract “execution” means helps test reverts, gas exhaustion, and state updates.


## Smart Contract
Immutable backend logic deployed on the blockchain.

QA relevance:
You validate:

function behavior

state transitions

emitted events

revert conditions

boundary cases

Even without reading Solidity code, you can test all contract behavior.

## Wallets (MetaMask, WalletConnect, Ledger, Phantom)



The unit of computational cost required to execute operations on Ethereum.

Every smart contract instruction consumes gas.

More complex logic = more gas.

If gas runs out → transaction reverts but the user still pays the fee.

QA significance:
Testing low gas scenarios ensures UI properly communicates failures.

Gas Price

Amount the user is willing to pay per gas unit.

Higher gas price → transaction gets mined faster.

QA relevance:

Wrong estimation = stuck transactions

UI must show correct speed/priority


Nonce

Unique identifier for transactions from an account.

Must be strictly increasing.

QA importance:

Nonce gaps = transaction reordering

Incorrect nonce = transaction rejection

Automation for Web3

Question:
“How do you automate Web3 flows?”

Answer:
“I use a hybrid model:

1. UI automation

Using Playwright:

Injecting a wallet provider (mock MetaMask or test wallet)

Automating signature flows

Validating displayed balances and events

Mocking RPC when determinism is needed

2. RPC automation

Using direct RPC calls:

Simulate contract calls (eth_call)

Broadcast raw transactions

Decode events

Validate contract states after UI actions

This combination removes flakiness caused by unpredictable mining times and gives full functional coverage of the Web3 stack.”



## Explain how a blockchain transaction flows from the moment a user signs it.
Senior answer:
A signed transaction is first broadcast to the mempool of the connected node.
Nodes validate the signature, nonce, gas limit, and balance before propagating it to other peers.
A validator/miner picks it up, orders it based on the gas price, and includes it in a block candidate.
Once the block is finalized, the transaction becomes part of the chain state, and the smart contract updates are reflected via the state trie.

I also highlight edge cases: nonce gaps, gas underestimation, chain re-orgs, and wallet/network mismatches — these are typical areas where issues surface during testing.

### What issues are common when testing Web3 applications?
Typical categories include:

Incorrect gas estimation leading to reverts.

UI showing outdated or inconsistent blockchain state due to slow RPC responses.

Network switching issues (wallet rejected switch, wrong chainId).

Race conditions when a user signs multiple transactions quickly.

Incorrect handling of failed transactions or reverts from smart contracts.

Signature request loops due to corrupted session or invalid nonce.

My focus is always on validating both on-chain state via RPC and UI state, ensuring they match.

### What are the best practices for testing Web3 applications?