#!/usr/bin/env bash
set -euo pipefail
pg_pid=""

pg_ctl -D .pgdata -w -m immediate stop || true
rm -rf .pgdata
