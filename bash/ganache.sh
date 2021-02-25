#!/usr/bin/env bash

MNEMONIC=$(grep MNEMONIC .env | cut -d '=' -f 2-)

ganache-cli -m $MNEMONIC