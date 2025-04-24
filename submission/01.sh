# What is the hash of block 243,833?
HASH=$(bitcoin-cli -signet getblockhash 243833)

echo "$HASH"
