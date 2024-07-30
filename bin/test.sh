get_second_line_process() {
    PANE_PID=$1
    ps --forest -o pid,args -g $PANE_PID | sed -n '3p'
}

# Get the list of all panes with their ids and the second line of the process tree
PANES=$(tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_pid}" | while read -r line; do
    PANE_ID=$(echo $line | awk '{print $1}')
    PANE_PID=$(echo $line | awk '{print $2}')
    SECOND_LINE=$(get_second_line_process $PANE_PID)
    echo "$PANE_ID $SECOND_LINE"
done)

echo $PANES
