# Uniswap v4 Hook Template

**A template for writing Uniswap v4 Hooks 🦄**

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

https://unichain-sepolia.blockscout.com/address/0x472c7ba6F53ba9F3d4832b6B68340b6fB5EA8Ac0?tab=contract

## Additional Resources

- [Uniswap v4 docs](https://docs.uniswap.org/contracts/v4/overview)
- [v4-periphery](https://github.com/uniswap/v4-periphery)
- [v4-core](https://github.com/uniswap/v4-core)
- [v4-by-example](https://v4-by-example.org)