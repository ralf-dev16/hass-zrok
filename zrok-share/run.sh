#!/usr/bin/env bashio
set -e

# ==============================================================================
# zrok Share Add-on for Home Assistant
# Provides secure remote access via zrok zero-trust networking
# ==============================================================================

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

CONFIG_PATH=/data/options.json
ZROK_HOME=/data/.zrok
export HOME=/data
export ZROK_ROOT="$ZROK_HOME"

# Get version from environment (set during build) or fallback
ADDON_VERSION="${ADDON_VERSION:-unknown}"

bashio::log.info "Starting zrok Share Add-on v${ADDON_VERSION}..."

# Read configuration directly from options.json using jq (no API dependency)
ZROK_TOKEN=$(jq -r '.zrok_token // empty' "$CONFIG_PATH")
BACKEND_URL=$(jq -r '.backend_url // empty' "$CONFIG_PATH")
BASIC_AUTH_USERNAME=$(jq -r '.basic_auth_username // empty' "$CONFIG_PATH")
BASIC_AUTH_PASSWORD=$(jq -r '.basic_auth_password // empty' "$CONFIG_PATH")
SHARE_MODE=$(jq -r '.share_mode // "public"' "$CONFIG_PATH")
AUTO_RESTART=$(jq -r '.auto_restart // true' "$CONFIG_PATH")
LOG_LEVEL=$(jq -r '.log_level // "info"' "$CONFIG_PATH")

# Set log level
case "$LOG_LEVEL" in
    debug) bashio::log.level debug ;;
    info) bashio::log.level info ;;
    warn) bashio::log.level warning ;;
    error) bashio::log.level error ;;
esac

bashio::log.debug "Configuration loaded from $CONFIG_PATH"

# ------------------------------------------------------------------------------
# Validation
# ------------------------------------------------------------------------------

if [ -z "$ZROK_TOKEN" ]; then
    bashio::log.fatal "No zrok token configured!"
    bashio::log.fatal "Please configure your zrok invitation token in the add-on settings."
    bashio::log.fatal "Get your token from: https://zrok.io"
    exit 1
fi

if [ -z "$BACKEND_URL" ]; then
    bashio::log.fatal "No backend URL configured!"
    exit 1
fi

bashio::log.info "Backend URL: $BACKEND_URL"
bashio::log.info "Share mode: $SHARE_MODE"

# ------------------------------------------------------------------------------
# zrok Environment Setup
# ------------------------------------------------------------------------------

# Create zrok home directory if it doesn't exist
mkdir -p "$ZROK_HOME"

# Function to enable zrok with better error handling
enable_zrok() {
    local output
    local exit_code=0

    bashio::log.info "Enabling zrok..."
    bashio::log.info "This may take a few moments..."

    # Capture output and exit code separately
    output=$(zrok enable --headless "$ZROK_TOKEN" 2>&1) || exit_code=$?

    # Log each line of output
    while IFS= read -r line; do
        [ -n "$line" ] && bashio::log.info "$line"
    done <<< "$output"

    # Check for 401 error (token already used)
    if echo "$output" | grep -q "401.*enableUnauthorized\|enableUnauthorized.*401"; then
        bashio::log.fatal "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        bashio::log.fatal "TOKEN ALREADY USED"
        bashio::log.fatal "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        bashio::log.fatal "This zrok token has already been used to create an environment."
        bashio::log.fatal ""
        bashio::log.fatal "To fix this, you have two options:"
        bashio::log.fatal ""
        bashio::log.fatal "Option 1: Delete the old environment"
        bashio::log.fatal "  1. Go to https://api-v1.zrok.io"
        bashio::log.fatal "  2. Log in to your account"
        bashio::log.fatal "  3. Delete the old environment"
        bashio::log.fatal "  4. Request a new invite token"
        bashio::log.fatal "  5. Update the token in the add-on configuration"
        bashio::log.fatal ""
        bashio::log.fatal "Option 2: Get a new token"
        bashio::log.fatal "  1. Go to https://zrok.io"
        bashio::log.fatal "  2. Request a new invite token"
        bashio::log.fatal "  3. Update the token in the add-on configuration"
        bashio::log.fatal "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        return 1
    fi

    # Check if enable succeeded
    if [ -n "$exit_code" ] && [ "$exit_code" -ne 0 ]; then
        bashio::log.fatal "Failed to enable zrok! (exit code: $exit_code)"
        bashio::log.fatal "Please check your token and try again."
        bashio::log.fatal "Get a new token from: https://zrok.io"
        return 1
    fi

    # Verify environment.json was created and sync to disk
    if [ -f "$ZROK_HOME/environment.json" ]; then
        sync
        bashio::log.info "zrok enabled successfully!"
        bashio::log.debug "Environment file saved to: $ZROK_HOME/environment.json"
        return 0
    else
        bashio::log.error "zrok enable appeared to succeed but environment.json was not created"
        bashio::log.error "This is unexpected - please report this issue"
        return 1
    fi
}

# Check if zrok is already enabled
if [ ! -f "$ZROK_HOME/environment.json" ]; then
    bashio::log.info "No existing zrok environment found."
    if ! enable_zrok; then
        exit 1
    fi
else
    bashio::log.info "Using existing zrok environment"
    bashio::log.debug "Environment file: $ZROK_HOME/environment.json"
fi

# Verify zrok status
if ! zrok status --headless &>/dev/null; then
    bashio::log.warning "zrok environment appears invalid, attempting to re-enable..."

    # First, try to disable cleanly (this may fail but that's okay)
    bashio::log.debug "Attempting to disable old environment..."
    zrok disable --headless 2>/dev/null || true

    # Remove local environment file
    rm -f "$ZROK_HOME/environment.json"

    # Try to enable again
    if ! enable_zrok; then
        exit 1
    fi
fi

# ------------------------------------------------------------------------------
# Build zrok share command
# ------------------------------------------------------------------------------

ZROK_CMD="zrok share public --headless"

# Add backend URL
ZROK_CMD="$ZROK_CMD $BACKEND_URL"

# Add Basic Auth if configured
if [ -n "$BASIC_AUTH_USERNAME" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then
    bashio::log.info "Basic Authentication enabled for user: $BASIC_AUTH_USERNAME"
    ZROK_CMD="$ZROK_CMD --basic-auth $BASIC_AUTH_USERNAME:$BASIC_AUTH_PASSWORD"
else
    bashio::log.warning "No Basic Authentication configured - your Home Assistant will be publicly accessible!"
    bashio::log.warning "It is recommended to configure username and password for additional security."
fi

bashio::log.debug "zrok command: ${ZROK_CMD//:$BASIC_AUTH_PASSWORD/:***}"

# ------------------------------------------------------------------------------
# Start zrok share
# ------------------------------------------------------------------------------

bashio::log.info "Starting zrok share..."
bashio::log.info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Retry logic for auto-restart
RETRY_COUNT=0
MAX_RETRIES=999999  # Effectively infinite if auto_restart is enabled

while true; do
    # Start zrok share and capture output
    if $ZROK_CMD 2>&1 | while IFS= read -r line; do
        # Highlight important information
        if [[ "$line" =~ https://.* ]]; then
            bashio::log.info "🌍 Public URL: $line"
            bashio::log.info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        else
            bashio::log.info "$line"
        fi
    done; then
        # Normal exit
        bashio::log.info "zrok share stopped normally"
        break
    else
        EXIT_CODE=$?
        RETRY_COUNT=$((RETRY_COUNT + 1))

        bashio::log.error "zrok share exited with code $EXIT_CODE"

        if [ "$AUTO_RESTART" = "true" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            WAIT_TIME=$((RETRY_COUNT * 5))
            if [ $WAIT_TIME -gt 60 ]; then
                WAIT_TIME=60
            fi

            bashio::log.warning "Auto-restart enabled, waiting ${WAIT_TIME}s before retry (attempt $RETRY_COUNT)..."
            sleep "$WAIT_TIME"

            # Check if environment is still valid
            if ! zrok status --headless &>/dev/null; then
                bashio::log.warning "zrok environment lost, attempting to re-enable..."

                # Try to disable cleanly first
                zrok disable --headless 2>/dev/null || true
                rm -f "$ZROK_HOME/environment.json"

                if ! enable_zrok; then
                    bashio::log.error "Failed to re-enable zrok, will retry..."
                    continue
                fi
            fi

            bashio::log.info "Restarting zrok share..."
        else
            bashio::log.fatal "zrok share failed and auto-restart is disabled or max retries reached"
            exit "$EXIT_CODE"
        fi
    fi
done

bashio::log.info "Add-on stopped"
