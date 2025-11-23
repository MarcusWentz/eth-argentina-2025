# Orbswap Asymmetric pm-AMM

**Uniswap v4 pm-AMM hook for an asymmetric LP payoff 🦄**

## Project Overview
Most prediction markets are adopted as orderbooks, but AMMs have not taken off as prediction market infrastructure. Our belief for it is that custom curves such as CPMM and LMSR do not allow for the concentration of the probability by the LP, instead the LP is forced to accept a 50/50 outcome, waiting until the event occurs, resulting in IL as seen in desmos figure below ([href=https://www.desmos.com/calculator/sk8d2g49hj]

Prediction market for AMMs with a Uniswap V4 hook.

### 50 percent

<img src="https://github.com/MarcusWentz/eth-argentina-2025/blob/main/images/probability_50_percent.jpg" alt="50_percent"/>


We come up with a custom curve that allows the LP to concentrate one's probability just like uniswap v3 allows one to concentrate one's range. We now have the ability to not just be passive liquidity providers, but also make a bet on the likelihood of an outcome ourselves.

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
