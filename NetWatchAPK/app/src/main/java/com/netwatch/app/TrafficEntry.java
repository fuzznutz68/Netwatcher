package com.netwatch.app;

/**
 * Represents a single captured network packet / traffic event.
 */
public class TrafficEntry {
    public String direction;    // "IN" or "OUT"
    public String protocol;     // "TCP", "UDP", etc.
    public String remoteIp;     // Remote IP address
    public String remoteHost;   // Resolved hostname (or IP if unresolvable)
    public int remotePort;      // Destination/source port
    public long bytes;          // Payload bytes
    public String timestamp;    // Human-readable time
}
