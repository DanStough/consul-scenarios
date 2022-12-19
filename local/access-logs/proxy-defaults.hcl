Kind      = "proxy-defaults"
Name      = "global"
AccessLogs {
    Enabled = true
    // JSONFormat = "{ \"start_time_special\": \"%START_TIME%\"}"
    // TextFormat = "ITS WORKING %START_TIME%" 
    Type = "stdout" // Optional w/ valid types "stdout", "stderr", "file"
    // Path = "/Users/dans/consul-scenarios/scenario-access-logs/logs/file.log"
}
