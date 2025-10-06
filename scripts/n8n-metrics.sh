#!/bin/sh

while true; do
  timestamp=$(date +%s)
  success=$(curl -s -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" http://n8n:5678/rest/executions?limit=1 | grep -o '"finished":true' | wc -l)
  running=$(curl -s -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" http://n8n:5678/rest/executions-active | grep -o '"id"' | wc -l)
  failed=$(curl -s -u "${N8N_BASIC_AUTH_USER}:${N8N_BASIC_AUTH_PASSWORD}" http://n8n:5678/rest/executions?status=error\&limit=1 | grep -o '"id"' | wc -l)

  cat <<EOF > /textfiles/n8n.prom
# HELP n8n_executions_successful Number of successful executions
# TYPE n8n_executions_successful gauge
n8n_executions_successful ${success}
# HELP n8n_executions_running Number of active executions
# TYPE n8n_executions_running gauge
n8n_executions_running ${running}
# HELP n8n_executions_failed Number of failed executions
# TYPE n8n_executions_failed gauge
n8n_executions_failed ${failed}
EOF

  sleep 60
done
