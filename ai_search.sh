#!/bin/bash

# Unified AI Search Interface
# Supports: OpenRouter, ChatGPT, Gemini, Mistral, DeepSeek

# Configuration
API_OPENROUTER="https://openrouter.ai/api/v1/chat/completions"
API_CHATGPT="https://api.openai.com/v1/chat/completions"
API_GEMINI="https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent"
API_MISTRAL="https://api.mistral.ai/v1/chat/completions"
API_DEEPSEEK="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"

# Detect available API keys
detect_keys() {
  declare -A services=(
    [openrouter]="$OPENROUTER_API_KEY"
    [chatgpt]="$OPENAI_API_KEY"
    [gemini]="$GEMINI_API_KEY"
    [mistral]="$MISTRAL_API_KEY"
    [deepseek]="$DEEPSEEK_API_KEY"
  )
  
  echo "Available services:"
  for service in "${!services[@]}"; do
    if [ -n "${services[$service]}" ]; then
      echo "  - $service"
      AVAILABLE_SERVICES+=("$service")
    fi
  done
}

# Query AI service
query_ai() {
  local service=$1
  local prompt=$2
  local response=""
  
  case $service in
    openrouter)
      response=$(curl -s -X POST "$API_OPENROUTER" \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
          "model": "mistralai/mistral-7b-instruct",
          "messages": [{"role": "user", "content": "'"$prompt"'"}]
        }')
      ;;
    chatgpt)
      response=$(curl -s -X POST "$API_CHATGPT" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
          "model": "gpt-3.5-turbo",
          "messages": [{"role": "user", "content": "'"$prompt"'"}]
        }')
      ;;
    gemini)
      response=$(curl -s -X POST "$API_GEMINI?key=$GEMINI_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
          "contents": [{"parts": [{"text": "'"$prompt"'"}]}]
        }')
      ;;
    mistral)
      response=$(curl -s -X POST "$API_MISTRAL" \
        -H "Authorization: Bearer $MISTRAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
          "model": "mistral-tiny",
          "messages": [{"role": "user", "content": "'"$prompt"'"}]
        }')
      ;;
    deepseek)
      # Save debug info to temporary file
      DEBUG_FILE="/tmp/deepseek_debug_$(date +%s).txt"
      
      # Execute curl with verbose output
      response=$(curl -v -X POST "$API_DEEPSEEK" \
        -H "Authorization: Bearer $DEEPSEEK_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
          "model": "deepseek-chat",
          "messages": [{"role": "user", "content": "'"$prompt"'"}]
        }' 2> "$DEBUG_FILE")
      
      # Append response to debug file
      echo -e "\n\nResponse: $response" >> "$DEBUG_FILE"
      
      # Display debug info path
      echo "Debug info saved to: $DEBUG_FILE" >&2
      ;;
      ;;
  esac

  # Extract content based on service
  if [ -z "$response" ]; then
    echo "Error: Empty response from $service API"
    return
  fi
  case $service in
    gemini)
      echo "$response" | jq -r '.candidates[0].content.parts[0].text'
      ;;
    *)
      # Check if response has error
      if echo "$response" | jq -e '.error' > /dev/null; then
        echo "Error: $(echo "$response" | jq -r '.error.message')"
        echo "Tip: Verify your API key for $service is valid and has sufficient credits"
      elif echo "$response" | jq -e '.choices[0].message.content' > /dev/null; then
        echo "$response" | jq -r '.choices[0].message.content'
      else
        echo "Unexpected response:"
        echo "$response"
      fi
      ;;
  esac
}

# Main script
AVAILABLE_SERVICES=()
detect_keys

if [ ${#AVAILABLE_SERVICES[@]} -eq 0 ]; then
  echo "Error: No API keys detected. Set environment variables:"
  echo "  OPENROUTER_API_KEY, OPENAI_API_KEY, GEMINI_API_KEY"
  echo "  MISTRAL_API_KEY, DEEPSEEK_API_KEY"
  exit 1
fi

PS3="Select AI service: "
select service in "${AVAILABLE_SERVICES[@]}"; do
  if [ -n "$service" ]; then
    read -p "Enter your query: " prompt
    query_ai "$service" "$prompt"
    break
  else
    echo "Invalid selection"
  fi
done
