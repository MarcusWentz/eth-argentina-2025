# Uniswap v4 Hook Template

**A template for writing Uniswap v4 Hooks 🦄**

## Project Overview

Prediction market for AMMs with a Uniswap V4 hook.

### 50 percent

<img src="https://github.com/MarcusWentz/eth-argentina-2025/blob/main/images/probability_50_percent.jpg" alt="50_percent"/>

### 80 percent

<img src="https://github.com/MarcusWentz/eth-argentina-2025/blob/main/images/probability_80_percent.jpg" alt="80_percent"/>

### 25 percent 

<img src="https://github.com/MarcusWentz/eth-argentina-2025/blob/main/images/probability_25_percent.jpg" alt="25_percent"/>

## Install

### Global libraries

```shell
forge install
```

### prb-math 

```shell
forge install PaulRBerg/prb-math@release-v4 --no-commit
```

## Test Contracts

### Compile

```shell
forge compile
```

### Test

```shell
forge test
```

## Deploy Hook

### Hook Counter.sol

```shell
forge script script/00_DeployHook.s.sol:DeployHookScript \
--private-key $devTestnetPrivateKey \
--rpc-url https://sepolia.unichain.org \
--broadcast 
```

### Verify Uniswap V4 Hook Contract Already Deployed

Use the `contractAddress` from CREATE2 from

```
broadcast/00_DeployHook.s.sol/1301/run-latest.json
```

then run

```shell
forge verify-contract \
--rpc-url https://sepolia.unichain.org \
<contract_address> \
src/Counter.sol:Counter \
--verifier blockscout \
--verifier-url https://unichain-sepolia.blockscout.com/api/
```

### Hook Deployed and Verified on Unichain Sepolia

https://unichain-sepolia.blockscout.com/address/0x229b2623ce3a4dfd5190844c4efe299c0edf0ac0?tab=contract

## Additional Resources

- [Uniswap v4 docs](https://docs.uniswap.org/contracts/v4/overview)
- [v4-periphery](https://github.com/uniswap/v4-periphery)
- [v4-core](https://github.com/uniswap/v4-core)
- [v4-by-example](https://v4-by-example.org)