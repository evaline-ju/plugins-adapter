curl http://localhost:50053/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "config_id": "hello_world",
    "messages": [
      { "role": "user", "content": "Who are you?" }
    ]
  }'
