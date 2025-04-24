# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7

TXID="d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7"

TX_DETAILS=$(bitcoin-cli getrawtransaction "$TXID" true)

TXIN_WITNESS=$(echo "$TX_DETAILS" | jq -r '.vin[0].txinwitness')

# Check if the witness contains public key data (for Taproot)
PUBLIC_KEY=$(echo "$TXIN_WITNESS" | jq -r '.[1]')

# Print the public key
if [[ "$PUBLIC_KEY" != "null" ]]; then
  echo "$PUBLIC_KEY"
else
  echo "No public key found for input 0."
fi
