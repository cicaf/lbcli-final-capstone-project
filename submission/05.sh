# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb


TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

TX_DETAILS=$(bitcoin-cli getrawtransaction "$TXID" true)

TOTAL_INPUT=0
TOTAL_OUTPUT=0

# Calculate total input value in satoshis
for VIN in $(echo "$TX_DETAILS" | jq -r '.vin[] | .txid'); do
  # Get the transaction details of the input transaction
  INPUT_TX_DETAILS=$(bitcoin-cli getrawtransaction "$VIN" true)

  # For each input, find the corresponding output to get the value in satoshis
  for INPUT_VOUT in $(echo "$TX_DETAILS" | jq -r '.vin[] | select(.txid == "'$VIN'") | .vout'); do
    INPUT_VALUE=$(echo "$INPUT_TX_DETAILS" | jq -r '.vout['$INPUT_VOUT'] | .value' | awk '{print int($1*100000000)}')  # Convert to satoshis (integer)
    TOTAL_INPUT=$((TOTAL_INPUT + INPUT_VALUE))
  done
done

# Calculate total output value in satoshis
for VOUT in $(echo "$TX_DETAILS" | jq -r '.vout[] | .value'); do
  OUTPUT_VALUE=$(echo "$VOUT" | awk '{print int($1*100000000)}')  # Convert to satoshis (integer)
  TOTAL_OUTPUT=$((TOTAL_OUTPUT + OUTPUT_VALUE))
done

TRANSACTION_FEE=$((TOTAL_INPUT - TOTAL_OUTPUT))

echo "$TRANSACTION_FEE"
