# what is the coinbase tx in this block 243,834
BLOCK_HASH=$(bitcoin-cli -signet getblockhash 243834)

BLOCK_DATA=$(bitcoin-cli -signet getblock "$BLOCK_HASH")

COINBASE_TXID=$(echo "$BLOCK_DATA" | jq -r '.tx[0]')

echo "$COINBASE_TXID"
