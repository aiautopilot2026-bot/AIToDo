<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Termux AI To-Do List Script</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <style>
        .code-block {
            background: #1e1e1e;
            color: #d4d4d4;
            border-radius: 8px;
            padding: 1.5rem;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            line-height: 1.5;
        }
        .keyword { color: #569cd6; }
        .string { color: #ce9178; }
        .comment { color: #6a9955; }
        .function { color: #dcdcaa; }
        .variable { color: #9cdcfe; }
        
        .task-item {
            transition: all 0.3s ease;
        }
        .task-item:hover {
            transform: translateX(4px);
        }
        
        .priority-high { border-left: 4px solid #ef4444; }
        .priority-medium { border-left: 4px solid #f59e0b; }
        .priority-low { border-left: 4px solid #10b981; }
    </style>
</head>
<body class="bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 min-h-screen text-white">
    <!-- Top Banner -->
    <div class="bg-gradient-to-r from-purple-600 to-pink-600 py-3 text-center">
        <p class="text-white font-semibold">
            ⭐ Open Source Project • Free Forever • 
            <a href="https://github.com/yourusername/aitodo" class="underline hover:text-yellow-300">Star on GitHub</a>
            to support development! ⭐
        </p>
    </div>

    <div class="container mx-auto px-4 py-8 max-w-6xl">
        <!-- Header -->
        <div class="text-center mb-12">
            <h1 class="text-5xl font-bold mb-4 bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                AITodo for Termux
            </h1>
            <p class="text-gray-300 text-lg mb-4">AI-powered to-do list • Offline-first • Smart priorities • Works completely offline</p>
            
            <!-- GitHub Star Button -->
            <div class="flex justify-center gap-4 mb-6">
                <a href="https://github.com/yourusername/aitodo" target="_blank" class="px-6 py-3 bg-slate-800 hover:bg-slate-700 rounded-lg font-semibold transition border border-slate-600 flex items-center gap-2">
                    ⭐ Star on GitHub
                </a>
                <a href="#content-demo" onclick="showTab('demo')" class="px-6 py-3 bg-purple-600 hover:bg-purple-700 rounded-lg font-semibold transition">
                    🚀 Try Live Demo
                </a>
            </div>
            
            <!-- One-Line Install -->
            <div class="bg-gradient-to-r from-green-900 to-emerald-900 rounded-lg p-6 max-w-4xl mx-auto mt-6">
                <h2 class="text-xl font-bold mb-3 text-green-300">🚀 Quick Install (One Command)</h2>
                
                <div class="mb-4">
                    <p class="text-sm text-gray-300 mb-2">📜 <strong>Full Version</strong> (all features):</p>
                    <div class="bg-black rounded-lg p-4 font-mono text-xs overflow-x-auto">
                        <code class="text-green-400">pkg install termux-api jq -y && curl -fsSL https://raw.githubusercontent.com/yourusername/aitodo/main/aitodo.sh -o ~/todo.sh && chmod +x ~/todo.sh && ~/todo.sh install</code>
                    </div>
                </div>
                
                <div>
                    <p class="text-sm text-gray-300 mb-2">⚡ <strong>Minimal Version</strong> (fast & lightweight):</p>
                    <div class="bg-black rounded-lg p-4 font-mono text-xs overflow-x-auto">
                        <code class="text-green-400">pkg install termux-api jq -y && curl -fsSL https://raw.githubusercontent.com/yourusername/aitodo/main/aitodo-mini.sh -o ~/todo.sh && chmod +x ~/todo.sh && ~/todo.sh install</code>
                    </div>
                </div>
                
                <p class="text-gray-300 text-sm mt-4 text-center">Then run: <code class="bg-slate-800 px-2 py-1 rounded">todo add "Your first task"</code></p>
                <p class="text-gray-400 text-xs mt-2 text-center">💡 The install command auto-installs to <code class="bg-slate-800 px-1 rounded">$PREFIX/bin/todo</code></p>
                <p class="text-yellow-300 text-xs mt-2 text-center">⚠️ Or copy the script below manually if you prefer</p>
            </div>
        </div>

        <!-- Tab Navigation -->
        <div class="flex gap-2 mb-6 overflow-x-auto">
            <button onclick="showTab('script')" id="tab-script" class="px-6 py-3 rounded-lg bg-purple-600 font-semibold whitespace-nowrap">
                📜 Full Version
            </button>
            <button onclick="showTab('minimal')" id="tab-minimal" class="px-6 py-3 rounded-lg bg-slate-700 hover:bg-slate-600 font-semibold whitespace-nowrap">
                ⚡ Minimal Version
            </button>
            <button onclick="showTab('install')" id="tab-install" class="px-6 py-3 rounded-lg bg-slate-700 hover:bg-slate-600 font-semibold whitespace-nowrap">
                ⚙️ Installation
            </button>
            <button onclick="showTab('usage')" id="tab-usage" class="px-6 py-3 rounded-lg bg-slate-700 hover:bg-slate-600 font-semibold whitespace-nowrap">
                📖 Usage
            </button>
            <button onclick="showTab('demo')" id="tab-demo" class="px-6 py-3 rounded-lg bg-slate-700 hover:bg-slate-600 font-semibold whitespace-nowrap">
                🚀 Live Demo
            </button>
        </div>

        <!-- Script Tab -->
        <div id="content-script" class="tab-content">
            <div class="bg-slate-800 rounded-lg p-6 shadow-2xl">
                <div class="flex justify-between items-center mb-4">
                    <div>
                        <h2 class="text-2xl font-bold">Full-Featured Version</h2>
                        <p class="text-gray-400 text-sm mt-1">~400 lines • All features • Delete, Clear, Stats, Logs</p>
                    </div>
                    <button onclick="copyScript()" class="px-4 py-2 bg-green-600 hover:bg-green-700 rounded-lg font-semibold transition">
                        📋 Copy Script
                    </button>
                </div>
                <pre class="code-block" id="bash-script">#!/data/data/com.termux/files/usr/bin/bash

# AITodo - AI-Powered To-Do List Manager for Termux
# Smart priority detection • Auto-categorization • Offline-first
# Author: AITodo Project
# Requirements: termux-api, jq

# ============================================
# SELF-INSTALLER
# ============================================
if [ "${1}" = "install" ]; then
    echo "Installing AITodo..."
    cp "$0" "$PREFIX/bin/todo"
    chmod +x "$PREFIX/bin/todo"
    echo -e "\033[0;32m✓ Installed successfully!\033[0m"
    echo "Usage: todo add 'your task'"
    exit 0
fi

# Configuration
SCRIPT_NAME="todo"
TODO_DIR="$HOME/storage/shared/TodoList"
TODO_FILE="$TODO_DIR/tasks.json"
BACKUP_FILE="$TODO_DIR/tasks.backup.json"
LOG_FILE="$TODO_DIR/todo.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Initialize
init_todo() {
    # Request storage access
    if [ ! -d "$HOME/storage" ]; then
        echo -e "${YELLOW}Requesting storage access...${NC}"
        termux-setup-storage
        sleep 2
    fi
    
    # Create directory structure
    mkdir -p "$TODO_DIR"
    
    # Initialize JSON file if it doesn't exist
    if [ ! -f "$TODO_FILE" ]; then
        echo '{"tasks": []}' > "$TODO_FILE"
        echo -e "${GREEN}Initialized new todo list${NC}"
    fi
    
    # Create log file
    touch "$LOG_FILE"
}

# Log function
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Auto-backup function
backup_tasks() {
    if [ -f "$TODO_FILE" ]; then
        cp "$TODO_FILE" "$BACKUP_FILE"
    fi
}

# Convert position number to task ID
get_task_id() {
    local input="$1"
    
    # If input is a number and within valid range, treat as position
    if [[ "$input" =~ ^[0-9]+$ ]]; then
        local total=$(jq '.tasks | length' "$TODO_FILE")
        if [ "$input" -ge 1 ] && [ "$input" -le "$total" ]; then
            # Get ID by position (sorted by priority)
            jq -r --argjson pos "$(($input - 1))" '
                .tasks | 
                sort_by(
                    if .priority == "high" then 0
                    elif .priority == "medium" then 1
                    else 2 end
                ) | 
                .[$pos].id' "$TODO_FILE"
            return 0
        fi
    fi
    
    # Otherwise, treat as ID
    echo "$input"
}

# AI-powered priority detection
detect_priority() {
    local task="$1"
    local priority="medium"
    
    # Convert to lowercase for matching
    local task_lower=$(echo "$task" | tr '[:upper:]' '[:lower:]')
    
    # High priority keywords
    if echo "$task_lower" | grep -qE "urgent|asap|critical|important|emergency|deadline|today"; then
        priority="high"
    # Low priority keywords
    elif echo "$task_lower" | grep -qE "someday|maybe|consider|eventually|low|minor"; then
        priority="low"
    fi
    
    echo "$priority"
}

# AI-powered category detection
detect_category() {
    local task="$1"
    local category="general"
    local task_lower=$(echo "$task" | tr '[:upper:]' '[:lower:]')
    
    if echo "$task_lower" | grep -qE "buy|shop|purchase|store"; then
        category="shopping"
    elif echo "$task_lower" | grep -qE "work|office|meeting|email|call|project"; then
        category="work"
    elif echo "$task_lower" | grep -qE "exercise|gym|run|workout|health|doctor"; then
        category="health"
    elif echo "$task_lower" | grep -qE "study|learn|read|course|book"; then
        category="learning"
    elif echo "$task_lower" | grep -qE "clean|repair|fix|home"; then
        category="home"
    fi
    
    echo "$category"
}

# Add task
add_task() {
    local description="$1"
    
    if [ -z "$description" ]; then
        echo -e "${RED}Error: Task description required${NC}"
        echo "Usage: $SCRIPT_NAME add 'task description'"
        return 1
    fi
    
    # AI detection
    local priority=$(detect_priority "$description")
    local category=$(detect_category "$description")
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local id=$(date +%s)
    
    # Create task object
    local new_task=$(jq -n \
        --arg id "$id" \
        --arg desc "$description" \
        --arg pri "$priority" \
        --arg cat "$category" \
        --arg time "$timestamp" \
        '{
            id: $id,
            description: $desc,
            priority: $pri,
            category: $cat,
            status: "pending",
            created: $time
        }')
    
    # Add to JSON file
    jq --argjson task "$new_task" '.tasks += [$task]' "$TODO_FILE" > "$TODO_FILE.tmp"
    mv "$TODO_FILE.tmp" "$TODO_FILE"
    
    # Auto-backup
    backup_tasks
    
    # Notification
    termux-notification \
        --title "✅ Task Added" \
        --content "$description" \
        --priority high \
        --sound
    
    echo -e "${GREEN}✓ Task added successfully!${NC}"
    echo -e "  Priority: ${YELLOW}$priority${NC}"
    echo -e "  Category: ${CYAN}$category${NC}"
    echo -e "  ID: $id"
    
    log_action "Added task: $description [Priority: $priority, Category: $category]"
}

# List tasks
list_tasks() {
    local filter="$1"
    
    if [ ! -f "$TODO_FILE" ]; then
        echo -e "${RED}No tasks found${NC}"
        return 1
    fi
    
    local task_count=$(jq '.tasks | length' "$TODO_FILE")
    
    if [ "$task_count" -eq 0 ]; then
        echo -e "${YELLOW}No tasks in your list${NC}"
        return 0
    fi
    
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📋 YOUR TO-DO LIST${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Sort by priority (high > medium > low) and display
    jq -r '.tasks | 
        sort_by(
            if .priority == "high" then 0
            elif .priority == "medium" then 1
            else 2 end
        ) | 
        to_entries[] | 
        "\(.key + 1)|\(.value.id)|\(.value.priority)|\(.value.category)|\(.value.status)|\(.value.description)"' "$TODO_FILE" | \
    while IFS='|' read -r num id priority category status description; do
        # Set priority color
        case $priority in
            high)   pri_color=$RED; pri_icon="🔴" ;;
            medium) pri_color=$YELLOW; pri_icon="🟡" ;;
            low)    pri_color=$GREEN; pri_icon="🟢" ;;
        esac
        
        # Set status icon
        if [ "$status" = "done" ]; then
            status_icon="✅"
            desc_color=$NC
        else
            status_icon="⏳"
            desc_color=$NC
        fi
        
        echo -e "${BLUE}[$num]${NC} $status_icon $pri_icon ${pri_color}${priority^^}${NC} | ${CYAN}$category${NC}"
        echo -e "    $description"
        echo -e "    ${NC}ID: $id${NC}"
        echo ""
    done
    
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Total tasks: $task_count"
    
    log_action "Listed tasks"
}

# Mark task as done
mark_done() {
    local task_input="$1"
    
    if [ -z "$task_input" ]; then
        echo -e "${RED}Error: Task number or ID required${NC}"
        echo "Usage: $SCRIPT_NAME done <number or id>"
        return 1
    fi
    
    # Convert position to ID if needed
    local task_id=$(get_task_id "$task_input")
    
    # Check if task exists
    local task_exists=$(jq --arg id "$task_id" '.tasks[] | select(.id == $id)' "$TODO_FILE")
    
    if [ -z "$task_exists" ]; then
        echo -e "${RED}Error: Task with ID $task_id not found${NC}"
        return 1
    fi
    
    # Get task description for notification
    local task_desc=$(jq -r --arg id "$task_id" '.tasks[] | select(.id == $id) | .description' "$TODO_FILE")
    
    # Mark as done
    jq --arg id "$task_id" '(.tasks[] | select(.id == $id) | .status) = "done"' "$TODO_FILE" > "$TODO_FILE.tmp"
    mv "$TODO_FILE.tmp" "$TODO_FILE"
    
    # Auto-backup
    backup_tasks
    
    # Notification
    termux-notification \
        --title "🎉 Task Completed!" \
        --content "$task_desc" \
        --priority default
    
    echo -e "${GREEN}✓ Task marked as done!${NC}"
    echo -e "  $task_desc"
    
    log_action "Completed task: $task_desc (ID: $task_id)"
}

# Delete task
delete_task() {
    local task_input="$1"
    
    if [ -z "$task_input" ]; then
        echo -e "${RED}Error: Task number or ID required${NC}"
        echo "Usage: $SCRIPT_NAME delete <number or id>"
        return 1
    fi
    
    # Convert position to ID if needed
    local task_id=$(get_task_id "$task_input")
    
    # Get task description
    local task_desc=$(jq -r --arg id "$task_id" '.tasks[] | select(.id == $id) | .description' "$TODO_FILE")
    
    if [ -z "$task_desc" ]; then
        echo -e "${RED}Error: Task with ID $task_id not found${NC}"
        return 1
    fi
    
    # Delete task
    jq --arg id "$task_id" '.tasks = [.tasks[] | select(.id != $id)]' "$TODO_FILE" > "$TODO_FILE.tmp"
    mv "$TODO_FILE.tmp" "$TODO_FILE"
    
    # Auto-backup
    backup_tasks
    
    echo -e "${GREEN}✓ Task deleted${NC}"
    echo -e "  $task_desc"
    
    log_action "Deleted task: $task_desc (ID: $task_id)"
}

# Clear completed tasks
clear_done() {
    local done_count=$(jq '[.tasks[] | select(.status == "done")] | length' "$TODO_FILE")
    
    if [ "$done_count" -eq 0 ]; then
        echo -e "${YELLOW}No completed tasks to clear${NC}"
        return 0
    fi
    
    jq '.tasks = [.tasks[] | select(.status != "done")]' "$TODO_FILE" > "$TODO_FILE.tmp"
    mv "$TODO_FILE.tmp" "$TODO_FILE"
    
    # Auto-backup
    backup_tasks
    
    echo -e "${GREEN}✓ Cleared $done_count completed task(s)${NC}"
    log_action "Cleared $done_count completed tasks"
}

# Show statistics
show_stats() {
    local total=$(jq '.tasks | length' "$TODO_FILE")
    local pending=$(jq '[.tasks[] | select(.status == "pending")] | length' "$TODO_FILE")
    local done=$(jq '[.tasks[] | select(.status == "done")] | length' "$TODO_FILE")
    local high=$(jq '[.tasks[] | select(.priority == "high" and .status == "pending")] | length' "$TODO_FILE")
    local medium=$(jq '[.tasks[] | select(.priority == "medium" and .status == "pending")] | length' "$TODO_FILE")
    local low=$(jq '[.tasks[] | select(.priority == "low" and .status == "pending")] | length' "$TODO_FILE")
    
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📊 TASK STATISTICS${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Total tasks:      $total"
    echo -e "${YELLOW}Pending:${NC}          $pending"
    echo -e "${GREEN}Completed:${NC}        $done"
    echo ""
    echo -e "${RED}High priority:${NC}    $high"
    echo -e "${YELLOW}Medium priority:${NC}  $medium"
    echo -e "${GREEN}Low priority:${NC}     $low"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Show help
show_help() {
    cat << EOF
${CYAN}AI-Powered To-Do List Manager${NC}

${YELLOW}USAGE:${NC}
  $SCRIPT_NAME <command> [arguments]

${YELLOW}COMMANDS:${NC}
  ${GREEN}add${NC} 'task'        Add a new task (AI detects priority & category)
  ${GREEN}list${NC}              List all tasks (sorted by priority)
  ${GREEN}done${NC} <id>         Mark task as completed
  ${GREEN}delete${NC} <id>       Delete a task
  ${GREEN}clear${NC}             Clear all completed tasks
  ${GREEN}stats${NC}             Show task statistics
  ${GREEN}help${NC}              Show this help message

${YELLOW}EXAMPLES:${NC}
  $SCRIPT_NAME add "Buy groceries today"
  $SCRIPT_NAME add "URGENT: Complete project report"
  $SCRIPT_NAME list
  $SCRIPT_NAME done 1234567890
  $SCRIPT_NAME delete 1234567890
  $SCRIPT_NAME clear
  $SCRIPT_NAME stats

${YELLOW}AI FEATURES:${NC}
  • Auto-detects priority from keywords (urgent, asap, critical, etc.)
  • Auto-categorizes tasks (work, shopping, health, learning, home)
  • Smart sorting by priority
  • Desktop notifications via Termux API

${YELLOW}FILES:${NC}
  Tasks: $TODO_FILE
  Logs:  $LOG_FILE
EOF
}

# Main script
main() {
    # Check dependencies
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is not installed${NC}"
        echo "Install it with: pkg install jq"
        exit 1
    fi
    
    if ! command -v termux-notification &> /dev/null; then
        echo -e "${YELLOW}Warning: termux-api is not installed${NC}"
        echo "Install it with: pkg install termux-api"
        echo "Also install the Termux:API app from F-Droid or Play Store"
    fi
    
    # Initialize
    init_todo
    
    # Parse command
    case "${1:-help}" in
        add)
            shift
            add_task "$*"
            ;;
        list|ls)
            list_tasks
            ;;
        done|complete)
            mark_done "$2"
            ;;
        delete|del|rm)
            delete_task "$2"
            ;;
        clear)
            clear_done
            ;;
        stats|statistics)
            show_stats
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"</pre>
            </div>
        </div>

        <!-- Minimal Version Tab -->
        <div id="content-minimal" class="tab-content hidden">
            <div class="bg-slate-800 rounded-lg p-6 shadow-2xl">
                <div class="flex justify-between items-center mb-4">
                    <div>
                        <h2 class="text-2xl font-bold">Minimal/Fast Version</h2>
                        <p class="text-gray-400 text-sm mt-1">~150 lines • Lightning fast • Core features only • Perfect for daily use</p>
                    </div>
                    <button onclick="copyMinimalScript()" class="px-4 py-2 bg-green-600 hover:bg-green-700 rounded-lg font-semibold transition">
                        📋 Copy Script
                    </button>
                </div>
                
                <div class="bg-blue-900 border border-blue-600 p-4 rounded-lg mb-4">
                    <h3 class="font-bold mb-2">⚡ Why Choose Minimal?</h3>
                    <ul class="text-sm space-y-1">
                        <li>✓ Faster startup and execution</li>
                        <li>✓ Simpler codebase (easier to customize)</li>
                        <li>✓ Still has AI priority detection</li>
                        <li>✓ Core commands: add, list, done, stats</li>
                        <li>✓ Auto-backup included</li>
                    </ul>
                </div>

                <pre class="code-block" id="minimal-script">#!/data/data/com.termux/files/usr/bin/bash

# AITodo Minimal - Lightweight AI To-Do List for Termux
# Core features only: add, list, done, stats
# ~150 lines • Fast & simple

# ============================================
# SELF-INSTALLER
# ============================================
if [ "${1}" = "install" ]; then
    echo "Installing AITodo Minimal..."
    cp "$0" "$PREFIX/bin/todo"
    chmod +x "$PREFIX/bin/todo"
    echo -e "\033[0;32m✓ Installed successfully!\033[0m"
    echo "Usage: todo add 'your task'"
    exit 0
fi

# Configuration
TODO_DIR="$HOME/storage/shared/TodoList"
[ ! -d "$HOME/storage/shared" ] && TODO_DIR="$HOME/TodoList"
DB_FILE="$TODO_DIR/tasks.json"
BACKUP_FILE="$TODO_DIR/tasks.backup.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Initialize
init() {
    if [ ! -d "$HOME/storage" ] && [[ "$TODO_DIR" == *"storage/shared"* ]]; then
        echo -e "${YELLOW}Requesting storage access...${NC}"
        termux-setup-storage
        sleep 2
    fi
    mkdir -p "$TODO_DIR"
    [ ! -f "$DB_FILE" ] && echo '[]' > "$DB_FILE"
}

# Auto-backup
backup_db() {
    [ -f "$DB_FILE" ] && cp "$DB_FILE" "$BACKUP_FILE"
}

# Send notification
notify() {
    if command -v termux-notification &> /dev/null; then
        termux-notification --title "AITodo" --content "$1" --priority default
    fi
}

# Detect priority (AI-powered)
detect_priority() {
    local task=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # High priority: 3
    if echo "$task" | grep -qE "urgent|asap|critical|important|emergency|deadline|today|now"; then
        echo 3
    # Low priority: 1
    elif echo "$task" | grep -qE "someday|maybe|consider|eventually|minor|later"; then
        echo 1
    # Medium priority: 2 (default)
    else
        echo 2
    fi
}

# Detect category
detect_category() {
    local task=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    if echo "$task" | grep -qE "buy|shop|purchase|store|grocery"; then
        echo "shopping"
    elif echo "$task" | grep -qE "work|office|meeting|email|call|project|deadline"; then
        echo "work"
    elif echo "$task" | grep -qE "exercise|gym|run|workout|health|doctor|fitness"; then
        echo "health"
    elif echo "$task" | grep -qE "study|learn|read|course|book|tutorial"; then
        echo "learning"
    elif echo "$task" | grep -qE "clean|repair|fix|home|house"; then
        echo "home"
    else
        echo "general"
    fi
}

# Add task
add_task() {
    local task="$*"
    
    if [ -z "$task" ]; then
        echo -e "${RED}Error: Task description required${NC}"
        echo "Usage: todo add 'task description'"
        return 1
    fi
    
    local priority=$(detect_priority "$task")
    local category=$(detect_category "$task")
    local next_id=$(jq 'if length == 0 then 1 else (max_by(.id).id + 1) end' "$DB_FILE")
    
    local tmp=$(mktemp)
    jq --arg task "$task" \
       --argjson pri "$priority" \
       --arg cat "$category" \
       --argjson id "$next_id" \
       '. += [{
           id: $id,
           task: $task,
           priority: $pri,
           category: $cat,
           status: "pending",
           created: now | strftime("%Y-%m-%d %H:%M:%S")
       }]' "$DB_FILE" > "$tmp" && mv "$tmp" "$DB_FILE"
    
    backup_db
    
    local pri_name="medium"
    [ "$priority" -eq 3 ] && pri_name="HIGH"
    [ "$priority" -eq 1 ] && pri_name="low"
    
    echo -e "${GREEN}✓ Task added!${NC}"
    echo -e "  Priority: ${YELLOW}$pri_name${NC}"
    echo -e "  Category: ${CYAN}$category${NC}"
    
    notify "✅ Added: $task"
}

# List tasks
list_tasks() {
    local total=$(jq 'length' "$DB_FILE")
    
    if [ "$total" -eq 0 ]; then
        echo -e "${YELLOW}No tasks yet${NC}"
        return 0
    fi
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📋 YOUR TO-DO LIST${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Show pending tasks only, sorted by priority (high to low)
    jq -r 'map(select(.status == "pending")) | 
           sort_by(-.priority) | 
           to_entries[] | 
           [.key + 1, .value.id, .value.priority, .value.category, .value.task] | 
           @tsv' "$DB_FILE" | \
    while IFS=$'\t' read -r num id pri cat task; do
        local pri_icon pri_color pri_name
        
        case $pri in
            3) pri_icon="🔴"; pri_color=$RED; pri_name="HIGH" ;;
            2) pri_icon="🟡"; pri_color=$YELLOW; pri_name="MED" ;;
            1) pri_icon="🟢"; pri_color=$GREEN; pri_name="LOW" ;;
        esac
        
        echo -e "${BLUE}[$num]${NC} $pri_icon ${pri_color}$pri_name${NC} | ${CYAN}$cat${NC}"
        echo -e "    $task"
        echo -e "    ${NC}ID: $id${NC}"
        echo ""
    done
    
    local pending=$(jq '[.[] | select(.status == "pending")] | length' "$DB_FILE")
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Pending: $pending | Total: $total"
}

# Mark task as done
mark_done() {
    local task_input="$1"
    
    if [ -z "$task_input" ]; then
        echo -e "${RED}Error: Task number or ID required${NC}"
        echo "Usage: todo done <number or id>"
        return 1
    fi
    
    # Convert position to ID if needed
    local task_id="$task_input"
    if [[ "$task_input" =~ ^[0-9]+$ ]]; then
        local total=$(jq '[.[] | select(.status == "pending")] | length' "$DB_FILE")
        if [ "$task_input" -ge 1 ] && [ "$task_input" -le "$total" ]; then
            task_id=$(jq -r --argjson pos "$(($task_input - 1))" \
                      '[.[] | select(.status == "pending")] | sort_by(-.priority) | .[$pos].id' "$DB_FILE")
        fi
    fi
    
    local task_desc=$(jq -r --argjson id "$task_id" \
                      '.[] | select(.id == $id) | .task' "$DB_FILE")
    
    if [ -z "$task_desc" ] || [ "$task_desc" = "null" ]; then
        echo -e "${RED}Error: Task not found${NC}"
        return 1
    fi
    
    local tmp=$(mktemp)
    jq --argjson id "$task_id" \
       'map(if .id == $id then .status = "completed" else . end)' "$DB_FILE" > "$tmp" && mv "$tmp" "$DB_FILE"
    
    backup_db
    
    echo -e "${GREEN}✓ Task completed!${NC}"
    echo -e "  $task_desc"
    
    notify "🎉 Done: $task_desc"
}

# Delete task
delete_task() {
    local task_input="$1"
    
    if [ -z "$task_input" ]; then
        echo -e "${RED}Error: Task number or ID required${NC}"
        return 1
    fi
    
    # Convert position to ID if needed (same logic as mark_done)
    local task_id="$task_input"
    if [[ "$task_input" =~ ^[0-9]+$ ]]; then
        local total=$(jq '[.[] | select(.status == "pending")] | length' "$DB_FILE")
        if [ "$task_input" -ge 1 ] && [ "$task_input" -le "$total" ]; then
            task_id=$(jq -r --argjson pos "$(($task_input - 1))" \
                      '[.[] | select(.status == "pending")] | sort_by(-.priority) | .[$pos].id' "$DB_FILE")
        fi
    fi
    
    local task_desc=$(jq -r --argjson id "$task_id" \
                      '.[] | select(.id == $id) | .task' "$DB_FILE")
    
    if [ -z "$task_desc" ] || [ "$task_desc" = "null" ]; then
        echo -e "${RED}Error: Task not found${NC}"
        return 1
    fi
    
    local tmp=$(mktemp)
    jq --argjson id "$task_id" \
       'map(select(.id != $id))' "$DB_FILE" > "$tmp" && mv "$tmp" "$DB_FILE"
    
    backup_db
    
    echo -e "${RED}✗ Task deleted${NC}"
    echo -e "  $task_desc"
}

# Clear completed tasks
clear_completed() {
    local done_count=$(jq '[.[] | select(.status == "completed")] | length' "$DB_FILE")
    
    if [ "$done_count" -eq 0 ]; then
        echo -e "${YELLOW}No completed tasks to clear${NC}"
        return 0
    fi
    
    local tmp=$(mktemp)
    jq 'map(select(.status != "completed"))' "$DB_FILE" > "$tmp" && mv "$tmp" "$DB_FILE"
    
    backup_db
    
    echo -e "${GREEN}✓ Cleared $done_count completed task(s)${NC}"
}

# Show statistics
show_stats() {
    local total=$(jq 'length' "$DB_FILE")
    local pending=$(jq '[.[] | select(.status == "pending")] | length' "$DB_FILE")
    local done=$(jq '[.[] | select(.status == "completed")] | length' "$DB_FILE")
    local high=$(jq '[.[] | select(.priority == 3 and .status == "pending")] | length' "$DB_FILE")
    local medium=$(jq '[.[] | select(.priority == 2 and .status == "pending")] | length' "$DB_FILE")
    local low=$(jq '[.[] | select(.priority == 1 and .status == "pending")] | length' "$DB_FILE")
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📊 TASK STATISTICS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Total tasks:      $total"
    echo -e "${YELLOW}Pending:${NC}          $pending"
    echo -e "${GREEN}Completed:${NC}        $done"
    echo ""
    echo -e "${RED}High priority:${NC}    $high"
    echo -e "${YELLOW}Medium priority:${NC}  $medium"
    echo -e "${GREEN}Low priority:${NC}     $low"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Help
show_help() {
    cat << EOF
${CYAN}AITodo Minimal - Fast AI To-Do List${NC}

${YELLOW}USAGE:${NC}
  todo <command> [arguments]

${YELLOW}COMMANDS:${NC}
  ${GREEN}add${NC} 'task'        Add new task (AI detects priority & category)
  ${GREEN}list${NC}              List pending tasks (sorted by priority)
  ${GREEN}done${NC} <#|id>       Mark task as completed (use position # or ID)
  ${GREEN}delete${NC} <#|id>     Delete a task
  ${GREEN}clear${NC}             Remove all completed tasks
  ${GREEN}stats${NC}             Show statistics
  ${GREEN}help${NC}              Show this help

${YELLOW}EXAMPLES:${NC}
  todo add "Buy groceries today"
  todo add "URGENT: Finish report"
  todo list
  todo done 1          ${NC}# Complete first task${NC}
  todo done 1234       ${NC}# Or use task ID${NC}
  todo delete 2
  todo clear
  todo stats

${YELLOW}AI FEATURES:${NC}
  • Auto-detects priority from keywords
  • Auto-categorizes tasks
  • Smart sorting (high priority first)
  • Termux notifications

${YELLOW}FILES:${NC}
  Tasks: $DB_FILE
  Backup: $BACKUP_FILE
EOF
}

# Main
main() {
    # Check jq
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq not installed${NC}"
        echo "Install: pkg install jq"
        exit 1
    fi
    
    init
    
    case "${1:-help}" in
        add)
            shift
            add_task "$@"
            ;;
        list|ls)
            list_tasks
            ;;
        done|complete)
            mark_done "$2"
            ;;
        delete|del|rm)
            delete_task "$2"
            ;;
        clear)
            clear_completed
            ;;
        stats)
            show_stats
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"</pre>
            </div>
        </div>

        <!-- Installation Tab -->
        <div id="content-install" class="tab-content hidden">
            <div class="bg-slate-800 rounded-lg p-6 shadow-2xl">
                <h2 class="text-2xl font-bold mb-6">Installation Instructions</h2>
                
                <div class="bg-gradient-to-r from-purple-900 to-blue-900 p-4 rounded-lg mb-6">
                    <h3 class="text-xl font-semibold mb-3">🎯 Which Version Should I Choose?</h3>
                    <div class="grid md:grid-cols-2 gap-4 text-sm">
                        <div class="bg-slate-800 p-3 rounded">
                            <h4 class="font-bold text-purple-400 mb-2">📜 Full Version</h4>
                            <ul class="space-y-1 text-gray-300">
                                <li>✓ All features (delete, clear, stats, logs)</li>
                                <li>✓ Comprehensive help system</li>
                                <li>✓ Detailed output and formatting</li>
                                <li>✓ Best for power users</li>
                            </ul>
                        </div>
                        <div class="bg-slate-800 p-3 rounded">
                            <h4 class="font-bold text-blue-400 mb-2">⚡ Minimal Version</h4>
                            <ul class="space-y-1 text-gray-300">
                                <li>✓ Lightning fast startup</li>
                                <li>✓ Core features only (add/list/done)</li>
                                <li>✓ Simpler code (easy to customize)</li>
                                <li>✓ Best for daily quick tasks</li>
                            </ul>
                        </div>
                    </div>
                    <p class="text-center mt-3 text-yellow-300">💡 Both have AI priority detection and auto-backup!</p>
                </div>
                
                <div class="space-y-6">
                    <div class="bg-slate-700 p-4 rounded-lg">
                        <h3 class="text-xl font-semibold mb-3 text-purple-400">Step 1: Install Required Packages</h3>
                        <pre class="code-block">pkg update && pkg upgrade
pkg install termux-api jq</pre>
                        <p class="mt-3 text-gray-300">Also install the <strong>Termux:API</strong> app from F-Droid or Google Play Store.</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg">
                        <h3 class="text-xl font-semibold mb-3 text-purple-400">Step 2: Create the Script</h3>
                        <pre class="code-block">nano ~/todo.sh</pre>
                        <p class="mt-3 text-gray-300">Paste the complete script from the "Full Version" or "Minimal Version" tab and save (Ctrl+X, then Y, then Enter).</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg">
                        <h3 class="text-xl font-semibold mb-3 text-purple-400">Step 3: Make it Executable & Install</h3>
                        <pre class="code-block">chmod +x ~/todo.sh
~/todo.sh install</pre>
                        <p class="mt-3 text-gray-300">✨ <strong>Self-Installer Magic!</strong> The script will copy itself to <code class="bg-slate-900 px-2 py-1 rounded">$PREFIX/bin/todo</code> automatically.</p>
                        <p class="mt-2 text-green-300 text-sm">No need for aliases or PATH modifications!</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg">
                        <h3 class="text-xl font-semibold mb-3 text-purple-400">Alternative: Manual Alias Setup</h3>
                        <pre class="code-block">echo "alias todo='~/todo.sh'" >> ~/.bashrc
source ~/.bashrc</pre>
                        <p class="mt-3 text-gray-300">If you prefer not to use the self-installer, create an alias instead.</p>
                    </div>

                    <div class="bg-green-900 border border-green-600 p-4 rounded-lg">
                        <h3 class="text-xl font-semibold mb-2">✅ You're Ready!</h3>
                        <p class="text-gray-200">Start using your AI-powered to-do list with commands like:</p>
                        <pre class="code-block mt-2">todo add "Buy groceries"
todo list
todo done &lt;id&gt;</pre>
                    </div>
                </div>
            </div>
        </div>

        <!-- Usage Tab -->
        <div id="content-usage" class="tab-content hidden">
            <div class="bg-slate-800 rounded-lg p-6 shadow-2xl">
                <h2 class="text-2xl font-bold mb-6">Usage Guide</h2>
                
                <div class="space-y-4">
                    <div class="bg-slate-700 p-4 rounded-lg border-l-4 border-green-500">
                        <h3 class="text-lg font-bold mb-2">➕ Add Tasks</h3>
                        <pre class="code-block">todo add "Task description"</pre>
                        <p class="mt-2 text-gray-300">AI automatically detects priority and category!</p>
                        <div class="mt-3 space-y-1 text-sm">
                            <p>🔴 <strong>High priority:</strong> urgent, asap, critical, important, emergency, deadline, today</p>
                            <p>🟡 <strong>Medium priority:</strong> default for most tasks</p>
                            <p>🟢 <strong>Low priority:</strong> someday, maybe, consider, eventually, minor</p>
                        </div>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg border-l-4 border-blue-500">
                        <h3 class="text-lg font-bold mb-2">📋 List Tasks</h3>
                        <pre class="code-block">todo list</pre>
                        <p class="mt-2 text-gray-300">Shows all tasks sorted by priority (high → medium → low)</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg border-l-4 border-purple-500">
                        <h3 class="text-lg font-bold mb-2">✅ Complete Tasks</h3>
                        <pre class="code-block">todo done &lt;task_id&gt;</pre>
                        <p class="mt-2 text-gray-300">Marks a task as completed and sends a celebration notification!</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg border-l-4 border-red-500">
                        <h3 class="text-lg font-bold mb-2">🗑️ Delete Tasks</h3>
                        <pre class="code-block">todo delete &lt;task_id&gt;</pre>
                        <p class="mt-2 text-gray-300">Permanently removes a task from the list</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg border-l-4 border-yellow-500">
                        <h3 class="text-lg font-bold mb-2">🧹 Clear Completed</h3>
                        <pre class="code-block">todo clear</pre>
                        <p class="mt-2 text-gray-300">Removes all completed tasks to keep your list clean</p>
                    </div>

                    <div class="bg-slate-700 p-4 rounded-lg border-l-4 border-cyan-500">
                        <h3 class="text-lg font-bold mb-2">📊 View Statistics</h3>
                        <pre class="code-block">todo stats</pre>
                        <p class="mt-2 text-gray-300">Shows task statistics: total, pending, completed, by priority</p>
                    </div>

                    <div class="bg-gradient-to-r from-purple-900 to-pink-900 p-4 rounded-lg mt-6">
                        <h3 class="text-xl font-bold mb-3">🤖 AI Features</h3>
                        <ul class="space-y-2 text-gray-200">
                            <li>✨ <strong>Smart Priority Detection:</strong> Analyzes task description for urgency keywords</li>
                            <li>🏷️ <strong>Auto-Categorization:</strong> Shopping, Work, Health, Learning, Home, General</li>
                            <li>📊 <strong>Priority Sorting:</strong> Always shows high-priority tasks first</li>
                            <li>🔔 <strong>Smart Notifications:</strong> Task added and completion alerts</li>
                            <li>📝 <strong>Action Logging:</strong> All operations logged for review</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Demo Tab -->
        <div id="content-demo" class="tab-content hidden">
            <div class="bg-slate-800 rounded-lg p-6 shadow-2xl">
                <div class="flex justify-between items-center mb-6">
                    <div>
                        <h2 class="text-2xl font-bold">🚀 Interactive Demo</h2>
                        <p class="text-gray-300 mt-2">Try the to-do list functionality right in your browser! Data is saved locally.</p>
                    </div>
                    <button 
                        onclick="resetDemo()" 
                        class="px-4 py-2 bg-slate-700 hover:bg-slate-600 rounded-lg text-sm font-semibold transition"
                    >
                        🔄 Reset Demo
                    </button>
                </div>

                <!-- AI Detection Hints -->
                <div class="bg-gradient-to-r from-blue-900 to-purple-900 p-4 rounded-lg mb-6">
                    <h3 class="font-bold mb-2 text-blue-300">💡 Try AI Detection!</h3>
                    <p class="text-sm text-gray-300 mb-2">Type tasks with these keywords to see smart priority/category detection:</p>
                    <div class="grid md:grid-cols-2 gap-2 text-xs">
                        <div>
                            <span class="text-red-400">🔴 High:</span> <code class="bg-slate-800 px-1 rounded">URGENT: Fix bug</code>
                        </div>
                        <div>
                            <span class="text-cyan-400">📧 Work:</span> <code class="bg-slate-800 px-1 rounded">Send email to client</code>
                        </div>
                        <div>
                            <span class="text-yellow-400">🟡 Medium:</span> <code class="bg-slate-800 px-1 rounded">Review code</code>
                        </div>
                        <div>
                            <span class="text-cyan-400">🛒 Shopping:</span> <code class="bg-slate-800 px-1 rounded">Buy milk</code>
                        </div>
                        <div>
                            <span class="text-green-400">🟢 Low:</span> <code class="bg-slate-800 px-1 rounded">Maybe clean garage</code>
                        </div>
                        <div>
                            <span class="text-cyan-400">💪 Health:</span> <code class="bg-slate-800 px-1 rounded">Go to gym</code>
                        </div>
                    </div>
                </div>

                <!-- Add Task Form -->
                <div class="bg-slate-700 p-4 rounded-lg mb-6">
                    <h3 class="text-xl font-semibold mb-4">Add New Task</h3>
                    <div class="flex gap-2">
                        <input 
                            type="text" 
                            id="taskInput" 
                            placeholder="Enter task description (try 'URGENT: Fix bug' or 'Buy groceries')"
                            class="flex-1 px-4 py-2 bg-slate-900 border border-slate-600 rounded-lg focus:outline-none focus:border-purple-500 text-white"
                            onkeypress="if(event.key==='Enter') addDemoTask()"
                        >
                        <button 
                            onclick="addDemoTask()" 
                            class="px-6 py-2 bg-green-600 hover:bg-green-700 rounded-lg font-semibold transition"
                        >
                            ➕ Add
                        </button>
                    </div>
                    <div id="addFeedback" class="mt-2 text-sm"></div>
                </div>

                <!-- Task List -->
                <div class="bg-slate-700 p-4 rounded-lg mb-6">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-xl font-semibold">Your Tasks</h3>
                        <button 
                            onclick="clearCompleted()" 
                            class="px-4 py-2 bg-yellow-600 hover:bg-yellow-700 rounded-lg text-sm font-semibold transition"
                        >
                            Clear Completed
                        </button>
                    </div>
                    <div id="taskList" class="space-y-3">
                        <p class="text-gray-400 text-center py-8">No tasks yet. Add one above!</p>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="bg-gradient-to-r from-purple-900 to-pink-900 p-4 rounded-lg">
                    <h3 class="text-xl font-semibold mb-3">📊 Statistics</h3>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4" id="stats">
                        <div class="text-center">
                            <div class="text-3xl font-bold" id="stat-total">0</div>
                            <div class="text-sm text-gray-300">Total</div>
                        </div>
                        <div class="text-center">
                            <div class="text-3xl font-bold text-yellow-400" id="stat-pending">0</div>
                            <div class="text-sm text-gray-300">Pending</div>
                        </div>
                        <div class="text-center">
                            <div class="text-3xl font-bold text-green-400" id="stat-done">0</div>
                            <div class="text-sm text-gray-300">Completed</div>
                        </div>
                        <div class="text-center">
                            <div class="text-3xl font-bold text-red-400" id="stat-high">0</div>
                            <div class="text-sm text-gray-300">High Priority</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-slate-900 border-t border-slate-700 mt-16 py-8">
        <div class="container mx-auto px-4 max-w-6xl">
            <div class="grid md:grid-cols-3 gap-8 mb-6">
                <div>
                    <h3 class="text-xl font-bold mb-3 bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">AITodo</h3>
                    <p class="text-gray-400 text-sm">Smart, offline-first to-do list for Termux. Free and open source.</p>
                </div>
                <div>
                    <h4 class="font-bold mb-3 text-gray-300">Quick Links</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="https://github.com/yourusername/aitodo" class="text-purple-400 hover:text-purple-300">GitHub Repository</a></li>
                        <li><a href="https://github.com/yourusername/aitodo/issues" class="text-purple-400 hover:text-purple-300">Report Issues</a></li>
                        <li><a href="https://wiki.termux.com/" target="_blank" class="text-purple-400 hover:text-purple-300">Termux Wiki</a></li>
                        <li><a href="https://f-droid.org/packages/com.termux.api/" target="_blank" class="text-purple-400 hover:text-purple-300">Termux:API App</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold mb-3 text-gray-300">Community</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="https://reddit.com/r/termux" target="_blank" class="text-purple-400 hover:text-purple-300">r/termux</a></li>
                        <li><a href="https://gitter.im/termux/termux" target="_blank" class="text-purple-400 hover:text-purple-300">Gitter Chat</a></li>
                        <li><a href="#content-demo" onclick="showTab('demo')" class="text-purple-400 hover:text-purple-300">Try Live Demo</a></li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-slate-700 pt-6 text-center text-gray-400 text-sm">
                <p>Built with ❤️ for the Termux community • Open Source under MIT License</p>
                <p class="mt-2">⭐ Star on <a href="https://github.com/yourusername/aitodo" class="text-purple-400 hover:text-purple-300">GitHub</a> if you find this useful!</p>
            </div>
        </div>
    </footer>

    <script>
        // Tab switching
        function showTab(tabName) {
            const tabs = ['script', 'minimal', 'install', 'usage', 'demo'];
            tabs.forEach(tab => {
                document.getElementById(`content-${tab}`).classList.add('hidden');
                document.getElementById(`tab-${tab}`).classList.remove('bg-purple-600');
                document.getElementById(`tab-${tab}`).classList.add('bg-slate-700', 'hover:bg-slate-600');
            });
            document.getElementById(`content-${tabName}`).classList.remove('hidden');
            document.getElementById(`tab-${tabName}`).classList.remove('bg-slate-700', 'hover:bg-slate-600');
            document.getElementById(`tab-${tabName}`).classList.add('bg-purple-600');
        }

        // Copy script to clipboard
        function copyScript() {
            const scriptText = document.getElementById('bash-script').textContent;
            navigator.clipboard.writeText(scriptText).then(() => {
                alert('✅ Full version copied to clipboard! Paste it into your Termux terminal.');
            });
        }

        // Copy minimal script to clipboard
        function copyMinimalScript() {
            const scriptText = document.getElementById('minimal-script').textContent;
            navigator.clipboard.writeText(scriptText).then(() => {
                alert('✅ Minimal version copied to clipboard! Paste it into your Termux terminal.');
            });
        }

        // Demo functionality
        let tasks = [];
        let taskIdCounter = 1;

        function detectPriority(description) {
            const lower = description.toLowerCase();
            if (/urgent|asap|critical|important|emergency|deadline|today/.test(lower)) {
                return 'high';
            } else if (/someday|maybe|consider|eventually|low|minor/.test(lower)) {
                return 'low';
            }
            return 'medium';
        }

        function detectCategory(description) {
            const lower = description.toLowerCase();
            if (/buy|shop|purchase|store/.test(lower)) return 'shopping';
            if (/work|office|meeting|email|call|project/.test(lower)) return 'work';
            if (/exercise|gym|run|workout|health|doctor/.test(lower)) return 'health';
            if (/study|learn|read|course|book/.test(lower)) return 'learning';
            if (/clean|repair|fix|home/.test(lower)) return 'home';
            return 'general';
        }

        function addDemoTask() {
            const input = document.getElementById('taskInput');
            const description = input.value.trim();
            
            if (!description) {
                showFeedback('Please enter a task description', 'error');
                return;
            }

            const priority = detectPriority(description);
            const category = detectCategory(description);
            
            const task = {
                id: taskIdCounter++,
                description,
                priority,
                category,
                status: 'pending',
                created: new Date().toISOString()
            };

            tasks.push(task);
            input.value = '';
            
            showFeedback(`✅ Task added! Priority: ${priority}, Category: ${category}`, 'success');
            saveTasks();
            renderTasks();
        }

        function showFeedback(message, type) {
            const feedback = document.getElementById('addFeedback');
            feedback.textContent = message;
            feedback.className = `mt-2 text-sm ${type === 'success' ? 'text-green-400' : 'text-red-400'}`;
            setTimeout(() => feedback.textContent = '', 3000);
        }

        function markDone(id) {
            const task = tasks.find(t => t.id === id);
            if (task) {
                task.status = task.status === 'done' ? 'pending' : 'done';
                saveTasks();
                renderTasks();
            }
        }

        function deleteTask(id) {
            tasks = tasks.filter(t => t.id !== id);
            saveTasks();
            renderTasks();
        }

        function clearCompleted() {
            const before = tasks.length;
            tasks = tasks.filter(t => t.status !== 'done');
            const cleared = before - tasks.length;
            if (cleared > 0) {
                showFeedback(`🧹 Cleared ${cleared} completed task(s)`, 'success');
            }
            saveTasks();
            renderTasks();
        }

        function renderTasks() {
            // Sort by priority
            const priorityOrder = { high: 0, medium: 1, low: 2 };
            const sortedTasks = [...tasks].sort((a, b) => {
                if (a.status === b.status) {
                    return priorityOrder[a.priority] - priorityOrder[b.priority];
                }
                return a.status === 'done' ? 1 : -1;
            });

            const taskList = document.getElementById('taskList');
            
            if (sortedTasks.length === 0) {
                taskList.innerHTML = '<p class="text-gray-400 text-center py-8">No tasks yet. Add one above!</p>';
            } else {
                taskList.innerHTML = sortedTasks.map(task => {
                    const priorityColors = {
                        high: 'priority-high',
                        medium: 'priority-medium',
                        low: 'priority-low'
                    };
                    const priorityIcons = {
                        high: '🔴',
                        medium: '🟡',
                        low: '🟢'
                    };
                    const statusIcon = task.status === 'done' ? '✅' : '⏳';
                    const isDone = task.status === 'done';
                    
                    return `
                        <div class="task-item bg-slate-600 p-4 rounded-lg ${priorityColors[task.priority]} ${isDone ? 'opacity-60' : ''}">
                            <div class="flex items-start justify-between gap-4">
                                <div class="flex-1">
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="text-2xl">${statusIcon}</span>
                                        <span class="text-2xl">${priorityIcons[task.priority]}</span>
                                        <span class="px-2 py-1 rounded text-xs font-bold uppercase ${
                                            task.priority === 'high' ? 'bg-red-600' :
                                            task.priority === 'medium' ? 'bg-yellow-600' : 'bg-green-600'
                                        }">${task.priority}</span>
                                        <span class="px-2 py-1 rounded text-xs bg-slate-700">${task.category}</span>
                                    </div>
                                    <p class="text-lg ${isDone ? 'line-through text-gray-400' : ''}">${task.description}</p>
                                    <p class="text-xs text-gray-400 mt-1">ID: ${task.id}</p>
                                </div>
                                <div class="flex gap-2">
                                    <button 
                                        onclick="markDone(${task.id})"
                                        class="px-3 py-1 ${isDone ? 'bg-yellow-600 hover:bg-yellow-700' : 'bg-green-600 hover:bg-green-700'} rounded font-semibold text-sm transition"
                                    >
                                        ${isDone ? '↩️' : '✓'}
                                    </button>
                                    <button 
                                        onclick="deleteTask(${task.id})"
                                        class="px-3 py-1 bg-red-600 hover:bg-red-700 rounded font-semibold text-sm transition"
                                    >
                                        🗑️
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                }).join('');
            }

            updateStats();
        }

        function updateStats() {
            const total = tasks.length;
            const pending = tasks.filter(t => t.status === 'pending').length;
            const done = tasks.filter(t => t.status === 'done').length;
            const high = tasks.filter(t => t.priority === 'high' && t.status === 'pending').length;

            document.getElementById('stat-total').textContent = total;
            document.getElementById('stat-pending').textContent = pending;
            document.getElementById('stat-done').textContent = done;
            document.getElementById('stat-high').textContent = high;
        }

        // Add sample tasks on load
        window.addEventListener('load', () => {
            // Check if we have saved tasks in localStorage
            const savedTasks = localStorage.getItem('aitodo-demo-tasks');
            if (savedTasks) {
                try {
                    const parsed = JSON.parse(savedTasks);
                    tasks = parsed.tasks;
                    taskIdCounter = parsed.counter;
                } catch (e) {
                    // If parsing fails, use default tasks
                    loadDefaultTasks();
                }
            } else {
                loadDefaultTasks();
            }
            renderTasks();
        });

        function loadDefaultTasks() {
            taskIdCounter = 1; // Reset counter
            tasks = [
                {
                    id: taskIdCounter++,
                    description: 'URGENT: Complete project report by Friday',
                    priority: 'high',
                    category: 'work',
                    status: 'pending',
                    created: new Date().toISOString()
                },
                {
                    id: taskIdCounter++,
                    description: 'Buy groceries from the store',
                    priority: 'medium',
                    category: 'shopping',
                    status: 'pending',
                    created: new Date().toISOString()
                },
                {
                    id: taskIdCounter++,
                    description: 'Maybe read that book someday',
                    priority: 'low',
                    category: 'learning',
                    status: 'pending',
                    created: new Date().toISOString()
                },
                {
                    id: taskIdCounter++,
                    description: 'Call doctor for appointment',
                    priority: 'high',
                    category: 'health',
                    status: 'pending',
                    created: new Date().toISOString()
                }
            ];
        }

        function resetDemo() {
            if (confirm('Reset demo to default tasks? Your current tasks will be lost.')) {
                localStorage.removeItem('aitodo-demo-tasks');
                loadDefaultTasks();
                saveTasks();
                renderTasks();
                showFeedback('✅ Demo reset to defaults!', 'success');
            }
        }

        // Save tasks to localStorage
        function saveTasks() {
            localStorage.setItem('aitodo-demo-tasks', JSON.stringify({
                tasks: tasks,
                counter: taskIdCounter
            }));
        }
    </script>
</body>
</html>
