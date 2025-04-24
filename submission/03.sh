# Which tx in block 216,351 spends the coinbase output of block 216,128?
BLOCK_216128_HASH=$(bitcoin-cli -signet getblockhash 216128)

BLOCK_216128_DETAILS=$(bitcoin-cli -signet getblock $BLOCK_216128_HASH 2)

# Find the first (coinbase) transaction's output details
COINBASE_TXID=$(echo "$BLOCK_216128_DETAILS" | jq -r '.tx[0].txid')
COINBASE_OUTPUT=$(echo "$BLOCK_216128_DETAILS" | jq -r '.tx[0].vout')

BLOCK_216351_HASH=$(bitcoin-cli -signet getblockhash 216351)

BLOCK_216351_DETAILS=$(bitcoin-cli -signet getblock $BLOCK_216351_HASH 2)

# Iterate through each transaction in block 216,351 to find one that spends the coinbase output
SPENDING_TXID=""
for TX in $(echo "$BLOCK_216351_DETAILS" | jq -r '.tx[] | @base64'); do
  _jq() {
    echo ${TX} | base64 --decode | jq -r ${1}
  }

  # Check the inputs (vin) to find if any of them reference the coinbase transaction
  for VIN_TXID in $(_jq '.vin[].txid'); do
    if [[ "$VIN_TXID" == "$COINBASE_TXID" ]]; then
      SPENDING_TXID=$(_jq '.txid')
      break
    fi
  done

  if [[ -n "$SPENDING_TXID" ]]; then
    break
  fi
done

echo "$SPENDING_TXID"
