# How many new outputs were created by block 243,825?
BLOCK_HEIGHT=243825

BLOCK_HASH=$(bitcoin-cli -signet getblockhash $BLOCK_HEIGHT)

BLOCK_DETAILS=$(bitcoin-cli -signet getblock $BLOCK_HASH 2)

if [ -z "$BLOCK_DETAILS" ]; then
  echo "Error: Could not fetch block details for block hash $BLOCK_HASH"
  exit 1
fi

OUTPUTS_COUNT=$(echo "$BLOCK_DETAILS" | jq '.tx[] | .vout | length' | awk '{s+=$1} END {print s}')

echo "$OUTPUTS_COUNT"
