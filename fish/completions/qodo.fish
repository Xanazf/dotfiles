# fish completion for qodo command
# Generated from `qodo -h`

# Determine if first non-flag token is a command
function __qodo_needs_command
    set -l tokens (commandline -opc)
    for t in $tokens
        switch $t
            case '-*'
                continue
            case run login models chat key create-agent list-agents list-mcp self-review update chain
                # already have a subcommand; don't show the list
                return 1
            case '*'
                # first non-flag token isn't a known subcommand; still show the subcommand list
                return 0
        end
    end
    # no non-flag tokens yet; need a subcommand
    return 0
end

# remove any previous completions as they're handled here
complete -c qodo -e
# Do not force file completion; allow normal argument completion
complete -c qodo -f

# Offer commands with descriptions
complete -c qodo -n __qodo_needs_command -a 'run' -d 'Execute a specific agent command'
complete -c qodo -n __qodo_needs_command -a 'login' -d 'Log in to Qodo'
complete -c qodo -n __qodo_needs_command -a 'models' -d 'Get available models'
complete -c qodo -n __qodo_needs_command -a 'chat' -d 'Start an interactive chat session'
complete -c qodo -n __qodo_needs_command -a 'key' -d 'Manage API keys'
complete -c qodo -n __qodo_needs_command -a 'create-agent' -d 'Create a new agent from requirements'
complete -c qodo -n __qodo_needs_command -a 'list-agents' -d 'List available agents'
complete -c qodo -n __qodo_needs_command -a 'list-mcp' -d 'List available local and remote tools'
complete -c qodo -n __qodo_needs_command -a 'self-review' -d 'Analyze git changes (opens web UI)'
complete -c qodo -n __qodo_needs_command -a 'update' -d 'Manage auto-updates'
complete -c qodo -n __qodo_needs_command -a 'chain' -d 'Run multiple agents sequentially'

# Global flags (available always)
complete -c qodo -s h -l help -d 'Show help and exit'
complete -c qodo -s v -l version -d 'Show version and exit'
complete -c qodo -s l -l log -r -d 'Redirect console output to a file | stdout | stderr'
complete -c qodo -s y -l yes -d 'Confirm all prompts automatically (useful for CI)'
complete -c qodo -s q -l silent -d 'Suppress output except final result'
complete -c qodo -s d -l debug -d 'Enable debug mode'
complete -c qodo -l dir -r -d 'Specify project root directories (repeatable)'
complete -c qodo -l ci -d 'Run commands in CI mode'
complete -c qodo -l mcp -d 'Run commands as tools from agent config in MCP-server-like mode'
complete -c qodo -l ui -d 'Open Qodo with web interface'
complete -c qodo -l webhook -d 'Run commands from agent config in webhook mode'
complete -c qodo -l slack -d 'Run as Slack bot (HTTP webhook by default)'
complete -c qodo -s p -l port -r -d 'Specify custom port for server modes'
complete -c qodo -s m -l model -r -d 'Specify a custom model to use'
complete -c qodo -l agent-file -r -d 'Path to agent configuration file'
complete -c qodo -l mcp-file -r -d 'Path to mcp.json'
complete -c qodo -s r -l resume -r -d 'Resume a task with the given session ID'
complete -c qodo -l set -r -d 'Set custom key=value (repeatable)'
complete -c qodo -l no-builtin -d 'Disable built-in MCP servers'
complete -c qodo -s t -l tools -r -d 'Specify authorized tools (comma-separated)'
complete -c qodo -l tool -r -d 'Specify authorized tool (repeatable)'
complete -c qodo -l permissions -r -a 'r rw rwx -' -d 'Set permissions level (r, rw, rwx, -)'
complete -c qodo -l with -r -d 'Preload context with a previous session summarization'

# run subcommand args
complete -c qodo -n '__fish_seen_subcommand_from run' -x -d 'Agent command to run'

# key subcommands
complete -c qodo -n '__fish_seen_subcommand_from key' -a 'list' -d 'List API keys'
complete -c qodo -n '__fish_seen_subcommand_from key' -a 'create' -d 'Create new API key'
complete -c qodo -n '__fish_seen_subcommand_from key' -a 'revoke' -d 'Revoke API key'
complete -c qodo -n '__fish_seen_subcommand_from key; and __fish_seen_subcommand_from create' -x -d 'API key name'
complete -c qodo -n '__fish_seen_subcommand_from key; and __fish_seen_subcommand_from revoke' -x -d 'API key name'

# update subcommands
complete -c qodo -n '__fish_seen_subcommand_from update' -l check -d 'Check for updates'
complete -c qodo -n '__fish_seen_subcommand_from update' -l install -d 'Install updates'
complete -c qodo -n '__fish_seen_subcommand_from update' -l configure -d 'Configure auto-updates'

# chain subcommand
complete -c qodo -n '__fish_seen_subcommand_from chain' -x -d 'Agent chain (e.g., "improve > review > open-pr")'

# chat subcommand
complete -c qodo -n '__fish_seen_subcommand_from chat' -x -d 'Start interactive chat session'

# models subcommand
complete -c qodo -n '__fish_seen_subcommand_from models' -x -d 'Get available models'

# login subcommand
complete -c qodo -n '__fish_seen_subcommand_from login' -x -d 'Log in to Qodo'

# create-agent subcommand
complete -c qodo -n '__fish_seen_subcommand_from create-agent' -x -d 'Create a new agent from requirements'

# list-agents subcommand
complete -c qodo -n '__fish_seen_subcommand_from list-agents' -x -d 'List available agents'

# list-mcp subcommand
complete -c qodo -n '__fish_seen_subcommand_from list-mcp' -x -d 'List available local and remote tools'

# self-review subcommand
complete -c qodo -n '__fish_seen_subcommand_from self-review' -x -d 'Analyze git changes (opens web UI)'
