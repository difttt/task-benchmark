done = function(summary, latency, requests)
    io.write("------------------------------ json:\n")
    io.write(string.format(
        "{\"result\":{\"requests_sec\":%.2f,\"avg_latency_ms\":%.2f}}",
        summary.requests/(summary.duration/1000000),
        (latency.mean/1000)
        ))
end
