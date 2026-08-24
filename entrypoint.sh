#!/bin/sh

TORRC_FILE=/etc/tor/torrc

: "${IPV4_ONLY:=1}"
: "${OR_PORT:=9001}"
: "${DIR_PORT:=9030}"
: "${RELAY_BANDWIDTH_RATE:=400 KBytes}"
: "${RELAY_BANDWIDTH_BURST:=800 KBytes}"
: "${ACCOUNTING_MAX:=300 GBytes}"
: "${ACCOUNTING_START:=month 1 00:00}"
: "${NICKNAME:=MyDockerRelay}"
: "${CONTACT_INFO:=myemail@example.com}"
: "${ENABLE_METRICS:=0}"
: "${METRICS_PORT:=9035}"
: "${METRICS_PORT_POLICY:=accept 0.0.0.0/0}"

# start fresh torrc
echo "ExitRelay 0" > "$TORRC_FILE"
echo "SocksPort 0" >> "$TORRC_FILE"
echo "Log notice stdout" >> "$TORRC_FILE"

if [ "$IPV4_ONLY" = "1" ]; then
    echo "ORPort $OR_PORT IPv4Only" >> "$TORRC_FILE"
    echo "DirPort $DIR_PORT IPv4Only" >> "$TORRC_FILE"
else
    echo "ORPort $OR_PORT" >> "$TORRC_FILE"
    echo "DirPort $DIR_PORT" >> "$TORRC_FILE"
fi
echo "RelayBandwidthRate $RELAY_BANDWIDTH_RATE" >> "$TORRC_FILE"
echo "RelayBandwidthBurst $RELAY_BANDWIDTH_BURST" >> "$TORRC_FILE"
echo "AccountingMax $ACCOUNTING_MAX" >> "$TORRC_FILE"
echo "AccountingStart $ACCOUNTING_START" >> "$TORRC_FILE"
echo "Nickname $NICKNAME" >> "$TORRC_FILE"
echo "ContactInfo $CONTACT_INFO" >> "$TORRC_FILE"

if [ "$ENABLE_METRICS" = "1" ]; then
    echo "MetricsPort 0.0.0.0:$METRICS_PORT" >> "$TORRC_FILE"
    echo "MetricsPortPolicy $METRICS_PORT_POLICY" >> "$TORRC_FILE"
fi

PUBLIC_IP=$(curl -s https://api.ipify.org)
echo "Address $PUBLIC_IP" >> "$TORRC_FILE"

cat "$TORRC_FILE"

exec tor -f "$TORRC_FILE"
