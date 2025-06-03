# Unified AI Search Interface

## Description
This project provides a unified command-line interface (CLI) for interacting with various AI chat services. Written in Bash, it allows users to query different AI models (OpenRouter, ChatGPT, Gemini, Mistral, DeepSeek) through a single script, simplifying access to multiple AI APIs. It also includes a setup script for managing API keys.

## Features
- **Unified Interface**: Interact with multiple AI services from a single Bash script.
- **Multiple AI Services**: Supports OpenRouter, ChatGPT, Gemini, Mistral, and DeepSeek.
- **API Key Management**: Includes a `setup_ai_keys.sh` script to easily configure and load your API keys.
- **Bash Codebase**: Lightweight and easily runnable on Linux systems.

## Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/islamux/ai-search.git
   cd ai-search
   ```
2. **Set up API Keys:**
   Run the setup script to configure your AI API keys. This script will create a `~/.ai_keys` file and open it for editing.
   ```bash
   ./setup_ai_keys.sh
   ```
   Replace `YOUR_KEY_HERE` with your actual API keys in the opened file.
   Note: The `ai_search.sh` script may contain a DeepSeek API key for testing purposes. It is highly recommended to replace this with your own API key, as the provided key may not be active or work for all users.
3. **Make scripts executable:**
   ```bash
   chmod +x ai_search.sh setup_ai_keys.sh
   ```

## Usage
1. **Load API keys (if not already sourced by your shell):**
   ```bash
   source ~/.ai_keys
   ```
   (This step is usually handled automatically by `setup_ai_keys.sh` adding it to your `.bashrc`.)

2. **Run the AI search interface:**
   ```bash
   ./ai_search.sh
   ```
   The script will detect available services based on your configured API keys and prompt you to select one. Then, you can enter your query.

## Contributing
Guidelines for how others can contribute to your project.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Open a Pull Request.

## License
This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Contact
islamux - your.email@example.com
Project Link: [https://github.com/islamux/ai-search](https://github.com/islamux/ai-search)
