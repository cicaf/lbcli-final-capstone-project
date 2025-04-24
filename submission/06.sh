# Only one tx in block 243,821 signals opt-in RBF. What is its txid?

BLOCK=243821
BLOCK_HASH=$(bitcoin-cli -signet getblockhash "$BLOCK")
TXS=$(bitcoin-cli getblock "$BLOCK_HASH" | jq -r '.tx[]')

# Define the max non-RBF sequence number dynamically
MAX_NON_RBF_SEQ=$((0xffffffff - 1))  # equals 4294967294

for TXID in $TXS; do
  TX=$(bitcoin-cli getrawtransaction "$TXID" true)
  SIGNALS_RBF=$(echo "$TX" | jq --argjson max_seq "$MAX_NON_RBF_SEQ" '[.vin[].sequence] | map(select(. < $max_seq)) | length > 0')
  if [ "$SIGNALS_RBF" == "true" ]; then
    echo "$TXID"
  fi
done
