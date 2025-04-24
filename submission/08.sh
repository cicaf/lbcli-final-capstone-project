# what block height was this tx mined ?
# 49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb

TXID="49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb"

BLOCKHASH=$(bitcoin-cli -signet getrawtransaction "$TXID" true | jq -r '.blockhash')

if [ -z "$BLOCKHASH" ] || [ "$BLOCKHASH" == "null" ]; then
  echo "Transaction $TXID is not confirmed or not found."
  exit 1
fi

BLOCKHEIGHT=$(bitcoin-cli -signet getblock "$BLOCKHASH" | jq '.height')

echo "$BLOCKHEIGHT"
