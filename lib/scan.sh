# shellcheck shell=bash

__get_default_route() {
  ip -j r | jq '.[] | select(.dst == "default")'
}

__get_default_nic() {
  __get_default_route | jq -r '.dev'
}

__get_default_gw() {
  __get_default_route | jq -r '.gateway'
}

__get_default_nw() {
  local default_nic
  local nic_info
  local network
  local netmask

  default_nic="$(__get_default_nic)"
  nic_info="$(ip -j a show "$default_nic" | \
                jq '.[].addr_info[] | select(.family == "inet")')"
  netmask="$(jq -r ".prefixlen" <<< "$nic_info")"
  network="$(jq -r ".local" <<< "$nic_info" | sed -r 's/\.[0-9]+$//')"

  echo "${network}.0/${netmask}"
}

adbd_discover() {
  local nw
  nw="${1:-$(__get_default_nw)}"

  nmap --open -sT -p 5555 "$nw" 2>/dev/null | \
    awk '/Nmap scan report for/ { print $NF }'
}

# vim: set ft=bash et ts=2 sw=2 :
