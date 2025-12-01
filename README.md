# agcoin

AGCOIN is an example fungible token implemented as a Clarity smart contract and managed with [Clarinet](https://github.com/hirosystems/clarinet).

## Project layout

- `Clarinet.toml` – Clarinet project configuration
- `contracts/agcoin.clar` – AGCOIN token smart contract
- `LICENSE` – MIT license for this repository

## Requirements

- [Clarinet](https://docs.hiro.so/clarinet) >= 3.10.0

Verify your installation with:

```bash path=null start=null
clarinet --version
```

## AGCOIN smart contract

The `agcoin` contract implements a simple fungible token with:

- On-chain storage of balances in a `balances` map keyed by principal
- A mutable `total-supply` that tracks the total number of minted AGC tokens
- Read-only helper functions for metadata and balances
- Public `mint` and `transfer` functions

> Note: The `mint` function in this example is **permissionless** and intended for
> demonstration only. Any caller can mint new AGC to any principal. Do not use
> this contract as-is in production.

### Key functions

- `get-name` – returns the token name (`"Agcoin"`)
- `get-symbol` – returns the token symbol (`"AGC"`)
- `get-decimals` – returns the number of decimals (`u6`)
- `get-total-supply` – returns the current total supply of AGC
- `get-balance` – returns the AGC balance for a given principal
- `mint` – mints new AGC to a recipient principal
- `transfer` – transfers AGC from the caller (`tx-sender`) to a recipient

## Development

### Check contract syntax

From the project root (`/home/anthony/Documents/GitHub/agcoin`), run:

```bash path=null start=null
clarinet check
```

This command loads all contracts listed in `Clarinet.toml` and performs
static analysis and syntax checks.

### REPL (optional)

You can experiment with the contract in a Clarinet REPL:

```bash path=null start=null
clarinet console
```

Then, in the REPL, you can call read-only functions, for example:

```clarity path=null start=null
(contract-call? .agcoin get-symbol)
(contract-call? .agcoin get-total-supply)
```

## License

This project is licensed under the MIT License. See `LICENSE` for details.
