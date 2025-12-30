#!/data/data/com.termux/files/usr/bin/bash

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
        echo "Usage: todo done "
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
  todo  [arguments]

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

main "$@"
