#!/bin/sh
task_id=0;
benchmark_url="";
report_url="";
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--task_id) task_id="$2" shift;;
        -b|--benchmark_url) benchmark_url="$2"; shift;;
        -r|--report_url) report_url="$2"; shift;;
        *) echo "Unknown parameter passed: $2"; exit 1 ;;
    esac
    shift
done

echo benchmark_url: $benchmark_url;
echo report_url: $report_url;
echo task_id: $task_id;

if [ "$task_id" -gt 0 ]; then
  success=$(curl http://host.docker.internal:8000/race?task_id=$task_id | jq '.success');
  if [ "$success" == "true" ]; then
    ipinfo=$(curl -s ipinfo.io | jq -r ".region")
    result=$(wrk  -t10 -c10 -d30s $benchmark_url -s report_json.lua | tail -1 | jq -c --arg ipinfo "$ipinfo" '.region = $ipinfo')
    echo $result
    curl -X POST -H 'Content-Type: application/json' -d "$result" $report_url
    curl http://host.docker.internal:8000/complete?task_id=$task_id
  else
      echo failed to race for task
  fi
else
  echo Invalid task_id
fi
