# Look for a running ssh-agent and connect to it or start a new agent

# usage: source ssh-attach.sh

if [[ ! -z "$SSH_AGENT_PID" && ! -z "$SSH_AUTH_SOCK" ]]; then
    echo "Already attached to an agent.";
else
    SSH_AGENT_PID=$(pgrep -o ssh-agent);
    if [ ! -z ${SSH_AGENT_PID} ]; then
        SSH_AUTH_SOCK=$(sudo lsof -wbp ${SSH_AGENT_PID} | awk "/\/tmp\/ssh.*\/agent.[[:digit:]]{3,}/ { print \$9; exit }");
        if [ ! -z ${SSH_AUTH_SOCK} ]; then
            echo "Run this to attach to ssh-agent (pid ${SSH_AGENT_PID}):";
            export SSH_AGENT_PID=${SSH_AGENT_PID};
            export SSH_AUTH_SOCK=${SSH_AUTH_SOCK};
            ssh-add -l
        else
            echo "Unable to determine SSH_AUTH_SOCK for ssh-agent (pid ${SSH_AGENT_PID})";
        fi;
    else
        echo "Unable to find running ssh-agent. Starting one.";
        eval $(ssh-agent);
        ssh-add -l
    fi
fi
