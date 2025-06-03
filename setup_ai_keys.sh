#!/bin/bash

# AI API Key Setup Script
CONFIG_FILE="$HOME/.ai_keys"

# Create config file if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating new API key configuration file..."
    cat << EOF > "$CONFIG_FILE"
# Add your API keys below (replace YOUR_KEY_HERE)
export OPENROUTER_API_KEY="YOUR_KEY_HERE"
export OPENAI_API_KEY="YOUR_KEY_HERE"
export GEMINI_API_KEY="YOUR_KEY_HERE"
export MISTRAL_API_KEY="YOUR_KEY_HERE"
export DEEPSEEK_API_KEY="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"
EOF
fi

# Edit the config file
echo "Opening configuration file for editing..."
echo "Please replace 'YOUR_KEY_HERE' with your actual API keys"
sleep 2
nano "$CONFIG_FILE"

# Add to bashrc if not already added
if ! grep -q "source $CONFIG_FILE" ~/.bashrc; then
    echo "Adding automatic key loading to .bashrc..."
    echo -e "\n# Load AI API keys" >> ~/.bashrc
    echo "source $CONFIG_FILE" >> ~/.bashrc
fi

echo "Setup complete! API keys will load automatically in new terminals."
echo "To apply to current terminal: source $CONFIG_FILE"
