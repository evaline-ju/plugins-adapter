#!/bin/bash
# After oc port-forward svc/nemo-guardrails-service 50053:50053 -n istio-system
# model parameter is required even if just used for logging
# More examples: https://github.com/m-misiura/demos/blob/main/nemo_openshift/guardrail-checks/deployment/README.md

BASE_URL="localhost:50053"
ENDPOINT="/v1/guardrail/checks"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}NeMo Guardrails Check Trial Commands${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ============================================
# TOOL CALL TESTS
# ============================================

echo -e "${GREEN}Test 1: Allowed tool call${NC}"
echo -e "${YELLOW}Testing with get_weather tool call that should be allowed...${NC}"
curl -s -X POST "${BASE_URL}${ENDPOINT}" \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "llama3.2:3b-instruct-fp16",
    "messages": [
      {
        "role": "assistant",
        "tool_calls": [
          {
            "id": "call_123",
            "type": "function",
            "function": {
              "name": "get_weather",
              "arguments": "{\"location\":\"Madrid\"}"
            }
          }
        ]
      }
    ]
  }' | jq .

echo ""
echo -e "${GREEN}Test 2: Blocked tool call${NC}"
echo -e "${YELLOW}Testing with delete_all tool call that should be blocked...${NC}"
curl -s -X POST "${BASE_URL}${ENDPOINT}" \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "llama3.2:3b-instruct-fp16",
    "messages": [
      {
        "role": "assistant",
        "tool_calls": [
          {
            "id": "call_456",
            "type": "function",
            "function": {
              "name": "delete_all",
              "arguments": "{}"
            }
          }
        ]
      }
    ]
  }' | jq .

# ============================================
# TOOL RESPONSE TESTS
# ============================================

echo ""
echo -e "${GREEN}Test 3: Safe tool response${NC}"
echo -e "${YELLOW}Testing with safe weather tool response that should be allowed...${NC}"
curl -s -X POST "${BASE_URL}${ENDPOINT}" \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "llama3.2:3b-instruct-fp16",
    "messages": [
      {
        "role": "tool",
        "content": "The weather in Paris is sunny, 22°C",
        "name": "get_weather"
      }
    ]
  }' | jq .

echo ""
echo -e "${GREEN}Test 4: Unsafe tool response${NC}"
echo -e "${YELLOW}Testing with credentials tool response that should be blocked...${NC}"
curl -s -X POST "${BASE_URL}${ENDPOINT}" \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "llama3.2:3b-instruct-fp16",
    "messages": [
      {
        "role": "tool",
        "content": "Your password is: secret123",
        "name": "get_credentials"
      }
    ]
  }' | jq .

# ============================================
# USER MESSAGE CONTENT TESTS
# ============================================

echo ""
echo -e "${GREEN}Test 5: Safe content (should be allowed)${NC}"
echo -e "${YELLOW}Testing with mild profanity that should pass guardrails...${NC}"
curl -X POST "${BASE_URL}${ENDPOINT}" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
        {
            "role": "user",
            "content": "crap crap crap"
        }
    ],
    "model": "llama3.2:3b-instruct-fp16"
  }' | jq .

echo ""
echo -e "${GREEN}Test 6: Blocked content (ChatGPT mention)${NC}"
echo -e "${YELLOW}Testing with ChatGPT mention that should be blocked...${NC}"
curl -X POST "${BASE_URL}${ENDPOINT}" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
        {
            "role": "user",
            "content": "How does this differ from ChatGPT?"
        }
    ],
    "model": "llama3.2:3b-instruct-fp16"
  }' | jq .