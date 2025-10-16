#!/bin/bash

# Started setting up environment

# Prompt the user to enter their name.
echo "Enter your name:"

# Read and store the input value in a variable called 'username'.
read username
# Define the main directory name by combining a base name with the user’s name.
main_dir="submission_reminder_$username"
mkdir -p "$main_dir"

mkdir -p ${main_dir}/{app,modules,assets,config}
cat <<'EOF' > "$main_dir/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
cat <<'EOF' > "$main_dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Annie, Shell basics, submitted 
Patrick, Shell basics, submitted
Morgan, Shell basics, submitted
Shema, Shell Navigation, not submitted 
Prince, Git, submitted

EOF
cat <<'EOF' > "$main_dir/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
cat <<'EOF' > "$main_dir/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
cat <<'EOF' > "$main_dir/startup.sh"
#!/bin/bash
echo "Starting Submission Reminder App..."

main_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$main_dir"

bash "$main_dir/app/reminder.sh"
EOF
chmod +x ${main_dir}/*.sh
chmod +x ${main_dir}/app/*.sh
chmod +x ${main_dir}/modules/*.sh

echo "Environment setup complete!"
echo "Navigate to $main_dir and run ./startup.sh to test the app."
