#!/usr/bin/env bash
#
# This script formats the code (Haskell and cabal files).
# Haskell formatting is done using Ormolu. Cabal formatting using
# cabal-fmt.
set -euf -o pipefail

# Check for the tools
if ! which cabal-fmt > /dev/null; then
    echo 'cabal-fmt was not found'
    exit -1
fi
if ! which ormolu > /dev/null; then
    echo 'ormolu was not found'
    exit -1
fi

# Find cabal files
declare -a CABAL_FILES
while IFS= read -r LINE; do
    CABAL_FILES+=("$LINE")
done < <(find . -name '*.cabal')
readonly CABAL_FILES

# Find Haskell files
declare -a HASKELL_FILES
while IFS= read -r LINE; do
    HASKELL_FILES+=("$LINE")
done < <(find . -name '*.hs' | grep --invert-match '\.stack-work')
readonly HASKELL_FILES

# Format files
cabal-fmt --tabular -i "${CABAL_FILES[@]}"
ormolu --mode=inplace "${HASKELL_FILES[@]}"