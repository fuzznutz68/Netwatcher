package com.netwatch.app;

/**
 * Represents a single captured traffic event from the VPN tunnel.
 */
public class TrafficEntry {
    public final String direction;  // "⬆" outbound | "⬇" inbound
    public final String protocol;   // TCP / UDP / IP
    public final String host;       // resolved hostname (may be empty)
    public final String ipPort;     // IP:port
    public final int    bytes;      // packet size in bytes
    public final String timestamp;  // HH:mm:ss

    public TrafficEntry(String direction, String protocol, String host,
                        String ipPort, int bytes, String timestamp) {
        this.direction = direction;
        this.protocol  = protocol;
        this.host      = host;
        this.ipPort    = ipPort;
        this.bytes     = bytes;
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return timestamp + "  " + direction + "  " + protocol + "  " +
               (host.isEmpty() ? ipPort : host + " (" + ipPort + ")")
               + "  " + bytes + "B";
    }
}
